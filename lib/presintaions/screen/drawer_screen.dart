import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/main.dart';
import 'package:animal_house/presintaions/widgets/text_style.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

List<Map> drawerItems = [
  {
    'icon': FontAwesomeIcons.paw,
    'title': 'Back to Home',
    'onTap': HOME_SCREEN,
  },
  {
    'icon': FontAwesomeIcons.plus,
    'title': 'Add pet',
    'onTap': ADD_NEW_PET_SCREEN
  },
  {'icon': Icons.favorite, 'title': 'Favorites', 'onTap': FAVORITE_SCREEN},
  {'icon': Icons.mail, 'title': 'Messages', 'onTap': CHAT_SCREEN},
  {
    'icon': FontAwesomeIcons.userLarge,
    'title': 'Profile',
    'onTap': PROFILE_SCREEN
  },
];

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(top: 50, bottom: 70, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<UserProvider>(
            builder: (context, user, _) {
              return user.getUserModel.id.isNotEmpty
                  ? Row(
                      children: [
                        user.getUserModel.picture.isNotEmpty
                            ? CircleAvatar(
                                radius: Dimensions.radius20,
                                backgroundImage: CachedNetworkImageProvider(
                                    user.getUserModel.picture),
                              )
                            : CircleAvatar(
                                radius: Dimensions.radius20,
                                backgroundImage:
                                    const AssetImage("assets/profile.png"),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.getUserModel.name.toUpperCase(),
                                style: TextStyles.cardSubTitleTextStyle2
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: Dimensions.font16)),
                            Text('Active Status',
                                style: TextStyles.cardSubTitleTextStyle2
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: Dimensions.font12))
                          ],
                        )
                      ],
                    )
                  : Container();
            },
          ),
          Column(
            children: drawerItems
                .map((element) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          if (element['title'] == 'Back to Home') {
                            Navigator.pushReplacementNamed(
                                context, element["onTap"]);
                          } if (element['title'] == 'Add pet') {
                            Navigator.pushNamed(
                                context, element["onTap"]);
                          } 
                          if (element['title'] == 'Favorites') {
                            Navigator.pushNamed(
                                context, element["onTap"]);
                          } 
                          
                          // else {
                          //   Navigator.pushNamed(context, element["onTap"]);
                          // }
                        },
                        child: Row(
                          children: [
                            Icon(
                              element['icon'],
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(element['title'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          Row(
            children: [
              const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushReplacementNamed(context, MY_APP_SCREEN);
                  });
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
