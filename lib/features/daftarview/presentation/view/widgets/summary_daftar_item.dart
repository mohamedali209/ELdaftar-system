import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class SummaryHeadersDaftaritem extends StatelessWidget {
  const SummaryHeadersDaftaritem({
    super.key,
    required this.daftarmodel,
    this.color,
    this.image,
  });
  final DaftarheaderModel daftarmodel;
  final Color? color;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        width: 204,
        decoration: BoxDecoration(
            // border: Border.all(color: const Color.fromARGB(255, 112, 111, 111)),
            color: color ?? Colors.black,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              daftarmodel.title,
              style: Appstyles.regular12cairo(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.amber,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text(daftarmodel.subtitle, style: Appstyles.numheader(context)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
