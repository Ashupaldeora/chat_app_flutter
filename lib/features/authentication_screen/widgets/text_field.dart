import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
      required this.text,
      required this.controller,
      required this.hintText,
      this.isObscure});

  final String text;
  final String hintText;
  final TextEditingController controller;
  final bool? isObscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 60.h,
          child: TextFormField(
            controller: controller,
            style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                hintText: hintText,
                hintStyle: GoogleFonts.lato()),
            onTapOutside: (event) =>
                FocusScope.of(context).requestFocus(FocusNode()),
            obscureText: isObscure ?? false,
            validator: (value) {
              if (text == "Email" &&
                  !RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value!) &&
                  value.isNotEmpty) {
                return "Please enter a valid email";
              } else if (text == "Password" && value!.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}
