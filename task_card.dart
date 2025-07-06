import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onTap;        // ✅ For tick toggle
  final VoidCallback onDetailTap;  // ✅ For detail page

  const TaskCard({
    super.key,
    required this.title,
    this.isDone = false,
    required this.onTap,
    required this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primary, width: 1),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: onTap, // ✅ Circle toggles done
          child: Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            color: isDone ? AppColors.accent : AppColors.white,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 16),
          onPressed: onDetailTap, // ✅ > opens detail
        ),
      ),
    );
  }
}
