import 'package:hive/hive.dart';

part 'image_model.g.dart';

@HiveType(typeId: 0)
class ImageModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String imagePath;

  const ImageModel({
    required this.name,
    required this.imagePath,
  });

  factory ImageModel.fromJson(Map<String, dynamic> data) {
    return ImageModel(
      name: data['title'] ?? '',
      imagePath: data['url'] ?? '',
    );
  }
}
