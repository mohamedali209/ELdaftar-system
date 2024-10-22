class Expense {
  final String description;
  final int amount;

  Expense({
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
    };
  }

  // If you need to create an Expense from Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      description: map['description'],
      amount: map['amount'],
    );
  }
}
