import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';

/// Picks a profile photo, crops it to a square and re-encodes it as PNG.
/// Re-encoding drops all EXIF metadata (GPS location, camera, date), so only
/// the pixels are kept. The result is stored encrypted inside the vault.
class ProfilePhoto {
  static const size = 384;

  static Future<Uint8List?> pick(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      preferredCameraDevice: CameraDevice.front,
      requestFullMetadata: false,
    );
    if (file == null) return null;
    return squarePng(await file.readAsBytes());
  }

  static Future<Uint8List> squarePng(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final img = frame.image;
    final side = img.width < img.height ? img.width : img.height;
    final src = Rect.fromLTWH((img.width - side) / 2, (img.height - side) / 2, side.toDouble(), side.toDouble());
    const dst = Rect.fromLTWH(0, 0, size + 0.0, size + 0.0);

    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawImageRect(img, src, dst, Paint()..filterQuality = FilterQuality.high);
    final out = await recorder.endRecording().toImage(size, size);
    final data = await out.toByteData(format: ui.ImageByteFormat.png);
    img.dispose();
    out.dispose();
    return data!.buffer.asUint8List();
  }
}
