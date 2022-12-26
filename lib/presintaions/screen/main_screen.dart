import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/domain/entities/category.dart';
import 'package:animal_house/main.dart';
import 'package:animal_house/presintaions/widgets/product_card_widget.dart';
import 'package:animal_house/presintaions/widgets/text_style.dart';
import 'package:animal_house/presintaions/providers/app_provider.dart';
import 'package:animal_house/presintaions/providers/product_provider.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'post_details_screen.dart';

List<CategoryModel> categories = [
  CategoryModel(name: 'Cats', imageUrl: "assets/cat.png", id: '1'),
  CategoryModel(name: 'Dogs', imageUrl: "assets/dog.png", id: '2'),
  CategoryModel(name: 'Birds', imageUrl: "assets/parrot.png", id: '3'),
  CategoryModel(name: 'Rabbits', imageUrl: "assets/rabbit.png", id: '4'),
  CategoryModel(name: 'Reptiles', imageUrl: "assets/reptiles.png", id: '5'),
  CategoryModel(name: 'Horses', imageUrl: "assets/horse.png", id: '6'),
];

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(isDrawerOpen ? -0.5 : 0),
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
      child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          strokeWidth: 2.0,
          onRefresh: () {
            Provider.of<ProductProvider>(context, listen: false)
                .loadProducts(context: context);
            return Future<void>.delayed(
              const Duration(seconds: 3),
              () => Navigator.pushReplacementNamed(context, MY_APP_SCREEN),
            );
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isDrawerOpen
                            ? IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  setState(() {
                                    xOffset = 0;
                                    yOffset = 0;
                                    scaleFactor = 1;
                                    isDrawerOpen = false;
                                  });
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  setState(() {
                                    xOffset = 230;
                                    yOffset = 150;
                                    scaleFactor = 0.6;
                                    isDrawerOpen = true;
                                  });
                                }),
                        Text(
                          'Pet House',
                          style: TextStyles.titleTextStyle
                              .copyWith(color: Colors.black),
                        ),
                        Consumer<UserProvider>(
                          builder: (context, user, _) {
                            return user.getUserModel.picture.isNotEmpty
                                ? CircleAvatar(
                                    radius: Dimensions.radius20,
                                    backgroundImage: CachedNetworkImageProvider(
                                        user.getUserModel.picture),
                                  )
                                : CircleAvatar(
                                    radius: Dimensions.radius20,
                                    backgroundImage:
                                        const AssetImage("assets/profile.png"),
                                  );
                          },
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    //=> Navigator.pushNamed(context, SEARCH_SCREEN),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                          boxShadow: shadowList,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          SizedBox(width: Dimensions.screenWidth * 0.18),
                          const Text(
                            'Search pet to adopt or buy',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .setCategoryName(
                                    name: categories[index].name,
                                    context: context);
                            Navigator.pushNamed(context, CATEGORY_SCREEN);
                          },
                          child: Container(
                            height: 10,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: shadowList,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  categories[index].imageUrl,
                                  height: 50,
                                  width: 50,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  categories[index].name,
                                  style: TextStyles.cardSubTitleTextStyle
                                      .copyWith(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      return provider.products.isNotEmpty
                          ? SizedBox(
                              height: Dimensions.screenHeight * 0.67,
                              width: double.infinity,
                              child: ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemCount: provider.products.length,
                                itemBuilder: (context, index) {
                                  return ProductCardWidget(
                                    index: index,
                                    product: provider.products[index],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(height: 15),
                              ),
                            )
                          : provider.products.isEmpty &&
                                  provider.loading == false
                              ? Center(
                                  child: Text(
                                    "No Items ",
                                    style: TextStyles.cardSubTitleTextStyle2
                                        .copyWith(color: Colors.black),
                                  ),
                                )
                              : provider.products.isEmpty &&
                                      provider.loading == true
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Container();
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
