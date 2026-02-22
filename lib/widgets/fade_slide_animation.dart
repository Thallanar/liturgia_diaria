import 'package:flutter/material.dart';

/// Widget que anima a entrada de um filho com fade e slide de baixo para cima
class FadeSlideAnimation extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  const FadeSlideAnimation({
    super.key,
    required this.child,
    this.index = 0,
    this.delay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 400),
    this.offset = const Offset(0, 30),
  });

  @override
  State<FadeSlideAnimation> createState() => _FadeSlideAnimationState();
}

class _FadeSlideAnimationState extends State<FadeSlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Delay baseado no índice para efeito cascata
    Future.delayed(Duration(milliseconds: widget.delay.inMilliseconds * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Widget que anima a entrada quando o elemento fica visível na tela
class ScrollFadeSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset offset;

  const ScrollFadeSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.offset = const Offset(0, 40),
  });

  @override
  State<ScrollFadeSlide> createState() => _ScrollFadeSlideState();
}

class _ScrollFadeSlideState extends State<ScrollFadeSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(bool isVisible) {
    if (isVisible && !_hasAnimated) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Widget simples para detectar visibilidade na viewport
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final void Function(bool isVisible) onVisibilityChanged;

  const VisibilityDetector({
    super.key,
    required this.child,
    required this.onVisibilityChanged,
  });

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  final GlobalKey _key = GlobalKey();
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;
    
    final RenderObject? renderObject = _key.currentContext?.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;

    final RenderBox box = renderObject as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final Size screenSize = MediaQuery.of(context).size;

    // Verifica se pelo menos parte do widget está visível
    final bool isVisible = position.dy < screenSize.height &&
        position.dy + size.height > 0 &&
        position.dx < screenSize.width &&
        position.dx + size.width > 0;

    if (isVisible != _wasVisible) {
      _wasVisible = isVisible;
      widget.onVisibilityChanged(isVisible);
    }

    // Continua verificando enquanto montado
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkVisibility();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
