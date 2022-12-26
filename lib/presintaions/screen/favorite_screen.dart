import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/presintaions/widgets/product_card_widget.dart';
import 'package:animal_house/presintaions/widgets/text_style.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getFavourites();
    super.initState();
  }

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
        return provider.myFavourites.isNotEmpty
            ? SizedBox(
                height: Dimensions.screenHeight,
                width: double.infinity,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: provider.myFavourites.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ProductCardWidget(
                          index: index,
                          product: provider.myFavourites[index],
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              onPressed: () {
                                provider.removeFromFavourites(
                                    favItemId: provider.myFavourites[index].id);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ))
                      ],
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
