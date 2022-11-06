import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatefulWidget {
  final String imageUrl;
  const CachedImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => const Center(
          child: SizedBox(
              height: 20, width: 20, child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
