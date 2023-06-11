class ImageModel {
  ImageModel(
      {required this.id,
      required this.src,
      required this.landscapeSrc,
      required this.small,
      required this.owner});

  final int id;
  final String src;
  final String owner;
  final String landscapeSrc;
  final String small;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
      id: json['id'],
      src: json['src']['original'],
      landscapeSrc: json['src']['portrait'],
      small: json['src']['medium'],
      owner: json['photographer']);

  factory ImageModel.fromDataBase(Map<String,dynamic> data) => ImageModel(id: data['id'],
      src: data['src'],
      landscapeSrc: data['landscape'],
      small: data['small'],
      owner: data['owner']);
}
