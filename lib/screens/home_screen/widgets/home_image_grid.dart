part of '../home_screen.dart';

class _HomeImageGrid extends StatelessWidget {
  const _HomeImageGrid({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return _ImageCard(image: image);
      },
    );
  }
}
