import 'package:flutter/material.dart';
import '../util/file_pick.dart';

Future<Source?> showSourceSelector(BuildContext context) => showDialog(
    context: context,
    barrierColor: Colors.black12,
    builder: (context) => const SourceSelector());

class SourceSelector extends StatelessWidget {
  const SourceSelector({Key? key}) : super(key: key);

  Widget buildItem(BuildContext context, Source source) {
    switch (source) {
      case Source.camera:
        return const SourceSelectorItem(
          icon: Icon(Icons.camera_alt_outlined),
          text: "Camera",
        );
      case Source.gallery:
        return const SourceSelectorItem(
          icon: Icon(Icons.photo_size_select_actual_outlined),
          text: "Photo & Video Library",
        );
      case Source.files:
        return const SourceSelectorItem(
          icon: Icon(Icons.folder_outlined),
          text: "Documents",
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.5),
            child: ListView(
              clipBehavior: Clip.antiAlias,
              shrinkWrap: true,
              children: Source.values
                  .map(
                    (source) => RawMaterialButton(
                      onPressed: () => Navigator.of(context).pop(source),
                      child: buildItem(context, source),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextButton(
            onPressed: Navigator.of(context).pop,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              minimumSize: MaterialStateProperty.all(
                const Size.fromHeight(50),
              ),
              foregroundColor: MaterialStateProperty.all(
                Colors.white,
              ),
            ),
            child: const Text("CANCEL"),
          ),
        )
      ],
    );
  }
}

class SourceSelectorItem extends StatelessWidget {
  const SourceSelectorItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 15),
          Text(text, style: Theme.of(context).textTheme.button)
        ],
      ),
    );
  }
}
