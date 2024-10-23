import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../feather.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border(
            top: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomNavigationItem(
                  onTap: () => GoRouter.of(context).go("/home"),
                  isActive: GoRouter.of(context).location == "/home",
                  icon: const Icon(FeatherIcons.home),
                ),
                BottomNavigationItem(
                  disabled: true,
                  onTap: () => GoRouter.of(context).go("/notifications"),
                  isActive: GoRouter.of(context).location == "/notifications",
                  icon: const Icon(FeatherIcons.bell),
                ),
                BottomNavigationItem(
                  disabled: true,
                  onTap: () => GoRouter.of(context).go("/menu"),
                  isActive: GoRouter.of(context).location == "/menu",
                  icon: const Icon(FeatherIcons.menu),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  const BottomNavigationItem({
    Key? key,
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.disabled = false,
  }) : super(key: key);

  final Widget icon;
  final Function() onTap;
  final bool isActive;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    Color color = isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary;
    return IconButton(
      icon: icon,
      onPressed: disabled ? null : onTap,
      color: color,
      padding: const EdgeInsets.all(25),
      disabledColor: Theme.of(context).colorScheme.primary.withAlpha(50),
    );
  }
}
