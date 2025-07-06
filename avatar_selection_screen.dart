import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AvatarSelectionScreen extends StatelessWidget {
  final List<String> avatars = [
    'assets/avatars/tanjiro.jpg',
    'assets/avatars/rengoku.jpg',
    'assets/avatars/sanemi.jpg',
    'assets/avatars/giyu.jpg',
    'assets/avatars/moichiro.jpg',
    'assets/avatars/nezuko.jpg',
    'assets/avatars/shinobu.jpg',
  ];

  AvatarSelectionScreen({super.key});

  void selectAvatar(BuildContext context, String avatarPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAvatar', avatarPath);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Avatar Selected!')),
    );
  }

  void pickFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedAvatar', picked.path);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Custom Avatar Selected!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ No image selected.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Slayer Avatar'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                final avatar = avatars[index];
                return GestureDetector(
                  onTap: () => selectAvatar(context, avatar),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(avatar, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => pickFromGallery(context),
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick from Gallery'),
            ),
          ),
        ],
      ),
    );
  }
}
