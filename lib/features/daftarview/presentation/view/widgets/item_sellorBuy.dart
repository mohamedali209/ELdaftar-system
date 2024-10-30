import 'package:aldafttar/features/daftarview/presentation/view/widgets/num_daftar_container.dart';
import 'package:aldafttar/utils/commas.dart';
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
    this.onPressed,
    required this.tfasel, // Added tfasel
  });

  final String details;
  final String ayar;
  final String adad;
  final String price;
  final String gram;
  final String num;
  final String? tfasel; // Added tfasel as nullable field
  final void Function()? onTap;
  final void Function()? onPressed;

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
                width: 35,
                color: Colors.black,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(details,
                          style: const TextStyle(color: Color(0xffF7EAD1))),
                      const SizedBox(height: 5),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.zero, // No padding around the text
                          minimumSize: Size
                              .zero, // No minimum size, to avoid any extra space
                          tapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // Reduces tap area to match text size
                        ),
                        onPressed: onPressed,
                        child: SizedBox(
                          width:
                              40, // Set a fixed width to ensure both texts take the same space
                          child: Text(
                            textDirection: TextDirection.rtl,
                            tfasel != null && tfasel!.isNotEmpty
                                ? 'تفاصيل' // Show "تفاصيل" if tfasel is not empty
                                : 'لا يوجد تفاصيل', // Show "لا يوجد تفاصيل" if tfasel is empty or null
                            textAlign:
                                TextAlign.center, // Align text in the center
                            style: const TextStyle(
                              color: Color(0xff979796),
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Conditionally show the edit icon button
              ModalRoute.of(context)?.settings.name == '/DaftarView' ||
                      ModalRoute.of(context)?.settings.name == '/employeeDaftar'
                  ? IconButton(
                      onPressed: onTap,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.amber,
                        size: 13,
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            width: ModalRoute.of(context)?.settings.name == '/DaftarView' ||
                    ModalRoute.of(context)?.settings.name == '/employeeDaftar'
                ? (MediaQuery.of(context).size.width < 600
                    ? MediaQuery.of(context).size.width *
                        .05 // Width for mobile when at DaftarView
                    : MediaQuery.of(context).size.width *
                        .13) // Width for larger screens at DaftarView
                : (MediaQuery.of(context).size.width < 600
                    ? MediaQuery.of(context).size.width *
                        .13 // Width for mobile when not at DaftarView
                    : MediaQuery.of(context).size.width *
                        .17), // Width for larger screens when not at DaftarView
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container for 'adad' with FittedBox
                Container(
                  width: 20,
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(adad,
                        style: const TextStyle(color: Color(0xffB8B8B8))),
                  ),
                ),
                // Container for 'gram' with FittedBox
                Container(
                  width: 20,
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(gram,
                        style: const TextStyle(color: Color(0xffB8B8B8))),
                  ),
                ),
                // Container for 'ayar' with FittedBox
                Container(
                  width: 20,
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(ayar,
                        style: const TextStyle(color: Color(0xffB8B8B8))),
                  ),
                ),
                // Container for 'price' with FittedBox
                Container(
                  width: 30,
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(NumberFormatter.format(int.parse(price)),
                        style: const TextStyle(color: Color(0xffB8B8B8))),
                  ),
                ),
                const SizedBox(width: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
