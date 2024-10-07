import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
 final TextInputType? keyboardType;

  const CustomTextField2({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xffB8B8B8),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff373737)),
          borderRadius: BorderRadius.circular(7),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
      ),
      validator: validator,
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String labelText;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff373737)),
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
      ),
      validator: validator,
    );
  }
}
