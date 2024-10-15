class TransactionModel {
  final String wazna18;
  final String wazna21;
  final String wazna24;
  final String nakdyia;
  final String date;
  final bool isAddition; // New field to track addition or subtraction

  TransactionModel({
    required this.wazna18,
    required this.wazna21,
    required this.wazna24,
    required this.nakdyia,
    required this.date,
    required this.isAddition, // Required in the constructor
  });

  // Factory method to create an instance from a map (Firestore or other sources)
  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      wazna18: data['wazna18'] ?? '0',
      wazna21: data['wazna21'] ?? '0',
      wazna24: data['wazna24'] ?? '0',
      nakdyia: data['nakdyia'] ?? '0',
      date: data['date'] ?? '',
      isAddition: data['isAdd'] ?? true, // Default to true if not present
    );
  }

  // Convert the instance to a map for saving to Firestore or other databases
  Map<String, dynamic> toMap() {
    return {
      'wazna18': wazna18,
      'wazna21': wazna21,
      'wazna24': wazna24,
      'nakdyia': nakdyia,
      'date': date,
      'isAdd': isAddition, // Include isAddition in the map
    };
  }
}
