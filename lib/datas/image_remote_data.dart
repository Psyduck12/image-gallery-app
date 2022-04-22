import 'dart:convert';

import 'package:image_gallery_app/models/image_model.dart';
import 'package:image_gallery_app/constants.dart';
import 'package:image_gallery_app/models/failure_model.dart';
import 'package:http/http.dart' as http;

abstract class IImageRemoteData {
  Future<List<ImageModel>> fetchRemoteImages();
}

class ImageRemoteData implements IImageRemoteData {
  final http.Client client;

  const ImageRemoteData({
    required this.client,
  });

  @override
  Future<List<ImageModel>> fetchRemoteImages() async {
    try {
      final uri = Uri.parse(url);
      final response = await client.get(uri);
      final datas = json.decode(response.body);
      if (response.statusCode == 200) {
        return (datas as List).map((data) => ImageModel.fromJson(data)).toList();
      } else {
        throw FailureModel('Fetch Images Failed');
      }
    } catch (_) {
      throw FailureModel('Fetch Images Failed');
    }
  }
}
