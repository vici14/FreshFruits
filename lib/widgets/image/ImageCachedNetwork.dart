import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageCachedNetwork extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const ImageCachedNetwork(
      {Key? key, required this.imageUrl, this.width = 28, this.height = 28})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: BoxFit.fill,
      imageUrl: imageUrl,
      errorWidget: (context, url, error) =>
      const Icon(Icons.image_not_supported),
      progressIndicatorBuilder: (context, url, progress) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white10,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
