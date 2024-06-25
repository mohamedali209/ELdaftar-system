import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/row_ofdaftar.dart';
import 'package:flutter/material.dart';
class ColumnDaftarlist extends StatefulWidget {
  const ColumnDaftarlist({super.key});
  @override
  State<ColumnDaftarlist> createState() => _ColumnDaftarlistState();
}
class _ColumnDaftarlistState extends State<ColumnDaftarlist> {
  final List<Daftarcheckmodel> items = [
    Daftarcheckmodel(
      gram: '22',
      num: '1',
      details: 'خاتم',
      adad: '1',
      price: '3500',
    ),
    Daftarcheckmodel(
        num: '2', details: 'خاتم', adad: '1', price: '3500', gram: '8'),
    Daftarcheckmodel(
        num: '3', details: 'حلق', adad: '2', price: '4500', gram: '7.2'),
    Daftarcheckmodel(
        num: '4', details: 'سلسلة', adad: '1', price: '50000', gram: '10'),
    Daftarcheckmodel(
        num: '5', details: 'دبلة', adad: '4', price: '10000', gram: '5.35'),
    Daftarcheckmodel(
        num: '6', details: 'خاتم', adad: '1', price: '7000', gram: '2.3'),
    Daftarcheckmodel(
        num: '7', details: 'خاتم', adad: '1', price: '7000', gram: '2.3'),
    Daftarcheckmodel(
        num: '8', details: 'خاتم', adad: '1', price: '7000', gram: '2.3'),
    Daftarcheckmodel(
        num: '9', details: 'خاتم', adad: '1', price: '7000', gram: '2.3'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Rowofdaftar(daftarcheckmodel: items[index]),
          );
        },
      ),
    );
  }
}
