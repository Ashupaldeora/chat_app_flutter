import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../../../services/globalkey_manager/key_manager.dart';
import '../../authentication_screen/model/user_model.dart';
import '../bloc/chat_bloc.dart';

Widget buildUserInfo(UserModel user, Animation<Offset> _slideAnimation,
    String receiverName, BuildContext context) {
  return SlideTransition(
    position: _slideAnimation,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(receiverName, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          user.isOnline ? "Online" : "Offline",
          style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 10),
        ),
      ],
    ),
  );
}

Widget buildActionButtons(
    TextEditingController txtMessage, FocusNode _focusNode) {
  return BlocBuilder<ChatBloc, ChatState>(
    builder: (context, state) {
      bool isMessageSelected = state is ChatMessageSelected;

      return SizedBox(
        width: 130,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isMessageSelected
                  ? buildDeleteButton(state, context, txtMessage, _focusNode)
                  : _buildCallButtons(),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildDeleteButton(ChatState state, BuildContext context,
    TextEditingController txtMessage, FocusNode _focusNode) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () async {
          // context.read<ChatBloc>().add(ChatDeleteMessage(
          //     (state as ChatMessageSelected).messageId, widget.receiverUserId));
          final id = (state as ChatMessageSelected).messageId;
          final snappableKey = GlobalKeyManager.getKey(id);
          SnappableState snpState = snappableKey!.currentState!;
          if (snpState.isInProgress) {
            // do nothing
            debugPrint("Animation is in progress, please wait!");
          } else {
            if (snappableKey.currentState != null) {
              await snappableKey.currentState!.snap();
            }
          }
        },
        child: Container(
          height: 38,
          width: 38,
          padding: const EdgeInsets.all(10),
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          child: Image.asset("assets/delete.png", color: Colors.white),
        ),
      ),
      if ((state as ChatMessageSelected).isSender)
        MaterialButton(
          padding: EdgeInsets.zero,
          color: Colors.white,
          // height: 30.h,
          minWidth: 30.w,
          shape: CircleBorder(),
          onPressed: () {
            final message = (state).message;
            txtMessage.text = message;
            FocusScope.of(context).requestScopeFocus();
            log("focused ??");
          },
          child: Icon(
            Icons.edit,
            color: Colors.black,
          ),
        ),
    ],
  );
}

Widget _buildCallButtons() {
  return Row(
    key: ValueKey('call_icons'),
    children: [
      IconButton(
        onPressed: () {
          // Handle phone call action
        },
        icon: Icon(Icons.phone_outlined, color: Colors.white),
      ),
      IconButton(
        onPressed: () {
          // Handle video call action
        },
        icon: Icon(Icons.video_call, color: Colors.white),
      ),
    ],
  );
}

Widget buildProfileAvatar(UserModel user, String hero) {
  return Hero(
    tag: hero,
    child: Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xffB24DDA), Color(0xffCE7F45)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CircleAvatar(
        backgroundImage: user.profilePic.isEmpty
            ? const AssetImage("assets/avatar.png") as ImageProvider
            : NetworkImage(user.profilePic),
        radius: 24,
      ),
    ),
  );
}
