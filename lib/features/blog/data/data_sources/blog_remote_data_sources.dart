import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/models/blog_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModels> uploadBlog(BlogModels blog);
  Future<String> uploadImage({
    required File file,
    required BlogModels blog,
  });
  Future<List<BlogModels>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModels> uploadBlog(BlogModels blog) async {
    try {
      if (supabaseClient.auth.currentSession == null) {
        throw ServerException('User is not authenticated');
      }
      final userId = supabaseClient.auth.currentUser!.id; // This is a UUID
      print('Authenticated user ID: $userId');
      print('Blog data before insert: ${blog.toJson()}');
      final blogData = await supabaseClient.from("blogs").insert({
        ...blog.toJson(),
        'poster_id': userId, // Ensure poster_id is the user's UUID
      }).select();
      if (blogData.isEmpty) {
        throw ServerException('No data returned from insert');
      }
      print('Blog uploaded successfully: $blogData');
      return BlogModels.fromJson(blogData.first);
    } catch (e) {
      print('Error uploading blog: $e');
      if (e is PostgrestException) {
        print(
            'Postgrest Error: ${e.message}, Code: ${e.code}, Details: ${e.details}');
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage(
      {required File file, required BlogModels blog}) async {
    try {
      await supabaseClient.storage.from("blog_images").upload(blog.id, file);
      print("image upload suceesfully");
      return supabaseClient.storage.from("blog_images").getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModels>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from("blogs").select("*, profiles (name)");
      return blogs
          .map((blog) => BlogModels.fromJson(blog).copyWith(
                posterName: blog['profiles']['name'],
              ))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
