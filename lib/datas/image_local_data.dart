import 'package:hive/hive.dart';
import 'package:image_gallery_app/models/failure_model.dart';
import 'package:image_gallery_app/constants.dart';
import 'package:image_gallery_app/models/image_model.dart';

abstract class IImageLocalData {
  Future<bool> isImagesCached();
  Future<List<ImageModel>> fetchCacheImages();
  Future<void> cacheImages(List<ImageModel> datas);
}

class ImageLocalData implements IImageLocalData {
  final HiveInterface hive;

  const ImageLocalData({
    required this.hive,
  });

  @override
  Future<bool> isImagesCached() async {
    try {
      final imageBox = await hive.openBox(imagesBox);
      int length = imageBox.length;
      return length != 0;
    } catch (e) {
      throw FailureModel('Is Images Cached Failed');
    }
  }

  @override
  Future<List<ImageModel>> fetchCacheImages() async {
    try {
      final imageBox = await hive.openBox(imagesBox);
      final datas = await imageBox.get(imagesKey);
      return (datas as List).map((data) => data as ImageModel).toList();
    } catch (_) {
      throw FailureModel('Fetch Cached Images Failed');
    }
  }

  @override
  Future<void> cacheImages(List<ImageModel> datas) async {
    try {
      final imageBox = await hive.openBox(imagesBox);
      await imageBox.put(imagesKey, datas);
    } catch (_) {
      throw FailureModel('Cache Images Failed');
    }
  }
}
