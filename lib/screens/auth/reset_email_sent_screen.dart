import 'package:flutter/material.dart';
import 'package:receipe_project/components/ScaffoldCustom.dart';
import 'package:receipe_project/constants.dart';
import '../../components/welcome_text.dart';

class ResetEmailSentScreen extends StatelessWidget {
  const ResetEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
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
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WelcomeText(
                      title: "Reset email sent",
                      text: "We have sent a instructions email to \nexample@email.com.",
                    ),
                    const SizedBox(height: defaultPadding),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Send again"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
