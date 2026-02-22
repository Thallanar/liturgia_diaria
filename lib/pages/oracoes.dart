import 'package:flutter/material.dart';
import 'package:liturgia_diaria/interface/appbar/appbar.dart';
import 'package:liturgia_diaria/interface/drawer.dart';
import '../services/liturgia_api_service.dart';

class Oracoes extends StatefulWidget {
  const Oracoes({super.key});

  @override
  State<Oracoes> createState() => _OracoesState();
}

class _OracoesState extends State<Oracoes> {
  final LiturgiaApiService _apiService = LiturgiaApiService();
  Map<String, dynamic>? _liturgiaData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _carregarOracoes();
  }

  Future<void> _carregarOracoes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _apiService.getLiturgiaDoDia();
      setState(() {
        _liturgiaData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar orações: $e';
        _isLoading = false;
      });
    }
  }

  List<OracaoItem> _extrairOracoes() {
    if (_liturgiaData == null || _liturgiaData!['oracoes'] == null) {
      return [];
    }

    final oracoes = _liturgiaData!['oracoes'] as Map<String, dynamic>;
    final List<OracaoItem> lista = [];

    oracoes.forEach((key, value) {
      // Não renderiza se for null, vazio, ou array vazio
      if (value == null) return;
      
      // Se for uma lista vazia, não adiciona
      if (value is List && value.isEmpty) return;
      
      // Se for string vazia, não adiciona
      if (value is String && value.isEmpty) return;
      
      // Formata o título da oração
      String titulo = _formatarTitulo(key);
      lista.add(OracaoItem(
        titulo: titulo,
        conteudo: value.toString(),
      ));
    });

    return lista;
  }

  String _formatarTitulo(String key) {
    // Converte chaves da API em títulos mais legíveis
    final Map<String, String> titulos = {
      'coleta': 'Oração da Coleta',
      'oferendas': 'Oração Sobre as Oferendas',
      'comunhao': 'Oração da Comunhão',
      'entrada': 'Antífona de Entrada',
      'final': 'Oração Final',
    };

    return titulos[key] ?? key.replaceAll('_', ' ').replaceFirst(
          key[0],
          key[0].toUpperCase(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: customAppBar(context, 'Orações do Dia'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _carregarOracoes,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : _buildOracoesContent(),
    );
  }

  Widget _buildOracoesContent() {
    final oracoes = _extrairOracoes();

    if (oracoes.isEmpty) {
      return const Center(
        child: Text('Nenhuma oração disponível para hoje'),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarOracoes,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: oracoes.length,
                itemBuilder: (context, index) {
                  final oracao = oracoes[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      childrenPadding: const EdgeInsets.all(16),
                      title: Text(
                        oracao.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      leading: Icon(
                        Icons.church,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            oracao.conteudo,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe auxiliar para armazenar informações de cada oração
class OracaoItem {
  final String titulo;
  final String conteudo;
  
  OracaoItem({
    required this.titulo,
    required this.conteudo,
  });
}