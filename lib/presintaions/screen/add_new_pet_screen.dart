import 'dart:io';

import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/domain/entities/product.dart';
import 'package:animal_house/presintaions/widgets/text_form_feild.dart';
import 'package:animal_house/presintaions/widgets/text_style.dart';
import 'package:animal_house/presintaions/providers/product_provider.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddNewPetScreen extends StatefulWidget {
  const AddNewPetScreen({Key? key}) : super(key: key);

  @override
  State<AddNewPetScreen> createState() => _AddNewPetScreenState();
}

class _AddNewPetScreenState extends State<AddNewPetScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController price = TextEditingController();

  int quantity = 0;
  int ageYears = 0;
  int ageMounth = 0;
  List<String> genderItems = ['male', 'female'];
  String genderValue = '';
  List<File> images = [];
  ImagePicker picker = ImagePicker();

  void pickImages() async {
    images.clear();
    List<XFile> pImage = [];
    pImage = await picker.pickMultiImage();
    for (var image in pImage) {
      images.add(File(image.path));
    }
    setState(() {});
  }

  String categoryValue = '';
  List<String> categoryItems = [];

  @override
  void initState() {
    genderValue = genderItems[0];
    getCategories();
    super.initState();
  }

  void getCategories() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .getCategories(context)
        .then((value) {
      for (var item
          in Provider.of<ProductProvider>(context, listen: false).categories) {
        categoryItems.add(item.name);
      }
      categoryValue = categoryItems[0];
      setState(() {});
    });
  }

  @override
  void dispose() {
    categoryItems.clear();
    categoryValue = '';
    name.dispose();
    description.dispose();
    contact.dispose();
    address.dispose();
    type.dispose();
    images.clear();
    price.dispose();
    quantity = 0;
    ageYears = 0;
    ageMounth = 0;
    genderValue = '';
    super.dispose();
  }

  void uploadNewPet() async {
    ProductModel product = ProductModel(
        name: name.text,
        id: '',
        userId:
            Provider.of<UserProvider>(context, listen: false).getUserModel.id,
        category: categoryValue,
        quantity: quantity.toString(),
        price: double.parse(price.text),
        ageYears: ageYears,
        ageMounth: ageMounth,
        pictures: images,
        description: description.text,
        address: address.text,
        dateTime: DateTime.now().toString(),
        contact: contact.text,
        gender: genderValue,
        type: type.text);
    await Provider.of<ProductProvider>(context, listen: false)
        .uploadProduct(product: product, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Consumer<ProductProvider>(builder: (context, state, _) {
          return state.loading
              ? const SizedBox()
              : IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                );
        }),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Add New pet",
          style: TextStyles.titleTextStyle.copyWith(color: Colors.black),
        ),
        actions: [
          Consumer<ProductProvider>(builder: (context, state, _) {
            return state.loading
                ? SizedBox(
                    width: Dimensions.height20 * 2,
                    child: const Center(child: CircularProgressIndicator()))
                : IconButton(
                    onPressed: uploadNewPet,
                    icon: const Icon(
                      Icons.file_upload_outlined,
                      color: Colors.black,
                    ),
                  );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: Dimensions.screenHeight / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.radius10 / 2),
                  ),
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: images.isEmpty
                    ? Center(
                        child: IconButton(
                            onPressed: pickImages,
                            icon: Icon(
                              Icons.add,
                              size: Dimensions.iconSize24,
                            )))
                    : ListView.builder(
                        itemCount: images.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        itemBuilder: ((context, index) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    images[index],
                                    fit: BoxFit.cover,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        images.remove(images[index]);
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: Dimensions.radius25 / 2,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                          child: Icon(
                                        Icons.close,
                                        size: Dimensions.iconSize18,
                                        color: Colors.black,
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ))),
              ),
              const SizedBox(height: 10),
              TextFormFieldWidget(title: 'Name', controller: name),
              const SizedBox(height: 10),
              TextFormFieldWidget(
                  title: 'Description', controller: description),
              const SizedBox(height: 10),
              TextFormFieldWidget(title: 'Type', controller: type),
              const SizedBox(height: 10),
              TextFormFieldWidget(title: 'Address', controller: address),
              const SizedBox(height: 10),
              TextFormFieldWidget(title: 'Contact', controller: contact),
              const SizedBox(height: 10),
              TextFormFieldWidget(
                  title: 'Price', controller: price, number: true),
              const SizedBox(height: 10),
              if (categoryItems.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimensions.radius10 / 2),
                    ),
                    border: Border.all(width: 2, color: Colors.grey),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: DropdownButton(
                    underline: Container(),
                    isExpanded: true,
                    value: categoryValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: categoryItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        categoryValue = newValue!;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.radius10 / 2),
                  ),
                  border: Border.all(width: 2, color: Colors.grey),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButton(
                  underline: Container(),
                  isExpanded: true,
                  value: genderValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: genderItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      genderValue = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Age years",
                        style: TextStyles.cardSubTitleTextStyle2
                            .copyWith(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: Dimensions.height45,
                        width: Dimensions.screenWidth / 3,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius10),
                          border:
                              Border.all(color: Colors.grey.shade700, width: 1),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    if (ageYears > 0) {
                                      setState(() {
                                        ageYears--;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.remove)),
                              Text("$ageYears"),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ageYears++;
                                    });
                                  },
                                  child: const Icon(Icons.add)),
                            ]),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Age mounths",
                        style: TextStyles.cardSubTitleTextStyle2
                            .copyWith(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: Dimensions.height45,
                        width: Dimensions.screenWidth / 3,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius10),
                          border:
                              Border.all(color: Colors.grey.shade700, width: 1),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    if (ageMounth > 0) {
                                      setState(() {
                                        ageMounth--;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.remove)),
                              Text("$ageMounth"),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ageMounth++;
                                    });
                                  },
                                  child: const Icon(Icons.add)),
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Quantity",
                        style: TextStyles.cardSubTitleTextStyle2
                            .copyWith(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: Dimensions.height45,
                        width: Dimensions.screenWidth / 3,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius10),
                          border:
                              Border.all(color: Colors.grey.shade700, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (quantity > 0) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },
                                child: const Icon(Icons.remove)),
                            Text("$quantity"),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                child: const Icon(Icons.add)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
