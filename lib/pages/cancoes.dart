import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liturgia_diaria/interface/appbar/appbar.dart';
import 'package:liturgia_diaria/interface/drawer.dart';
import 'package:liturgia_diaria/models/musica_model.dart';
import 'package:liturgia_diaria/pages/cancao_detalhe.dart';

class CancoesPage extends StatefulWidget {
  const CancoesPage({super.key});

  @override
  State<CancoesPage> createState() => _CancoesPageState();
}

class _CancoesPageState extends State<CancoesPage> {
  List<MusicaModel> _todasMusicas = [];
  List<MusicaModel> _musicasFiltradas = [];
  List<String> _categorias = [];
  String? _categoriaSelecionada;
  final TextEditingController _buscaController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarMusicas();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarMusicas() async {
    try {
      final jsonString = await rootBundle.loadString('assets/musicas.json');
      final data = json.decode(jsonString);

      final categorias = List<String>.from(data['categorias'] ?? []);
      final musicas = (data['musicas'] as List)
          .map((m) => MusicaModel.fromJson(m))
          .toList();

      setState(() {
        _categorias = categorias;
        _todasMusicas = musicas;
        _musicasFiltradas = musicas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filtrar() {
    final busca = _buscaController.text.toLowerCase();
    setState(() {
      _musicasFiltradas = _todasMusicas.where((m) {
        final matchCategoria = _categoriaSelecionada == null ||
            m.categoria == _categoriaSelecionada;
        final matchBusca = busca.isEmpty ||
            m.titulo.toLowerCase().contains(busca) ||
            m.numero.toString().contains(busca) ||
            m.autor.toLowerCase().contains(busca);
        return matchCategoria && matchBusca;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: customAppBar(context, 'Canções'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Barra de busca e filtro
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _buscaController,
                        onChanged: (_) => _filtrar(),
                        decoration: InputDecoration(
                          hintText: 'Buscar por título, número ou autor...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _buscaController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _buscaController.clear();
                                    _filtrar();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Chips de categoria
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: const Text('Todas'),
                                selected: _categoriaSelecionada == null,
                                onSelected: (_) {
                                  _categoriaSelecionada = null;
                                  _filtrar();
                                },
                              ),
                            ),
                            ..._categorias.map((cat) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(cat),
                                    selected: _categoriaSelecionada == cat,
                                    onSelected: (_) {
                                      _categoriaSelecionada =
                                          _categoriaSelecionada == cat
                                              ? null
                                              : cat;
                                      _filtrar();
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Contador
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_musicasFiltradas.length} música(s)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Lista de músicas - adaptável
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;
                      if (isWide) {
                        return _buildGrid(crossAxisCount: 2);
                      }
                      return _buildGrid(crossAxisCount: 1);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGrid({required int crossAxisCount}) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: crossAxisCount == 1 ? 5 : 3.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _musicasFiltradas.length,
      itemBuilder: (context, index) {
        final musica = _musicasFiltradas[index];
        return Card(
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CancaoDetalhePage(musica: musica),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${musica.numero}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          musica.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (musica.autor.isNotEmpty)
                          Text(
                            musica.autor,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
