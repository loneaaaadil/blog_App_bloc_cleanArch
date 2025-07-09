import 'package:blog_app/core/common/cubits/App_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/curren_user.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_remote_data_sources.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repositories_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repositories.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/secrets/app_secrets.dart';
import 'features/auth/domain/usecases/user_sign_in.dart';
import 'features/auth/domain/usecases/user_sign_up.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Hive
  try {
    // Import path_provider and get the application documents directory
    // before initializing Hive.
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox('blogs'); // Open the 'blogs' box
  } catch (e) {
    print('Error initializing Hive: $e');
    rethrow;
  }

  // Initialize Supabase
  final supabase = await Supabase.initialize(
    url: AppSecrets.superBaseUrl,
    anonKey: AppSecrets.superBaseAnonKey,
  );

  // Register dependencies
  initAuth();
  _initBlog();

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator
      .registerLazySingleton(() => Hive.box('blogs')); // Register opened box
  serviceLocator.registerFactory(() => InternetConnection());

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(
        serviceLocator(),
      ));
}

void initAuth() {
  // Data sources
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepoImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  // Usecases
  serviceLocator.registerFactory<UserSignUp>(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<UserSignIn>(
    () => UserSignIn(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<CurrenUser>(
    () => CurrenUser(
      serviceLocator(),
    ),
  );

  // Bloc
  serviceLocator.registerLazySingleton(() => AuthBloc(
        UserSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currenUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ));
}

void _initBlog() {
  // Data sources
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<BlogLocalDataSource>(
    () => BlogLocalDataSourceImpl(
      serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerFactory<BlogRepositories>(
    () => BlogRepositoriesImpl(
      serviceLocator(),
      serviceLocator(),
      blogRemoteDataSource: serviceLocator(),
    ),
  );

  // Usecases
  serviceLocator.registerFactory<UploadBlog>(
    () => UploadBlog(
      blogRepositories: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<GetAllBlogs>(
    () => GetAllBlogs(serviceLocator()),
  );

  // Bloc
  serviceLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
    ),
  );
}
