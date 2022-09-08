import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../product/cubits/cubits.dart';
import '../viewmodel/register_view_model.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      viewModel: RegisterViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      onPageBuilder: (BuildContext context, RegisterViewModel viewModel) =>
          BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) =>
            viewModel.listenRegisterState(state.registerStatus, state.customErrorModel),
        builder: (context, state) {
          return Scaffold(
            key: viewModel.scaffoldKey,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                    padding: context.paddingMedium, child: buildForm(viewModel, context, state)),
              ),
            ),
          );
        },
      ),
    );
  }

  Form buildForm(RegisterViewModel viewModel, BuildContext context, RegisterState state) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          buildNameTextFormField(viewModel),
          context.emptySizedHeightBoxLow3x,
          buildEmailTextFormField(viewModel),
          context.emptySizedHeightBoxLow3x,
          buildPasswordTextFormField(context, viewModel, state),
          context.emptySizedHeightBoxLow3x,
          buildConfirmPasswordFormField(context, viewModel, state),
          context.emptySizedHeightBoxLow3x,
          SizedBox(width: context.width, child: buildRegisterButton(viewModel, state)),
          context.emptySizedHeightBoxLow3x,
          buildSignInRichText(context, viewModel, state)
        ],
      ),
    );
  }

  Text buildSignInRichText(BuildContext context, RegisterViewModel viewModel, RegisterState state) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(color: context.colorScheme.onSurface.withOpacity(0.4))),
        TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () => viewModel.navigateSignInWithRichText(state.registerStatus),
            text: 'Sign In',
            style: TextStyle(color: context.colorScheme.primary))
      ],
    ));
  }

  ElevatedButton buildRegisterButton(RegisterViewModel viewModel, RegisterState state) {
    return ElevatedButton(
      onPressed: () => viewModel.registerApp(state.registerStatus),
      child: Text(
        state.registerStatus == RegisterStatus.submitting ? 'Loading...' : 'Register',
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField(
      BuildContext context, RegisterViewModel viewModel, RegisterState state) {
    return TextFormField(
      controller: viewModel.confirmPasswordTextController,
      obscureText: state.isObscure,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: 'Confirm Password',
        prefixIcon: const Icon(Icons.password),
        suffixIcon: IconButton(
          onPressed: () => context.read<RegisterCubit>().toggleObscure(),
          icon: state.isObscure ? const Icon(Icons.lock) : const Icon(Icons.lock_open),
        ),
      ),
      validator: (String? value) {
        if (viewModel.passwordTextController!.text != value) {
          return 'Password not match!';
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordTextFormField(
      BuildContext context, RegisterViewModel viewModel, RegisterState state) {
    return TextFormField(
      controller: viewModel.passwordTextController,
      obscureText: state.isObscure,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: 'Password',
        prefixIcon: const Icon(Icons.password),
        suffixIcon: IconButton(
          onPressed: () => context.read<RegisterCubit>().toggleObscure(),
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

  TextFormField buildEmailTextFormField(RegisterViewModel viewModel) {
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
        if (!value.isValidEmail) {
          return 'Enter a valid email!';
        }
        return null;
      },
    );
  }

  TextFormField buildNameTextFormField(RegisterViewModel viewModel) {
    return TextFormField(
      controller: viewModel.nameTextController,
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
    );
  }
}
