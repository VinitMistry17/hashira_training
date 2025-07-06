import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../utils/streak_helper.dart';
import 'avatar_selection_screen.dart';
import 'about_screen.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int streakDays;

  const ProfileScreen({super.key, required this.streakDays});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? avatarPath;

  @override
  void initState() {
    super.initState();
    loadAvatar();
  }

  void loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      avatarPath = prefs.getString('selectedAvatar');
    });
  }

  Future<int> getDemonsSlain() async => StreakHelper.getDemonsSlain();

  Future<void> handleLogout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Logged Out!')),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
    );
  }

  Future<void> handleDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          '⚠️ Are you sure you want to delete your account? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseAuth.instance.currentUser?.delete();

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Account Deleted!')),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()),
              (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  '⚠️ Please login again to delete your account.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rank = StreakHelper.getRank(widget.streakDays);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hashira Profile',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white),
            onSelected: (value) async {
              if (value == 'logout') {
                await handleLogout();
              } else if (value == 'delete') {
                await handleDeleteAccount();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Account'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage: avatarPath != null
                  ? AssetImage(avatarPath!)
                  : const AssetImage('assets/avatars/giyu.jpg'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AvatarSelectionScreen(),
                  ),
                );
                loadAvatar();
              },
              child: const Text('Edit Avatar'),
            ),
            const SizedBox(height: 20),
            Text(
              rank,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '⚔️ ${widget.streakDays} : Days Streak',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/historicalBG.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '"Your blade can cut your fate — keep forging it!"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ✅ DYNAMIC DEMONS SLAIN
            FutureBuilder<int>(
              future: getDemonsSlain(),
              builder: (context, snapshot) {
                final slain = snapshot.data ?? 0;
                return Text(
                  '🗡️ Total Demons Slain: $slain',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // ✅ RESET BUTTON
            ElevatedButton(
              onPressed: () async {
                await StreakHelper.resetDemonsSlain();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('🔄 Total Demons Slain Reset to 0!')),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white),
              child: const Text('Reset Demons Slain'),
            ),

            const SizedBox(height: 40),

            // ✅ ABOUT BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
              child: const Text('📜 About This App'),
            ),
          ],
        ),
      ),
    );
  }
}

