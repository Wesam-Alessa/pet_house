import 'package:animal_house/core/error/show_custom_snackbar.dart';
import 'package:animal_house/domain/entities/category.dart';
import 'package:animal_house/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class ProductsService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String collection = 'products';
  List<ProductModel> allProducts = [];
  List<CategoryModel> categories = [];

  Future<List<ProductModel>> getProducts({
    required BuildContext context,
  }) async =>
      await _fireStore.collection(collection).get().then((result) {
        List<ProductModel> products = [];
        for (var product in result.docs) {
          products.add(ProductModel.fromMap(product.data(), product.id));
        }
        allProducts = products;
        return products;
      }).catchError((e) {
         ScaffoldMessenger.of(context)
            .showSnackBar(MySnackBars.failureSnackBar(e.toString()));
      });

  Future<List<ProductModel>> getProductsFav(
          {required BuildContext context, required String pId}) async =>
      _fireStore
          .collection(collection)
          .where('id', isEqualTo: pId)
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (var product in result.docs) {
          products.add(ProductModel.fromMap(product.data(), product.id));
        }
        return products;
      }).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(MySnackBars.failureSnackBar(e.toString()));
      });

  List<ProductModel> searchProducts({required String productName}) {
    // code to convert the first character to lowercase
    String searchKey = productName[0].toLowerCase() + productName.substring(1);
    List<ProductModel> products = [];
    for (var element in allProducts) {
      if (element.name.toLowerCase().startsWith(searchKey)) {
        products.add(element);
      }
    }
    return products;
  }



  Future<List<CategoryModel>> getCategories(
      {required BuildContext context}) async {
    await _fireStore.collection('categories').get().then((result) {
      for (var category in result.docs) {
        categories.add(CategoryModel.fromjson(category.data()));
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.failureSnackBar(e.toString()));
    });
    return categories;
  }

  Future<bool> deletePost(String postID) async {
    await _fireStore.collection(collection).doc(postID).delete().then((value) {
      return true;
    }).catchError((onError) {
      return false;
    });
    return false;
  }
}
