import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/user_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModels> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModels> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModels?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModels> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException("User is null");
      }
      return UserModels.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException("Error logging in user: $e");
    }
  }

  @override
  Future<UserModels> registerWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {
        'name': name,
      });
      if (response.user == null) {
        throw ServerException("User is null");
      }
      return UserModels.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException("Error registering user: $e");
    }
  }

  @override
  Future<UserModels?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModels.fromJson(userData.first)
            .copyWith(id: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
