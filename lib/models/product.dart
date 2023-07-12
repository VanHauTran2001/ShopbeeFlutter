
// ignore_for_file: non_constant_identifier_names
import 'dart:ui';

class Product{
  String IdProduct;
  String ImageProduct;
  String NameProduct;
  String PriceProduct;
  String DescriptionProduct;
  String TypeProduct;
  String SelledProduct;
  String FavStatusProduct;
  String sale;
  int? numberOrder;
  Product(
      {
      required this.IdProduct,
      required this.ImageProduct,
      required this.NameProduct,
      required this.PriceProduct,
      required this.DescriptionProduct,
      required this.TypeProduct,
      required this.SelledProduct,
      required this.FavStatusProduct,
      required this.sale,
      required this.numberOrder
      }
      );
  factory Product.fromJson(Map<String, dynamic> json){
      return Product(
          IdProduct: json['IdProduct'],
          ImageProduct: json['ImageProduct'],
          NameProduct: json['NameProduct'],
          PriceProduct: json['PriceProduct'],
          DescriptionProduct: json['DescriptionProduct'],
          TypeProduct: json['TypeProduct'],
          SelledProduct: json['SelledProduct'],
          FavStatusProduct: json['FavStatusProduct'],
          sale: json['sale'],
          numberOrder: json['numberOrder']
      );
  }
  Map<String,dynamic> toJson() => {
    'IdProduct' : IdProduct,
    'ImageProduct' : ImageProduct,
    'NameProduct' : NameProduct,
    'PriceProduct' : PriceProduct,
    'DescriptionProduct' : DescriptionProduct,
    'TypeProduct' : TypeProduct,
    'SelledProduct' : SelledProduct,
    'FavStatusProduct' : FavStatusProduct,
    'sale' : sale,
    'numberOrder' : numberOrder,

  };
  Product copyWith({
    int? numberOrder,
}) => 
      Product(
          IdProduct: IdProduct,
          ImageProduct: ImageProduct,
          NameProduct: NameProduct,
          PriceProduct: PriceProduct,
          DescriptionProduct: DescriptionProduct,
          TypeProduct: TypeProduct,
          SelledProduct: SelledProduct,
          FavStatusProduct: FavStatusProduct,
          sale: sale,
          numberOrder: numberOrder ?? this.numberOrder
      );
}