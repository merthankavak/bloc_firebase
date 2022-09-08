import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../product/cubits/cubits.dart';
import '../viewmodel/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      onPageBuilder: (BuildContext context, LoginViewModel viewModel) =>
          BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) =>
            viewModel.listenLoginState(state.loginStatus, state.customErrorModel),
        builder: (context, state) {
          return Scaffold(
            key: viewModel.scaffoldKey,
            body: SafeArea(
              child: Padding(
                  padding: context.paddingMedium, child: buildForm(viewModel, context, state)),
            ),
          );
        },
      ),
    );
  }

  Form buildForm(LoginViewModel viewModel, BuildContext context, LoginState state) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          buildEmailTextFormField(viewModel),
          context.emptySizedHeightBoxLow3x,
          buildPasswordTextFormField(context, viewModel, state),
          context.emptySizedHeightBoxLow3x,
          SizedBox(width: context.width, child: buildLoginButton(state, viewModel, context)),
          context.emptySizedHeightBoxLow3x,
          buildSignUpRichText(context, state, viewModel)
        ],
      ),
    );
  }

  Text buildSignUpRichText(BuildContext context, LoginState state, LoginViewModel viewModel) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text: 'Don\'t have an account? ',
            style: TextStyle(color: context.colorScheme.onSurface.withOpacity(0.4))),
        TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () => viewModel.navigateSignUpWithRichText(state.loginStatus),
            text: 'Sign Up',
            style: TextStyle(color: context.colorScheme.primary))
      ],
    ));
  }

  ElevatedButton buildLoginButton(
      LoginState state, LoginViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: () => viewModel.loginApp(state.loginStatus),
      child: const Text('Login'),
    );
  }

  TextFormField buildPasswordTextFormField(
      BuildContext context, LoginViewModel viewModel, LoginState state) {
    return TextFormField(
      controller: viewModel.passwordTextController,
      obscureText: state.isObscure,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: 'Password',
        prefixIcon: const Icon(Icons.password),
        suffixIcon: IconButton(
          onPressed: () => context.read<LoginCubit>().toggleObscure(),
          icon: state.isObscure ? const Icon(Icons.lock) : const Icon(Icons.lock_open),
        ),
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
    );
  }

  TextFormField buildEmailTextFormField(LoginViewModel viewModel) {
    return TextFormField(
      controller: viewModel.emailTextController,
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
        if (!value.isValidEmails) {
          return 'Enter a valid email!';
        }
        return null;
      },
    );
  }
}
