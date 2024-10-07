import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomTextFieldInventory extends StatelessWidget {
final  FocusNode? focusNode;
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  const CustomTextFieldInventory({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return 
    
    
    TextFormField(
      focusNode: focusNode,
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelStyle: Appstyles.regular12cairo(context).copyWith(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(
                  255, 31, 30, 30)), // Set the default border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color:
                  Color.fromARGB(255, 31, 30, 30)), // Set enabled border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 31, 30, 30),
              width: 2), // Set focused border color
        ),
        filled: true,
        fillColor: Colors.black,
      ),
      validator: validator,
    );
  }
}
