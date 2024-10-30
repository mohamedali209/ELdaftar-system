import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/employeesdftar/view/widgets/employees_dftarbody.dart';
import 'package:flutter/material.dart';

class EmployeesDaftarScreen extends StatelessWidget {
  const EmployeesDaftarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AdaptiveLayout(
        mobileLayout: (context) => const EmployeesDftarBody(),
        tabletLayout: (context) => const EmployeesDftarBody(),
        desktopLayout: (context) => const EmployeesDftarBody(),
      ),
    );
  }
}
