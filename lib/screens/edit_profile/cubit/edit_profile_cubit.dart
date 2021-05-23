import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:meta/meta.dart';
part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final ProfileBloc _profileBloc;

  //constructor
  EditProfileCubit({
    @required UserRepository userRepository,
    @required StorageRepository storageRepository,
    @required ProfileBloc profileBloc,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _profileBloc = profileBloc,
        super(EditProfileState.initial()) {
    final user = _profileBloc.state.user;
    emit(state.copyWith(
      username: user.username,
      bio: user.bio,
    ));
  }

  void profileImageChanged(File image) => emit(
      state.copyWith(profileImage: image, status: EditProfileStatus.initial));

  void usernameChanged(String username) => emit(
      state.copyWith(username: username, status: EditProfileStatus.initial));

  void bioChanged(String bio) =>
      emit(state.copyWith(bio: bio, status: EditProfileStatus.initial));

  void submit() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;

      var profileImageUrl = user.profileImageUrl;

      if (state.profileImage != null) {
        profileImageUrl = await _storageRepository.uploadProfileImage(
            url: profileImageUrl, image: state.profileImage);
      }

      final updatedUser = user.copyWith(
          username: state.username,
          profileImageUrl: profileImageUrl,
          bio: state.bio);

      await _userRepository.updateUser(user: updatedUser);

      _profileBloc.add(ProfileLoadUser(userId: user.id));

      emit(state.copyWith(status: EditProfileStatus.success));
    } on Failure catch (_) {
      emit(
        state.copyWith(
          status: EditProfileStatus.error,
          failure: const Failure(
              code: 'Edit Profile', message: 'Unable to update profile.'),
        ),
      );
    }
  }
}
