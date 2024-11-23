import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../utils/helpers.dart';
import '../services/contact_service.dart';

class CreateContactScreen extends StatefulWidget {
  const CreateContactScreen({super.key});

  @override
  State<CreateContactScreen> createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;

  void createContact() async {
    setState(() => isLoading = true);

    final result = await ContactService.createContact(
      emailController.text,
      nameController.text,
      lastNameController.text,
      phoneController.text,
    );

    setState(() => isLoading = false);

    if (result != null) {
      
      Navigator.pushNamed(context, '/validate-code', arguments: emailController.text);
    } else {
      Helpers.showErrorDialog(context, 'Error al crear el contacto. Verifica los datos ingresados.');
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
                'Crear Contacto',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: emailController,
                hintText: 'Correo Electrónico',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: nameController,
                hintText: 'Nombre',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: lastNameController,
                hintText: 'Apellido',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: phoneController,
                hintText: 'Teléfono',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                      onTap: createContact,
                      buttonText: 'Siguiente',
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
