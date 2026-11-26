import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/store.dart';
import '../services/photo.dart';
import '../theme.dart';
import '../widgets.dart';

/// Round-cornered avatar: the student's photo, or their initial.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.store, this.size = 48, this.tilt = true});
  final AppStore store;
  final double size;
  final bool tilt;

  @override
  Widget build(BuildContext context) {
    final photo = store.photo;
    final name = store.profile.firstName;
    final box = ClipRRect(
      borderRadius: BorderRadius.circular(size / 3),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        color: AppColors.sun,
        child: photo != null
            ? Image.memory(photo, width: size, height: size, fit: BoxFit.cover, gaplessPlayback: true)
            : Text(name.isEmpty ? '👋' : name.characters.first.toUpperCase(), style: bigNumber(size: size * .42)),
      ),
    );
    return tilt ? Transform.rotate(angle: -0.1, child: box) : box;
  }
}

Future<void> showPhotoOptions(BuildContext context, AppStore store) {
  Future<void> pick(BuildContext sheet, ImageSource source) async {
    Navigator.pop(sheet);
    try {
      final png = await ProfilePhoto.pick(source);
      if (png != null) store.setPhoto(png);
    } on Object {
      if (context.mounted) {
        toast(context, source == ImageSource.camera ? 'Couldn’t open the camera.' : 'Couldn’t open your photos.');
      }
    }
  }

  return showSheet(context, (c) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Profile photo', style: Theme.of(c).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('Stored encrypted on this phone only. Location and other hidden photo data are removed.',
                style: smallText, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded, color: AppColors.blue),
            title: const Text('Choose from photos'),
            onTap: () => pick(c, ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_rounded, color: AppColors.coral),
            title: const Text('Take a photo'),
            onTap: () => pick(c, ImageSource.camera),
          ),
          if (store.photo != null)
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: AppColors.mute),
              title: const Text('Remove photo'),
              onTap: () {
                Navigator.pop(c);
                store.removePhoto();
              },
            ),
        ]),
      ));
}
