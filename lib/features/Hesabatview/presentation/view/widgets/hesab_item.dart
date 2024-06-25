
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/supplierwazna_nkdyia.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Hesabitem extends StatelessWidget {
  const Hesabitem({
    super.key,
    required this.hesabmodel,
  });
  final Hesabmodel hesabmodel;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Color(0xff151312)),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            hesabmodel.suppliername,
            style: Appstyles.regular25(context).copyWith(fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                Supplierwaznaornkdyia(
                  waznaornakdyia: 'وزنة',
                  num: hesabmodel.wazna,
                ),
                const SizedBox(
                  height: 25,
                ),
                Supplierwaznaornkdyia(
                  waznaornakdyia: 'نقدية',
                  num: hesabmodel.nakdyia,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

