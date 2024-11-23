import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../utils/helpers.dart';
import '../services/auth_service.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  final String contactId = "1"; 

  void registerUser() async {
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
      Helpers.showErrorDialog(context, 'Error al registrar al usuario.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'Crear Usuario',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: usernameController,
                hintText: 'Nombre de Usuario',
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
                      onTap: registerUser,
                      buttonText: 'Registrar',
                      width: double.infinity,
                      height: 50.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
