class UserTests {
  List<Data>? data;
  int? testsCount;

  UserTests({this.data, this.testsCount});

  UserTests.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    testsCount = json['tests_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['tests_count'] = this.testsCount;
    return data;
  }
}

class Data {
  String? bacteria;
  String? createdAt;
  int? id;
  String? img;
  String? sampleType;
  int? userId;
  String? mobileResult;
  String? processedImage;

  Data(
      {this.bacteria,
        this.createdAt,
        this.id,
        this.img,
        this.sampleType,
        this.userId,
        this.mobileResult,
        this.processedImage
      });

  Data.fromJson(Map<String, dynamic> json) {
    bacteria = json['bacteria'];
    createdAt = json['created_at'];
    id = json['id'];
    img = json['img'];
    sampleType = json['sample_type'];
    userId = json['user_id'];
    mobileResult = json['mobile_result'];
    processedImage = json['processed_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bacteria'] = this.bacteria;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['img'] = this.img;
    data['sample_type'] = this.sampleType;
    data['user_id'] = this.userId;
    data['mobile_result'] = this.mobileResult;
    data['processed_image'] = this.processedImage;
    return data;
  }
}