import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

Widget smallImage({required String urlImage}){
  return ProgressiveImage(
    placeholder: AssetImage('images/default.png'),
    thumbnail: NetworkImage(urlImage),
    image: NetworkImage(urlImage),
    height: 70,
    width: 70,
    fit: BoxFit.cover,
  );
}