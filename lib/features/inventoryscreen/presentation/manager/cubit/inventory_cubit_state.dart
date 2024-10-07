import 'package:equatable/equatable.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryUpdated extends InventoryState {
  final Map<String, String> controllers;

  const InventoryUpdated(this.controllers);

  @override
  List<Object> get props => [controllers];
}

class InventoryTotalsCalculated extends InventoryState {
  final double total18kWeight;
  final double total21kWeight;
  final double total18kKasr;
  final double total21kKasr;
  final double totalCash;
  final double totalInventoryWeight21;
  final double sabekatQuantity;
  final double sabekatWeight;
  final double ginehatQuantity;
  final double ginehatWeight; // Added field

  const InventoryTotalsCalculated(
    this.total18kWeight,
    this.total21kWeight,
    this.total18kKasr,
    this.total21kKasr,
    this.totalCash,
    this.totalInventoryWeight21, this.sabekatQuantity, this.sabekatWeight, this.ginehatQuantity, this.ginehatWeight, // Include new field in constructor
  );

  @override
  List<Object> get props => [
        total18kWeight,
        total21kWeight,
        total18kKasr,
        total21kKasr,
        totalCash,
        totalInventoryWeight21, // Include new field in props list
      ];
}
