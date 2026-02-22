import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liturgia_diaria/pages/homepage.dart';
import 'package:liturgia_diaria/pages/liturgia.dart';
import 'package:liturgia_diaria/pages/oracoes.dart';
import 'package:liturgia_diaria/pages/cancoes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.blue[200]
              : Colors.green[200],
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Início'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Liturgia do Dia'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LiturgiaPage(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.music_note_rounded),
                title: const Text('Canções'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CancoesPage(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.calendarDays),
                title: const Text('Orações do Dia'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Oracoes(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
