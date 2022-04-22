import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_app/constants.dart';
import 'package:image_gallery_app/datas/image_local_data.dart';
import 'package:image_gallery_app/models/failure_model.dart';
import 'package:image_gallery_app/models/image_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'image_local_data_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  late HiveInterface mockHive;
  late Box mockBox;
  late ImageLocalData sut;

  setUp(() {
    mockHive = MockHiveInterface();
    mockBox = MockBox();
    sut = ImageLocalData(hive: mockHive);
  });

  group('isImagesCached', () {
    void setUpMockBoxOpened() {
      when(mockHive.openBox(imagesBox)).thenAnswer((_) async => mockBox);
    }

    void setUpMockBoxNotEmpty() {
      when(mockBox.length).thenAnswer((_) => 1);
    }

    void setUpMockBoxEmpty() {
      when(mockBox.length).thenAnswer((_) => 0);
    }

    test('return true if box is not empty', () async {
      setUpMockBoxOpened();
      setUpMockBoxNotEmpty();
      final call = await sut.isImagesCached();
      expect(call, true);
    });

    test('return false if box is empty', () async {
      setUpMockBoxOpened();
      setUpMockBoxEmpty();
      final call = await sut.isImagesCached();
      expect(call, false);
    });
  });
  group('fetchCacheImages', () {
    const List<ImageModel> images = [
      ImageModel(name: 'Test1', imagePath: 'ImagePath1'),
      ImageModel(name: 'Test2', imagePath: 'ImagePath2'),
      ImageModel(name: 'Test3', imagePath: 'ImagePath3'),
      ImageModel(name: 'Test4', imagePath: 'ImagePath4'),
    ];

    void setUpMockBoxOpened() {
      when(mockHive.openBox(imagesBox)).thenAnswer((_) async => mockBox);
    }

    void setUpMockBoxGetKeyExist() {
      when(mockBox.get(imagesKey)).thenAnswer((_) => images);
    }

    void setUpMockBoxGetKeyNotExist() {
      when(mockBox.get(imagesKey)).thenAnswer((_) => null);
    }

    test('return list of images if key exist', () async {
      setUpMockBoxOpened();
      setUpMockBoxGetKeyExist();
      final call = await sut.fetchCacheImages();
      expect(call, images);
    });

    test('return failure if key not exist', () async {
      setUpMockBoxOpened();
      setUpMockBoxGetKeyNotExist();
      final call = sut.fetchCacheImages();
      expect(call, throwsA(const TypeMatcher<FailureModel>()));
    });
  });
  group('cacheImages', () {
    const List<ImageModel> images = [
      ImageModel(name: 'Test1', imagePath: 'ImagePath1'),
      ImageModel(name: 'Test2', imagePath: 'ImagePath2'),
      ImageModel(name: 'Test3', imagePath: 'ImagePath3'),
      ImageModel(name: 'Test4', imagePath: 'ImagePath4'),
    ];

    void setUpMockBoxOpened() {
      when(mockHive.openBox(imagesBox)).thenAnswer((_) async => mockBox);
    }

    void setUpMockCacheImages() {
      when(mockBox.put(imagesKey, images)).thenAnswer((_) async {});
    }

    test('image cache success', () async {
      setUpMockBoxOpened();
      setUpMockCacheImages();
      final call = await sut.cacheImages(images);
      expect(() => call, returnsNormally);
    });
  });
}
