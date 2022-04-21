class ReportItem {
  String id;
  String name;
  String title;
  String description;
  String createdAt;
  List<dynamic> whitelistedDepartments;
  String owner;
  String author;
  String authorProfilePicture;
  Map<String, dynamic> mostRecentVersion;
  String self;
  List<dynamic> files;
  String version;
  ReportItem(
    this.id,
    this.name,
    this.title,
    this.description,
    this.createdAt,
    this.whitelistedDepartments,
    this.owner,
    this.author,
    this.authorProfilePicture,
    this.mostRecentVersion,
    this.self, [
    this.files,
    this.version,
  ]);
}
