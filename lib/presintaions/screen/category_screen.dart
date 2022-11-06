import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/presintaions/common/product_card_widget.dart';
import 'package:animal_house/presintaions/common/text_style.dart';
import 'package:animal_house/presintaions/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

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
          "${Provider.of<AppProvider>(context, listen: false).categoryName} Category",
          style: TextStyles.titleTextStyle.copyWith(color: Colors.black),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return provider.filter.isNotEmpty
              ? SizedBox(
                  height: Dimensions.screenHeight * 0.67,
                  width: double.infinity,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: provider.filter.length,
                    itemBuilder: (context, index) {
                      return ProductCardWidget(
                        index: index,
                        product: provider.filter[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 15),
                  ),
                )
              : provider.filter.isEmpty && provider.loading == false
                  ? Center(
                      child: Text(
                        "No Items ",
                        style: TextStyles.cardSubTitleTextStyle2
                            .copyWith(color: Colors.black),
                      ),
                    )
                  : provider.filter.isEmpty && provider.loading == true
                      ? const Center(child: CircularProgressIndicator())
                      : Container();
        },
      ),
    );
  }
}
