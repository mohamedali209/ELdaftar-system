
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class DaftarelgardHeader extends StatelessWidget {
  const DaftarelgardHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'جرد فوري',
          style: Appstyles.regular25(context)
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {},
            icon: Custombackgroundcontainer(
                child: Text(
              ' اضافة او تعديل وزنة ',
              style: Appstyles.regular12cairo(context).copyWith(fontSize: 15),
            ))),
        const SizedBox(
          width: 50,
        )
      ],
    );
  }
}
