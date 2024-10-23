import 'package:flutter/material.dart';
import 'package:yoda_app/feather.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.radius,
    required this.image,
  }) : super(key: key);

  final Future<ImageProvider?>? image;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: image,
      builder: (context, snapshot) {
        return CircleAvatar(
          foregroundImage: snapshot.data,
          radius: radius,
          child: Icon(
            FeatherIcons.user,
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      },
    );
  }
}
