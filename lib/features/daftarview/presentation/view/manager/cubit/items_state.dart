import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:equatable/equatable.dart';

class ItemsState extends Equatable {
  final List<Daftarcheckmodel> sellingItems;
  final List<Daftarcheckmodel> buyingItems;

  const ItemsState({required this.sellingItems, required this.buyingItems});

  @override
  List<Object> get props => [sellingItems, buyingItems];

  
}