import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesab_item.dart';
import 'package:flutter/material.dart';

class Hesabatgridview extends StatefulWidget {
  const Hesabatgridview({super.key});

  @override
  State<Hesabatgridview> createState() => _HesabatgridviewState();
}

class _HesabatgridviewState extends State<Hesabatgridview> {
  final List<Hesabmodel> items = [
    Hesabmodel(suppliername: 'حسين', wazna: '1250.99', nakdyia: '30000'),
    Hesabmodel(suppliername: 'مايكل', wazna: '340.8', nakdyia: '5260'),
    Hesabmodel(suppliername: 'وليد', wazna: '5556.99', nakdyia: '12560'),
    Hesabmodel(suppliername: 'بطرس', wazna: '250.23', nakdyia: '3220'),
    Hesabmodel(suppliername: 'حسين', wazna: '1250.99', nakdyia: '30000'),
    Hesabmodel(suppliername: 'مايكل', wazna: '340.8', nakdyia: '5260'),
    Hesabmodel(suppliername: 'وليد', wazna: '5556.99', nakdyia: '12560'),
    Hesabmodel(suppliername: 'بطرس', wazna: '250.23', nakdyia: '3220'),
    Hesabmodel(suppliername: 'حسين', wazna: '1250.99', nakdyia: '30000'),
    Hesabmodel(suppliername: 'مايكل', wazna: '340.8', nakdyia: '5260'),
    Hesabmodel(suppliername: 'وليد', wazna: '5556.99', nakdyia: '12560'),
    Hesabmodel(suppliername: 'بطرس', wazna: '250.23', nakdyia: '3220'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(30),
      itemCount: items.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hesabitem(hesabmodel: items[index]),
      ),
    );
  }
}
