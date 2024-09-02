import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app_flutter/services/firestore/firestore_services.dart';
import 'package:equatable/equatable.dart';

import '../../authentication_screen/model/user_model.dart';

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
      emit(SearchInitial(
          users: users, filteredUsers: const [], query: state.query));
    } catch (e) {
      // Handle error
      log(e.toString());
    }
  }

  void searchUsers(String query) {
    final filteredUsers = query.isEmpty
        ? <UserModel>[]
        : state.users.where((user) {
            return user.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

    emit(SearchInitial(
        users: state.users, filteredUsers: filteredUsers, query: query));
  }

  void clearSearch() {
    emit(SearchInitial(users: state.users, filteredUsers: const [], query: ''));
  }
}
