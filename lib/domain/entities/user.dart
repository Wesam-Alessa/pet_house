// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'package:animal_house/domain/entities/favourite.dart';
import 'package:animal_house/domain/entities/product.dart';

class UserModel {
  static const String NAME = 'name';
  static const String ID = 'userId';
  static const String EMAIL = 'email';
  static const String PHONE = 'phone';
  static const String FAVOURITES = 'favourites';
  static const String PICTURE = 'picture';
  static const String ADDRESS = 'address';
  static const String MYPRODUCTS = "my_products";

  final String name;
  final String id;
  final String email;
  final String phone;
  final String picture;
  final String address;
  List<FavModel> favourites;
  List<ProductModel> myProducts;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.picture,
    required this.phone,
    required this.favourites,
    required this.address,
    required this.myProducts,
  });

  factory UserModel.fromjson(Map<String, dynamic> json) => UserModel(
        name: json[NAME],
        id: json[ID],
        email: json[EMAIL],
        phone: json[PHONE],
        picture: json[PICTURE],
        address: json[ADDRESS],
        favourites: List<FavModel>.from(
            json[FAVOURITES].map((e) => FavModel.fromMap(e))),
        myProducts: List<ProductModel>.from(
            json[MYPRODUCTS].map((e) => ProductModel.fromMap(e, json[ID]))),
      );

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "email": email,
      "phone": phone,
      "picture": picture,
      "address": address,
      "favourites": favourites,
      "myProducts": myProducts,
    };
  }
}
