import 'package:aldafttar/utils/styles.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/columns_daftar_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/saleorbuy.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/textfieldanddfater.dart';
import 'package:flutter/material.dart';

class SellingorBuying extends StatelessWidget {
  const SellingorBuying({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Custombackgroundcontainer(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'الدفتر اليومي',
                    style: Appstyles.regular25(context),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Textfieldanddfater(),
                  const Divider(
                    color: Color.fromARGB(255, 114, 110, 110),
                  ),
                  const Sellorbuyitems(),
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height * .4,
                      child: const ColumnDaftarlist()),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ));
  }
}
