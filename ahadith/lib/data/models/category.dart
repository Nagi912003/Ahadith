class Category {
  String? id;
  String? title;
  String? hadeethsCount;
  Null? parentId;

  Category({this.id, this.title, this.hadeethsCount, this.parentId});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    hadeethsCount = json['hadeeths_count'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['hadeeths_count'] = this.hadeethsCount;
    data['parent_id'] = this.parentId;
    return data;
  }
}
