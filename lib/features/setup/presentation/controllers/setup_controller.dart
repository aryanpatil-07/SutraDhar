import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/party_setup_model.dart';
import '../../../home/presentation/controllers/home_controller.dart';

final setupControllerProvider =
    StateNotifierProvider<SetupController, SessionConfiguration>((ref) {
  return SetupController(ref);
});

class SetupController extends StateNotifier<SessionConfiguration> {
  final Ref ref;

  SetupController(this.ref)
      : super(SessionConfiguration(
          selectedCharacterIds: [],
          playerNames: {},
          gameMode: GameMode.assistedGm,
          sessionPacing: SessionPacing.fullCampaign,
          departureChoice: Act1DepartureChoice.swiftDeparture,
          createdAt: DateTime.now(),
        ));

  void toggleCharacter(String characterId) {
    final current = List<String>.from(state.selectedCharacterIds);
    if (current.contains(characterId)) {
      current.remove(characterId);
      final updatedNames = Map<String, String>.from(state.playerNames);
      updatedNames.remove(characterId);
      state = state.copyWith(
        selectedCharacterIds: current,
        playerNames: updatedNames,
      );
    } else {
      if (current.length < 4) {
        current.add(characterId);
        state = state.copyWith(selectedCharacterIds: current);
      }
    }
  }

  void setPlayerName(String characterId, String name) {
    final updatedNames = Map<String, String>.from(state.playerNames);
    if (name.trim().isEmpty) {
      updatedNames.remove(characterId);
    } else {
      updatedNames[characterId] = name.trim();
    }
    state = state.copyWith(playerNames: updatedNames);
  }

  void setGameMode(GameMode mode) {
    state = state.copyWith(gameMode: mode);
  }

  void setSessionPacing(SessionPacing pacing) {
    state = state.copyWith(sessionPacing: pacing);
  }

  void setDepartureChoice(Act1DepartureChoice choice) {
    state = state.copyWith(departureChoice: choice);
  }

  Future<bool> saveAndStartSession() async {
    if (!state.isValid) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(HomeController.sessionKey, state.toJson());
    await ref.read(homeSessionProvider.notifier).checkSavedSession();
    return true;
  }
}
