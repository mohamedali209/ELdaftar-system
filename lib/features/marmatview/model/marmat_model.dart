class MarmatModel {
  final String id;
  final String product;
  final String repairRequirements;
  final String paidAmount;
  final String remainingAmount;
  final String customerName;
  final String note;
  final bool isRepaired; // New bool field

  MarmatModel({
    required this.id,
    required this.product,
    required this.repairRequirements,
    required this.paidAmount,
    required this.remainingAmount,
    required this.customerName,
    required this.note,
    required this.isRepaired, // Initialize in the constructor
  });

  // Add a method to convert MarmatModel to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'product': product,
      'repairRequirements': repairRequirements,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'customerName': customerName,
      'note': note,
      'isRepaired': isRepaired, // Include this in the map
    };
  }

  // Factory method to create MarmatModel from a Firestore document
  factory MarmatModel.fromMap(Map<String, dynamic> map, String id) {
    return MarmatModel(
      id: id,
      product: map['product'] ?? '',
      repairRequirements: map['repairRequirements'] ?? '',
      paidAmount: map['paidAmount'] ?? '',
      remainingAmount: map['remainingAmount'] ?? '',
      customerName: map['customerName'] ?? '',
      note: map['note'] ?? '',
      isRepaired: map['isRepaired'] ?? false, // Fetch bool from Firestore
    );
  }
}
