import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_app/constants.dart';
import 'package:image_gallery_app/datas/image_remote_data.dart';
import 'package:image_gallery_app/models/failure_model.dart';
import 'package:image_gallery_app/models/image_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'image_remote_data_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late http.Client mockClient;
  late ImageRemoteData sut;

  setUp(() {
    mockClient = MockClient();
    sut = ImageRemoteData(client: mockClient);
  });
  group('fetchRemoteImages', () {
    const String body = '''[
      {"title": "title1", "url1": "url1"},
      {"title": "title2", "url1": "url2"},
      {"title": "title3", "url1": "url3"},
      {"title": "title4", "url1": "url4"}
    ]''';

    void setUpMockClientSuccess() {
      when(mockClient.get(Uri.parse(url))).thenAnswer((_) async => http.Response(body, 200));
    }

    void setUpMockClientError() {
      when(mockClient.get(Uri.parse(url))).thenAnswer((_) async => http.Response(jsonEncode('Not Found'), 404));
    }

    test('returns list of images if http call completes successfully', () async {
      setUpMockClientSuccess();
      final call = await sut.fetchRemoteImages();
      expect(call, isA<List<ImageModel>>());
    });

    test('throws a failure if http call completes with an error', () async {
      setUpMockClientError();
      final call = sut.fetchRemoteImages();
      expect(call, throwsA(const TypeMatcher<FailureModel>()));
    });
  });
}
