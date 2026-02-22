import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:liturgia_diaria/models/noticia_model.dart';

class NoticiaDioceseService {
  static const String baseUrl = 'https://www.diocesevr.com.br';
  static const String noticiasUrl = '$baseUrl/noticia';

  /// Busca as notícias mais recentes da Diocese de Volta Redonda
  Future<List<NoticiaModel>> getNoticias({int limite = 5}) async {
    try {
      final response = await http.get(
        Uri.parse(noticiasUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        return _parseNoticias(response.body, limite);
      } else {
        return [];
      }
    } catch (e) {
      print('Erro ao buscar notícias: $e');
      return [];
    }
  }

  List<NoticiaModel> _parseNoticias(String html, int limite) {
    final document = parser.parse(html);
    final noticias = <NoticiaModel>[];

    // Busca os cards de notícias - ajustar seletores conforme estrutura do site
    final cards = document.querySelectorAll('.card, .post, .noticia, article, .news-item');
    
    if (cards.isEmpty) {
      // Tenta buscar por links com imagens (estrutura comum)
      final links = document.querySelectorAll('a[href*="/noticia/"]');
      
      for (var i = 0; i < links.length && noticias.length < limite; i++) {
        final link = links[i];
        final href = link.attributes['href'] ?? '';
        
        if (href.isEmpty || href == '/noticia' || href == '/noticia/') continue;
        
        // Busca título
        final titulo = link.querySelector('h2, h3, h4, .title, .titulo')?.text.trim() ??
            link.text.trim();
        
        if (titulo.isEmpty || titulo.length < 5) continue;
        
        // Busca imagem
        final img = link.querySelector('img');
        String? imagemUrl = img?.attributes['src'] ?? img?.attributes['data-src'];
        if (imagemUrl != null && !imagemUrl.startsWith('http')) {
          imagemUrl = '$baseUrl$imagemUrl';
        }
        
        // Busca resumo
        final resumo = link.querySelector('p, .resumo, .excerpt, .description')?.text.trim() ?? '';
        
        // Busca data
        final data = link.querySelector('.date, .data, time')?.text.trim();
        
        final fullLink = href.startsWith('http') ? href : '$baseUrl$href';
        
        // Evita duplicatas
        if (noticias.any((n) => n.link == fullLink)) continue;
        
        noticias.add(NoticiaModel(
          titulo: titulo,
          resumo: resumo,
          imagemUrl: imagemUrl,
          link: fullLink,
          data: data,
        ));
      }
    } else {
      for (var i = 0; i < cards.length && noticias.length < limite; i++) {
        final card = cards[i];
        
        // Busca link
        final linkElement = card.querySelector('a[href*="/noticia/"]') ?? card.querySelector('a');
        final href = linkElement?.attributes['href'] ?? '';
        
        if (href.isEmpty) continue;
        
        // Busca título
        final titulo = card.querySelector('h2, h3, h4, .title, .titulo')?.text.trim() ??
            linkElement?.text.trim() ?? '';
        
        if (titulo.isEmpty || titulo.length < 5) continue;
        
        // Busca imagem
        final img = card.querySelector('img');
        String? imagemUrl = img?.attributes['src'] ?? img?.attributes['data-src'];
        if (imagemUrl != null && !imagemUrl.startsWith('http')) {
          imagemUrl = '$baseUrl$imagemUrl';
        }
        
        // Busca resumo
        final resumo = card.querySelector('p, .resumo, .excerpt, .description')?.text.trim() ?? '';
        
        // Busca data
        final data = card.querySelector('.date, .data, time')?.text.trim();
        
        final fullLink = href.startsWith('http') ? href : '$baseUrl$href';
        
        // Evita duplicatas
        if (noticias.any((n) => n.link == fullLink)) continue;
        
        noticias.add(NoticiaModel(
          titulo: titulo,
          resumo: resumo,
          imagemUrl: imagemUrl,
          link: fullLink,
          data: data,
        ));
      }
    }

    return noticias;
  }
}
