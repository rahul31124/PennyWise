import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _currencyKey = 'currency_code';

  Future<void> setCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencyCode);
  }

  Future<String?> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey);
  }
}


final settingsRepositoryProvider = Provider((ref) => SettingsRepository());


class CurrencyNotifier extends StateNotifier<AsyncValue<String?>> {
  final SettingsRepository _repo;

  CurrencyNotifier(this._repo) : super(const AsyncValue.loading()) {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    try {
      final currency = await _repo.getCurrency();
      state = AsyncValue.data(currency);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveCurrency(String currency) async {
    state = const AsyncValue.loading();
    await _repo.setCurrency(currency);
    state = AsyncValue.data(currency);
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, AsyncValue<String?>>((ref) {
  return CurrencyNotifier(ref.watch(settingsRepositoryProvider));
});