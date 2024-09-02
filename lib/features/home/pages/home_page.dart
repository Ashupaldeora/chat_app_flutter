import 'package:chat_app_flutter/features/home/model/home_model.dart';
import 'package:chat_app_flutter/features/home/pages/visiblity_cubit.dart';
import 'package:chat_app_flutter/services/chat/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../config/route/route_names.dart';
import '../../chat/widgets/custom_bottom_sheet.dart';
import '../../chat/widgets/custom_user_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController txtMessage = TextEditingController();
  final GlobalKey<PopupMenuButtonState<String>> _popupMenuKey =
      GlobalKey<PopupMenuButtonState<String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BlocBuilder<VisibilityCubit, VisibilityState>(
            builder: (context, state) {
              return Visibility(
                visible: state is VisibilityVisible,
                child: Text(
                  "Chats",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 28.sp, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25.sp,
                )),
            PopupMenuButton<String>(
              key: _popupMenuKey,
              onSelected: (value) {
                if (value == 'signOut') {
                  Future.delayed(Duration(milliseconds: 100), () {
                    Navigator.of(context).pushNamed(RoutesName.signUp);
                  });
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'signOut',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ],
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(RoutesName.search),
                child: SizedBox(
                  height: 40.h,
                  child: Hero(
                    tag: "search",
                    child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        enabled: false,
                        showCursor: false,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(color: Colors.white)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff24252a),
                          hintText: "Search",
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 15.w),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.r)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Expanded(
                child: StreamBuilder<List<HomeChatModel>>(
                    stream: ChatServices.chatServices.getHomeChats(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.twistingDots(
                              leftDotColor: const Color(0xffB816D9),
                              rightDotColor: Colors.white,
                              size: 40),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Search users to get started !"),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var homeChatDetails = snapshot.data![index];

                            return Column(
                              children: [
                                CustomUserTile(
                                  hero: homeChatDetails.userId,
                                  lastMessage: homeChatDetails.lastMessage,
                                  name: homeChatDetails.name,
                                  profilePic: homeChatDetails.profilePic,
                                  timeSent: DateFormat.Hm()
                                      .format(homeChatDetails.timeSent),
                                  onTap: () {
                                    context.read<VisibilityCubit>().hideTitle();
                                    Navigator.pushNamed(
                                        context, RoutesName.chat,
                                        arguments: {
                                          "hero": homeChatDetails.userId,
                                          "receiverId": homeChatDetails.userId,
                                          "receiverName": homeChatDetails.name,
                                        });
                                    CustomBottomSheet.show(context, txtMessage,
                                        homeChatDetails.userId);
                                  },
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 50.w, bottom: 10.h),
                                  child: Divider(
                                    color: Colors.grey.shade800,
                                  ),
                                )
                              ],
                            );
                          });
                    }),
              )
            ],
          ),
        ));
  }
}
