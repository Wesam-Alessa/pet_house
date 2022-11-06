// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:animal_house/core/error/show_custom_snackbar.dart';
import 'package:animal_house/data/favourite_service.dart';
import 'package:animal_house/data/users_service.dart';
import 'package:animal_house/domain/entities/conversation/chat.dart';
import 'package:animal_house/domain/entities/product.dart';
import 'package:animal_house/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
// enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  //late User _user;
  final UserServices _userServices = UserServices();
  late UserModel _userModel;
  UserModel? userProduct;

  final FavouritesServices _favouritesServices = FavouritesServices();
  bool loading = false;
  List<ProductModel> favourites = [];
  List<ProductModel> myProducts = [];
  List<ChatModel> chats = [];
  //User get user => _user;

  UserModel get getUserModel => _userModel;

  UserProvider.initialized() : _auth = FirebaseAuth.instance {
    _userModel = UserModel(
      email: '',
      favourites: [],
      id: '',
      name: '',
      picture: '',
      address: '',
      myProducts: [],
      phone: '',
    );
    if (FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
      getUserData();
    }
  }

  Future<void> getChats() async {
    loading = true;
    chats = await _userServices.getChats(userID: _userModel.id);
    loading = false;
    notifyListeners();
  }

  Future<void> addMessage({required ChatModel chatModel}) async {
   await _userServices.addMessage(userID: _userModel.id, chatModel: chatModel);
  }

  Future<void> getUserProduct(String id) async {
    userProduct = await _userServices.getUserById(id);
    log(userProduct!.name);
    notifyListeners();
  }

  Future<void> getUserData() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    _userModel = await _userServices.getUserById(id);
    log(_userModel.name);
    notifyListeners();
  }

  Future<bool> signIn(
      BuildContext context, String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(result.user!.uid)
          .get()
          .then((doc) {
        log(doc.data().toString());
        _userModel = UserModel.fromjson(doc.data()!);
      });
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.failureSnackBar(e.toString()));
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(BuildContext context, String name, String email,
      String password, String phone) async {
    try {
      loading = true;
      notifyListeners();
      await _userServices.createUser(
        email,
        password,
        name,
        phone,
      );
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.failureSnackBar(e.toString()));
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    // _status = Status.Unauthenticated;
    notifyListeners();
    return;
  }

  // void _onStateChanged(User? user) async {
  //   if (user == null) {
  //     // _status = Status.Unauthenticated;
  //   } else {
  //     _user = user;
  //     _userFetcher = await _userServices.getUserById(user.uid);
  //     // _status = Status.Authenticated;
  //   }
  //   notifyListeners();
  // }

  // Future<bool> addToCart({
  //   ProductModel? product,
  //   String? size,
  //   String? quantity,
  // }) async {
  //   try {
  //     // var uuid = const Uuid();
  //     // String cartItemId = uuid.v4();
  //     //List<CartModel> cart = _userFetcher.cart!;

  //     Map<String,dynamic> cartItem = {
  //       "id": '',
  //       "name": product!.name,
  //       "pictures": product.pictures,
  //       "productId": product.id,
  //       "price": product.price,
  //       "size": size,
  //       "quantity": quantity,
  //       "brand": product.brand,
  //       'category': product.category,
  //       "description": product.description,
  //       "featured": product.featured
  //     };

  //     //CartModel item = CartModel.fromMap(cartItem);
  //     //print("CART ITEMS ARE: ${cart.toString()}");
  //     //_userServices.addToCart(userId: _user.uid, cartItemFetcher: item);
  //     return true;
  //   } catch (e) {
  //     print("THE ERROR ${e.toString()}");
  //     return false;
  //   }
  // }

  Future<bool> addToFavourites({required String productId}) async {
    try {
      // List<FavModel> favourites = _userFetcher.favourites!;
      // Map<String, dynamic> favouritesItem = {
      //   "id": product.id,
      //   "name": product.name,
      //   "pictures": product.pictures,
      //   "quantity": product.quantity,
      //   "price": product.price,
      //   "brand": product.brand,
      //   'category': product.category,
      //   "description": product.description,
      //   "featured": product.featured,
      //   'age_years': product.ageYears,
      //   'age_mounth': product.ageMounth
      // };
      // FavModel item = FavModel.fromMap(favouritesItem);
      if (_userModel.id.isEmpty) {
        await getUserData();
      }
      _userServices.addToFavourites(
          userId: _userModel.id, favItemId: productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> removeFromCart({required CartModel cartItem}) async {
  //    try {
  //     _userServices.removeFromCart(
  //         userId: _user.uid, cartItemFetcher: cartItem);
  //     return true;
  //   } catch (e) {
  //     print("THE ERROR ${e.toString()}");
  //     return false;
  //   }
  // }

  Future<bool> removeFromFavourites({required String favItemId}) async {
    try {
      _userServices.removeFromFavourites(
          userId: _userModel.id, favItemId: favItemId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> reloadUserFetcher() async {
    _userModel = await _userServices.getUserById(_userModel.id);
    notifyListeners();
  }

  // Future<void> getOrders() async {
  //   orders = await _orderServices.getUserOrders(userId: _user.uid);
  //   notifyListeners();
  // }

  Future<void> getFavourites() async {
    if (_userModel.id.isEmpty) {
      await getUserData();
    }
    favourites =
        await _favouritesServices.getUserFavourites(userId: _userModel.id);
    notifyListeners();
  }
}
