import 'package:aldafttar/features/Loginview/manager/signup/cubit/signup_cubit.dart';
import 'package:aldafttar/features/Loginview/manager/signup/cubit/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aldafttar/features/Loginview/view/widgets/signup_textfields.dart';
import 'package:aldafttar/utils/styles.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the screen with a BlocProvider for SignupCubit
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'الدفتر',
                    style: Appstyles.bold50(context).copyWith(fontSize: 70),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'انشاء حساب',
                    style: Appstyles.regular25(context)
                        .copyWith(color: Colors.amber),
                  ),
                  const SizedBox(height: 15),
                  SignupForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.isSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
          Navigator.pop(context);
        } else if (state.errorMessage != null) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Column(
        children: [
          SignupTextfields(
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
            storeNameController: _storeNameController,
            phoneController: _phoneController,
          ),
          const SizedBox(height: 20),
          SignupButton(
            onSignup: () {
              // Trigger signup on button press
              BlocProvider.of<SignupCubit>(context).signup(
                email: _emailController.text,
                password: _passwordController.text,
                name: _nameController.text,
                storeName: _storeNameController.text,
                phone: _phoneController.text,
              );
            },
          ),
        ],
      ),
    );
  }
}

class SignupButton extends StatelessWidget {
  final VoidCallback onSignup;

  const SignupButton({super.key, required this.onSignup});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Container(
      width: MediaQuery.of(context).size.width * .7,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.amber, // Color on the left
            Color(0xFFBF8F00), // Color on the right
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make background transparent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          onSignup(); },
        child: Text(
          ' انشاء حساب ',
          style: Appstyles.regular12cairo(context)
              .copyWith(fontSize: 15, color: Colors.white),
        ),
      ),
    );
      },
    );
  }
}
