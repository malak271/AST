// class ASTModel {
//   double? centerX;
//   double? centerY;
//   double? diameter;
//   String? label;
//   double? radius;
//
//   ASTModel(
//       {this.centerX, this.centerY, this.diameter, this.label, this.radius});
//
//   ASTModel.fromJson(Map<String, dynamic> json) {
//     centerX = json['centerX'];
//     centerY = json['centerY'];
//     diameter = json['diameter'];
//     label = json['label'];
//     radius = json['radius'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['centerX'] = this.centerX;
//     data['centerY'] = this.centerY;
//     data['diameter'] = this.diameter;
//     data['label'] = this.label;
//     data['radius'] = this.radius;
//     return data;
//   }
// }


class ASTModel {
  int? analysedCrops;
  List<CropsDetails> cropsDetails=[];

  ASTModel({this.analysedCrops, required this.cropsDetails});

  ASTModel.fromJson(Map<String, dynamic> json) {
    analysedCrops = json['analysed crops'];
    if (json['crops details'] != null) {
      cropsDetails = <CropsDetails>[];
      json['crops details'].forEach((v) {
        cropsDetails.add(new CropsDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['analysed crops'] = this.analysedCrops;
    if (this.cropsDetails != null) {
      data['crops details'] =
          this.cropsDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CropsDetails {
  double? diameter;
  double? centerX;
  double? centerY;
  double? height;
  String? imgFolder;
  String? imgName;
  double? width;
  String? label;

  CropsDetails(
      {this.diameter,
        this.centerX,
        this.centerY,
        this.height,
        this.imgFolder,
        this.imgName,
        this.width,
        this.label
      });

  CropsDetails.fromJson(Map<String, dynamic> json) {
    diameter = json['diameter'];
    centerX = json['centerX'];
    centerY = json['centerY'];
    height = json['height'];
    imgFolder = json['img_folder'];
    imgName = json['img_name'];
    width = json['width'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diameter'] = this.diameter;
    data['centerX'] = this.centerX;
    data['centerY'] = this.centerY;
    data['height'] = this.height;
    data['img_folder'] = this.imgFolder;
    data['img_name'] = this.imgName;
    data['width'] = this.width;
    data['label'] = this.label;
    return data;
  }
}

