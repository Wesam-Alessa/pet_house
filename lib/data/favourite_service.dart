 import 'package:animal_house/domain/entities/favourite.dart';
import 'package:animal_house/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesServices{
  String collection = "favourites";
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  void createFavourites({required String userId ,
    required String id,required List description,
    required List<FavModel> favourites}) {
     List<Map> convertedFav = [];
    for(FavModel item in favourites){
      convertedFav.add(item.toMap());
    }
    fireStore.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "description": description,
    });
  }

  Future<List<ProductModel>> getUserFavourites({required String userId}) async =>
      fireStore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .get()
          .then((result) {
        List<ProductModel> favourites = [];
        for (var fav in result.docs) {
          favourites.add(ProductModel.fromMap(fav.data(),fav.id));
        }
        return favourites;
      });

}
