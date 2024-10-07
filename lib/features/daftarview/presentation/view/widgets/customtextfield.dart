import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    // Get the screen width to calculate font size dynamically
    final screenWidth = MediaQuery.of(context).size.width;

    return Custombackgroundcontainer(
      child: SizedBox(
        height: 45,
        width: screenWidth * .2,
        child: TextField(
          textAlign: TextAlign.right, // Align hint text to the right
          style: TextStyle(
            color: Colors.white, // Text color when typing is white
            fontSize: screenWidth < 600
                ? 14
                : 16, // Adjust font size based on screen width
          ),
          decoration: InputDecoration(
            filled: true, // Enable filling the background color
            fillColor: Colors.black, // Inside color of TextField is black
            hintText: '...بحث', // Use the passed hint
            hintStyle: TextStyle(
              color: const Color(0xFFCC9900), // Hint text color is amber
              fontSize:
                  screenWidth < 600 ? 12 : 14, // Adjust hint text size as well
            ),
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.all(10.0), // Adjust padding if necessary
              child: SvgPicture.asset(
                'assets/images/mingcute_search-line.svg',
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(
                    Color(0xFFCC9900), BlendMode.srcIn), // Icon color is amber
              ),
            ),
            border: buildBorder(),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.86), // Circular border radius
      borderSide: const BorderSide(
        color: Color(0xFF4D4D4D), // Border color is grey
      ),
    );
  }
}
