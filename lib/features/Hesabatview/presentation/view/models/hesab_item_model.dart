import 'package:aldafttar/features/Hesabatview/presentation/view/models/transaction.dart';

class Hesabmodel {
  final String id;
  final String suppliername;
  final String wazna21;

  final String nakdyia;
  final List<TransactionModel> transactions; // Add transactions field

  Hesabmodel({
    required this.id,
    required this.suppliername,
    required this.wazna21,
    required this.nakdyia,
    required this.transactions, // Initialize transactions
  });

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
      wazna21: data['wazna21'] ?? '0',
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
      'wazna21': wazna21,
      'nakdyia': nakdyia,
      'transactions': transactionMaps, // Add transactions to the map
    };
  }
}
