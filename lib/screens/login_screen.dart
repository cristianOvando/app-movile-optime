import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/helpers.dart';
import '../components/my_textfield.dart';
import '../components/my_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void signIn() async {
    setState(() => isLoading = true);

    final result = await AuthService.login(
      usernameController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (result != null && result['success'] == true) {
      Navigator.pushNamed(context, '/home');
    } else {
      Helpers.showErrorDialog(
        context,
        result?['message'] ?? 'Error al iniciar sesión. Verifica tus credenciales.',
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
              const SizedBox(height: 10),
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: usernameController,
                hintText: 'Correo electrónico',
                obscureText: false,
                borderRadius: 10.0,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
                borderRadius: 10.0,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                      onTap: signIn,
                      buttonText: 'Iniciar sesión',
                      width: double.infinity,
                      height: 50.0,
                      borderRadius: 12.0,
                    ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              const Text(
                'O continuar con',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
               
                },
                child: Image.asset(
                  'lib/assets/images/googleicon.png',
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes cuenta?',
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      ' Regístrate',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
