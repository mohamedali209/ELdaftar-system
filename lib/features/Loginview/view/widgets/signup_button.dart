import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Signupbutton extends StatelessWidget {
  const Signupbutton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          AppRouter.router.pop();
        },
        child: Text(
          ' انشاء حساب',
          style: Appstyles.regular12cairo(context)
              .copyWith(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
