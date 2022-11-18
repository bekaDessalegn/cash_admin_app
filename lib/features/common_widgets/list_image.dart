import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

Widget listImage({required String urlImage}){
  return ProgressiveImage(
    placeholder: AssetImage('images/default.png'),
    thumbnail: NetworkImage(urlImage),
    image: NetworkImage(urlImage),
    height: 120,
    width: 120,
    fit: BoxFit.cover,
  );
}