import 'package:cash_admin_app/features/customize/data/model/image.dart';

class WhatMakesUsUnique {
  final List whatMakesUsUnique;
  final ImageContent whatMakesUsUniqueImage;

  WhatMakesUsUnique({required this.whatMakesUsUnique, required this.whatMakesUsUniqueImage});
   factory WhatMakesUsUnique.fromJson(Map<String, dynamic> json) => WhatMakesUsUnique(
       whatMakesUsUnique: json["whatMakesUsUnique"],
       whatMakesUsUniqueImage: ImageContent.fromJson(json["whatMakesUsUniqueImage"])
   );
}