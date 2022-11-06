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

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  final UserServices _userServices = UserServices();
  late UserModel _userModel;
  UserModel? userProduct;

  final FavouritesServices _favouritesServices = FavouritesServices();
  bool loading = false;
  List<ProductModel> myFavourites = [];
  List<ProductModel> myProducts = [];
  List<ChatModel> chats = [];

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
    if (FirebaseAuth.instance.currentUser != null) {
      getUserData().then((value) => getFavourites());
    }
  }

  ChatModel existChat({required String frindId}) {
    ChatModel? model;
    for (var e in chats) {
      if (e.id == frindId) {
        model = e;
      }
    }
    if (model != null) {
      return model;
    } else {
      model = ChatModel(
        id: frindId,
        user: userProduct!,
        messages: [],
        unReadCount: 0,
        lastMessageAt: '',
      );
      return model;
    }
  }

  Future<void> getChats() async {
    loading = true;
    chats = await _userServices.getChats(userID: _userModel.id);
    loading = false;
    notifyListeners();
  }

  Future<void> addMessage({required ChatModel myModel}) async {
    await _userServices.addMessage(userModel: _userModel, myModel: myModel);
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

  Future<bool> addToFavourites({required String productId}) async {
    try {
      if (_userModel.id.isEmpty) {
        await getUserData();
      }
      await _userServices.addToFavourites(
          userId: _userModel.id, favItemId: productId);
      await getUserData();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromFavourites({required String favItemId}) async {
    try {
      await _userServices.removeFromFavourites(
          userId: _userModel.id, favItemId: favItemId);
     await getUserData();
      myFavourites.remove(
          myFavourites.firstWhere((element) => element.id == favItemId));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getFavourites() async {
    if (_userModel.id.isEmpty) {
      await getUserData();
    }
    myFavourites = await _favouritesServices.getMyFavourites(
        items: _userModel.favourites, userId: _userModel.id);
     notifyListeners();
  }
}
