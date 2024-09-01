import 'package:chat_app_flutter/config/route/route_names.dart';
import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/features/authentication_screen/page/login_page.dart';
import 'package:chat_app_flutter/features/home/model/home_model.dart';
import 'package:chat_app_flutter/features/home/widgets/custom_bottom_sheet.dart';
import 'package:chat_app_flutter/features/search/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController txtMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Row(
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<SearchCubit>().clearSearch();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    )),
                Expanded(
                  child: SizedBox(
                    height: 40.h,
                    child: Hero(
                      tag: "search",
                      child: Material(
                        color: Colors.transparent,
                        child: TextField(
                          autofocus: true,
                          // Keep this false to manually control focus
                          onChanged: (value) {
                            context.read<SearchCubit>().searchUsers(value);
                          },
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
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffD227AB), width: 1.5.w),
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: BlocBuilder<SearchCubit, SearchInitial>(
                builder: (context, state) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  if (state.filteredUsers.isEmpty) {
                    return const Center(
                      child: Text("Search users"),
                    );
                  }
                  final user = state.filteredUsers[index];
                  return Hero(
                    tag: user.uid,
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RoutesName.chat, arguments: {
                            "hero": user.uid,
                            "receiverId": user.uid,
                            "receiverName": user.name,
                          });
                          CustomBottomSheet.show(context, txtMessage, user.uid);
                        },
                        leading: CircleAvatar(
                          radius: 22.r,
                          backgroundImage: (user.profilePic == "")
                              ? const AssetImage("assets/avatar.png")
                                  as ImageProvider
                              : NetworkImage(user.profilePic),
                        ),
                        title: Text(
                          user.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          "Hey i am available",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        // Customize your tile here
                      ),
                    ),
                  );
                },
              );
            })),
          ],
        ),
      ),
    );
  }
}
