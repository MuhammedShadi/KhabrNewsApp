class TelegramPost {
  String id;
  String date;
  String text;
  String username;
  Map reportIdentifier;
  Map universalIdentifier;
  TelegramPost(
    this.id,
    this.date,
    this.text,
    this.username,
    this.reportIdentifier,
    this.universalIdentifier,
  );
}
