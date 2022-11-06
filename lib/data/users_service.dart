import 'dart:developer';

import 'package:animal_house/domain/entities/conversation/chat.dart';
import 'package:animal_house/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "users";
  UserModel? user;
  List<ChatModel> chats = [];

  Future<void> addMessage(
      {required String userID, required ChatModel chatModel}) async {
    await _fireStore
        .collection(ref)
        .doc(userID)
        .collection('chats')
        .doc(chatModel.id)
        .update(chatModel.toJson());
  }

  Future<List<ChatModel>> getChats({required String userID}) async {
    await _fireStore
        .collection(ref)
        .doc(userID)
        .collection("chats")
        .get()
        .then((value) async {
      for (var element in value.docs) {
        UserModel user = await getUserById(element.id);
        chats.add(ChatModel.fromJson(element.data(), user));
      }
    }).catchError((e) {
      throw e;
    });
    return chats;
  }

  Future<void> createUser(
      String email, String password, String name, String phone) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _fireStore.collection(ref).doc(result.user!.uid).set({
      'userId': result.user!.uid,
      'name': name,
      "password": password,
      'email': email,
      'phone': phone,
      "my_products": [],
      "picture": '',
      "favourites": [],
      'address': '',
    }).then((value) {
      user = UserModel(
        id: result.user!.uid,
        email: email,
        name: name,
        picture: '',
        phone: phone,
        address: '',
        favourites: [],
        myProducts: [],
      );
    }).catchError((e) {
      throw e;
    });
  }

  Future<UserModel> getUserById(String id) async {
    late UserModel user;
    await _fireStore.collection(ref).doc(id).get().then((doc) {
      user = UserModel.fromjson(doc.data()!);
    });
    return user;
  }

  // void addToCart({required String userId, required CartModel cartItemFetcher}) {
  //   _fireStore.collection(ref).doc(userId).update({
  //     "cart": FieldValue.arrayUnion([cartItemFetcher.toMap()])
  //   });
  // }

  void addToFavourites(
      {required String userId, required String favItemId}) async {
    await _fireStore.collection(ref).doc(userId).update({
      "favourites": FieldValue.arrayUnion([favItemId])
    });
  }

  // void removeFromCart(
  //     {required String userId, required CartModel cartItemFetcher}) {
  //   _fireStore.collection(ref).doc(userId).update({
  //     "cart": FieldValue.arrayRemove([cartItemFetcher.toMap()])
  //   });
  // }

  void removeFromFavourites(
      {required String userId, required String favItemId}) {
    _fireStore.collection(ref).doc(userId).update({
      "favourites": FieldValue.arrayRemove([favItemId])
    });
  }
}
