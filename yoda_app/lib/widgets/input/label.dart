import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({
    Key? key,
    this.isRequired = false,
    required this.hint,
  }) : super(key: key);

  final String hint;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).hintColor),
        children: [
          TextSpan(text: hint),
          if (isRequired)
            const TextSpan(
              text: "*",
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}