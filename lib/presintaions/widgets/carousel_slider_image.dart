import 'package:animal_house/presintaions/widgets/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarsouelSliderWidget extends StatelessWidget {
  final List pictures;
  const CarsouelSliderWidget({Key? key, required this.pictures})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: pictures.length,
      itemBuilder: (BuildContext context, int index, int pageViewIndex) {
        return SizedBox(
            width: double.infinity,
            child: CachedImage(
              imageUrl: pictures[index],
            ));
      },
      options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true,
          viewportFraction: 0.8,
          ),
    );
  }
}
