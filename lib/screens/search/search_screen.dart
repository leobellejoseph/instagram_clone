import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram_clone/widgets/widgets.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'cubit/cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  static const id = 'search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            controller: _textEditingController,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                context.read<SearchCubit>().searchUsers(query: value);
              }
            },
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              hintText: 'Search Users',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  context.read<SearchCubit>().clearSearch();
                  _textEditingController.clear();
                },
              ),
            ),
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.loading:
                return const Center(
                    child: SpinKitFadingCircle(color: Colors.amber));
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? _searchList(state)
                    : CenteredText(text: 'No users found');
              case SearchStatus.error:
                return CenteredText(text: state.failure.message);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _searchList(SearchState state) {
    return ListView.builder(
      itemCount: state.users.length,
      itemBuilder: (context, index) {
        final user = state.users[index];
        return ListTile(
          leading: UserProfileImage(
            profileImageUrl: user.profileImageUrl,
            radius: 22,
          ),
          title: Text(user.username, style: const TextStyle(fontSize: 16)),
          onTap: () => Navigator.of(context).pushNamed(
            ProfileScreen.id,
            arguments: ProfileScreenArgs(userId: user.id),
          ),
        );
      },
    );
  }
}
