class AdjustmentModel{
  int? id;
  String? label;
  double? radius;

  AdjustmentModel({this.id, this.label, this.radius});

  AdjustmentModel.fromJson(Map<String, dynamic> json) {
    id = json['"id"'];
    label = json['"label"'];
    radius = json['"radius"'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['"id"'] = this.id;
    data['"label"'] = this.label;
    data['"radius"'] = this.radius;
    return data;
  }
}