import 'package:flutter/material.dart';
import 'package:liturgia_diaria/interface/appbar/appbar.dart';
import 'package:liturgia_diaria/interface/drawer.dart';
import 'package:liturgia_diaria/interface/tabBar.dart';
import 'package:liturgia_diaria/models/liturgia_model.dart';
import 'package:liturgia_diaria/services/liturgia_api_service.dart';

class LiturgiaPage extends StatefulWidget {
  const LiturgiaPage({super.key});

  @override
  State<LiturgiaPage> createState() => _LiturgiaPageState();
}

class _LiturgiaPageState extends State<LiturgiaPage> {
  final LiturgiaApiService _apiService = LiturgiaApiService();
  LiturgiaModel? _liturgia;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarLiturgia();
  }

  Future<void> _carregarLiturgia() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final data = await _apiService.getLiturgiaDoDia();
    if (data != null) {
      setState(() {
        _liturgia = LiturgiaModel.fromJson(data);
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = 'Não foi possível carregar a liturgia';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: customAppBar(context, "Liturgia do Dia"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _carregarLiturgia,
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                )
              : _liturgia == null
                  ? const Center(child: Text('Nenhuma liturgia disponível'))
                  : LiturgiaContent(
                      liturgia: _liturgia!,
                      onRefresh: _carregarLiturgia,
                    ),
    );
  }
}

class LiturgiaContent extends StatefulWidget {
  final LiturgiaModel liturgia;
  final VoidCallback onRefresh;

  const LiturgiaContent({
    super.key,
    required this.liturgia,
    required this.onRefresh,
  });

  @override
  State<LiturgiaContent> createState() => _LiturgiaContentState();
}

class _LiturgiaContentState extends State<LiturgiaContent>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  @override
  void didUpdateWidget(LiturgiaContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.liturgia != widget.liturgia) {
      _initTabController();
    }
  }

  void _initTabController() {
    final tabCount = widget.liturgia.hasSegundaLeitura() ? 4 : 3;
    _tabController?.dispose();
    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
        if (_tabController != null)
          buildLiturgiaTabBar(
            tabController: _tabController!,
            liturgia: widget.liturgia,
          ),

        // TabBarView
        if (_tabController != null)
          buildLiturgiaTabBarView(
            tabController: _tabController!,
            liturgia: widget.liturgia,
            primeiraLeituraTab: _buildPrimeiraLeitura(),
            salmoTab: _buildSalmo(),
            segundaLeituraTab: _buildSegundaLeitura(),
            evangelhoTab: _buildEvangelho(),
          ),
      ],
    );
  }

  Widget _buildPrimeiraLeitura() {
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.liturgia.getPrimeiraLeitura() != null) ...[
              Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Primeira Leitura',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (widget.liturgia.getReferenciaPrimeiraLeitura() != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.liturgia.getReferenciaPrimeiraLeitura()!,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.liturgia.getPrimeiraLeitura()!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ] else ...[
              const Center(
                child: Text('Primeira leitura não disponível'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSalmo() {
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.music_note, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  'Salmo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (widget.liturgia.getReferenciaSalmo() != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.liturgia.getReferenciaSalmo()!,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            if (widget.liturgia.getRefraoSalmo() != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  widget.liturgia.getRefraoSalmo()!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.purple[700],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.liturgia.getSalmo() ?? 'Salmo não disponível',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegundaLeitura() {
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.liturgia.getSegundaLeitura() != null) ...[
              Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text(
                    'Segunda Leitura',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (widget.liturgia.getReferenciaSegundaLeitura() != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.liturgia.getReferenciaSegundaLeitura()!,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.liturgia.getSegundaLeitura()!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ] else ...[
              const Center(
                child: Text('Segunda leitura não disponível'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEvangelho() {
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.liturgia.getEvangelho() != null) ...[
              Row(
                children: [
                  const Icon(Icons.auto_stories, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Text(
                    'Evangelho',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (widget.liturgia.getReferenciaEvangelho() != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.liturgia.getReferenciaEvangelho()!,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.liturgia.getEvangelho()!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ] else ...[
              const Center(
                child: Text('Evangelho não disponível'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
