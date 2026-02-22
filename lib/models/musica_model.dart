class MusicaModel {
  final int numero;
  final String titulo;
  final String autor;
  final String categoria;
  final String letra;

  MusicaModel({
    required this.numero,
    required this.titulo,
    required this.autor,
    required this.categoria,
    required this.letra,
  });

  factory MusicaModel.fromJson(Map<String, dynamic> json) {
    return MusicaModel(
      numero: json['numero'] ?? 0,
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      categoria: json['categoria'] ?? '',
      letra: json['letra'] ?? '',
    );
  }
}
