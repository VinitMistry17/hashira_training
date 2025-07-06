import 'package:shared_preferences/shared_preferences.dart';

class StreakHelper {
  static const String streakKey = 'streakDays';
  static const String lastDateKey = 'lastStreakDate';
  static const String allTasksDoneKey = 'allTasksDoneToday';
  static const String demonsKey = 'demonsSlain'; // ✅ NEW

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(streakKey) ?? 0;
  }

  static Future<void> resetDemonsSlain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('demonsSlain', 0);
  }


  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final lastDateStr = prefs.getString(lastDateKey);

    bool allTasksDone = prefs.getBool(allTasksDoneKey) ?? false;

    if (lastDateStr != null) {
      final lastDate = DateTime.parse(lastDateStr);
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        if (allTasksDone) {
          int current = prefs.getInt(streakKey) ?? 0;
          prefs.setInt(streakKey, current + 1);
        } else {
          prefs.setInt(streakKey, 0);
        }
      } else if (difference > 1) {
        prefs.setInt(streakKey, 0);
      }
    } else {
      if (allTasksDone) {
        prefs.setInt(streakKey, 1); // Pehla din complete hua, streak 1 se start
      } else {
        prefs.setInt(streakKey, 0); // Tasks done nahi hue to 0 hi rahe
      }
    }

    prefs.setString(lastDateKey, today.toIso8601String());
    prefs.setBool(allTasksDoneKey, false);
  }

  static Future<void> markAllTasksDone() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(allTasksDoneKey, true);
  }

  static String getRank(int streakDays) {
    if (streakDays <= 5) return 'Mizunoto';
    if (streakDays <= 15) return 'Mizunoe';
    if (streakDays <= 30) return 'Kanoto';
    if (streakDays <= 50) return 'Kanoe';
    if (streakDays <= 70) return 'Tsuchinoto';
    if (streakDays <= 90) return 'Tsuchinoe';
    if (streakDays <= 115) return 'Hinoto';
    if (streakDays <= 140) return 'Hinoe';
    if (streakDays <= 160) return 'Kinoto';
    if (streakDays <= 179) return 'Kinoe';
    return 'Hashira';
  }

  // ✅ NEW: Demons Slain
  static Future<int> getDemonsSlain() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(demonsKey) ?? 0;
  }

  static Future<void> addDemonsSlain(int count) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(demonsKey) ?? 0;
    prefs.setInt(demonsKey, current + count);
  }
}
