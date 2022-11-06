 import 'package:animal_house/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesServices{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getMyFavourites(
      {required String userId, required List items}) async {
    List<ProductModel> myFav = [];
    for (var id in items) {
      await _fireStore.collection('products').doc(id).get().then((value) {
        
        myFav.add(ProductModel.fromMap(value.data()!, value.id));
      });
    }
    return myFav;
  }

}
