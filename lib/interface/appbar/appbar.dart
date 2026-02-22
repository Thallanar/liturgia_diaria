import 'package:flutter/material.dart';

AppBar customAppBar(BuildContext context, String title, {bool haveDrawer = true}) {
  return AppBar(
    elevation: 10,
    leading: haveDrawer
        ? Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
        : null,
    centerTitle: true,
    title: Text(
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
    actions: haveDrawer
        ? [
            SizedBox(width: 48), // Mesmo tamanho do leading para balancear
          ]
        : null,
    backgroundColor:
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.blue[200]
            : Colors.green[200],
  );
}
