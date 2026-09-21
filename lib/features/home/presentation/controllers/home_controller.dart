import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../setup/domain/models/party_setup_model.dart';

final homeSessionProvider =
    StateNotifierProvider<HomeController, AsyncValue<SessionConfiguration?>>((ref) {
  return HomeController();
});

class HomeController extends StateNotifier<AsyncValue<SessionConfiguration?>> {
  HomeController() : super(const AsyncValue.loading()) {
    checkSavedSession();
  }

  static const String sessionKey = 'sutradhar_active_session';

  Future<void> checkSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(sessionKey);
      if (sessionJson != null && sessionJson.isNotEmpty) {
        final config = SessionConfiguration.fromJson(sessionJson);
        state = AsyncValue.data(config);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionKey);
    state = const AsyncValue.data(null);
  }
}
