class Category {
  String? id;
  String? title;
  String? hadeethsCount;
  String? parentId;

  Category({this.id, this.title, this.hadeethsCount, this.parentId});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    hadeethsCount = json['hadeeths_count'];
    parentId = json['parent_id'];
  }
}
