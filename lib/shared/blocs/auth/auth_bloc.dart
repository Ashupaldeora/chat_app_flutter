import 'dart:developer';

import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/features/authentication_screen/model/user_model.dart';
import 'package:chat_app_flutter/services/authentication/auth_services.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCreateAccountPressed>(_createAccount);
    on<AuthLoginPressed>(_loginAccount);
    on<AuthSignOutPressed>(_signOut);
  }

  Future<void> _createAccount(
      AuthCreateAccountPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await AuthServices.authServices
          .createAccountWithEmail(event.email, event.password);

      if (user != null) {
        List<String> keywords = generateSearchKeywords(event.name);
        UserModel userData = UserModel(
            email: user.email!,
            profilePic: "",
            name: event.name,
            uid: user.uid,
            isOnline: true,
            searchableKeywords: keywords);
        FireStoreService().saveUserData(userData);
        return emit(AuthSuccess());
      }
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _loginAccount(
      AuthLoginPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await AuthServices.authServices
          .signInWithEmail(event.email, event.password);
      if (user != null) {
        return emit(AuthSuccess());
      }
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _signOut(
      AuthSignOutPressed event, Emitter<AuthState> emit) async {
    await AuthServices.authServices.signOut();
  }

  @override
  void onChange(Change<AuthState> change) {
    // TODO: implement onChange
    super.onChange(change);
    log(change.toString());
  }
}
