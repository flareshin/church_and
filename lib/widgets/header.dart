import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false,
    required String titleText,
    removeBackButton = false}) {
  return AppBar(
    backgroundColor: Color(0xFF543d35),
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? 'St.Franscis' : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "cafe" : "",
        fontSize: isAppTitle ? 50.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    toolbarHeight: 86,
  );
}
