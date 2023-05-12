class ResultModel{
  int? img_id;
  String? result;

  ResultModel({this.img_id, this.result});

  // ResultModel.fromJson(Map<String, dynamic> json) {
  //   img_id = json['id'];
  //   result = json['label'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.img_id;
    data['result'] = this.result;
    return data;
  }
}