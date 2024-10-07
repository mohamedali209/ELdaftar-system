
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerCubit extends Cubit<int> {
  DrawerCubit() : super(0); // Initial state is index 0

  void updateIndex(int index) {
    emit(index); // Update the index
  }
}
