import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_app/datas/image_local_data.dart';
import 'package:image_gallery_app/datas/image_remote_data.dart';
import 'package:image_gallery_app/models/failure_model.dart';
import 'package:image_gallery_app/models/image_model.dart';
import 'package:image_gallery_app/repositories/image_repository.dart';
import 'package:http/http.dart' as http;

part './widgets/home_body.dart';
part './widgets/home_image_grid.dart';
part './widgets/image_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHomeAppBar(),
      body: const _HomeBody(),
    );
  }

  AppBar _buildHomeAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: const Text('Gallery App'),
    );
  }
}
