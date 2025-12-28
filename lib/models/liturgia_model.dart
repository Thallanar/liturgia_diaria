/// Modelo simplificado para representar a Liturgia Diária
/// Versão experimental - contém apenas os campos principais
class LiturgiaModel {
  final String data;
  final String liturgia;
  final String cor;
  final Map<String, dynamic> oracoes;
  final Map<String, dynamic> leituras;
  final Map<String, dynamic>? antifonas;

  LiturgiaModel({
    required this.data,
    required this.liturgia,
    required this.cor,
    required this.oracoes,
    required this.leituras,
    this.antifonas,
  });

  factory LiturgiaModel.fromJson(Map<String, dynamic> json) {
    return LiturgiaModel(
      data: json['data'] ?? '',
      liturgia: json['liturgia'] ?? '',
      cor: json['cor'] ?? '',
      oracoes: json['oracoes'] ?? {},
      leituras: json['leituras'] ?? {},
      antifonas: json['antifonas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'liturgia': liturgia,
      'cor': cor,
      'oracoes': oracoes,
      'leituras': leituras,
      'antifonas': antifonas,
    };
  }

  /// Retorna a primeira leitura se disponível
  String? getPrimeiraLeitura() {
    if (leituras['primeiraLeitura'] != null &&
        leituras['primeiraLeitura'] is List &&
        (leituras['primeiraLeitura'] as List).isNotEmpty) {
      final primeira = (leituras['primeiraLeitura'] as List).first;
      return primeira['texto'] ?? '';
    }
    return null;
  }

  /// Retorna a referência da primeira leitura
  String? getReferenciaPrimeiraLeitura() {
    if (leituras['primeiraLeitura'] != null &&
        leituras['primeiraLeitura'] is List &&
        (leituras['primeiraLeitura'] as List).isNotEmpty) {
      final primeira = (leituras['primeiraLeitura'] as List).first;
      return primeira['referencia'] ?? '';
    }
    return null;
  }

  /// Retorna a segunda leitura se disponível
  String? getSegundaLeitura() {
    if (leituras['segundaLeitura'] != null &&
        leituras['segundaLeitura'] is List &&
        (leituras['segundaLeitura'] as List).isNotEmpty) {
      final segunda = (leituras['segundaLeitura'] as List).first;
      return segunda['texto'] ?? '';
    }
    return null;
  }

  /// Retorna a referência da segunda leitura
  String? getReferenciaSegundaLeitura() {
    if (leituras['segundaLeitura'] != null &&
        leituras['segundaLeitura'] is List &&
        (leituras['segundaLeitura'] as List).isNotEmpty) {
      final segunda = (leituras['segundaLeitura'] as List).first;
      return segunda['referencia'] ?? '';
    }
    return null;
  }

  /// Verifica se existe segunda leitura
  bool hasSegundaLeitura() {
    return leituras['segundaLeitura'] != null &&
        leituras['segundaLeitura'] is List &&
        (leituras['segundaLeitura'] as List).isNotEmpty;
  }

  /// Retorna o salmo se disponível
  String? getSalmo() {
    if (leituras['salmo'] != null &&
        leituras['salmo'] is List &&
        (leituras['salmo'] as List).isNotEmpty) {
      final salmo = (leituras['salmo'] as List).first;
      return salmo['texto'] ?? '';
    }
    return null;
  }

  /// Retorna a referência do salmo
  String? getReferenciaSalmo() {
    if (leituras['salmo'] != null &&
        leituras['salmo'] is List &&
        (leituras['salmo'] as List).isNotEmpty) {
      final salmo = (leituras['salmo'] as List).first;
      return salmo['referencia'] ?? '';
    }
    return null;
  }

  /// Retorna o refrão do salmo
  String? getRefraoSalmo() {
    if (leituras['salmo'] != null &&
        leituras['salmo'] is List &&
        (leituras['salmo'] as List).isNotEmpty) {
      final salmo = (leituras['salmo'] as List).first;
      return salmo['refrao'] ?? '';
    }
    return null;
  }

  /// Retorna o evangelho se disponível
  String? getEvangelho() {
    if (leituras['evangelho'] != null &&
        leituras['evangelho'] is List &&
        (leituras['evangelho'] as List).isNotEmpty) {
      final evangelho = (leituras['evangelho'] as List).first;
      return evangelho['texto'] ?? '';
    }
    return null;
  }

  /// Retorna a referência do evangelho
  String? getReferenciaEvangelho() {
    if (leituras['evangelho'] != null &&
        leituras['evangelho'] is List &&
        (leituras['evangelho'] as List).isNotEmpty) {
      final evangelho = (leituras['evangelho'] as List).first;
      return evangelho['referencia'] ?? '';
    }
    return null;
  }

  /// Retorna a oração da coleta
  String? getOracaoColeta() {
    return oracoes['coleta'] ?? '';
  }

  /// Retorna a cor litúrgica
  String getCorLiturgica() {
    return cor;
  }
}
