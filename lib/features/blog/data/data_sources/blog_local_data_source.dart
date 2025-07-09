import 'package:blog_app/features/blog/data/models/blog_models.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModels> blogs});
  List<BlogModels> getLocalBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);
  final List<BlogModels> _localBlogs = [];

  @override
  void uploadLocalBlogs({required List<BlogModels> blogs}) {
    box.clear();
    for (int i = 0; i < blogs.length; i++) {
      box.put(i.toString(), blogs[i].toJson());
    }
  }

  @override
  List<BlogModels> getLocalBlogs() {
    List<BlogModels> blogs = [];
    for (int i = 0; i < box.length; i++) {
      blogs.add(BlogModels.fromJson(box.get(i.toString())));
    }
    return blogs;
  }
}
