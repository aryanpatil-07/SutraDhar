import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../campaign_rules/presentation/state_providers.dart';
import '../../../ai_orchestration/data/ai_repository.dart';

class SpeechInputWidget extends ConsumerStatefulWidget {
  const SpeechInputWidget({super.key});

  @override
  ConsumerState<SpeechInputWidget> createState() => _SpeechInputWidgetState();
}

class _SpeechInputWidgetState extends ConsumerState<SpeechInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final AiRepository _aiRepository = AiRepository();
  bool _isListening = false;
  bool _isProcessing = false;

  final List<String> _quickSimulations = [
    'Kavalan strikes the bandit with his spear, rolling 5 and 4',
    'Kalviyalar studies ancient palm-leaf records, rolling 6 and 5',
    'Vēṭan sneaks past the lookout, rolling 1 and 1',
    'Marakkalam steers through the monsoon squall, rolling 6 and 6',
    'Thoodhuvar negotiates with Clerk Ananthan, rolling 4 and 4',
    'Party travels south along the coastal road toward Nagapattinam',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _processTranscript(String transcript) async {
    if (transcript.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    final gameState = ref.read(gameStateProvider);
    final characters = ref.read(partyCharactersProvider);

    try {
      final delta = await _aiRepository.parseSpeechToStateDelta(
        speechTranscript: transcript,
        gameState: gameState,
        characters: characters,
      );

      // Enqueue into DM Review Queue
      ref.read(pendingActionQueueProvider.notifier).enqueue(delta);
      _textController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppTheme.graniteCard,
            content: Text(
              'Speech processed! Proposed action delta queued for GM review.',
              style: TextStyle(color: AppTheme.bronzeLight),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.terracotta,
            content: Text('Error analyzing speech: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Simulated speech-to-text live stream indicator
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted && _isListening) {
          _textController.text = 'Kavalan strikes the mercenary with his spear, rolling 4 and 5';
          setState(() {
            _isListening = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isListening ? AppTheme.terracotta : AppTheme.graniteBorder,
          width: _isListening ? 1.8 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 18,
                    color: _isListening ? AppTheme.terracotta : AppTheme.bronzePrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isListening ? 'LISTENING TO PLAYERS...' : 'PLAYER SPEECH & 2D6 INPUT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _isListening ? AppTheme.terracotta : AppTheme.bronzeLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              if (_isProcessing)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.bronzePrimary),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Transcript Input Row
          Row(
            children: [
              // Push to Talk Mic Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isListening ? AppTheme.terracotta : AppTheme.graniteDark,
                  foregroundColor: _isListening ? Colors.white : AppTheme.bronzePrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: _isListening ? AppTheme.terracotta : AppTheme.graniteBorder,
                    ),
                  ),
                ),
                onPressed: _toggleListening,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 20),
              ),
              const SizedBox(width: 10),

              // Text Field
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(fontSize: 13, color: AppTheme.parchment),
                  decoration: InputDecoration(
                    hintText: 'e.g. "Kavalan attacks mercenary, rolled 4 and 5"',
                    hintStyle: const TextStyle(fontSize: 12, color: AppTheme.parchmentMuted),
                    filled: true,
                    fillColor: AppTheme.obsidian,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.graniteBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.bronzePrimary),
                    ),
                  ),
                  onSubmitted: (val) => _processTranscript(val),
                ),
              ),
              const SizedBox(width: 10),

              // Process Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.bronzePrimary,
                  foregroundColor: AppTheme.obsidian,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isProcessing
                    ? null
                    : () => _processTranscript(_textController.text),
                child: const Icon(Icons.send_rounded, size: 18),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Quick Simulation Chips
          const Text(
            'Quick Speech Samples (Tap to Test):',
            style: TextStyle(fontSize: 10, color: AppTheme.parchmentMuted, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickSimulations.map((sim) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: AppTheme.graniteDark,
                    side: const BorderSide(color: AppTheme.graniteBorder),
                    label: Text(
                      sim,
                      style: const TextStyle(fontSize: 11, color: AppTheme.parchment),
                    ),
                    onPressed: _isProcessing
                        ? null
                        : () {
                            _textController.text = sim;
                            _processTranscript(sim);
                          },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
