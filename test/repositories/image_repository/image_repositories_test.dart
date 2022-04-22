import 'package:flutter_test/flutter_test.dart';
import 'package:image_gallery_app/datas/image_local_data.dart';
import 'package:image_gallery_app/datas/image_remote_data.dart';
import 'package:image_gallery_app/models/image_model.dart';
import 'package:image_gallery_app/repositories/image_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'image_repositories_test.mocks.dart';

@GenerateMocks([IImageLocalData, IImageRemoteData])
void main() {
  late IImageLocalData mockLocalData;
  late IImageRemoteData mockRemoteData;
  late ImageRepository sut;

  setUp(() {
    mockLocalData = MockIImageLocalData();
    mockRemoteData = MockIImageRemoteData();

    sut = ImageRepository(
      imageLocalData: mockLocalData,
      imageRemoteData: mockRemoteData,
    );
  });
  group('getImages', () {
    const List<ImageModel> images = [
      ImageModel(name: 'Test1', imagePath: 'ImagePath1'),
      ImageModel(name: 'Test2', imagePath: 'ImagePath2'),
      ImageModel(name: 'Test3', imagePath: 'ImagePath3'),
      ImageModel(name: 'Test4', imagePath: 'ImagePath4'),
    ];

    void setUpIsImageCachedTrue() {
      when(mockLocalData.isImagesCached()).thenAnswer((_) async => true);
    }

    void setUpIsImageCachedFalse() {
      when(mockLocalData.isImagesCached()).thenAnswer((_) async => false);
    }

    void setUpMockRemoteDataReturnImages() {
      when(mockRemoteData.fetchRemoteImages()).thenAnswer((_) async => images);
    }

    void setUpMockLocalDataReturnImages() {
      when(mockLocalData.fetchCacheImages()).thenAnswer((_) async => images);
    }

    void setUpMockLocalDataCacheImages() {
      when(mockLocalData.cacheImages(images)).thenAnswer((_) async {});
    }

    test(
      "return cached images if cached image exist",
      () async {
        setUpIsImageCachedTrue();
        setUpMockLocalDataReturnImages();
        final call = await sut.getImages();
        verify(mockLocalData.fetchCacheImages()).called(1);
        expect(call, images);
      },
    );
    test(
      "return remote images and cache it if cached images not exist",
      () async {
        setUpIsImageCachedFalse();
        setUpMockRemoteDataReturnImages();
        setUpMockLocalDataCacheImages();
        final call = await sut.getImages();
        verify(mockRemoteData.fetchRemoteImages()).called(1);
        verify(mockLocalData.cacheImages(images)).called(1);
        expect(call, images);
      },
    );
    test(
      "return list of images",
      () async {
        setUpMockRemoteDataReturnImages();
        final call = await sut.fetchAndCacheImages();
        verify(mockLocalData.cacheImages(images)).called(1);
        expect(call, images);
      },
    );
  });
  group('fetchAndCacheImages', () {
    const List<ImageModel> images = [
      ImageModel(name: 'Test1', imagePath: 'ImagePath1'),
      ImageModel(name: 'Test2', imagePath: 'ImagePath2'),
      ImageModel(name: 'Test3', imagePath: 'ImagePath3'),
      ImageModel(name: 'Test4', imagePath: 'ImagePath4'),
    ];

    void setUpMockRemoteDataReturnImages() {
      when(mockRemoteData.fetchRemoteImages()).thenAnswer((_) async => images);
    }

    void setUpMockLocalDataCacheImages() {
      when(mockLocalData.cacheImages(images)).thenAnswer((_) async {});
    }

    test(
      "gets images using remote data source",
      () async {
        setUpMockRemoteDataReturnImages();
        setUpMockLocalDataCacheImages();
        await sut.fetchAndCacheImages();
        verify(mockRemoteData.fetchRemoteImages()).called(1);
      },
    );
    test(
      "cache fetched images using local data source",
      () async {
        setUpMockRemoteDataReturnImages();
        setUpMockLocalDataCacheImages();
        await sut.fetchAndCacheImages();
        verify(mockLocalData.cacheImages(images)).called(1);
      },
    );
    test(
      "return list of images",
      () async {
        setUpMockRemoteDataReturnImages();
        setUpMockLocalDataCacheImages();
        final call = await sut.fetchAndCacheImages();
        verify(mockLocalData.cacheImages(images)).called(1);
        expect(call, images);
      },
    );
  });
}
