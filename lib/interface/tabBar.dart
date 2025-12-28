import 'package:flutter/material.dart';
import 'package:liturgia_diaria/models/liturgia_model.dart';

class AnimatedTabText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;

  const AnimatedTabText({super.key, required this.text, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(text),
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: 0.7 + (0.3 * clampedValue),
          child: Opacity(
            opacity: clampedValue,
            child: child,
          ),
        );
      },
      child: Text(text, textAlign: textAlign),
    );
  }
}

Widget buildLiturgiaTabBar({
  required TabController tabController,
  required LiturgiaModel liturgia,
}) {
  return TabBar(
    controller: tabController,
    tabs: [
      Tab(child: AnimatedTabText(text: 'Primeira Leitura', textAlign: TextAlign.center)),
      Tab(child: AnimatedTabText(text: 'Salmo', textAlign: TextAlign.center)),
      if (liturgia.hasSegundaLeitura())
        Tab(child: AnimatedTabText(text: 'Segunda Leitura', textAlign: TextAlign.center)),
      Tab(child: AnimatedTabText(text: 'Evangelho', textAlign: TextAlign.center)),
    ],
  );
}

Widget buildLiturgiaTabBarView({
  required TabController tabController,
  required LiturgiaModel liturgia,
  required Widget primeiraLeituraTab,
  required Widget salmoTab,
  required Widget segundaLeituraTab,
  required Widget evangelhoTab,
}) {
  return Expanded(
    child: TabBarView(
      controller: tabController,
      children: [
        primeiraLeituraTab,
        salmoTab,
        if (liturgia.hasSegundaLeitura())
          segundaLeituraTab,
        evangelhoTab,
      ],
    ),
  );
}
