import 'package:chat_app_flutter/features/chat/bloc/chat_bloc.dart';

import 'package:chat_app_flutter/services/chat/chat_services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/cubit/visibility_cubit.dart';
import 'chat_message_list.dart';

class CustomBottomSheet {
  static void show(BuildContext context, TextEditingController txtMessage,
      String receiverId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      elevation: 0,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.80,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            children: [
              // Chat messages list with stream
              Expanded(
                child: ChatMessagesList(receiverId: receiverId),
              ),
              // Input field section
              Padding(
                padding: EdgeInsets.only(
                    top: 10.h,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 85.h,
                  width: double.infinity,
                  padding:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, -0.5),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: txtMessage,
                          maxLines: null,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(color: Colors.black)),
                          decoration: InputDecoration(
                            suffixIcon: SizedBox(
                              width: 80.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.image,
                                        color: Colors.grey.shade500,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        final message = txtMessage.text.trim();
                                        if (message.isNotEmpty) {
                                          context.read<ChatBloc>().add(
                                              ChatSendButtonPressed(
                                                  receiverId: receiverId,
                                                  message:
                                                      txtMessage.text.trim()));
                                        }
                                        txtMessage.clear();
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.grey.shade500,
                                      )),
                                ],
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xffF7F7F7),
                            hintText: "Type here",
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 13.h, horizontal: 15.w),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15.r)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5.w, color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15.r)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5.w, color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(15.r)),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {},
                          icon: Icon(
                            Icons.mic,
                            color: Colors.grey.shade500,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      context.read<VisibilityCubit>().showTitle();
      Navigator.pop(context);
    });
  }
}
