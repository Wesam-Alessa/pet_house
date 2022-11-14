import 'dart:developer';
import 'dart:io';

import 'package:animal_house/domain/entities/conversation/chat.dart';
import 'package:animal_house/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "users";
  UserModel? user;
  List<ChatModel> chats = [];

  Future<void> addFriendMessage(
      {required bool exist,
      required ChatModel model,
      required UserModel userModel}) async {
    if (exist) {
      ChatModel freindChatModel = ChatModel(
          id: userModel.id,
          user: userModel,
          messages: model.messages,
          unReadCount: model.unReadCount,
          lastMessageAt: model.lastMessageAt);
      await _fireStore
          .collection(ref)
          .doc(model.id)
          .collection('chats')
          .doc(userModel.id)
          .update(freindChatModel.toJson());
    } else {
      ChatModel freindChatModel = ChatModel(
          id: userModel.id,
          user: userModel,
          messages: model.messages,
          unReadCount: model.unReadCount,
          lastMessageAt: model.lastMessageAt);
      await _fireStore
          .collection(ref)
          .doc(model.id)
          .collection('chats')
          .doc(userModel.id)
          .set(freindChatModel.toJson());
    }
  }

  Future<void> addMessage({
    required UserModel userModel,
    required ChatModel myModel,
  }) async {
    await getChats(userID: userModel.id);
    bool exist = false;
    for (var element in chats) {
      if (element.id == myModel.id) {
        log("exist:= ${element.id}");
        exist = true;
      }
    }

    if (exist) {
      await _fireStore
          .collection(ref)
          .doc(userModel.id)
          .collection('chats')
          .doc(myModel.id)
          .update(myModel.toJson())
          .then((value) {
        addFriendMessage(exist: exist, model: myModel, userModel: userModel);
      });
    } else {
      await _fireStore
          .collection(ref)
          .doc(userModel.id)
          .collection('chats')
          .doc(myModel.id)
          .set(myModel.toJson())
          .then((value) {
        addFriendMessage(exist: exist, model: myModel, userModel: userModel);
      });
    }
  }

  Future<bool> existChat(
      {required String userID, required String friendID}) async {
    final result = await _fireStore
        .collection(ref)
        .doc(userID)
        .collection('chats')
        .where('id', isEqualTo: friendID)
        .get();
    if (result.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<ChatModel>> getChats({required String userID}) async {
    chats.clear();
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

  Future<void> addToFavourites(
      {required String userId, required String favItemId}) async {
    await _fireStore.collection(ref).doc(userId).update({
      "favourites": FieldValue.arrayUnion([favItemId])
    });
  }

  Future<void> removeFromFavourites(
      {required String userId, required String favItemId}) async {
    log(favItemId);
    await _fireStore.collection(ref).doc(userId).update({
      "favourites": FieldValue.arrayRemove([favItemId])
    });
  }

  Future<void> updateUserName({
    required String userId,
    required String newName,
  }) async {
    await _fireStore.collection(ref).doc(userId).update({"name": newName});
  }

  Future<void> updateUserImage({
    required String userId,
    required File image,
  }) async {
    String url = '';
    await FirebaseStorage.instance
        .ref("users/$userId/profile/picture")
        .putFile(image)
        .then((value) {
      value.ref.getDownloadURL().then((durl) async {
        url = durl;
        await _fireStore.collection(ref).doc(userId).update({"picture": url});
      });
    });
  }
}
