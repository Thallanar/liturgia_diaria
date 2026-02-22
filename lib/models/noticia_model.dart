class NoticiaModel {
  final String titulo;
  final String resumo;
  final String? imagemUrl;
  final String link;
  final String? data;

  NoticiaModel({
    required this.titulo,
    required this.resumo,
    this.imagemUrl,
    required this.link,
    this.data,
  });

  @override
  String toString() {
    return 'NoticiaModel(titulo: $titulo, resumo: $resumo, link: $link)';
  }
}
