import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constant/color.dart';
import '../../constant/constants.dart';
import 'location_service.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  final Set<Marker> _markers = <Marker>{};
  final Set<Polygon> _polygons = <Polygon>{};
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polygonLatLngs = <LatLng>[];
  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  //String _currentLocationTitle = '';
  Position? _currentPosition;

  void _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //     position.latitude, position.longitude);
      //    Placemark currentPlace = placemarks[0];
      //    String title = currentPlace.street!;
      //   _currentLocationTitle = title;
      setState(() {
        _currentPosition = position;
        _setMarker(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
      });
    } catch (e) {
      print(e);
    }
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 5,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _kGooglePlex = _currentPosition != null
        ? CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 14.4746,
          )
        : const CameraPosition(
            target: LatLng(21.017506551750863, 105.78401782522056),
            zoom: 14.4746,
          );
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: ColorInstance.backgroundColor,
            title: Text(
              getString(context, 'type_map'),
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Handle'),
            ),
            elevation: 5,
          ),
          Expanded(
            flex: 1,
            child: _currentPosition == null
                ? Center(
                    child: CircularProgressIndicator(
                        color: ColorInstance.backgroundColor),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 8, right: 8),
                                  child: TextFormField(
                                    controller: _originController,
                                    decoration: InputDecoration(
                                        hintText:
                                            getString(context, 'txt_origin')),
                                    onChanged: (value) {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _destinationController,
                                    decoration: InputDecoration(
                                        hintText: getString(
                                            context, 'txt_destination')),
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (_originController.text.isEmpty ||
                                  _destinationController.text.isEmpty) {
                                showMessage(getString(
                                    context, 'message_data_not_empty'));
                              } else {
                                try {
                                  var directions = await LocationService()
                                      .getDirections(_originController.text,
                                          _destinationController.text);
                                  _goToPlace(
                                    directions['start_location']['lat'],
                                    directions['start_location']['lng'],
                                    directions['bounds_ne'],
                                    directions['bounds_sw'],
                                  );
                                  _setPolyline(directions['polyline_decoded']);
                                } catch (e) {
                                  showMessage(e.toString());
                                }
                              }
                            },
                            icon: Icon(Icons.search,
                                color: ColorInstance.backgroundColor, size: 35),
                          ),
                        ],
                      ),
                      Expanded(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          markers: _markers,
                          polygons: _polygons,
                          polylines: _polylines,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          onTap: (point) {
                            setState(() {
                              polygonLatLngs.add(point);
                              _setPolygon();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );
    _setMarker(LatLng(lat, lng));
  }
}
