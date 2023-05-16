class ResultModel{
  int? img_id;
  String? result;
  String? label;

  ResultModel({this.img_id, this.result,this.label});

  ResultModel.fromJson(json) {
    img_id = json['id'];
    result = json['result'];
    label= json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['"id"'] = this.img_id;
    data['"result"'] = '"${this.result}"';
    data['"label"']='"${this.label}"';
    return data;
  }
}