import 'package:chat_app_flutter/features/authentication_screen/page/sign_up.dart';
import 'package:chat_app_flutter/features/chat/bloc/chat_bloc.dart';
import 'package:chat_app_flutter/features/home/pages/visiblity_cubit.dart';
import 'package:chat_app_flutter/features/search/cubit/search_cubit.dart';
import 'package:chat_app_flutter/firebase_options.dart';
import 'package:chat_app_flutter/services/authentication/auth_services.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:chat_app_flutter/services/status/status_services.dart';
import 'package:chat_app_flutter/shared/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/route/route.dart';
import 'features/home/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final appLifecycleObserver = AppLifecycleObserver();
  appLifecycleObserver.startListening();

  runApp(const MyApp());

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // Make status bar transparent
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarColor: Colors.transparent,
    // Set navigation bar transparent
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => VisibilityCubit(),
        ),
        BlocProvider(
          create: (context) => ChatBloc(),
        ),
        BlocProvider(
          create: (context) =>
              SearchCubit(FirebaseAuth.instance.currentUser!.uid)..loadUsers(),
        ),
      ],
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xff181922),
              inputDecorationTheme: InputDecorationTheme(
                // contentPadding:
                //     EdgeInsets.symmetric(vertical: 17.h, horizontal: 15.w),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5.w,
                    ),
                    borderRadius: BorderRadius.circular(15.r)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color(0xffD227AB), width: 1.5.w),
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              appBarTheme: AppBarTheme(
                toolbarHeight: 70.h,
                backgroundColor: Colors.transparent,
              ),
              textTheme: TextTheme(
                displayMedium: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 23.sp),
                ),
                labelSmall: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp),
                ),
                bodyMedium: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp),
                ),
              )),
          home: StreamBuilder<User?>(
            stream: AuthServices.authServices.firebaseAuth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              print(FirebaseAuth.instance.currentUser?.email);
              if (snapshot.hasData) {
                // User is signed in
                FireStoreService().getUserData(snapshot.data!.uid);
                return HomePage();
              } else {
                // No user is signed in
                return const SignUp();
              }
            },
          ),
          onGenerateRoute: Routes.generateRoute,
        ),
      ),
    );
  }
}
