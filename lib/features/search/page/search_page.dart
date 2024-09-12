import 'package:chat_app_flutter/config/route/route_names.dart';
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
  void initState() {
    // TODO: implement initState
    context.read<SearchCubit>().loadUsers();
    super.initState();
  }

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
                      context.read<SearchCubit>().clearSearch();
                      Navigator.of(context).pop();
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
                          onChanged: (value) {
                            print("Value changed: '$value'"); // Debugging
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
              if (state.filteredUsers.isEmpty) {
                return const Center(
                  child: Text("Search users"),
                );
              }
              return ListView.builder(
                itemCount: state.filteredUsers.length,
                itemBuilder: (context, index) {
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
