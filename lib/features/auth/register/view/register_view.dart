import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../../core/constants/navigation_enums.dart';
import '../../../../core/init/navigation/navigation_service.dart';
import '../../../../product/utility/error_dialog.dart';
import '../cubit/register_cubit.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _passwordController = TextEditingController();

  String? _name, _email, _password;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.registerStatus == RegisterStatus.error) {
          ErrorDialog.showMessage(_scaffoldKey, state.customErrorModel);
        }
        if (state.registerStatus == RegisterStatus.success) {
          // Eğer işlem başarılı ise homepageye yolla
          NavigationService.instance.router.go(NavigationEnums.homeView.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: context.paddingMedium,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.account_box),
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name required!';
                          }
                          if (value.trim().length < 2) {
                            return 'Enter a valid name!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      context.emptySizedHeightBoxLow3x,
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
                        onSaved: (value) {
                          _email = value!;
                        },
                      ),
                      context.emptySizedHeightBoxLow3x,
                      TextFormField(
                        controller: _passwordController,
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
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                      context.emptySizedHeightBoxLow3x,
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: Icon(Icons.lock),
                        ),
                        validator: (String? value) {
                          if (_passwordController.text != value) {
                            return 'Password not match!';
                          }
                          return null;
                        },
                      ),
                      context.emptySizedHeightBoxLow3x,
                      SizedBox(
                        width: context.width,
                        child: ElevatedButton(
                          onPressed: () {
                            if (state.registerStatus == RegisterStatus.submitting) {
                              return;
                            } else {
                              if (!_formKey.currentState!.validate()) return;

                              if (kDebugMode) {
                                print('name $_name');
                                print('_email $_email');
                                print('_password $_password');
                              }

                              _formKey.currentState!.save();
                              context
                                  .read<RegisterCubit>()
                                  .signUp(name: _name!, email: _email!, password: _password!);
                            }
                          },
                          child: Text(
                            state.registerStatus == RegisterStatus.submitting
                                ? 'Loading...'
                                : 'Register',
                          ),
                        ),
                      ),
                      context.emptySizedHeightBoxLow3x,
                      Text.rich(TextSpan(
                        children: [
                          TextSpan(
                              text: 'Already have an account? ',
                              style:
                                  TextStyle(color: context.colorScheme.onSurface.withOpacity(0.4))),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (state.registerStatus == RegisterStatus.submitting) return;
                                  NavigationService.instance.router
                                      .go(NavigationEnums.loginView.routeName);
                                },
                              text: 'Sign In',
                              style: TextStyle(color: context.colorScheme.primary))
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
