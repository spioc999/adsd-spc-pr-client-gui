import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final Function? onFieldSubmitted;
  final Function(String)? onChanged;
  final TextCapitalization? textCapitalization;
  final bool enabled;
  final TextEditingController? controller;
  final Widget? suffix;
  final String? labelText;

  const AppTextFormField({
    Key? key,
    this.hintText,
    this.onFieldSubmitted,
    this.onChanged,
    this.textCapitalization,
    this.enabled = true,
    this.controller,
    this.suffix,
    this.labelText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      enabled: enabled,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      minLines: 1,
      controller: controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.go,
      onChanged: (value) => onChanged?.call(value),
      onFieldSubmitted: (value) => onFieldSubmitted?.call(),
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: const EdgeInsets.all(8),
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.01)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        suffix: suffix,
      ),
      textAlign: TextAlign.start,
    );
  }
}