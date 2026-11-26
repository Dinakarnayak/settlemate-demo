import 'package:flutter/material.dart';

import '../content/guides.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets.dart';

const guideStyle = <String, (IconData, Color, Color)>{
  'visa': (Icons.badge_rounded, AppColors.blueSoft, AppColors.blue),
  'work': (Icons.work_rounded, AppColors.sunSoft, AppColors.sunText),
  'money': (Icons.savings_rounded, AppColors.mintSoft, AppColors.mint),
  'housing': (Icons.house_rounded, AppColors.coralSoft, AppColors.coral),
  'health': (Icons.local_hospital_rounded, AppColors.pinkSoft, AppColors.pink),
  'study': (Icons.school_rounded, AppColors.blueSoft, AppColors.blue),
  'transport': (Icons.train_rounded, AppColors.sunSoft, AppColors.sunText),
  'food': (Icons.restaurant_rounded, AppColors.mintSoft, AppColors.mint),
  'phone': (Icons.sim_card_rounded, AppColors.blueSoft, AppColors.blue),
  'community': (Icons.diversity_3_rounded, AppColors.pinkSoft, AppColors.pink),
  'emergency': (Icons.emergency_rounded, AppColors.coralSoft, AppColors.coral),
  'careers': (Icons.rocket_launch_rounded, AppColors.mintSoft, AppColors.mint),
};

(IconData, Color, Color) styleForGuide(String id) => guideStyle[id] ?? (Icons.article_rounded, AppColors.line, AppColors.mute);

void openGuide(BuildContext context, AppStore store, String id) {
  final g = guideById(id);
  if (g == null) return;
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => GuideScreen(guide: g, store: store)));
}

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key, required this.guide, required this.store});
  final Guide guide;
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final st = styleForGuide(guide.id);
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(guide.title),
          actions: [
            IconButton(
              tooltip: store.isSaved(guide.id) ? 'Remove from saved' : 'Save guide',
              onPressed: () {
                store.toggleSaved(guide.id);
                final m = store.takeMessage();
                if (m != null) toast(context, m);
              },
              icon: Icon(store.isSaved(guide.id) ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
            ),
          ],
        ),
        body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 40), children: [
          Row(children: [
            IconBubble(st.$1, bg: st.$2, fg: st.$3, size: 54),
            const SizedBox(width: 14),
            Expanded(child: Text(guide.summary, style: const TextStyle(fontSize: 15, color: AppColors.mute, height: 1.35))),
          ]),
          const SizedBox(height: 16),
          if (guide.warning != null) Banner2(guide.warning!),
          for (final sec in guide.sections)
            SoftCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(sec.heading, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final p in sec.points)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        margin: const EdgeInsets.only(top: 7, right: 10),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: st.$3, shape: BoxShape.circle),
                      ),
                      Expanded(child: Text(p, style: const TextStyle(fontSize: 15, height: 1.4))),
                    ]),
                  ),
                for (final l in sec.links) LinkText(l.label, l.url),
              ]),
            ),
          const Text('Last checked $guidesLastChecked. Rules change, so always confirm on the official site.',
              style: smallText, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

/// Tile used in the guide grid.
class GuideTile extends StatelessWidget {
  const GuideTile({super.key, required this.guide, required this.onTap});
  final Guide guide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final st = styleForGuide(guide.id);
    return Material(
      color: st.$2,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(st.$1, color: st.$3, size: 26),
            Text(guide.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, height: 1.2)),
          ]),
        ),
      ),
    );
  }
}
