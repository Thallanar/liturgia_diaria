import 'package:flutter/material.dart';
import 'package:liturgia_diaria/models/noticia_model.dart';
import 'package:liturgia_diaria/interface/appbar/appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticiaDetalhePage extends StatelessWidget {
  final NoticiaModel noticia;

  const NoticiaDetalhePage({super.key, required this.noticia});

  Future<void> _abrirNoNavegador() async {
    final uri = Uri.parse(noticia.link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Notícia", haveDrawer: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (noticia.imagemUrl != null)
              CachedNetworkImage(
                imageUrl: noticia.imagemUrl!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 60),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (noticia.data != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, 
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          noticia.data!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (noticia.resumo.isNotEmpty)
                    Text(
                      noticia.resumo,
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _abrirNoNavegador,
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Ler notícia completa'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
