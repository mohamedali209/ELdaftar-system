import 'package:aldafttar/features/daftarview/presentation/view/widgets/num_daftar_container.dart';
import 'package:flutter/material.dart';

class ItemSellorBuy extends StatelessWidget {
  const ItemSellorBuy({
    super.key,
    required this.details,
    required this.ayar,
    required this.adad,
    required this.price,
    required this.gram,
    this.onTap,
    required this.num,
  });

  final String details;
  final String ayar;
  final String adad;
  final String price;
  final String gram;
  final String num;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Numdaftarcontainer(title: num),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              Container(
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(details,
                        style: const TextStyle(color: Color(0xffF7EAD1))),
                    const SizedBox(height: 5),
                    const Text('تفاصيل',
                        style: TextStyle(color: Color(0xff979796), fontSize: 9)),
                  ],
                ),
              ),
              IconButton(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.amber,
                    size: 15,
                  ))
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .15,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container for 'adad' with FittedBox
                Container(
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(adad,
                        style: const TextStyle(color: Color(0xffB8B8B8))),
                  ),
                ),

                // Container for 'gram' with FittedBox
                Container(
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(gram,
                        style: const TextStyle(color: Color(0xffB8B8B8))),
                  ),
                ),

                // Container for 'ayar' with FittedBox
                Container(
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(ayar,
                        style: const TextStyle(color: Color(0xffB8B8B8))),
                  ),
                ),

                // Container for 'price' with FittedBox
                Container(
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(price,
                        style: const TextStyle(color: Color(0xffB8B8B8))),
                  ),
                ),

                const SizedBox(width: 1),
              ],
            ),
          )
        ],
      ),
    );
  }
}
