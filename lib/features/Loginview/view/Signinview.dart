import 'package:aldafttar/features/Loginview/manager/signin/cubit/signin_cubit.dart';
import 'package:aldafttar/features/Loginview/view/widgets/sign_in_body.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  SigninScreenState createState() => SigninScreenState();
}

class SigninScreenState extends State<SigninScreen> {
  @override
  void initState() {
    super.initState();
    // Check if the user is already signed in and navigate if true
    context.read<SigninCubit>().checkIfSignedIn(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).go(AppRouter.kinventoryview);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(),
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: Signinbody(),
      ),
    );
  }
}
