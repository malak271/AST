import 'dart:typed_data';

class ASTModel {
  int? imgId;
  int? testId;
  String? label;
  double? inhibitionRadius;
  double? centerX;
  double? centerY;
  double? width;
  double? height;
  Uint8List? img;
  String? result;

  ASTModel(
      {this.imgId,
        this.testId,
        this.label,
        this.inhibitionRadius,
        this.centerX,
        this.centerY,
        this.width,
        this.height,
        this.img,
      });

  ASTModel.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    testId = json['test_id'];
    label = json['label'];
    inhibitionRadius = json['inhibition_radius'];
    centerX = json['centerX'];
    centerY = json['centerY'];
    width = json['width'];
    height = json['height'];
    img = json['img'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['test_id'] = this.testId;
    data['label'] = this.label;
    data['inhibition_radius'] = this.inhibitionRadius;
    data['centerX'] = this.centerX;
    data['centerY'] = this.centerY;
    data['width'] = this.width;
    data['height'] = this.height;
    data['img'] = this.img;
    return data;
  }
}