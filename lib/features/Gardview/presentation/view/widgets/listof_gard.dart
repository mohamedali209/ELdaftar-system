
import 'package:aldafttar/features/Gardview/presentation/model/row_gard_model.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/rowof_gard.dart';
import 'package:flutter/material.dart';

class Listgard extends StatelessWidget {
   Listgard({super.key});
final List<Gardmodel>items=[Gardmodel(no3: 'خواتم', num21: '69', num18: '122', wazn: '570'),
Gardmodel(no3: 'دبل', num21: '21', num18: '88', wazn: '579'),
Gardmodel(no3: 'سلاسل', num21: '69', num18: '122', wazn: '570'),
Gardmodel(no3: 'حلقان', num21: '69', num18: '122', wazn: '570'),
Gardmodel(no3: 'انسيالات', num21: '69', num18: '122', wazn: '570'),
Gardmodel(no3: 'اساور', num21: '69', num18: '122', wazn: '570'),
Gardmodel(no3: 'اساور بخواتم', num21: '69', num18: '122', wazn: '570'),
Gardmodel(no3: 'تعاليق', num21: '69', num18: '122', wazn: '570'),
Gardmodel(no3: 'كوليهات', num21: '69', num18: '122', wazn: '570'),
Gardmodel(no3: 'غوايش', num21: '69', num18: '122', wazn: '570'),
];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) =>Padding(
          padding: const EdgeInsets.all(8.0),
          child: Rowofgard(gardmodel: items[index]),
        ) ,),
    );
  }
}