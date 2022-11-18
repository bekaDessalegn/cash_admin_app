import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mi.dart';

class SearchWidget extends StatefulWidget {

  final VoidCallback onChange;
  SearchWidget({required this.onChange});

  @override
  State<SearchWidget> createState() => _SearchWidgetState(this.onChange);
}

class _SearchWidgetState extends State<SearchWidget> {

  final VoidCallback onChange;
  _SearchWidgetState(this.onChange);

  String? value;

  List<String> filter = ["Latest", "Old"];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
              });
              onChange();
            },
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(color: onBackgroundColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              filled: true,
              fillColor: surfaceColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
              ),
              hintText: "Search....",
              hintStyle: TextStyle(
                  color: textInputPlaceholderColor
              ),
              prefixIcon: Icon(Icons.search),
              prefixIconColor: textInputPlaceholderColor,
            ),
          ),
        ),
        // Container(
        //   width: 40,
        //   margin: EdgeInsets.only(right: 10),
        //   child: DropdownButtonHideUnderline(
        //     child: DropdownButton<String>(
        //       icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
        //       // value: values,
        //       isExpanded: true,
        //       hint: Iconify(Mi.filter, size: 40, color: onBackgroundColor,),
        //       items: filter.map(buildMenuLocation).toList(),
        //       onChanged: (value) => setState(() {
        //         this.value = value;
        //
        //       }),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuLocation(String filter) => DropdownMenuItem(
    value: filter,
    child: Text(
      filter,
      style: TextStyle(
        color: onBackgroundColor,
        fontSize: 14,
      ),
    ),
  );

}