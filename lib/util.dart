import 'package:health_companion/models/fineli_model.dart';
import 'package:health_companion/services/fineli_service.dart';

import 'models/component_model.dart';

class Util {
  static Future<List<Component>?> createComponents(String food) async {
    final data = await FineliService.getFoodItem(food);
    return data?.map((element) => FineliModel.fromJson(element).toComponent()).toList();
  }
}
