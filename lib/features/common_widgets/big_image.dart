import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

Widget bigImage({required String urlImage}){
  return ProgressiveImage(
    placeholder: AssetImage('images/loading.png'),
    thumbnail: NetworkImage(urlImage),
    image: NetworkImage(urlImage),
    height: 139,
    width: double.infinity,
    fit: BoxFit.cover,
  );
}