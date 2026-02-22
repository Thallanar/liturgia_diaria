import 'dart:convert';
import 'package:http/http.dart' as http;

class LiturgiaApiService {
  static const String baseUrl = 'https://liturgia.up.railway.app/v2';

  /// Retorna a liturgia do dia atual
  Future<Map<String, dynamic>?> getLiturgiaDoDia() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      return null;
    }
  }

  /// Retorna a liturgia de uma data específica
  /// [dia] - dia do mês (1-31)
  /// [mes] - mês (1-12)
  /// [ano] - ano (opcional, usa o ano atual se não informado)
  Future<Map<String, dynamic>?> getLiturgiaData({
    required int dia,
    required int mes,
    int? ano,
  }) async {
    String url = '$baseUrl/?dia=$dia&mes=$mes';
    if (ano != null) {
      url += '&ano=$ano';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      return null;
    }
  }

  /// Retorna liturgias de um período a partir de hoje
  /// [periodo] - quantidade de dias (máximo 7)
  Future<List<Map<String, dynamic>>?> getLiturgiaPeriodo(int periodo) async {
    if (periodo > 7) {
      return null;
    }

    final response = await http.get(Uri.parse('$baseUrl/?periodo=$periodo'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      return [data];
    } else {
      return null;
    }
  }

  /// Retorna liturgia usando formato de URL alternativo (dia-mes)
  /// Exemplo: 20-03 para 20 de março
  Future<Map<String, dynamic>?> getLiturgiaFormatoAlternativo({
    required int dia,
    required int mes,
  }) async {
    final response = await http.get(Uri.parse('$baseUrl/$dia-$mes'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      return null;
    }
  }
}
