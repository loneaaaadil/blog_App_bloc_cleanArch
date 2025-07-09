import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_remote_data_sources.dart';
import 'package:blog_app/features/blog/data/models/blog_models.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoriesImpl implements BlogRepositories {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoriesImpl(
    this.blogLocalDataSource,
    this.connectionChecker, {
    required this.blogRemoteDataSource,
  });
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File file,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure("No internet connection!"));
      }
      BlogModels blogModels = BlogModels(
        id: Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: " ",
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl =
          await blogRemoteDataSource.uploadImage(file: file, blog: blogModels);
      blogModels = blogModels.copyWith(imageUrl: imageUrl);
      final updatedBlog = await blogRemoteDataSource.uploadBlog(blogModels);
      return right(updatedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.getLocalBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
