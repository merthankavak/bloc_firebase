import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../../core/constants/navigation_enums.dart';
import '../../../../core/init/navigation/navigation_service.dart';
import '../../../../product/utility/error_dialog.dart';
import '../cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.error) {
          ErrorDialog.showMessage(_scaffoldKey, state.customErrorModel);
        }
        if (state.loginStatus == LoginStatus.success) {
          NavigationService.instance.router.go(NavigationEnums.homeView.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: Padding(
              padding: context.paddingMedium,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email required!';
                        }
                        if (!value.isValidEmail) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _email = value;
                      },
                    ),
                    context.emptySizedHeightBoxLow3x,
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: Icon(Icons.lock),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password required!';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _password = value;
                      },
                    ),
                    context.emptySizedHeightBoxLow3x,
                    SizedBox(
                      width: context.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (state.loginStatus == LoginStatus.submitting) return;
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState!.save();
                          context.read<LoginCubit>().signIn(email: _email!, password: _password!);
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    context.emptySizedHeightBoxLow3x,
                    Text.rich(TextSpan(
                      children: [
                        TextSpan(
                            text: 'Don\'t have an account? ',
                            style:
                                TextStyle(color: context.colorScheme.onSurface.withOpacity(0.4))),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (state.loginStatus == LoginStatus.submitting) return;
                                NavigationService.instance.router
                                    .go(NavigationEnums.registerView.routeName);
                              },
                            text: 'Sign Up',
                            style: TextStyle(color: context.colorScheme.primary))
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
