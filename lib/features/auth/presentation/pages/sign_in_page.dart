import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/themes/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../widgets/auth_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authfailure) {
                showSnackBar(context, state.message);
              } else if (state is AuthSuccess) {
                Navigator.pushAndRemoveUntil(
                    context, BlogPage.route(), (route) => false);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return CustomLoader();
              }
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AuthField(
                      controller: emailController,
                      hintText: "Email",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AuthField(
                      controller: passwordController,
                      hintText: "Password",
                      isObsecure: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AuthGradientButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(AuthSignIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ));
                        }
                      },
                      buttonText: "Sign In",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                      children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                );
                              },
                            text: "Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                )),
                      ],
                    )),
                  ],
                ),
              );
            },
          )),
    );
  }
}
