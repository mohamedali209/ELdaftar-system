class Daftarcheckmodel {
  final String num;
  final String details;
  final String adad;
  final String gram;
  final String price;
  final String ayar;  // Added ayar field

  Daftarcheckmodel({
    required this.num,
    required this.details,
    required this.adad,
    required this.gram,
    required this.price,
    required this.ayar,  // Added ayar to constructor
  });

  factory Daftarcheckmodel.fromFirestore(Map<String, dynamic> data) {
    return Daftarcheckmodel(
      num: data['num'],
      details: data['details'],
      adad: data['adad'],
      gram: data['gram'],
      price: data['price'],
      ayar: data['ayar'],  // Added ayar to factory constructor
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'num': num,
      'details': details,
      'adad': adad,
      'gram': gram,
      'price': price,
      'ayar': ayar,  // Added ayar to toFirestore map
    };
  }

  Daftarcheckmodel copyWith({
    String? num,
    String? details,
    String? adad,
    String? gram,
    String? price,
    String? ayar,  // Added ayar to copyWith method
  }) {
    return Daftarcheckmodel(
      num: num ?? this.num,
      details: details ?? this.details,
      adad: adad ?? this.adad,
      gram: gram ?? this.gram,
      price: price ?? this.price,
      ayar: ayar ?? this.ayar,  // Updated copyWith to include ayar
    );
  }
}
