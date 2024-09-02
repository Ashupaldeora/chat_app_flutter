import 'package:chat_app_flutter/config/route/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants.dart';
import '../../../services/firestore/firestore_services.dart';
import '../../../shared/blocs/auth/auth_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final txtEmail = TextEditingController();

  final txtPassword = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Log in",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesName.home,
              (route) => false,
            )..then((_) {
                FireStoreService()
                    .getUserData(FirebaseAuth.instance.currentUser!.uid);
              });
          }
          if (state is AuthFailure) {
            snackBar(context, state.error);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    "Log in with one of the following options",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    // height: 27.h,
                    // width: 30.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/svg/google.svg",
                      fit: BoxFit.cover,
                      height: 25.h,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  MyTextFormField(
                    text: "Email",
                    controller: txtEmail,
                    hintText: "Johndoe@gmail.com",
                  ),
                  MyTextFormField(
                    text: "Password",
                    controller: txtPassword,
                    hintText: "Pick a strong password",
                    isObscure: true,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                              color: Color(0xffD227A9), size: 40),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: CustomButton(
                          text: 'Log in',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthLoginPressed(
                                  email: txtEmail.text.trim(),
                                  password: txtPassword.text.trim()));
                            }
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "Don't have an account ?  ",
                        style: TextStyle(color: Colors.grey.shade500)),
                    TextSpan(
                        text: "Sign up",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pop();
                          }),
                  ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
