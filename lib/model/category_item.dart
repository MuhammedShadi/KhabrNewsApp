class CateItems {
  final String id;
  final String name;
  final String data;
  final String sources;

  CateItems(
    this.id,
    this.name,
    this.data,
    this.sources,
  );
  List<String> printList() {
    return [
      this.id,
      this.name,
      this.data,
      this.sources,
    ];
  }
}
