import 'package:image_gallery_app/datas/image_local_data.dart';
import 'package:image_gallery_app/datas/image_remote_data.dart';
import 'package:image_gallery_app/models/image_model.dart';

class ImageRepository {
  final IImageLocalData imageLocalData;
  final IImageRemoteData imageRemoteData;

  const ImageRepository({
    required this.imageLocalData,
    required this.imageRemoteData,
  });

  Future<List<ImageModel>> getImages() async {
    final isImageCached = await imageLocalData.isImagesCached();
    late final List<ImageModel> images;
    if (isImageCached) {
      images = await imageLocalData.fetchCacheImages();
    } else {
      images = await fetchAndCacheImages();
    }
    return images;
  }

  Future<List<ImageModel>> fetchAndCacheImages() async {
    final images = await imageRemoteData.fetchRemoteImages();
    await imageLocalData.cacheImages(images);
    return images;
  }
}
