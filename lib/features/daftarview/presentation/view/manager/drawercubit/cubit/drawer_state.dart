
import 'package:equatable/equatable.dart';

sealed class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}

final class DrawerInitial extends DrawerState {}
