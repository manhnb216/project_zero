import 'dart:async';

import 'package:de1_mobile_friends/domain/interactor/food/add_food_interactor.dart';
import 'package:de1_mobile_friends/domain/interactor/food/delete_food_interactor.dart';
import 'package:de1_mobile_friends/domain/interactor/food/observe_all_food_interactor.dart';
import 'package:de1_mobile_friends/domain/model/either.dart';
import 'package:de1_mobile_friends/domain/model/food_type.dart';
import 'package:de1_mobile_friends/presentation/page/food/food_manage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class FoodManageCubit extends Cubit<FoodManageState> {
  FoodManageCubit(
    this._allFoodInteractor,
    this._addFoodInteractor,
    this._deleteFoodInteractor,
  ) : super(FoodManageInitialState());

  final ObserveAllFoodInteractor _allFoodInteractor;
  final AddFoodInteractor _addFoodInteractor;
  final DeleteFoodInteractor _deleteFoodInteractor;

  StreamSubscription? _foodStreamSubscription;
  FoodType _currentFoodType = FoodType();

  void initialize() async {
    final stream = await _allFoodInteractor.execute(null);
    _foodStreamSubscription = stream.listen((foodList) {
      emit(FoodManagePrimaryState(foodList));
    });
  }

  void addFood(String? foodName) async {
    if (foodName?.isNotEmpty != true) {
      return;
    }
    final input = AddFoodInput(name: foodName!, type: _currentFoodType);
    final result = await _addFoodInteractor.execute(input);
    if (result.isSuccess()) {
      // Do nothing, already observe results
    } else {
      // emit(FoodManageErrorState(result.exception!));
    }
  }

  void deleteFood(String id) async {
    final result = await _deleteFoodInteractor.execute(id);
    if (result.isSuccess()) {
      // Do nothing, already observe results
    } else {
      // emit(FoodManageErrorState(result.exception!));
    }
  }

  void onChangedType(FoodType type) {
    _currentFoodType = type;
  }

  void disposeManual() {
    _foodStreamSubscription?.cancel();
  }
}
