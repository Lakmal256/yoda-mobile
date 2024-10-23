import 'package:flutter/material.dart';

class PageHeader extends AppBar {
  PageHeader({
    super.key,
    Widget? leading = const BackButton(),
    required String title
  }) : super(
          elevation: 0,
          leading: leading,
          title: Text(title),
          flexibleSpace: Builder(
            builder: (context) => SafeArea(
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        );
}
