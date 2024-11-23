import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../utils/helpers.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  final String contactId = "1"; 

  void register() async {
    setState(() => isLoading = true);

    final result = await AuthService.register(
      usernameController.text,
      passwordController.text,
      contactId,
    );

    setState(() => isLoading = false);

    if (result != null) {
      Navigator.pushNamed(context, '/');
    } else {
      Helpers.showErrorDialog(
        context,
        'Error al registrarse. Verifica los datos ingresados.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'OPTIME',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 22, 123, 206),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Registro',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: usernameController,
                hintText: 'Usuario',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                      onTap: register,
                      buttonText: 'Registrar',
                      width: double.infinity,
                      height: 50.0,
                      borderRadius: 12.0,
                    ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/'),
                child: const Text(
                  '¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
