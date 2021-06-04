import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/repositories/user/user_repository.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;
  SearchCubit({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(
          SearchState.initial(),
        );
  void searchUsers({@required String query}) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final users = await _userRepository.searchUsers(query: query);
      emit(state.copyWith(users: users, status: SearchStatus.loaded));
    } on Failure catch (_) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          failure: Failure(code: 'Search User', message: 'Unable to search.'),
        ),
      );
    }
  }

  void clearSearch() =>
      emit(state.copyWith(users: [], status: SearchStatus.initial));
}
