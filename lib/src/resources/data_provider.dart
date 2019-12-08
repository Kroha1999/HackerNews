import '../models/item_model.dart';
import 'list_type.dart';

abstract class Source {
  Future<List<int>> fetchListIds(TypeOfList type);
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  addItem(ItemModel item);
  Future<int> clear();
}
