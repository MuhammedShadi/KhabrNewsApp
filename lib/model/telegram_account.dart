class TelegramAccount {
  String id;
  String name;
  bool active;
  String error;
  String lastActive;
  Map volume;
  String categoryId;
  Map categoryName;
  Map category;
  List<dynamic> customSources;
  String self;
  TelegramAccount(
    this.id,
    this.name,
    this.active,
    this.error,
    this.lastActive,
    this.volume,
    this.categoryId,
    this.categoryName,
    this.category,
    this.customSources,
    this.self,
  );
}
