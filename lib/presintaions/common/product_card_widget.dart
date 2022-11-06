import 'package:animal_house/domain/entities/product.dart';
import 'package:animal_house/presintaions/common/text_style.dart';
import 'package:animal_house/presintaions/providers/app_provider.dart';
import 'package:animal_house/presintaions/screen/ad_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final int index;
  const ProductCardWidget(
      {Key? key, required this.product, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<AppProvider>(context, listen: false)
            .setProductForDetails(product);
        Provider.of<UserProvider>(context, listen: false).userProduct = null;
        if (product.userId.isNotEmpty) {
          Provider.of<UserProvider>(context, listen: false)
              .getUserProduct(product.userId);
        }

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AdDetailsScreen()));
      },
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? Colors.blueGrey[300]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: shadowList,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(product.pictures[0]),
                        fit: BoxFit.fill)),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadowList,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        product.name,
                        style: TextStyles.subscriptionTitleTextStyle
                            .copyWith(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            product.address,
                            style: TextStyles.cardSubTitleTextStyle
                                .copyWith(color: Colors.black),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      Text(
                        DateFormat('MMM d, h:mm a')
                            .format(DateTime.parse(product.dateTime)),
                        style: TextStyles.cardSubTitleTextStyle
                            .copyWith(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product.price == 0)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                "For Adoption",
                                style: TextStyles.body3TextStyle
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              product.gender == "female"
                                  ? Icons.female
                                  : Icons.male,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      if (product.price != 0)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                "${product.price} JOD",
                                style: TextStyles.body3TextStyle
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              product.gender == "female"
                                  ? Icons.female
                                  : Icons.male,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
