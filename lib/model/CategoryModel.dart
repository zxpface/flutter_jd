// FocusModel.fromJson(json);
class CategoryModel {
  List<CategoryItemModel> result;
  CategoryModel({this.result});
  CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<CategoryItemModel>();
      json['result'].forEach((v) {
        result.add(new CategoryItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryItemModel {
  String sId; // _id=>sId
  String title;
  Object status; // Object是所有类的根类 
  String pic;
  String pid;
  String sort;

  CategoryItemModel({this.sId, this.title, this.status, this.pic, this.pid, this.sort});
  CategoryItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    status = json['status']; //type 'int' is not a subtype of type 'String'
    pic = json['pic'];
    this.pid = json['pid'];
    this.sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['status'] = this.status;
    data['pic'] = this.pic;
    data['pid'] = this.pid;
    data['sort'] = this.sort;
     return data;
  }
}