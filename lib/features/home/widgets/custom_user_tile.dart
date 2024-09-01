import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomUserTile extends StatelessWidget {
  const CustomUserTile({
    super.key,
    required this.hero,
    required this.onTap,
    required this.profilePic,
    required this.lastMessage,
    required this.name,
    required this.timeSent,
  });

  final String hero;
  final VoidCallback onTap;
  final String profilePic;
  final String lastMessage;
  final String name;
  final String timeSent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Hero(
              tag: hero,
              child: CircleAvatar(
                backgroundImage: (profilePic == "")
                    ? const AssetImage("assets/avatar.png") as ImageProvider
                    : NetworkImage(profilePic),
                radius: 22.r, // Example CircleAvatar
              ),
            ),
            SizedBox(width: 15.w),
            // Add space between the avatar and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: Theme.of(context).textTheme.bodyMedium!),
                  Text(lastMessage,
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              // Align trailing text vertically with subtitle
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min, // Keeps Row compact
                  children: [
                    Text(timeSent,
                        style: Theme.of(context).textTheme.labelSmall),
                    SizedBox(width: 8),
                    Icon(
                      Icons.check,
                      color: Colors.grey.shade600,
                      size: 17.sp,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
