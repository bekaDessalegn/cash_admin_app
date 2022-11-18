import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

Widget mediumImage({required String urlImage}){
  return ProgressiveImage(
    placeholder: AssetImage('images/default.png'),
    thumbnail: NetworkImage(urlImage),
    image: NetworkImage(urlImage),
    height: 84,
    width: 84,
    fit: BoxFit.cover,
  );
}