import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with MessageViewMixin {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            height: 250,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 45,
                      width: 300,
                      child: TextFormField(
                        controller: _apiKeyEC,
                        decoration: const InputDecoration(
                          label: Center(
                            child: Text("API Key"),
                          ),
                        ),
                        validator:
                            Validatorless.required("API Key is required"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, "/home");
                      }
                    },
                    child: const Text("Entrar"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
