import 'package:flutter/material.dart';
import 'package:liturgia_diaria/interface/appbar/appbar.dart';
import 'package:liturgia_diaria/models/musica_model.dart';

class CancaoDetalhePage extends StatelessWidget {
  final MusicaModel musica;

  const CancaoDetalhePage({super.key, required this.musica});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Canção ${musica.numero}', haveDrawer: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Text(
              '${musica.numero}- ${musica.titulo}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (musica.autor.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  musica.autor,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Chip(
                label: Text(
                  musica.categoria,
                  style: const TextStyle(fontSize: 12),
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
            const Divider(height: 24),
            // Letra com formatação
            _buildLetra(context, musica.letra),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Renderiza a letra interpretando **negrito** como refrão
  Widget _buildLetra(BuildContext context, String letra) {
    final paragrafos = letra.split('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragrafos.map((paragrafo) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildParagrafo(context, paragrafo),
        );
      }).toList(),
    );
  }

  Widget _buildParagrafo(BuildContext context, String texto) {
    // Verifica se o parágrafo inteiro é um refrão (começa e termina com **)
    final isRefrao = texto.contains('**');

    if (!isRefrao) {
      return Text(
        texto,
        style: const TextStyle(fontSize: 16, height: 1.6),
      );
    }

    // Parse de trechos com **negrito** intercalados com texto normal
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*', dotAll: true);
    int lastEnd = 0;

    for (final match in regex.allMatches(texto)) {
      // Texto antes do negrito
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: texto.substring(lastEnd, match.start),
          style: const TextStyle(fontSize: 16, height: 1.6),
        ));
      }
      // Texto em negrito (refrão)
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          fontWeight: FontWeight.w900,
        ),
      ));
      lastEnd = match.end;
    }

    // Texto restante após último negrito
    if (lastEnd < texto.length) {
      spans.add(TextSpan(
        text: texto.substring(lastEnd),
        style: const TextStyle(fontSize: 16, height: 1.6),
      ));
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(
          decoration: TextDecoration.none,
        ),
        children: spans,
      ),
    );
  }
}
