import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/presintaions/common/product_card_widget.dart';
import 'package:animal_house/presintaions/common/text_style.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:animal_house/presintaions/screen/choos_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Favorites",
          style: TextStyles.titleTextStyle.copyWith(color: Colors.black),
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, provider, _) {
        //provider.favourites = products;
        return provider.favourites.isNotEmpty
            ? SizedBox(
                height: Dimensions.screenHeight,
                width: double.infinity,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: provider.favourites.length,
                  itemBuilder: (context, index) {
                    return ProductCardWidget(
                      index: index,
                      product: provider.favourites[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 15),
                ),
              )
            : Center(
                child: Text(
                  "No Favorite Item",
                  style: TextStyles.cardSubTitleTextStyle2
                      .copyWith(color: Colors.black),
                ),
              );
      }),
    );
  }
}
