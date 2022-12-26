import 'dart:developer';
import 'dart:io';

import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/presintaions/widgets/product_card_widget.dart';
import 'package:animal_house/presintaions/widgets/text_style.dart';
import 'package:animal_house/presintaions/providers/product_provider.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImagePicker picher = ImagePicker();
  File? imageFile;
  TextEditingController nameController = TextEditingController();
  bool edit = false;

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).getMyProducts(
        Provider.of<UserProvider>(context, listen: false).getUserModel.id);
    Provider.of<UserProvider>(context, listen: false).getFavourites();
    super.initState();
  }

  @override
  void dispose() {
    imageFile = null;
    nameController.dispose();
    edit = false;
    super.dispose();
  }

  void updateImage(BuildContext context) async {
    XFile? baseFile;
    baseFile = await picher.pickImage(source: ImageSource.gallery);
    if (baseFile != null) {
      File image = File(baseFile.path);
      setState(() {
        imageFile = image;
      });
      if (imageFile != null) {
        uploadImage(image);
      }
    }
  }

  Future<void> uploadImage(File image) async {
    Provider.of<UserProvider>(context, listen: false)
        .updateUserImage(image, context)
        .then((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Provider.of<UserProvider>(context, listen: false).getUserData();
      });
    });
  }

  Future<void> updateName(String newName) async {
    setState(() {
      edit = false;
    });
    Provider.of<UserProvider>(context, listen: false)
        .updateUserName(newName, context)
        .then((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Provider.of<UserProvider>(context, listen: false).getUserData();
      });
    });
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
          "Profile",
          style: TextStyles.titleTextStyle.copyWith(color: Colors.black),
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Dimensions.screenWidth,
                height: Dimensions.screenHeight * 0.27,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15 / 2,
                    vertical: Dimensions.height15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: Dimensions.radius30 * 4.5,
                          height: Dimensions.radius30 * 4.5,
                          child: imageFile != null
                              ? CircleAvatar(
                                  radius: Dimensions.radius30 * 2,
                                  backgroundImage: FileImage(imageFile!))
                              : userProvider.getUserModel.picture.isNotEmpty
                                  ? CircleAvatar(
                                      radius: Dimensions.radius30 * 2,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        userProvider.getUserModel.picture,
                                      ))
                                  : CircleAvatar(
                                      radius: Dimensions.radius30 * 2,
                                      backgroundImage: const AssetImage(
                                          "assets/profile.png")),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => updateImage(context),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: Dimensions.radius15,
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userProvider.getUserModel.name,
                          style: TextStyles.subscriptionAmountTextStyle
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (edit)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Name',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.5, color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.5, color: Colors.black),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      log(value);
                      updateName(nameController.text);
                    },
                  ),
                ),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15 / 2,
                    vertical: Dimensions.height10 / 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Favourites",
                          style: TextStyles.subscriptionTitleTextStyle
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          "${userProvider.myFavourites.length}",
                          style: TextStyles.enjoyTextStyle
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                    Consumer<ProductProvider>(builder: (context, provider, _) {
                      return Column(
                        children: [
                          Text(
                            "My Posts",
                            style: TextStyles.subscriptionTitleTextStyle
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            "${provider.myProducts.length}",
                            style: TextStyles.enjoyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      );
                    })
                  ],
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15 / 2,
                    vertical: Dimensions.height10),
                child: Row(
                  children: [
                    Text(
                      "My Posts",
                      style: TextStyles.subscriptionTitleTextStyle
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  return provider.myProducts.isNotEmpty
                      ? SizedBox(
                          height: Dimensions.screenHeight * 0.67,
                          width: double.infinity,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: provider.myProducts.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ProductCardWidget(
                                    index: index,
                                    product: provider.myProducts[index],
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red[400],
                                        ),
                                        onPressed: () {
                                          log(provider.myProducts[index].id);
                                          provider.deletePost(
                                            provider.myProducts[index].id,
                                            context,
                                          );
                                          userProvider.removeFromFavourites(
                                              favItemId: provider
                                                  .myProducts[index].id);
                                        },
                                      ))
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 15),
                          ),
                        )
                      : provider.products.isEmpty && provider.loading == false
                          ? Container()
                          : provider.products.isEmpty &&
                                  provider.loading == true
                              ? const Center(child: CircularProgressIndicator())
                              : Container();
                },
              ),
             const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
