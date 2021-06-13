import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:twitterapp/blocs/auth_bloc/authentication_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:twitterapp/navigation/router.gr.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, listenState) {
        if (listenState is AuthenticationLoading) {
          EasyLoading.show(status: 'Loading...');
        } else if (listenState is AuthenticationSuccess) {
          context.router
              .pushAndPopUntil(HomeScreenRoute(), predicate: (route) => false);
        } else if (listenState is AuthenticationFailure) {
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
          EasyLoading.showError(listenState.errorMessage);
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: EmailValidator(
                        errorText: 'enter a valid email address'),
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'This field is required'),
                      MinLengthValidator(6,
                          errorText: 'This field must be 6 character long'),
                    ]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    state is AuthenticationFailure ? state.errorMessage : '',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          authBloc.add(
                            AuthenticationLogin(_emailController.value.text,
                                _passwordController.value.text),
                          );
                        }
                      },
                      child: Text('Login')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? '),
                      TextButton(onPressed: () {}, child: Text('Create one'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
