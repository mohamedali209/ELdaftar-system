import 'package:aldafttar/features/Hesabatview/presentation/view/models/transaction.dart';

class Hesabmodel {
  final String id;
  final String suppliername;
  final String wazna18;
  final String wazna21;
  final String wazna24;

  final String nakdyia;
  final List<TransactionModel> transactions; // Add transactions field

  Hesabmodel({
    required this.wazna24,
    required this.id,
    required this.suppliername,
    required this.wazna18,
    required this.wazna21,
    required this.nakdyia,
    required this.transactions, // Initialize transactions
  });
double get total21 {
    final double wazna18Value = double.tryParse(wazna18) ?? 0;
    final double wazna21Value = double.tryParse(wazna21) ?? 0;
    final double wazna24Value = double.tryParse(wazna24) ?? 0;
    return (wazna18Value * 6 / 7) + (wazna24Value * 24 / 21) + wazna21Value;
  }
  factory Hesabmodel.fromMap(Map<String, dynamic> data, String documentId) {
    // Convert transaction list from Map to Transaction object
    List<TransactionModel> transactions = (data['transactions']
                as List<dynamic>?)
            ?.map((e) => TransactionModel.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];

    return Hesabmodel(
      id: documentId,
      suppliername: data['suppliername'] ?? '',
      wazna18: data['wazna18'] ?? '0',
      wazna21: data['wazna21'] ?? '0',
      wazna24: data['wazna24'] ?? '0',
      nakdyia: data['nakdyia'] ?? '0',
      transactions: transactions, // Assign converted transactions list
    );
  }

  Map<String, dynamic> toMap() {
    // Convert transactions to a list of Maps
    List<Map<String, dynamic>> transactionMaps =
        transactions.map((transaction) => transaction.toMap()).toList();

    return {
      'suppliername': suppliername,
      'wazna18': wazna18,
      'wazna21': wazna21,
      'wazna24': wazna24,
      'total21': total21,
      'nakdyia': nakdyia,
      'transactions': transactionMaps, // Add transactions to the map
    };
  }
}
