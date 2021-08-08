import 'package:flutter/material.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/ui/ui.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              CardContainer(
                  child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ChangeNotifierProvider(
                    create: (_) => AuthProvider(),
                    child: _LoginForm(),
                  ),
                ],
              )),
              SizedBox(
                height: 50,
              ),
              Text(
                'Need an account yet? Create a new account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<AuthProvider>(context);
    return Container(
      key: loginForm.formKey,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                loginForm.email = value;
              },
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                labelText: 'Email',
                hintText: 'john.doe@domain.com',
                prefixIcon: Icon(
                  Icons.alternate_email_outlined,
                  color: Colors.deepPurple,
                ),
              ),
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Entered value is not valid';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              onChanged: (value) {
                loginForm.password = value;
              },
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                labelText: 'Password',
                hintText: '******',
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: Colors.deepPurple,
                ),
              ),
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'The password value must be at least 6 characters long';
              },
            ),
            SizedBox(height: 30),
            MaterialButton(
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        //if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        await Future.delayed(Duration(seconds: 4));

                        Navigator.pushReplacementNamed(context, 'home');
                      },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    !loginForm.isLoading ? 'Login' : 'Please wait...',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
