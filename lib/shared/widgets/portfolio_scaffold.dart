import 'package:flutter/material.dart';

import '../../data/content/app_content.dart';
import '../../theme/app_theme.dart';

class PortfolioScaffold extends StatelessWidget {
  const PortfolioScaffold({
    super.key,
    required this.locale,
    required this.onToggleLocale,
    required this.body,
    this.currentRoute = '/',
  });

  final AppLocale locale;
  final VoidCallback onToggleLocale;
  final Widget body;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.paper,
              Color(0xFFF8F7F2),
              Color(0xFFF3E6D8),
            ],
          ),
        ),
        child: Stack(
          children: [
            const _BackdropBlobs(),
            SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    locale: locale,
                    onToggleLocale: onToggleLocale,
                    currentRoute: currentRoute,
                  ),
                  Expanded(child: body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.locale,
    required this.onToggleLocale,
    required this.currentRoute,
  });

  final AppLocale locale;
  final VoidCallback onToggleLocale;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 820;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.of(context).pushNamed('/'),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                'ENRI DV',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.6,
                ),
              ),
            ),
          ),
          const Spacer(),
          if (!isCompact)
            Wrap(
              spacing: 10,
              children: [
                _NavButton(
                  label: appStrings.navWork.of(locale),
                  onPressed: () => Navigator.of(context).pushNamed('/'),
                  active: currentRoute == '/',
                ),
                _NavButton(
                  label: appStrings.navCv.of(locale),
                  onPressed: () => Navigator.of(context).pushNamed('/cv'),
                  active: currentRoute == '/cv',
                ),
              ],
            ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: onToggleLocale,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.7),
              foregroundColor: AppTheme.ink,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            child: Text(locale.toggleLabel),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.onPressed,
    required this.active,
  });

  final String label;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.ink,
        backgroundColor: active ? Colors.white.withValues(alpha: 0.72) : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }
}

class _BackdropBlobs extends StatelessWidget {
  const _BackdropBlobs();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -50,
            child: _Blob(
              color: AppTheme.gold.withValues(alpha: 0.23),
              size: 240,
            ),
          ),
          Positioned(
            top: 160,
            left: -90,
            child: _Blob(
              color: AppTheme.coral.withValues(alpha: 0.14),
              size: 260,
            ),
          ),
          Positioned(
            bottom: -60,
            right: 90,
            child: _Blob(
              color: AppTheme.teal.withValues(alpha: 0.14),
              size: 220,
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
