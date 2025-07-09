import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepositories {
  Future<Either<Failure, Blog>> uploadBlog(
      {required String posterId,
      required File file,
      required String title,
      required String content,
      required List<String> topics});
  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
