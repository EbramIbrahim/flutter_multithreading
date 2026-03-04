import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class ShortLivedIsolates extends StatelessWidget {
  const ShortLivedIsolates({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),

            ElevatedButton(onPressed: () async {
              final Uint8List imageBytes = await _loadImage();
              final Uint8List processedImageBytes = await _isolateClosure(imageBytes);

              print(processedImageBytes);
              // now the image bytes used inside the isolate so the isolate capture the
              // context of all closure from on pressed method
              // so it try to serialize the image bytes in main isolate and it can'
              // so the exception happened
              showDialog(context: context, builder: (context) {
                return Image.memory(processedImageBytes);
              });
            }, child: const Text('Process Image'))
          ]
        ),
      ),
    );
  }
  static Uint8List _processImage(Uint8List bytes) {
    final image = img.decodeImage(bytes)!;
    img.Image processedImage = img.invert(image);

    processedImage = img.grayscale(processedImage);
    processedImage = img.gaussianBlur(processedImage, radius: 50);
    processedImage = img.adjustColor(processedImage, brightness: 0.6);

    return Uint8List.fromList(img.encodePng(processedImage));
  }

  Future<Uint8List> _loadImage() async {
    final ByteData imageData = await rootBundle.load("assets/tiger.png");
    return imageData.buffer.asUint8List();
  }
  // make it static means it will be global so it's context not tied to this widget
  // but it can be accessed throw this widget.
  static Future<Uint8List> _isolateClosure(Uint8List imageBytes) async{
    // I have a limitation in isolate, I can't use any related UI into it.
    final processedImageBytes = await Isolate.run(() async {
      return _processImage(imageBytes);
    });
    return processedImageBytes;
  }
}



