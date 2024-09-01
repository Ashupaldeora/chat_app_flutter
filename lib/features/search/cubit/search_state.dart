part of 'search_cubit.dart';

final class SearchInitial extends Equatable {
  final List<UserModel> users;
  final List<UserModel> filteredUsers;
  final String query;

  const SearchInitial(
      {required this.users, required this.filteredUsers, required this.query});

  @override
  List<Object> get props => [users, query, filteredUsers];
}
