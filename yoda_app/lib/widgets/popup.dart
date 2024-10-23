import 'package:flutter/material.dart';

class PopupController extends ValueNotifier<List<Widget>> {
  PopupController() : super([]);

  addItem(Widget widget) {
    value.add(widget);
    notifyListeners();
  }

  addItemFor(Widget widget, Duration duration) async {
    addItem(widget);
    await Future.delayed(duration, () => removeItem(widget));
  }

  removeItem(Widget widget) {
    value.remove(widget);
    notifyListeners();
  }

  clear() {
    value.clear();
    notifyListeners();
  }
}

class Popups extends StatelessWidget {
  const Popups({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PopupController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, _) {
          return _PopupContainer(children: value);
        },
      ),
    );
  }
}

class _PopupContainer extends StatelessWidget {
  const _PopupContainer({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isNotEmpty) {
      return SingleChildScrollView(
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Column(children: children),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}

class AlertCard extends StatelessWidget {
  const AlertCard({
    Key? key,
    required this.message,
    required this.onDismiss,
  }) : super(key: key);

  final String message;
  final Function(AlertCard) onDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: GlobalKey(),
      onDismissed: (_) => onDismiss(this),
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: .5, color: Colors.black45),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(child: Text(message)),
            TextButton(
              onPressed: () => onDismiss(this),
              child: const Text("Dismiss"),
            ),
          ],
        ),
      ),
    );
  }
}
