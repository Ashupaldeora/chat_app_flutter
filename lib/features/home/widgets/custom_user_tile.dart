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
    required this.numberOfUnseenMessages,
  });

  final String hero;
  final VoidCallback onTap;
  final String profilePic;
  final String lastMessage;
  final String name;
  final String timeSent;
  final int numberOfUnseenMessages;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Hero(
              tag: hero,
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.pink, Colors.purple], // Gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profilePic),
                  radius: 22.r, // Example CircleAvatar
                ),
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
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    lastMessage,
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              // Align trailing text vertically with subtitle
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (numberOfUnseenMessages > 0)
                  Badge(
                    backgroundColor: Color(0xffB816D9),
                    label: Text(numberOfUnseenMessages.toString()),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min, // Keeps Row compact
                  children: [
                    Text(timeSent,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontSize: 10.sp)),
                    const SizedBox(width: 8),
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
