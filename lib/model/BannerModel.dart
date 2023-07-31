class BannerModel {
  final String? imageUrl;

  BannerModel({this.imageUrl});

  factory BannerModel.fromQuerySnapshot(Map<String, dynamic> snapshot){
    return BannerModel(
       imageUrl: snapshot['imageUrl'] ,
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "imageUrl": imageUrl
    };
  }
}