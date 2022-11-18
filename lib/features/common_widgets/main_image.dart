import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

Widget mainImage({required String urlImage}){
  return ProgressiveImage(
    placeholder: AssetImage('images/default.png'),
    thumbnail: NetworkImage(urlImage),
    image: NetworkImage(urlImage),
    height: 250,
    width: double.infinity,
    fit: BoxFit.cover,
  );
}