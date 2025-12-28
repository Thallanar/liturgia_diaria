import 'package:flutter/material.dart';

AppBar customAppBar(BuildContext context, String title) {
  return AppBar(
    elevation: 10,
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(
          Icons.menu,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.black
              : Colors.white,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    title: Center(
      child: Text(
        title,
        style: TextStyle(
          color:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
          fontFamily: 'StoryScript',
          fontWeight: FontWeight.bold
        ),
      ),
    ),
    backgroundColor:
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.blue[200]
            : Colors.green[200],
  );
}
