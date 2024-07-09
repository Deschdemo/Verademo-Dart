import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:verademo_dart/theme/theme.dart';
import 'package:verademo_dart/utils/constants.dart';
import 'login.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: VTheme.loginTheme,
      child: Scaffold(
  
        body: Column (
          children: [
            const SizedBox(height: 150),
            Text("Choose Username", style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: VConstants.veracodeWhite)),
            const SizedBox(height: 50),
            _credField('Username', context),
            const SizedBox(height: 42),
            loginButton(context),
            const SizedBox(height: 85),
            signInText(context)
          ],
        )
      ),
    );
  }

  Text signInText(BuildContext context) {
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: "Already have an account? "),
        TextSpan(
          text: "Sign In",
          // style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blue),
          style: const TextStyle(
            color: Colors.blue
          ),
          recognizer: TapGestureRecognizer()..onTap = () {
            print("Sign in");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        )
      ])
    );
  }

  Row signUpTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          height: 48,
          image: AssetImage(VConstants.vcIcon)
        ),
        const SizedBox(width: 9.2),
        Text("Register", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: VConstants.codeWhite)),
        const SizedBox(width: 4),
      ],
    );
  }

  Container loginButton(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 33),
          child: ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              print('pressed login');
            },
          ),
        );
  }

  Container _credField(String placeholder, BuildContext context) {
    return Container(
          // height: 40,
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 33),
          child: TextField (
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              hintText: placeholder,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VConstants.veracodeWhite),
              filled: true,

              fillColor: const Color(0xff454443),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              )
        
            )
          )
        );
  }
}