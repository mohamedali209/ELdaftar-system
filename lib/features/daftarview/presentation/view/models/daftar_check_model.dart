class Daftarcheckmodel {
  final String num;
  final String details;
  final String adad;
  final String gram;
  final String price;
  final String ayar;
  final String tfasel; // Added tfasel field

  Daftarcheckmodel({
    required this.num,
    required this.details,
    required this.adad,
    required this.gram,
    required this.price,
    required this.ayar,
    required this.tfasel, // Added tfasel to constructor
  });

  // Factory constructor to create a Daftarcheckmodel from Firestore data
  factory Daftarcheckmodel.fromFirestore(Map<String, dynamic> data) {
    return Daftarcheckmodel(
      num: data['num'],
      details: data['details'],
      adad: data['adad'],
      gram: data['gram'],
      price: data['price'],
      ayar: data['ayar'],
      tfasel: data['tfasel'] ?? '', // Added tfasel to factory constructor
    );
  }

  // Converts Daftarcheckmodel object to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'num': num,
      'details': details,
      'adad': adad,
      'gram': gram,
      'price': price,
      'ayar': ayar,
      'tfasel': tfasel, // Added tfasel to toFirestore map
    };
  }

  // CopyWith method for immutability
  Daftarcheckmodel copyWith({
    String? num,
    String? details,
    String? adad,
    String? gram,
    String? price,
    String? ayar,
    String? tfasel, // Added tfasel to copyWith method
  }) {
    return Daftarcheckmodel(
      num: num ?? this.num,
      details: details ?? this.details,
      adad: adad ?? this.adad,
      gram: gram ?? this.gram,
      price: price ?? this.price,
      ayar: ayar ?? this.ayar,
      tfasel: tfasel ?? this.tfasel, // Updated copyWith to include tfasel
    );
  }
}
