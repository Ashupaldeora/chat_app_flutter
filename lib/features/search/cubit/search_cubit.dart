import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../authentication_screen/model/user_model.dart';
import '../../home/model/home_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchInitial> {
  final String loggedInUserId;

  SearchCubit(this.loggedInUserId)
      : super(const SearchInitial(query: '', users: [], filteredUsers: []));

  // Initialize users and set initial query
  Future<void> loadUsers() async {
    try {
      final users =
          await FireStoreService().getAllUsersExcludingLoggedIn(loggedInUserId);
      emit(SearchInitial(users: users, filteredUsers: [], query: state.query));
    } catch (e) {
      // Handle error
      log(e.toString());
    }
  }

  void searchUsers(String query) {
    final filteredUsers = state.users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(SearchInitial(
        users: state.users, filteredUsers: filteredUsers, query: query));
  }

  void clearSearch() {
    emit(SearchInitial(users: state.users, filteredUsers: [], query: ''));
  }
}
