import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_app/models/image_model.dart';
import 'package:image_gallery_app/screens/home_screen/home_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  await setup();
  runApp(const ImageGalleryApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ImageModelAdapter());
}

class ImageGalleryApp extends StatefulWidget {
  const ImageGalleryApp({Key? key}) : super(key: key);

  @override
  State<ImageGalleryApp> createState() => _ImageGalleryAppState();
}

class _ImageGalleryAppState extends State<ImageGalleryApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
