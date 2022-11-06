import 'package:animal_house/core/constant/strings.dart';
import 'package:animal_house/main.dart';
import 'package:animal_house/presintaions/common/custom_appbar.dart';
import 'package:animal_house/presintaions/common/neivigation_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:animal_house/presintaions/common/text_style.dart';

class ScreenLanding extends StatelessWidget {
  const ScreenLanding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/elephant.jpg",
            height: height,
            width: double.infinity,
            fit: BoxFit.fitHeight,
          ),
          Column(
            children: [
              const CustomAppBar(
                opacity: 0.8,
                title: "Pet House",
                subTitle: "",
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.login)),
              Padding(
                padding: const EdgeInsets.only(
                    top: 35, right: 35, left: 35, bottom: 20),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: Strings.readyText,
                      style: TextStyles.bigHeadingTextStyle,
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: Strings.readyToWatchDesc,
                      style: TextStyles.bodyTextStyle,
                    ),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: Strings.startEnjoying,
                      style: TextStyles.enjoyTextStyle,
                    ),
                  ]),
                ),
              ),
            ],
          ),
          NeivigtionButton(path: SCREEN_CHOOSE)
        ],
      ),
    );
  }
}
