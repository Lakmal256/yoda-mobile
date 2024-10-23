import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class UploadContainer extends StatelessWidget {
  const UploadContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

enum IconType { image, widget }

class FileIcon extends StatelessWidget {
  const FileIcon({
    Key? key,
    required this.name,
    this.progress,
    this.loading = false,
    this.error = false,
    this.onRemove,
    this.fileSize,
    this.iconType = IconType.widget,
  }) : super(key: key);

  final Function()? onRemove;
  final double? progress;
  final String? fileSize;
  final String name;
  final bool loading;
  final bool error;
  final IconType iconType;

  @override
  Widget build(BuildContext context) {
    Widget icon;

    switch (iconType) {
      case IconType.image:
        icon = DocumentImageIcon(fileName: name);
        break;
      case IconType.widget:
        icon = DocumentWidgetIcon(fileName: name);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            heightFactor: .65,
            widthFactor: .65,
            child: icon,
          ),
          if (error)
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 40,
            ),
          if (progress != null)
            Center(
              child: CircularProgressIndicator(value: progress),
            ),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (onRemove != null)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onRemove!,
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          if (fileSize != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(fileSize!),
              ),
            ),
        ],
      ),
    );
  }
}

abstract class FileWithNameExtension {
  String get extension;
}

class DocumentImageIcon extends StatelessWidget with FileWithNameExtension {
  const DocumentImageIcon({Key? key, required this.fileName}) : super(key: key);

  final String fileName;

  @override
  Widget build(BuildContext context) {
    switch (extension) {
      case (".doc"):
        {
          return Image.asset("assets/images/icons/doc.png");
        }
      case (".docx"):
        {
          return Image.asset("assets/images/icons/docx.png");
        }
      case (".pdf"):
        {
          return Image.asset("assets/images/icons/pdf.png");
        }
      case (".xlsx"):
        {
          return Image.asset("assets/images/icons/xlsx.png");
        }
      case (".xls"):
        {
          return Image.asset("assets/images/icons/xls.png");
        }
      case (".jpg"):
        {
          return Image.asset("assets/images/icons/jpg.png");
        }
      case (".jpeg"):
        {
          return Image.asset("assets/images/icons/jpeg.png");
        }
      case (".png"):
        {
          return Image.asset("assets/images/icons/png.png");
        }
    }
    return const Icon(
      Icons.description_outlined,
      color: Colors.black12,
    );
  }

  @override
  String get extension => path.extension(fileName);
}

class DocumentWidgetIcon extends StatelessWidget with FileWithNameExtension {
  const DocumentWidgetIcon({Key? key, required this.fileName}) : super(key: key);

  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.centerLeft,
      children: [
        const FittedBox(
          fit: BoxFit.contain,
          child: Icon(
            Icons.description_outlined,
            color: Colors.black12,
          ),
        ),
        extension != ""
            ? Align(
                alignment: Alignment.bottomLeft,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      // border: Border.all(width: 2, color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).colorScheme.primary
                      // color: Colors.white,
                    ),
                    child: Text(
                      extension.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  @override
  String get extension => path.extension(fileName);
}
