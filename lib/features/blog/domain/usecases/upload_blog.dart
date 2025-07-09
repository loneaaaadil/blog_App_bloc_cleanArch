import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/use_case.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepositories blogRepositories;
  UploadBlog({required this.blogRepositories});
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepositories.uploadBlog(
      posterId: params.posterId,
      file: params.image,
      title: params.title,
      content: params.content,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;
  UploadBlogParams({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}
