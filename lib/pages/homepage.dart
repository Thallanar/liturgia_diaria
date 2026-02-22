import 'package:flutter/material.dart';
import 'package:liturgia_diaria/interface/appbar/appbar.dart';
import 'package:liturgia_diaria/interface/drawer.dart';
import 'package:liturgia_diaria/services/liturgia_api_service.dart';
import 'package:liturgia_diaria/services/noticia_diocese_service.dart';
import 'package:liturgia_diaria/models/liturgia_model.dart';
import 'package:liturgia_diaria/models/noticia_model.dart';
import 'package:liturgia_diaria/pages/noticia_detalhe.dart';
import 'package:liturgia_diaria/widgets/fade_slide_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LiturgiaApiService _apiService = LiturgiaApiService();
  final NoticiaDioceseService _noticiaService = NoticiaDioceseService();
  LiturgiaModel? _liturgia;
  List<NoticiaModel> _noticias = [];
  bool _isLoading = false;
  bool _isLoadingNoticias = false;

  @override
  void initState() {
    super.initState();
    _carregarLiturgia();
    _carregarNoticias();
  }

  Future<void> _carregarNoticias() async {
    setState(() {
      _isLoadingNoticias = true;
    });

    final noticias = await _noticiaService.getNoticias(limite: 5);
    setState(() {
      _noticias = noticias;
      _isLoadingNoticias = false;
    });
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
                const SizedBox(height: 32),
                // Card da liturgia do dia
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_liturgia != null)
                  FadeSlideAnimation(
                    index: 0,
                    child: Card(
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
                ),
                // Seção de Notícias
                const SizedBox(height: 32),
                _buildSecaoNoticias(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecaoNoticias() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollFadeSlide(
          child: const Row(
            children: [
              Icon(Icons.newspaper, size: 24),
              SizedBox(width: 8),
              Text(
                'Notícias da Diocese',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ScrollFadeSlide(
          child: Text(
            'Diocese de Barra do Piraí / Volta Redonda',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoadingNoticias)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_noticias.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Não foi possível carregar as notícias.'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _carregarNoticias,
                  ),
                ],
              ),
            ),
          )
        else
          ...List.generate(_noticias.length, (index) {
            final noticia = _noticias[index];
            return ScrollFadeSlide(
              duration: const Duration(milliseconds: 400),
              offset: const Offset(0, 30),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildNoticiaCard(noticia),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildNoticiaCard(NoticiaModel noticia) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoticiaDetalhePage(noticia: noticia),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (noticia.imagemUrl != null)
              CachedNetworkImage(
                imageUrl: noticia.imagemUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (noticia.resumo.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      noticia.resumo,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (noticia.data != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      noticia.data!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}