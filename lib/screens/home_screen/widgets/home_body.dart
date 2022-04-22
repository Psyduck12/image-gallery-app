part of '../home_screen.dart';

class _HomeBody extends StatefulWidget {
  const _HomeBody({Key? key}) : super(key: key);

  @override
  State<_HomeBody> createState() => __HomeBodyState();
}

class __HomeBodyState extends State<_HomeBody> {
  late ImageRepository _imageRepository;
  late Future<List<ImageModel>> _futureItems;

  @override
  void initState() {
    super.initState();
    _imageRepository = ImageRepository(
      imageLocalData: ImageLocalData(hive: Hive),
      imageRemoteData: ImageRemoteData(client: http.Client()),
    );
    _futureItems = _imageRepository.getImages();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureItems = _imageRepository.fetchAndCacheImages();
        });
      },
      child: FutureBuilder<List<ImageModel>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final images = snapshot.data!;
              return _HomeImageGrid(images: images);
            } else if (snapshot.hasError) {
              final failure = snapshot.error as FailureModel;
              return Center(
                child: Text(
                  failure.message,
                  textAlign: TextAlign.center,
                ),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
