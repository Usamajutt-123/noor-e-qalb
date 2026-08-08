import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];

  final List<String> _prompts = const [
    'What is the power of Istighfar?',
    'Tell me a Hadith about patience',
    'Best Dua for success in life',
    'Explain Surah Al-Kahf',
    'What is Zakat and how to calculate?',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send(String value) {
    final text = value.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text, true));
      _messages.add(_ChatMessage('I\'ll help you reflect on that. Noor-e-Qalb guidance is being prepared with authentic sources.', false));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: NoorPageHeader(
        title: 'Islamic Assistant',
        actions: [
          NoorIconButton(icon: Icons.bookmark_border_rounded, tooltip: 'Saved', onPressed: () {}),
          const SizedBox(width: 5),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 15),
                  if (_messages.isEmpty) ...[
                    const NoorSectionTitle(title: 'Try asking'),
                    ..._prompts.map((prompt) => _buildPrompt(prompt)),
                  ] else ...[
                    ..._messages.map(_buildMessage),
                    const SizedBox(height: 12),
                    const NoorSectionTitle(title: 'Continue exploring'),
                    ..._prompts.take(3).map((prompt) => _buildPrompt(prompt)),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _send,
                      style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 11),
                      decoration: const InputDecoration(hintText: 'Ask anything...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  NoorIconButton(
                    size: 45,
                    icon: Icons.arrow_upward_rounded,
                    backgroundColor: NoorColors.gold,
                    color: NoorColors.background,
                    onPressed: () => _send(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: NoorColors.panelRaised, shape: BoxShape.circle, border: Border.all(color: NoorColors.gold.withOpacity(0.35))),
          child: const Icon(Icons.auto_awesome_rounded, color: NoorColors.goldBright, size: 26),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assalamu Alaikum', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('How can I help you today?', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrompt(String prompt) {
    return NoorPanel(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      onTap: () => _send(prompt),
      color: NoorColors.panelSoft,
      child: Row(
        children: [
          Expanded(child: Text(prompt, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 10))),
          const Icon(Icons.arrow_forward_ios_rounded, color: NoorColors.gold, size: 12),
        ],
      ),
    );
  }

  Widget _buildMessage(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? NoorColors.gold : NoorColors.panel,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: message.isUser ? NoorColors.goldBright : NoorColors.gold.withOpacity(0.2)),
        ),
        child: Text(message.text, style: GoogleFonts.poppins(color: message.isUser ? NoorColors.background : NoorColors.text, fontSize: 10, height: 1.4)),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage(this.text, this.isUser);
}
