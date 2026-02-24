import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:liturgia_diaria/interface/appbar/appbar.dart';

class SobrePage extends StatefulWidget {
  const SobrePage({super.key});

  @override
  State<SobrePage> createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _carregarInfo();
  }

  Future<void> _carregarInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final primaryColor = isDark ? Colors.blue[200] : Colors.green[700];

    return Scaffold(
      appBar: customAppBar(context, 'Sobre', haveDrawer: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.church, size: 80, color: primaryColor),
              const SizedBox(height: 24),
              Text(
                'Liturgia Diária',
                style: TextStyle(
                  fontFamily: 'StoryScript',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              if (_version.isNotEmpty)
                Text(
                  'v$_version+$_buildNumber',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              const SizedBox(height: 32),
              Text(
                'Acompanhe a liturgia do dia, orações e cânticos para as celebrações da Igreja Católica.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
