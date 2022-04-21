class Category {
  final String id;
  final String name;
  final String data;
  final String sources;

  const Category({this.id, this.name, this.data, this.sources});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['_id'] as String,
        name: json['name'] as String,
        data: json['data'] as String,
        sources: json['sources'] as String);
  }
  String printString() {
    return '{ ${this.id},\n ${this.name},\n ${this.data},\n ${this.sources}\n}';
  }

  List<String> printList() {
    return [
      this.id,
      this.name,
      this.data,
      this.sources,
    ];
  }

  Map<String, String> printMap() {
    return {
      'id': this.id,
      'name': this.name,
      'data': this.data,
      'sources': this.sources
    };
  }
}
