import 'dart:developer';

import 'package:chat_app_flutter/features/authentication_screen/model/user_model.dart';
import 'package:chat_app_flutter/services/firebase_messaging/api_servies.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../../../services/chat/chat_services.dart';
import '../../../services/globalkey_manager/key_manager.dart';
import '../../home/cubit/visibility_cubit/visibility_cubit.dart';
import '../bloc/chat_bloc.dart';
import '../model/message_model.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/user_tile_widgets.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen(
//       {super.key,
//       required this.hero,
//       required this.receiverUser,
//       required this.receiverName});
//
//   final String hero;
//   final String receiverUser;
//   final String receiverName;
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen>
//     with SingleTickerProviderStateMixin {
//   late Animation<Offset> position;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late AnimationController controller;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     FireStoreService().getReceiverData(widget.receiverUser);
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animation = Tween<double>(begin: 1, end: 0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );
//     _animationController.forward();
//     controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     position = Tween(begin: Offset(0, -2), end: Offset(0, 0))
//         .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
//     WidgetsBinding.instance.addPostFrameCallback((_) {
// //Following future can be uncommented to check
// //if the call back works after 5 seconds.
//       Future.delayed(
//           const Duration(milliseconds: 100), () => {controller.forward()});
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     controller.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<bool> _handlePopScope() async {
//     if (_animationController.status == AnimationStatus.completed) {
//       await _animationController.reverse();
//       return false;
//     }
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff17181E),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 40.h,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15.w),
//             child: StreamBuilder<UserModel>(
//                 stream: FireStoreService().getUserDataById(widget.receiverUser),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Text(widget.receiverName,
//                         style: Theme.of(context).textTheme.bodyMedium!);
//                   }
//                   if (snapshot.data == null) {
//                     return Text(widget.receiverName,
//                         style: Theme.of(context).textTheme.bodyMedium!);
//                   }
//
//                   return Row(
//                     children: [
//                       Hero(
//                         tag: widget.hero,
//                         child: Container(
//                           padding: const EdgeInsets.all(2),
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color(0xffB24DDA),
//                                 Color(0xffCE7F45),
//                               ], // Gradient colors
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                           ),
//                           child: CircleAvatar(
//                             backgroundImage: snapshot.data!.profilePic == ""
//                                 ? const AssetImage("assets/avatar.png")
//                                     as ImageProvider
//                                 : NetworkImage(snapshot.data!.profilePic),
//                             radius: 24.r, // Example CircleAvatar
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.w,
//                       ),
//                       Expanded(
//                         child: SlideTransition(
//                           position: position,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(widget.receiverName,
//                                   style:
//                                       Theme.of(context).textTheme.bodyMedium!),
//                               Text(
//                                   snapshot.data!.isOnline
//                                       ? "Online"
//                                       : "Offline",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelSmall!
//                                       .copyWith(fontSize: 10.sp)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       BlocBuilder<ChatBloc, ChatState>(
//                         builder: (context, state) {
//                           bool isMessageSelected = state
//                               is ChatMessageSelected; // Check if a message is selected
//
//                           return SizedBox(
//                             width: 80.w,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // AnimatedSwitcher for smooth transitions between the icons
//                                 AnimatedSwitcher(
//                                   duration: const Duration(milliseconds: 300),
//                                   // Animation duration
//                                   transitionBuilder: (child, animation) {
//                                     return ScaleTransition(
//                                       scale: animation,
//                                       child: child,
//                                     );
//                                   },
//                                   child: isMessageSelected
//                                       ? GestureDetector(
//                                           onTap: () {
//                                             log(state.messageId +
//                                                 "---------------------");
//                                             context.read<ChatBloc>().add(
//                                                 ChatDeleteMessage(
//                                                     state.messageId,
//                                                     widget.receiverUser));
//                                           },
//                                           child: Container(
//                                               height: 38,
//                                               width: 38,
//                                               padding: const EdgeInsets.all(10),
//                                               decoration: const BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: Colors.red),
//                                               child: Image.asset(
//                                                 "assets/delete.png",
//                                                 color: Colors.white,
//                                               )),
//                                         )
//                                       : Row(
//                                           key: ValueKey('call_icons'),
//                                           // Key for the call icons
//                                           children: [
//                                             IconButton(
//                                               onPressed: () {
//                                                 // Handle phone call action
//                                               },
//                                               icon: Icon(
//                                                 Icons.phone_outlined,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             IconButton(
//                                               onPressed: () {
//                                                 // Handle video call action
//                                               },
//                                               icon: Icon(
//                                                 Icons.video_call,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       )
//                     ],
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Import other necessary packages and files

// Import other necessary packages and files

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.hero,
    required this.receiverUserId,
    required this.receiverName,
  });

  final String hero;
  final String receiverUserId;
  final String receiverName;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late AnimationController _bottomSheetController;
  late Animation<double> _bottomSheetAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final TextEditingController txtMessage = TextEditingController();
  final GlobalKey<FormFieldState> _textFieldKey = GlobalKey<FormFieldState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    FireStoreService().getReceiverData(widget.receiverUserId);

    _bottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bottomSheetAnimation = Tween<double>(begin: 13, end: 0).animate(
      CurvedAnimation(parent: _bottomSheetController, curve: Curves.easeOut),
    );
    _bottomSheetController.forward();

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          const Duration(milliseconds: 100), () => _slideController.forward());
    });
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    _slideController.dispose();

    super.dispose();
  }

  Future<bool> _handlePopScope() async {
    if (_bottomSheetController.status == AnimationStatus.completed) {
      await _bottomSheetController.reverse();
      context.read<VisibilityCubit>().showTitle();
    }
    return true; // Always return true to allow navigation
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        context.read<VisibilityCubit>().showTitle();
        log("heyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
        if (!didPop) {
          await _handlePopScope();

          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildChatHeader(),
              Expanded(
                child: AnimatedBuilder(
                  animation: _bottomSheetAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                          0,
                          _bottomSheetAnimation.value *
                              MediaQuery.of(context).size.height *
                              0.1),
                      child: _buildBottomSheet(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: EdgeInsets.only(left: 15.w, bottom: 25.h, top: 25.h, right: 5.w),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: StreamBuilder<UserModel>(
        stream: FireStoreService().getUserDataById(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return Text(widget.receiverName,
                style: Theme.of(context).textTheme.bodyMedium);
          }

          UserModel receiverData = snapshot.data!;

          return Row(
            children: [
              buildProfileAvatar(receiverData, widget.hero),
              SizedBox(width: 10),
              Expanded(
                  child: buildUserInfo(receiverData, _slideAnimation,
                      receiverData.name, context)),
              buildActionButtons(txtMessage, _focusNode),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Chat messages list with stream
          Expanded(
            child: ChatMessagesList(receiverId: widget.receiverUserId),
          ),
          // Input field section
          Padding(
            padding: EdgeInsets.only(
              top: 10.h,
            ),
            child: Container(
              height: 85.h,
              width: double.infinity,
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
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
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        return TextField(
                          key: _textFieldKey,
                          focusNode: _focusNode,
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
                                      onPressed: () async {
                                        if (state is ChatMessageSelected) {
                                          final id = (state).messageId;
                                          final isSender = (state).isSender;
                                          context.read<ChatBloc>().add(
                                              ChatUpdateMessage(
                                                  id,
                                                  txtMessage.text,
                                                  widget.receiverUserId,
                                                  isSender));
                                        } else {
                                          // Check if user is online before sending
                                          final onlineSnapshot =
                                              await FireStoreService()
                                                  .getUserOnlineStatus(
                                                      widget.receiverUserId)
                                                  .first;
                                          final isOnline =
                                              onlineSnapshot['isOnline']
                                                  as bool;
                                          final message =
                                              txtMessage.text.trim();
                                          if (message.isNotEmpty) {
                                            context.read<ChatBloc>().add(
                                                ChatSendButtonPressed(
                                                    receiverId:
                                                        widget.receiverUserId,
                                                    message: txtMessage.text
                                                        .trim()));
                                            if (!isOnline) {
                                              ApiServices.apiServices
                                                  .pushNotification(
                                                      title:
                                                          widget.receiverName,
                                                      body: txtMessage.text
                                                          .trim(),
                                                      token: FireStoreService
                                                          .receiverUserData!
                                                          .deviceToken);
                                            }
                                          }
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
                        );
                      },
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
  }
}
