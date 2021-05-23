part of 'edit_profile_cubit.dart';

enum EditProfileStatus {
  initial,
  submitting,
  success,
  error,
}

class EditProfileState extends Equatable {
  final File profileImage;
  final String username;
  final String bio;
  final EditProfileStatus status;
  final Failure failure;

  EditProfileState copyWith({
    final File profileImage,
    final String username,
    final String bio,
    final EditProfileStatus status,
    final Failure failure,
  }) {
    return EditProfileState(
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  const EditProfileState({
    @required this.profileImage,
    @required this.username,
    @required this.bio,
    @required this.status,
    @required this.failure,
  });

  factory EditProfileState.initial() => const EditProfileState(
        profileImage: null,
        username: '',
        bio: '',
        status: EditProfileStatus.initial,
        failure: Failure(),
      );

  @override
  List<Object> get props => [
        this.profileImage,
        this.username,
        this.bio,
        this.status,
        this.failure,
      ];
}
