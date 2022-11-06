class CategoryModel {
  final String name;
  final String imageUrl;
  final String id;

  CategoryModel({required this.name,required this.imageUrl,required this.id});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
      'id':id,
    };
  }

  factory CategoryModel.fromjson(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String,
      imageUrl: map['imageUrl'] ??'',
      id: map['id'] as String,
    );
  }

}
