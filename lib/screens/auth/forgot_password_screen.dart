import 'package:flutter/material.dart';
import 'package:receipe_project/components/ScaffoldCustom.dart';
import 'package:receipe_project/screens/auth/reset_email_sent_screen.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ScaffoldCustom(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: ForgotPassForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: defaultPadding,
          ),

          Text(
            'Forgot Password',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),

          // Email Field
          TextFormField(
            validator: emailValidator,
            decoration: InputDecoration(
              label: const Text('Email'),
              hintText: 'Enter Email',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12, // Default border color
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12, // Default border color
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Reset password Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If all data are correct then save data to out variables
                _formKey.currentState!.save();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetEmailSentScreen(),
                  ),
                );
              }
            },
            child: const Text("Reset password"),
          ),
        ],
      ),
    );
  }
}
