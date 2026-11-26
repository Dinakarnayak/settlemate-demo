import 'package:flutter/material.dart';

import '../content/assistant.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'guide.dart';

class _Msg {
  _Msg.user(this.text)
      : fromUser = true,
        url = null,
        linkLabel = null,
        guideId = null;
  _Msg.bot(this.text, {this.url, this.linkLabel, this.guideId}) : fromUser = false;
  final bool fromUser;
  final String text;
  final String? url;
  final String? linkLabel;
  final String? guideId;
}

/// Answers questions about the student's own data first, then built-in answers.
_Msg answerFor(String q, AppStore s) {
  final t = q.toLowerCase();
  bool has(List<String> ws) => ws.any(t.contains);

  if (has(['hours left', 'how many hours have i', 'my hours', 'hours this week', 'worked this week'])) {
    final h = s.hoursThisWeek;
    final left = s.profile.weeklyLimit - h;
    return _Msg.bot(left >= 0
        ? 'You’ve logged ${fmtHours(h)} this week, so you have ${fmtHours(left)} left of your ${s.profile.weeklyLimit}h term-time limit.'
        : 'You’ve logged ${fmtHours(h)} this week: ${fmtHours(-left)} over your ${s.profile.weeklyLimit}h limit. If it’s term time, talk to your international student team.');
  }
  if (has(['money left', 'budget left', 'how much can i spend', 'my budget', 'spent this month'])) {
    return _Msg.bot(s.leftThisMonth >= 0
        ? 'You’ve spent ${gbp(s.spentThisMonth)} this month and have ${gbp(s.leftThisMonth)} left: about ${gbp(s.dailyAllowance.floorToDouble())} a day.'
        : 'You’re ${gbp(-s.leftThisMonth)} over your ${gbp(s.profile.monthlyBudget)} budget this month.');
  }
  if (has(['my visa', 'visa expire', 'visa expiry', 'days left on my visa'])) {
    final d = s.visaDaysLeft;
    if (d != null) {
      return _Msg.bot('Your visa expiry is set to ${fmtDate(s.profile.visaExpiry!, year: true)}, ${daysLeftText(d)}. Check it in your UKVI account.',
          url: 'https://www.gov.uk/view-prove-immigration-status', linkLabel: 'View your eVisa', guideId: 'visa');
    }
  }
  if (has(['next deadline', 'what is due', 'what’s due', "what's due", 'my deadlines'])) {
    final up = s.upcoming;
    if (up.isEmpty) return _Msg.bot('You have no upcoming deadlines saved. Add them in Explore → Deadlines.');
    final d = up.first;
    return _Msg.bot('Next up: ${d.title}, ${fmtDate(d.date, weekday: true)} (${daysLeftText(d.daysLeft(s.now))}). You have ${up.length} upcoming in total.');
  }

  final m = searchAnswers(q, limit: 1);
  if (m.isEmpty) {
    return _Msg.bot(
        'I don’t have an answer for that yet. Try different words, browse Explore → Guides, or ask your university’s student advice team. They’re free and confidential.');
  }
  final a = m.first.answer;
  return _Msg.bot(a.text, url: a.url, linkLabel: a.linkLabel.isEmpty ? null : a.linkLabel, guideId: a.guideId);
}

void showAssistant(BuildContext context, AppStore store, {String? initial}) {
  showSheet(context, (c) => SizedBox(height: MediaQuery.of(c).size.height * .8, child: _AssistantSheet(store: store, initial: initial)));
}

class _AssistantSheet extends StatefulWidget {
  const _AssistantSheet({required this.store, this.initial});
  final AppStore store;
  final String? initial;

  @override
  State<_AssistantSheet> createState() => _AssistantSheetState();
}

class _AssistantSheetState extends State<_AssistantSheet> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _msgs = <_Msg>[
    _Msg.bot('Hi! Ask me about visas, work hours, money, housing, health and more. I work offline, so your questions never leave this phone.'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) WidgetsBinding.instance.addPostFrameCallback((_) => _ask(widget.initial!));
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _ask(String q) {
    if (q.trim().isEmpty) return;
    setState(() {
      _msgs.add(_Msg.user(q.trim()));
      _msgs.add(answerFor(q, widget.store));
    });
    _input.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(children: [
        Row(children: [
          const IconBubble(Icons.auto_awesome_rounded, bg: AppColors.blueSoft, fg: AppColors.blue, size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ask Landed', style: Theme.of(context).textTheme.titleLarge),
              const Text('Offline helper · answers link to official sources', style: smallText),
            ]),
          ),
        ]),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(controller: _scroll, children: [
            for (final m in _msgs) _bubble(context, m),
            if (_msgs.length == 1) ...[
              const SizedBox(height: 6),
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final q in const ['How many hours have I worked this week?', 'How much money is left?', ...suggestedQuestions])
                  ActionChip(label: Text(q), onPressed: () => _ask(q)),
              ]),
            ],
          ]),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _input,
              textInputAction: TextInputAction.send,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: _ask,
              decoration: const InputDecoration(hintText: 'Type a question…'),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: 'Send',
            style: IconButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white),
            onPressed: () => _ask(_input.text),
            icon: const Icon(Icons.send_rounded),
          ),
        ]),
      ]),
    );
  }

  Widget _bubble(BuildContext context, _Msg m) => Align(
        alignment: m.fromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: m.fromUser ? AppColors.blue : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(m.fromUser ? 18 : 4),
              bottomRight: Radius.circular(m.fromUser ? 4 : 18),
            ),
            border: m.fromUser ? null : Border.all(color: AppColors.line),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.text, style: TextStyle(color: m.fromUser ? Colors.white : AppColors.ink, height: 1.35, fontSize: 15)),
            if (m.url != null) LinkText(m.linkLabel ?? 'Official guidance', m.url!),
            if (m.guideId != null)
              InkWell(
                onTap: () => openGuide(context, widget.store, m.guideId!),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('Read the full guide →', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
          ]),
        ),
      );
}
