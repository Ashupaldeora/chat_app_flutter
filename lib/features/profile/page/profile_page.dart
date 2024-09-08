import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_flutter/features/authentication_screen/widgets/custom_button.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../cubit/profile_cubit/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtAbout = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    context.read<ProfileCubit>().fetchUserProfile();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    txtName.dispose();
    txtAbout.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.only(left: 15.w, right: 15.w, bottom: 40.h, top: 20.h),
          child: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                  buildWhen: (previous, current) => (previous != current),
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Container(
                          height: 180,
                          width: 180,
                          padding: EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink,
                                Colors.purple
                              ], // Gradient colors
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ClipOval(
                            child: state.imageFile != null
                                ? SizedBox(
                                    height: 170,
                                    width: 170,
                                    child: Image.file(state.imageFile!),
                                  )
                                : CachedNetworkImage(
                                    height: 170,
                                    width: 170,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[500]!,
                                      highlightColor: Colors.grey[100]!,
                                      enabled: true,
                                      child: Container(
                                        height: 170,
                                        width: 170,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    imageUrl: state.imageUrl ??
                                        FireStoreService
                                            .currentUserData!.profilePic,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -10.w,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              context.read<ProfileCubit>().pickImagePressed();
                            },
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              SizedBox(height: 25.h),
              BlocBuilder<ProfileCubit, ProfileState>(
                buildWhen: (previous, current) => (previous != current),
                builder: (context, state) {
                  txtName.text = state.name!;
                  return TextField(
                    controller: txtName,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(color: Colors.white)),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.black26,
                      hintText: "Name",
                    ),
                    onTapOutside: (event) =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: txtAbout,
                maxLines: null,
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(color: Colors.white)),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  hintText: "Hey I am available for chat",
                ),
                onTapOutside: (event) =>
                    FocusScope.of(context).requestFocus(FocusNode()),
              ),
              const Spacer(),
              CustomButton(
                text: "Save",
                onPressed: () {
                  context.read<ProfileCubit>().updateUser(txtName.text.trim());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
