part of 'profile_cubit.dart';

final class ProfileState extends Equatable {
  final String? imageUrl;
  final File? imageFile;
  final String? name;

  const ProfileState({this.name, this.imageUrl, this.imageFile});

  @override
  // TODO: implement props
  List<Object?> get props => [imageUrl, imageFile, name];
}

final class ProfileLoading extends ProfileState {}

final class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess(
      {required String super.imageUrl,
      required super.imageFile,
      required String super.name});
}

final class ProfileUpdateFailure extends ProfileState {
  final String error;

  const ProfileUpdateFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
