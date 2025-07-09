import 'dart:io';

import 'package:blog_app/core/usecase/use_case.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<UploadBlogEvent>(_onBlogUpload);
    on<BlogGetAllBlogsEvent>(_onFetchAllBlogs);
  }
  void _onFetchAllBlogs(
      BlogGetAllBlogsEvent event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blogs) => emit(BlogDisplaySucess(blogs)),
    );
  }

  void _onBlogUpload(UploadBlogEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      image: event.image,
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      topics: event.topics,
    ));
    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }
}
