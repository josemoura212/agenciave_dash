import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/modules/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:validatorless/validatorless.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with MessageViewMixin {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyEC = TextEditingController();

  final controller = Injector.get<SplashController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            height: 250,
            child: Card(
              elevation: 12,
              child: AutofillGroup(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: _apiKeyEC,
                          decoration: const InputDecoration(
                            label: Center(
                              child: Text("API Key"),
                            ),
                          ),
                          autofillHints: const [AutofillHints.password],
                          validator:
                              Validatorless.required("API Key e obrigatorio"),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await controller.checkAuth(
                              apiKey: _apiKeyEC.text);
                          if (result) {
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(context, "/home");
                            }
                          }
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
      ),
    );
  }
}
