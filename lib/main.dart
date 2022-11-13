// ignore_for_file: non_constant_identifier_names

import 'package:animal_house/presintaions/providers/app_provider.dart';
import 'package:animal_house/presintaions/providers/product_provider.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:animal_house/presintaions/screen/post_details_screen.dart';
import 'package:animal_house/presintaions/screen/add_new_pet_screen.dart';
import 'package:animal_house/presintaions/screen/auth/login_screen.dart';
import 'package:animal_house/presintaions/screen/auth/signup_screen.dart';
import 'package:animal_house/presintaions/screen/category_screen.dart';
import 'package:animal_house/presintaions/screen/conversation/chat_screen.dart';
import 'package:animal_house/presintaions/screen/conversation/message_screen.dart';
import 'package:animal_house/presintaions/screen/favorite_screen.dart';
import 'package:animal_house/presintaions/screen/home_screen.dart';
import 'package:animal_house/presintaions/screen/profile_screen.dart';
import 'package:animal_house/presintaions/screen/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:animal_house/presintaions/screen/main_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

String MAIN_SCREEN = 'main-screen';
String LOGIN_SCREEN = 'login-screen';
String SIGNUP_SCREEN = 'signup-screen';
String AD_DETAILS_SCREEN = 'Ad-details-screen';
String HOME_SCREEN = 'home-screen';
String FAVORITE_SCREEN = 'fav-screen';
String ADD_NEW_PET_SCREEN = 'add-new-pet-screen';
String CATEGORY_SCREEN = 'category-screen';
String CHAT_SCREEN = 'chat-screen';
String MESSAGE_SCREEN = 'message-screen';
String PROFILE_SCREEN = 'profile-screen';
String SEARCH_SCREEN = 'search-screen';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool active = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          active = false;
        });
      } else {
        setState(() {
          active = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider.initialized()),
        ChangeNotifierProvider.value(value: AppProvider()),
        ChangeNotifierProvider.value(
            value: ProductProvider.initialize(context: context)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pet House',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(65, 109, 109, 1),
        ),
        home: active ? const HomeScreen() : const LoginScreen(),
        routes: {
          HOME_SCREEN: (context) => const HomeScreen(),
          MAIN_SCREEN: (context) => const MainScreen(),
          LOGIN_SCREEN: (context) => const LoginScreen(),
          SIGNUP_SCREEN: (context) => const SignUpScreen(),
          AD_DETAILS_SCREEN: (context) => const PostDetailsScreen(),
          FAVORITE_SCREEN: (context) => const FavoriteScreen(),
          ADD_NEW_PET_SCREEN: (context) => const AddNewPetScreen(),
          CATEGORY_SCREEN: (context) => const CategoryScreen(),
          CHAT_SCREEN: (context) => const ChatScreen(),
          MESSAGE_SCREEN: (context) => const MessageScreen(),
          PROFILE_SCREEN: (context) => const ProfileScreen(),
          SEARCH_SCREEN: (context) => const SearchScreen(),
        },
      ),
    );
  }
}
