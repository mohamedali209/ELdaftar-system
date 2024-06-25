
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Custombackgroundcontainer(
      child: SizedBox(
        height: 45,
        width: MediaQuery.sizeOf(context).width * .2,
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
              hintText: hint ,
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              border: buildBorder(),
              enabledBorder: buildBorder(),
              focusedBorder: buildBorder()),
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 112, 111, 111)),
    );
  }
}
