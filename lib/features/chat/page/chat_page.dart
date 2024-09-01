import 'package:chat_app_flutter/features/authentication_screen/model/user_model.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.hero,
      required this.receiverUser,
      required this.receiverName});

  final String hero;
  final String receiverUser;
  final String receiverName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Animation<Offset> position;

  late AnimationController controller;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        FireStoreService().updateIsOnline(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        FireStoreService().updateIsOnline(false);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FireStoreService().getReceiverData(widget.receiverUser);
    WidgetsBinding.instance.addObserver(this);
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    position = Tween(begin: Offset(0, -2), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((_) {
//Following future can be uncommented to check
//if the call back works after 5 seconds.
      Future.delayed(
          const Duration(milliseconds: 100), () => {controller.forward()});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff17181E),
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: StreamBuilder<UserModel>(
                stream: FireStoreService().getUserDataById(widget.receiverUser),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(widget.receiverName,
                        style: Theme.of(context).textTheme.bodyMedium!);
                  }
                  if (snapshot.data == null) {
                    return Text(widget.receiverName,
                        style: Theme.of(context).textTheme.bodyMedium!);
                  }

                  return Row(
                    children: [
                      Hero(
                        tag: widget.hero,
                        child: CircleAvatar(
                          backgroundImage: snapshot.data!.profilePic == ""
                              ? const AssetImage("assets/avatar.png")
                                  as ImageProvider
                              : NetworkImage(snapshot.data!.profilePic),
                          radius: 25.r, // Example CircleAvatar
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: SlideTransition(
                          position: position,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.receiverName,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!),
                              Text(
                                  snapshot.data!.isOnline
                                      ? "online"
                                      : "offline",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(fontSize: 10.sp)),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
