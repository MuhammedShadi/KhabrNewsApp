class TelegramChannel {
  Map id;
  Map type;
  String name;
  Map data;
  Map categoryName;
  Map customSources;
  String icon;
  String self;
  TelegramChannel(
    this.id,
    this.type,
    this.name,
    this.data,
    this.categoryName,
    this.customSources,
    this.icon,
    this.self,
  );
}
