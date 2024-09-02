import 'package:chat_app_flutter/config/route/route_names.dart';
import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:chat_app_flutter/shared/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    txtName.dispose();
    txtEmail.dispose();
    txtPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        elevation: 0,
        backgroundColor: const Color(0xff181922),
        title: Text(
          "Sign Up",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(
              RoutesName.home,
              (route) => false,
            )
                .then((_) {
              FireStoreService()
                  .getUserData(FirebaseAuth.instance.currentUser!.uid);
            });
          }
          if (state is AuthFailure) {
            snackBar(context, state.error);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
          ),
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
                    "Sign up with one of the following options",
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
                  MyTextFormField(
                    text: "Name",
                    controller: txtName,
                    hintText: "John Doe",
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
                            color: Color(0xffD227A9),
                            size: 40,
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: CustomButton(
                          text: 'Create account',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print(txtName.text +
                                  txtEmail.text +
                                  txtPassword.text);
                              context.read<AuthBloc>().add(
                                  AuthCreateAccountPressed(
                                      name: txtName.text.trim(),
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
                        text: "Already have an account ?  ",
                        style: TextStyle(color: Colors.grey.shade500)),
                    TextSpan(
                        text: "Log in",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushNamed(RoutesName.logIn);
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
