import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/supplierwazna_nkdyia.dart';
import 'package:aldafttar/features/marmatview/manager/cubit/marmat_cubit.dart';
import 'package:aldafttar/features/marmatview/model/marmat_model.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarmatItem extends StatelessWidget {
  final MarmatModel marmatModel;

  const MarmatItem({
    super.key,
    required this.marmatModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color.fromARGB(255, 36, 35, 35),
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7, right: 7, left: 7),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Toggle the isRepaired field and update Firestore
                              context
                                  .read<MarmatCubit>()
                                  .toggleRepairStatus(marmatModel);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(3),
                              side: BorderSide(
                                color: marmatModel.isRepaired
                                    ? const Color(0xFF15CAB8)
                                    : Colors.red,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.09),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Text(
                                  marmatModel.isRepaired
                                      ? 'تم التصليح'
                                      : 'لم يتم التصليح',
                                  style: TextStyle(
                                    color: marmatModel.isRepaired
                                        ? const Color(0xFF15CAB8)
                                        : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<MarmatCubit>()
                                  .deleteMarmatItem(marmatModel.id);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Supplierwaznaornkdyia(
                              waznaornakdyia: 'المنتج',
                              num: marmatModel.product,
                            ),
                            Supplierwaznaornkdyia(
                              waznaornakdyia: 'متطلبات التصليح',
                              num: marmatModel.repairRequirements,
                            ),
                            Supplierwaznaornkdyia(
                              waznaornakdyia: 'تم دفعه',
                              num: marmatModel.paidAmount,
                            ),
                            Supplierwaznaornkdyia(
                              waznaornakdyia: 'المتبقي من الحساب',
                              num: marmatModel.remainingAmount,
                            ),
                            Supplierwaznaornkdyia(
                              waznaornakdyia: 'اسم العميل',
                              num: marmatModel.customerName,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Center(
                child: Text(
                  textDirection: TextDirection.rtl,
                  'ملحوظة : ${marmatModel.note}',
                  style: Appstyles.regular12cairo(context)
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
