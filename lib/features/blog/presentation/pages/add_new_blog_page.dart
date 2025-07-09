import 'dart:io';

import 'package:blog_app/core/common/cubits/App_user/app_user_cubit.dart';
import 'package:blog_app/core/common/cubits/App_user/app_user_state.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/themes/app_pallete.dart';
import 'package:blog_app/core/utils/image_picker.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final contentController = TextEditingController();
  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> selectedTopics = [];

  File? image;
  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    contentController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    selectedTopics.isNotEmpty &&
                    image != null) {
                  final posterId =
                      (context.read<AppUserCubit>().state as AppUserLoggedIn)
                          .user
                          .id;
                  context.read<BlogBloc>().add(UploadBlogEvent(
                        posterId: posterId,
                        image: image!,
                        title: titleController.text.trim(),
                        content: contentController.text.trim(),
                        topics: selectedTopics,
                      ));
                }
              },
            ),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.error);
            } else if (state is BlogUploadSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return CustomLoader();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      image != null
                          ? GestureDetector(
                              onTap: () {
                                selectImage();
                              },
                              child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            )
                          : GestureDetector(
                              onTap: () {
                                selectImage();
                              },
                              child: DottedBorder(
                                color: AppPallete.borderColor,
                                dashPattern: [10, 5],
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Select your image",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            "Technology",
                            "Business",
                            "programming",
                            "entertainment"
                          ]
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                      setState(() {});
                                      // print(selectedTopics);
                                    },
                                    child: Chip(
                                      side: selectedTopics.contains(e)
                                          ? null
                                          : BorderSide(
                                              color: AppPallete.borderColor,
                                            ),
                                      label: Text(e),
                                      color: selectedTopics.contains(e)
                                          ? WidgetStateProperty.all(
                                              AppPallete.gradient1)
                                          : null,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlogEditor(
                          controller: titleController, hintText: "Blog Title"),
                      SizedBox(
                        height: 20,
                      ),
                      BlogEditor(
                          controller: contentController,
                          hintText: "Blog Content"),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
