import 'dart:developer';

import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/main.dart';
import 'package:animal_house/presintaions/common/cached_network_image.dart';
import 'package:animal_house/presintaions/common/text_style.dart';
import 'package:animal_house/presintaions/providers/app_provider.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdDetailsScreen extends StatefulWidget {
  const AdDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

Color primaryGreen = const Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(
      color: Colors.grey.shade300, blurRadius: 30, offset: const Offset(0, 10))
];

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  bool exist = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, state, _) {
          if (state.productModelDetails == null) {
            return const Center(
              child: Text("something wrong"),
            );
          } else {
            return Stack(
              children: [
                Positioned(
                  top: Dimensions.screenHeight / 1.9,
                  child: Container(
                    height: Dimensions.screenHeight / 3,
                    width: Dimensions.screenWidth,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<UserProvider>(
                          builder: (context, userProvider, _) {
                            return userProvider.userProduct != null
                                ? SizedBox(
                                    height: Dimensions.height10 * 5,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: Dimensions.radius25,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  userProvider
                                                      .userProduct!.picture),
                                        ),
                                        SizedBox(width: Dimensions.width10 / 2),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    userProvider
                                                        .userProduct!.name,
                                                    style: TextStyles
                                                        .enjoyTextStyle
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    DateFormat('MMM d, h:mm a')
                                                        .format(DateTime.parse(state
                                                            .productModelDetails!
                                                            .dateTime)),
                                                    style: TextStyles
                                                        .cardSubTitleTextStyle2
                                                        .copyWith(
                                                            color: Colors
                                                                .grey.shade500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Owner",
                                                    style: TextStyles
                                                        .cardSubTitleTextStyle2
                                                        .copyWith(
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  if (userProvider
                                                          .userProduct!.id !=
                                                      userProvider
                                                          .getUserModel.id)
                                                    GestureDetector(
                                                      onTap: () {
                                                        var chat = Provider.of<
                                                                    UserProvider>(
                                                                context,
                                                                listen: false)
                                                            .existChat(
                                                                frindId:
                                                                    userProvider
                                                                        .userProduct!
                                                                        .id);

                                                        chat.messages = chat
                                                            .messages.reversed
                                                            .toList();

                                                        Navigator.pushNamed(
                                                            context,
                                                            MESSAGE_SCREEN,
                                                            arguments: chat);
                                                      },
                                                      child: Icon(
                                                        Icons.chat,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Description',
                            style: TextStyles.cardSubTitleTextStyle2
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          height: Dimensions.screenHeight / 5.5,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SingleChildScrollView(
                            child: RichText(
                              text: TextSpan(
                                  text: state.productModelDetails!.description,
                                  style: TextStyles.cardSubTitleTextStyle2
                                      .copyWith(color: Colors.grey.shade500)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: Dimensions.screenHeight / 2.5,
                  margin: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Hero(
                      tag: 1,
                      child: Stack(
                        children: [
                          CarouselSlider.builder(
                            itemCount:
                                state.productModelDetails!.pictures.length,
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              return CachedImage(
                                imageUrl:
                                    state.productModelDetails!.pictures[index],
                              );
                            },
                            carouselController: _controller,
                            options: CarouselOptions(
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                              height: Dimensions.screenHeight / 2,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: Dimensions.screenHeight / 2.65,
                  child: Container(
                    height: 100,
                    width: Dimensions.screenWidth - 40,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: shadowList,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.productModelDetails!.name,
                              style: TextStyles.subscriptionTitleTextStyle
                                  .copyWith(color: Colors.black),
                            ),
                            Icon(
                              state.productModelDetails!.gender == "male"
                                  ? Icons.male
                                  : Icons.female,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.productModelDetails!.type,
                              style: TextStyles.cardSubTitleTextStyle2
                                  .copyWith(color: Colors.grey.shade500),
                            ),
                            Text(
                              state.productModelDetails!.ageYears != 0 &&
                                      state.productModelDetails!.ageMounth != 0
                                  ? '${state.productModelDetails!.ageYears}.${state.productModelDetails!.ageMounth} y old'
                                  : state.productModelDetails!.ageYears != 0 &&
                                          state.productModelDetails!
                                                  .ageMounth ==
                                              0
                                      ? '${state.productModelDetails!.ageYears} years old'
                                      : '${state.productModelDetails!.ageMounth} mounths old',
                              style: TextStyles.cardSubTitleTextStyle2
                                  .copyWith(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_sharp,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              state.productModelDetails!.address,
                              style: TextStyles.cardSubTitleTextStyle2
                                  .copyWith(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Row(
                      children: [
                        Consumer<UserProvider>(builder: (context, provider, _) {
                          exist = provider.getUserModel.favourites
                              .contains(state.productModelDetails!.id);
                          return GestureDetector(
                            onTap: () {
                              if (exist) {
                                provider.removeFromFavourites(
                                    favItemId: state.productModelDetails!.id);
                              } else {
                                provider.addToFavourites(
                                    productId: state.productModelDetails!.id);
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                exist
                                    ? Icons.favorite_outlined
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => callNumber(
                                number: state.productModelDetails!.contact),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Call for Adoption',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimensions.font16),
                                  ),
                                ],
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: state.productModelDetails!.pictures
                                .asMap()
                                .entries
                                .map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black)
                                          .withOpacity(_current == entry.key
                                              ? 0.9
                                              : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  callNumber({required String number}) async {
    await FlutterPhoneDirectCaller.callNumber(number) ?? false;
  }
}
