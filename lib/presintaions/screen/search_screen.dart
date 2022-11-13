import 'package:animal_house/presintaions/common/text_style.dart';
import 'package:animal_house/presintaions/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utills/dimensions.dart';
import '../common/product_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {   
     Provider.of<ProductProvider>(context, listen: false)
        .productsSearched
        .clear();
     super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          "Search pet",
          style: TextStyles.titleTextStyle.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    Provider.of<ProductProvider>(context, listen: false)
                        .search(productName: value);
                  }
                  if (value.isEmpty) {
                    Provider.of<ProductProvider>(context, listen: false)
                        .productsSearched
                        .clear();
                    setState(() {});
                  }
                },
              ),
            ),
            Consumer<ProductProvider>(builder: (context, provider, _) {
              return provider.productsSearched.isNotEmpty
                  ? SizedBox(
                      height: Dimensions.screenHeight,
                      width: double.infinity,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: provider.productsSearched.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ProductCardWidget(
                            index: index,
                            product: provider.productsSearched[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 15),
                      ),
                    )
                  : Center(
                      child: Text(
                        "No Search Item",
                        style: TextStyles.cardSubTitleTextStyle2
                            .copyWith(color: Colors.black),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
