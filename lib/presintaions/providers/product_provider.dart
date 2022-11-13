import 'dart:io';

import 'package:animal_house/core/error/show_custom_snackbar.dart';
import 'package:animal_house/data/product_service.dart';
import 'package:animal_house/domain/entities/category.dart';
import 'package:animal_house/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final ProductsService _productServices = ProductsService();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];
  List<ProductModel> myProducts = [];
  List<CategoryModel> categories = [];
  bool loading = false;

  ProductProvider.initialize({required BuildContext context}) {
    loading = true;
    notifyListeners();
    FirebaseAuth.instance.currentUser != null
        ? loadProducts(context: context)
        : null;
  }

  Future<void> loadProducts({required BuildContext context}) async {
    products = await _productServices.getProducts(context: context);
    loading = false;
    notifyListeners();
  }

  Future<List<ProductModel>> getMyProducts(String id) async {
    myProducts.clear();
    for (var element in products) {
      if (element.userId == id) {
        myProducts.add(element);
      }
    }
    return myProducts;
  }

   

  Future<void> getCategories(context) async {
    categories = await _productServices.getCategories(context: context);
    notifyListeners();
  }

  Future<void> search({required String productName}) async {
    
    productsSearched =
        _productServices.searchProducts(productName: productName);
    notifyListeners();
  }

 

  Future<List<String>> uploadFiles(List<File> images, String userId) async {
    var imageUrls =
        await Future.wait(images.map((image) => uploadFile(image, userId)));
    return imageUrls;
  }

  Future<String> uploadFile(File image, String userId) async {
    var storageReference =
        FirebaseStorage.instance.ref('images').child('$userId/${image.path}');
    var uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() {});
    return await storageReference.getDownloadURL();
  }

  Future<void> uploadProduct(
      {required BuildContext context, required ProductModel product}) async {
    loading = true;
    notifyListeners();
    try {
      if (product.pictures != []) {
        await uploadFiles(product.pictures as List<File>, product.userId)
            .then((value) {
          ProductModel newPro = ProductModel(
            name: product.name,
            id: product.id,
            userId: product.userId,
            category: product.category,
            quantity: product.quantity,
            price: product.price,
            ageYears: product.ageYears,
            ageMounth: product.ageMounth,
            pictures: value,
            description: product.description,
            address: product.address,
            dateTime: product.dateTime,
            contact: product.contact,
            gender: product.gender,
            type: product.type,
          );
          FirebaseFirestore.instance
              .collection('products')
              .add(newPro.toMap())
              .then((value) {
            products.add(product);
          }).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
                MySnackBars.successSnackBar("upload successfully "));
          }).catchError((onError) {
            products.remove(product);
          });
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(MySnackBars.failureSnackBar("Add at least 1 image"));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.failureSnackBar(e.toString()));
    }
    loading = false;
    notifyListeners();
  }

  Future<void> deletePost(
    String postID,
    BuildContext context,
  ) async {
    await _productServices.deletePost(postID).then((value) {
      if (true) {
        myProducts.remove(myProducts.firstWhere(
          (element) => element.id == postID,
        ));
        
        loadProducts(context: context);
      }
    });
    notifyListeners();
  }
}
