import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Tahlelsummaryitem extends StatelessWidget {
  const Tahlelsummaryitem({
    super.key,
    required this.title,
    this.date,
    required this.color,
  });
  final String title;
  final String? date;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Custombackgroundcontainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Appstyles.regular25(context),
          ),
          Text(
            date ?? '',
            style: Appstyles.regular25(context),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(15, 7, 16.5, 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0x1AFFFFFF)),
                      borderRadius: BorderRadius.circular(4),
                      color: color,
                    ),
                    child: GestureDetector(
                      onTap: () {} ,
                      child: Container(
                        width: 150,
                        alignment: Alignment.center,
                        child: const Text(
                          'Download PDF',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.5,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
