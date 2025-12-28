import 'package:flutter/material.dart';
import 'package:liturgia_diaria/interface/appbar/appbar.dart';
import 'package:liturgia_diaria/interface/drawer.dart';
import 'package:liturgia_diaria/services/liturgia_api_service.dart';
import 'package:liturgia_diaria/models/liturgia_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LiturgiaApiService _apiService = LiturgiaApiService();
  LiturgiaModel? _liturgia;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarLiturgia();
  }

  Future<void> _carregarLiturgia() async {
    setState(() {
      _isLoading = true;
    });

    final data = await _apiService.getLiturgiaDoDia();
    if (data != null) {
      setState(() {
        _liturgia = LiturgiaModel.fromJson(data);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getCorLiturgica(String cor) {
    switch (cor.toLowerCase()) {
      case 'verde':
        return Colors.green;
      case 'vermelho':
        return Colors.red;
      case 'roxo':
        return Colors.purple;
      case 'rosa':
        return Colors.pink;
      case 'branco':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: customAppBar(context, "Liturgia Diária"),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.church,
                  size: 100,
                  color: MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.blue[200]
                      : Colors.green[200],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bem-vindo!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'StoryScript',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Use o menu para navegar',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Card da liturgia do dia
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_liturgia != null)
                  Card(
                    elevation: 4,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getCorLiturgica(_liturgia!.cor).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _liturgia!.data,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCorLiturgica(_liturgia!.cor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _liturgia!.cor,
                                  style: TextStyle(
                                    color: _liturgia!.cor.toLowerCase() == 'branco'
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _liturgia!.liturgia,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'StoryScript',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}