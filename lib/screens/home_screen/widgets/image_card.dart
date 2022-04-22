part of '../home_screen.dart';

class _ImageCard extends StatelessWidget {
  final ImageModel image;
  const _ImageCard({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey,
        ),
        child: CachedNetworkImage(
          imageUrl: image.imagePath,
          imageBuilder: (context, _) => _ImageLoaded(image: image),
          placeholder: (context, _) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

class _ImageLoaded extends StatefulWidget {
  final ImageModel image;

  const _ImageLoaded({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<_ImageLoaded> createState() => _ImageLoadedState();
}

class _ImageLoadedState extends State<_ImageLoaded> {
  late OverlayEntry _previewDialog;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _previewDialog = _buildPreviewDialog();
        Overlay.of(context)!.insert(_previewDialog);
      },
      onLongPressEnd: (_) => _previewDialog.remove(),
      child: Image(
        fit: BoxFit.cover,
        image: CachedNetworkImageProvider(widget.image.imagePath),
      ),
    );
  }

  OverlayEntry _buildPreviewDialog() {
    return OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.grey.withOpacity(0.8),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(image: CachedNetworkImageProvider(widget.image.imagePath)),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
                      child: Text(widget.image.name),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
