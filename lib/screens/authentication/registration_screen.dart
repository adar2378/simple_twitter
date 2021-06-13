import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:twitterapp/blocs/auth_bloc/authentication_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:twitterapp/navigation/router.gr.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        if (listenState is AuthenticationLoading) {
          EasyLoading.show(status: 'Creating account...');
        } else if (listenState is AuthenticationSuccess) {
          context.router
              .pushAndPopUntil(HomeScreenRoute(), predicate: (route) => false);
        } else if (listenState is AuthenticationFailure) {
          EasyLoading.showError(listenState.errorMessage);
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register',
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
                          AuthenticationRegister(_emailController.value.text,
                              _passwordController.value.text),
                        );
                      }
                    },
                    child: Text('Register'),
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
