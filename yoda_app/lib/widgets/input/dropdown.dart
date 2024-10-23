import 'package:flutter/material.dart';
import '../../feather.dart';
import './label.dart';

class DropdownSelector<T> extends StatelessWidget {
  const DropdownSelector({
    Key? key,
    this.value,
    this.items,
    this.isRequired = false,
    this.isDisabled = false,
    this.isBusy = false,
    this.isDense = true,
    this.prefixIcon,
    this.inputDecoration = const InputDecoration(),
    required this.onChange,
    required this.hint,
  }) : super(key: key);

  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final Function(T?) onChange;
  final String hint;
  final bool isDisabled;
  final bool isDense;
  final bool isBusy;
  final bool isRequired;
  final IconData? prefixIcon;
  final InputDecoration inputDecoration;

  Widget _buildDropdownIcon(BuildContext context) {
    if (isBusy) {
      return const SizedBox.square(
        dimension: 24,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (isDisabled) {
      return Icon(
        FeatherIcons.alert_circle,
        color: Theme.of(context).indicatorColor.withAlpha(50),
      );
    }

    return Icon(
      FeatherIcons.chevron_down,
      color: Theme.of(context).indicatorColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      isDense: true,
      decoration: inputDecoration
          .copyWith(
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5),
                    child: Icon(
                      size: 20,
                      prefixIcon,
                      color: Theme.of(context).disabledColor,
                    ),
                  )
                : null,
            label: InputLabel(
              hint: hint,
              isRequired: isRequired,
            ),
          )
          .applyDefaults(Theme.of(context).inputDecorationTheme),
      icon: _buildDropdownIcon(context),
      value: value,
      items: items,
      onChanged: (isDisabled || isBusy) ? null : onChange,
    );
  }
}


