import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'l10n/l10n.dart';
import 'theme.dart';

const pagePad = EdgeInsets.fromLTRB(18, 8, 18, 140);
const smallText = TextStyle(fontSize: 13, color: AppColors.mute);

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

  final double value;
  final Color color;
  final Color track;
  final double size;
  final double stroke;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final v = value.isNaN ? 0.0 : value.clamp(0.0, 1.0).toDouble();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: v),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(t, color, track, stroke),
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
    final r = (Offset.zero & size).deflate(stroke / 2);
    canvas.drawArc(r, 0, math.pi * 2, false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = track);
    if (value > 0) {
      canvas.drawArc(r, -math.pi / 2, math.pi * 2 * value, false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke
            ..strokeCap = StrokeCap.round
            ..color = color);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value || old.color != color || old.track != track;
}

/// Rounded white card with a soft coral shadow.
class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.color, this.padding = const EdgeInsets.all(16), this.onTap});
  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final plain = color == null;
    final radius = BorderRadius.circular(22);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: radius,
        border: plain ? Border.all(color: AppColors.line) : null,
        boxShadow: plain
            ? [BoxShadow(color: AppColors.coral.withValues(alpha: .10), blurRadius: 18, offset: const Offset(0, 6))]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
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
    final v = value.isNaN ? 0.0 : value.clamp(0.0, 1.0).toDouble();
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: v,
        minHeight: 10,
        color: color,
        backgroundColor: track ?? AppColors.ink.withValues(alpha: .12),
      ),
    );
  }
}

/// Small rounded label such as "5-day streak".
class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, required this.bg, required this.fg, this.icon});
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: 4)],
        Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13)),
      ]),
    );
  }
}

/// Rounded square with an icon, used in lists.
class IconBubble extends StatelessWidget {
  const IconBubble(this.icon, {super.key, required this.bg, required this.fg, this.size = 46});
  final IconData icon;
  final Color bg;
  final Color fg;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(size * .33)),
        child: Icon(icon, color: fg, size: size * .5),
      );
}

/// Big page heading with a subtitle.
class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.title, this.subtitle, {super.key, this.trailing});
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: AppColors.mute, fontSize: 15)),
            ]),
          ),
          if (trailing != null) trailing!,
        ]),
      );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
        ]),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.icon, this.text, {super.key});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(children: [
          Icon(icon, size: 34, color: AppColors.mute.withValues(alpha: .6)),
          const SizedBox(height: 8),
          Text(text, style: smallText, textAlign: TextAlign.center),
        ]),
      );
}

/// Coloured banner for warnings and tips.
class Banner2 extends StatelessWidget {
  const Banner2(this.text, {super.key, this.bg = AppColors.sunSoft, this.fg = AppColors.sunText, this.icon = Icons.info_rounded});
  final String text;
  final Color bg;
  final Color fg;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 14, height: 1.35))),
        ]),
      );
}

// ------------------------------------------------------------------ helpers

/// Opens a website or app (Maps, NHS, GOV.UK, phone dialler) outside Landed.
Future<void> openUrl(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } on Object {
    // No app could open it; nothing else to do.
  }
}

String mapsUrl(String query) => 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(query)}';

/// Small blue "Open guide ↗" style link.
class LinkText extends StatelessWidget {
  const LinkText(this.label, this.url, {super.key});
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => openUrl(url),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text('$label ↗', style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700, fontSize: 14)),
        ),
      );
}

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String fmtDate(DateTime d, {bool weekday = false, bool year = false}) =>
    '${weekday ? '${t(_days[d.weekday - 1])} ' : ''}${d.day} ${t(_months[d.month - 1])}${year ? ' ${d.year}' : ''}';

String fmtMonth(DateTime d) => '${t(const [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ][d.month - 1])} ${d.year}';

String dayName(DateTime d) => t(_days[d.weekday - 1]);

String daysLeftText(int days) => switch (days) {
      < 0 => t('{n} days ago', {'n': '${-days}'}),
      0 => t('Today'),
      1 => t('Tomorrow'),
      _ => t('in {n} days', {'n': '$days'}),
    };

Future<DateTime?> pickDate(BuildContext context, {DateTime? initial, DateTime? first, DateTime? last}) {
  final now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: initial ?? now,
    firstDate: first ?? DateTime(now.year - 2),
    lastDate: last ?? DateTime(now.year + 6),
  );
}

Future<bool> confirm(BuildContext context, String title, String body, {String yes = 'Delete', bool danger = true}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t('Cancel'))),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: AppColors.coral) : null,
          onPressed: () => Navigator.pop(c, true),
          child: Text(yes),
        ),
      ],
    ),
  );
  return r ?? false;
}

void toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(milliseconds: 1800)));
}

/// Opens a rounded bottom sheet that scrolls and moves above the keyboard.
Future<T?> showSheet<T>(BuildContext context, Widget Function(BuildContext) builder) => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (c) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
        child: SafeArea(top: false, child: builder(c)),
      ),
    );

double? parseAmount(String s) => double.tryParse(s.replaceAll(RegExp(r'[£,\s]'), ''));
