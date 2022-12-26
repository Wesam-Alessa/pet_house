
import 'package:animal_house/domain/entities/product.dart';
import 'package:animal_house/presintaions/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppProvider with ChangeNotifier {
  //final ProductsService _productsService = ProductsService();
  bool loading = false;
  ProductModel? productModelDetails;
  String categoryName = '';
  List<ProductModel> filter = [];

  void setProductForDetails(ProductModel productModel) {
    productModelDetails = productModel;
    notifyListeners();
  }

  void setCategoryName({required String name, required BuildContext context}) {
    categoryName = name;
    filterProducts(context: context);
    notifyListeners();
  }

  void filterProducts({required BuildContext context}) {
    loading = true;
    notifyListeners();
    filter.clear();
    for (var element
        in Provider.of<ProductProvider>(context, listen: false).products) {
      if (element.category.toLowerCase().contains(categoryName.toLowerCase())) {
        filter.add(element);
      }
    }
    loading = false;
    notifyListeners();
  }

  // void changeIsLoading() {
  //   isLoading = !isLoading;
  //   notifyListeners();
  // }

  // AppProvider() {
  //   _getFeaturedProducts();
  // }

//  getter
  //List<ProductModel> get featureProducts => _featureProducts;

//  methods
  // Future<void> getFeaturedProducts({required BuildContext context}) async {
  //   featureProducts = await _productsService.getProducts(context: context);
  //   notifyListeners();
  // }
}
