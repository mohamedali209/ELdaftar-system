import 'package:aldafttar/features/daftarview/presentation/view/manager/summarylist/cubit/summary_item_state.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';
import 'package:aldafttar/utils/commas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryDftarCubit extends Cubit<SummaryDftarState> {
  SummaryDftarCubit() : super(SummaryDftarInitial());

  Future<void> fetchData() async {
    emit(SummaryDftarLoading());

    try {
      // Fetch data from Firestore
      final weightDoc = await FirebaseFirestore.instance
          .collection('weight')
          .doc('HQWsDzc8ray5gwZp5XgF')
          .get();

      final dailyTransactionsDoc = await FirebaseFirestore.instance
          .collection('dailyTransactions')
          .doc('today')
          .get();

      if (weightDoc.exists && dailyTransactionsDoc.exists) {
        final weightData = weightDoc.data() ?? {};
        final dailyTransactionsData = dailyTransactionsDoc.data() ?? {};

        // Safely fetch and format values
        final totalSalePrice = NumberFormatter.format(
          int.tryParse(
                  dailyTransactionsData['totalSalePrice']?.toString() ?? '0') ??
              0,
        );

        final totalBuyingPrice = NumberFormatter.format(
          int.tryParse(dailyTransactionsData['totalBuyingPrice']?.toString() ??
                  '0') ??
              0,
        );
        final total18kasr =
            dailyTransactionsData['total18kasr']?.toString() ?? '0';
        final total21kasr =
            dailyTransactionsData['total21kasr']?.toString() ?? '0';
        final totalCash = NumberFormatter.formatDoubleString(weightData['total_cash']);

        final items = [
          DaftarheaderModel(
            title: 'مبيعات اليوم',
            subtitle: totalSalePrice,
          ),
          DaftarheaderModel(
            title: 'شراء اليوم',
            subtitle: totalBuyingPrice,
          ),
          DaftarheaderModel(
            title: 'النقدية المتاحة',
            subtitle: totalCash,
          ),
          DaftarheaderModel(
            title: '18 الكسر',
            subtitle: total18kasr,
          ),
          DaftarheaderModel(
            title: '21 الكسر',
            subtitle: total21kasr,
          ),
        ];
        

        emit(SummaryDftarLoaded(items));
      } else {
        throw Exception('Documents not found');
      }
    } catch (e) {
      emit(SummaryDftarError('Error fetching data: ${e.toString()}'));
    }
  }

 
}
