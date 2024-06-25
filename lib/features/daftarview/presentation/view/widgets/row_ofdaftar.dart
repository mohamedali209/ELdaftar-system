
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/daftar_container_item.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/detailsdaftar_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/num_daftar_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Rowofdaftar extends StatelessWidget {
  const Rowofdaftar({super.key, required this.daftarcheckmodel});
  final Daftarcheckmodel daftarcheckmodel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Numdaftarcontainer(title: daftarcheckmodel.num,),
        DetailsDaftarcontainer(details: daftarcheckmodel.details,color: Colors.white,icon: FontAwesomeIcons.pencil,sizeicon: 15,),
        DaftarcontainerItem(title: daftarcheckmodel.adad,color: Colors.white,),
        DaftarcontainerItem(title: daftarcheckmodel.gram,color: Colors.white,),
        DaftarcontainerItem(title: daftarcheckmodel.price,color: Colors.white,)
      ],
    );
  }
}

