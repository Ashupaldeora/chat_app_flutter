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
