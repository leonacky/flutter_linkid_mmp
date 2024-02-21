class ProductCategory {
  String id = "";
  String name = "";

  ProductCategory({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "c_id": id,
      "c_name": name,
    };
    // print("ProductCategory to map $data");
    return data;
  }

  static List<Map<String, dynamic>> convertToList(List<ProductCategory> categories) {
    List<Map<String, dynamic>> list = List.empty(growable: true);
    for (var element in categories) {
      list.add(element.toMap());
    }
    return list;
  }
}
