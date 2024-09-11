import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard(
      {super.key,
      required this.message,
      required this.timeSent,
      required this.isSeen});

  final String message;
  final String timeSent;

  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10.w,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // margin: EdgeInsets.only(right: 10.w),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff9C5EDF),
                        Color(0xff9C5EDF),
                        Color(0xff8A42F3),
                      ])),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Text(
                    timeSent,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 9.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  isSeen ? Icons.done_all : Icons.done,
                  size: 11.sp,
                  color: isSeen ? const Color(0xff9C5EDF) : Colors.grey,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
