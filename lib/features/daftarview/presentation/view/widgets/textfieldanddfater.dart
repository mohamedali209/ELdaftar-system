
import 'package:aldafttar/utils/styles.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/customtextfield.dart';
import 'package:flutter/material.dart';

class Textfieldanddfater extends StatelessWidget {
  const Textfieldanddfater({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomTextField(hint: 'بحث'),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Text(
                'الدفاتر',
                style: Appstyles.regular25(context),
              ),
              const Icon(Icons.keyboard_arrow_right),
              const SizedBox(
                width: 35,
              )
            ],
          )
        ])
      ],
    );
  }
}
