import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:instagram_clone/helpers/helpers.dart';
import 'package:instagram_clone/screens/create_post/cubit/create_post_cubit.dart';
import 'package:instagram_clone/widgets/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CreatePostScreen extends StatelessWidget {
  static const id = 'create';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              _formKey.currentState.reset();
              context.read<CreatePostCubit>().reset();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Post Created'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1),
              ));
            } else if (state.status == CreatePostStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialogue(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              progressIndicator: SpinKitCircle(color: Colors.amber),
              inAsyncCall: state.status == CreatePostStatus.submitting,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _selectPostImage(context),
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.blue[200]),
                        ),
                        height: MediaQuery.of(context).size.height / 2,
                        width: double.infinity,
                        child: state.postImage != null
                            ? Image.file(state.postImage, fit: BoxFit.cover)
                            : const Icon(Icons.image,
                                color: Colors.grey, size: 120),
                      ),
                    ),
                    if (state.status == CreatePostStatus.submitting)
                      LinearProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              validator: (value) => value.trim().isEmpty
                                  ? 'Caption cannot be empty'
                                  : null,
                              decoration: InputDecoration(hintText: 'Caption'),
                              onChanged: (value) => context
                                  .read<CreatePostCubit>()
                                  .captionChanged(value),
                            ),
                            const SizedBox(height: 28),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(elevation: 1),
                              onPressed:
                                  state.status == CreatePostStatus.submitting
                                      ? null
                                      : () => _submitForm(
                                          context,
                                          state.status ==
                                              CreatePostStatus.submitting,
                                          state.postImage),
                              child: Text('Post'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectPostImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context, cropStyle: CropStyle.rectangle, title: 'Create Post');
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting, File postImage) {
    if (_formKey.currentState.validate() &&
        !isSubmitting &&
        postImage != null) {
      context.read<CreatePostCubit>().submit();
    }
  }
}
