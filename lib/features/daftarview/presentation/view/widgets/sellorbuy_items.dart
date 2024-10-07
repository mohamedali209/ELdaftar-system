import 'package:aldafttar/features/daftarview/presentation/view/widgets/num_daftar_container.dart';
import 'package:flutter/material.dart';

class Sellorbuyitems extends StatelessWidget {
  const Sellorbuyitems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Numdaftarcontainer(title: '#'),
                  SizedBox(width: MediaQuery.of(context).size.width * .02),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'الصنف',
                      style: TextStyle(color: Color(0xffB8B8B8)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .15,
              ),
              const Expanded(
                // Use Expanded to take available space
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('العدد',
                            style: TextStyle(color: Color(0xffB8B8B8)))),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('الجرام',
                            style: TextStyle(color: Color(0xffB8B8B8)))),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('العيار',
                            style: TextStyle(color: Color(0xffB8B8B8)))),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('السعر',
                            style: TextStyle(color: Color(0xffB8B8B8)))),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xff1D1D1D), thickness: 2),
      ],
    );
  }
}
