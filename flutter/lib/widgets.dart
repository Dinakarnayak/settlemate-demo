import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme.dart';

/// Circular progress ring with a label in the middle.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.color,
    required this.track,
    this.size = 96,
    this.stroke = 11,
    this.child,
  });

  final double value; // 0..1 (values over 1 show a full ring)
  final Color color;
  final Color track;
  final double size;
  final double stroke;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0).toDouble()),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(v, color, track, stroke),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color, this.track, this.stroke);
  final double value;
  final Color color;
  final Color track;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawArc(r, 0, math.pi * 2, false, base);
    if (value > 0) {
      final fg = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawArc(r, -math.pi / 2, math.pi * 2 * value, false, fg);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}

/// Rounded white card with a soft coral shadow.
class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.color, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final Color? color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final plain = color == null;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: plain ? Border.all(color: AppColors.line) : null,
        boxShadow: plain
            ? [BoxShadow(color: AppColors.coral.withValues(alpha: .12), blurRadius: 18, offset: const Offset(0, 6))]
            : null,
      ),
      child: child,
    );
  }
}

/// Thin rounded progress bar.
class Meter extends StatelessWidget {
  const Meter({super.key, required this.value, this.color = AppColors.ink, this.track});
  final double value;
  final Color color;
  final Color? track;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0).toDouble(),
        minHeight: 10,
        color: color,
        backgroundColor: track ?? AppColors.ink.withValues(alpha: .12),
      ),
    );
  }
}

/// Small rounded label such as "5-day streak".
class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, required this.bg, required this.fg});
  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}

/// Coloured event card with a simple shape illustration.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.title, required this.when, required this.a, required this.b, required this.url});
  final String url;
  final String title;
  final String when;
  final Color a;
  final Color b;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openUrl(url),
      child: Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 86,
            width: double.infinity,
            child: Stack(children: [
              Positioned.fill(child: ColoredBox(color: a)),
              Positioned(right: -18, top: -38, child: CircleAvatar(radius: 38, backgroundColor: b)),
              Positioned(left: -4, bottom: -54, child: CircleAvatar(radius: 44, backgroundColor: b.withValues(alpha: .55))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 2),
              const SizedBox(height: 2),
              Text(when, style: const TextStyle(fontSize: 13, color: AppColors.mute)),
            ]),
          ),
        ],
      ),
    ),
    );
  }
}

const eventColours = [
  [AppColors.coral, AppColors.sun],
  [AppColors.blue, AppColors.pink],
  [AppColors.mint, AppColors.sun],
  [AppColors.pink, AppColors.blue],
];

/// Opens a website or app (Maps, NHS, gov.uk…) outside SettleMate.
Future<void> openUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

String mapsUrl(String query) =>
    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(query)}';

String searchUrl(String query) => 'https://www.google.com/search?q=${Uri.encodeQueryComponent(query)}';

/// Small blue "Open guide ↗" style link.
class LinkText extends StatelessWidget {
  const LinkText(this.label, this.url, {super.key});
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text('$label ↗',
            style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700, fontSize: 13)),
      ),
    );
  }
}
