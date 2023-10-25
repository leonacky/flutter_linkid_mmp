import 'product_category.dart';

class ProductItem {
  String id = "";
  String name = "";
  String image = "";
  String price = "";
  int quantity = 1;
  List<ProductCategory> categories = List.empty(growable: true);

  ProductItem({
    required this.id,
    required this.name,
    this.image = "",
    this.price = "",
    this.quantity = 1,
  });

  void setCategories(List<ProductCategory> categories) {
    this.categories = categories;
  }

  void addCategory(ProductCategory category) {
    categories.add(category);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "p_id": id,
      "p_name": name,
      "p_img": image,
      "p_price": price,
      "p_quantity": quantity,
      "p_categories": ProductCategory.convertToList(categories)
    };
    // print("ProductItem to map $data");
    return data;
  }

  static List<Map<String, dynamic>> convertToList(List<ProductItem> products) {
    List<Map<String, dynamic>> list = List.empty(growable: true);
    for (var element in products) {
      list.add(element.toMap());
    }
    return list;
  }
}
