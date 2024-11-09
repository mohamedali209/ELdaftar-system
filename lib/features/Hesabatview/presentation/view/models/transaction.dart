class TransactionModel {
  final String wazna21;
  final String nakdyia;
  final String date;
  final bool isAddition; // New field to track addition or subtraction

  TransactionModel({
    required this.wazna21,
    required this.nakdyia,
    required this.date,
    required this.isAddition, // Required in the constructor
  });

  // Factory method to create an instance from a map (Firestore or other sources)
  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      wazna21: data['wazna21'] ?? '0',
      nakdyia: data['nakdyia'] ?? '0',
      date: data['date'] ?? '',
      isAddition: data['isAdd'] ?? true, // Default to true if not present
    );
  }

  // Convert the instance to a map for saving to Firestore or other databases
  Map<String, dynamic> toMap() {
    return {
      'wazna21': wazna21,
      'nakdyia': nakdyia,
      'date': date,
      'isAdd': isAddition, // Include isAddition in the map
    };
  }

  // Override toString method for better debugging
  @override
  String toString() {
    return 'TransactionModel( wazna21: $wazna21,  nakdyia: $nakdyia, date: $date, isAddition: $isAddition)';
  }
}
