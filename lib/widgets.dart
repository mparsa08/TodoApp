import 'package:flutter/material.dart';

class MyCheckBox extends StatelessWidget {
  const MyCheckBox({super.key, required this.ischecked, required this.onTap});
  final bool ischecked;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ischecked ? themeData.colorScheme.primary : null,
          border: ischecked
              ? null
              : Border.all(
                  color: const Color(0xffAFBED0),
                ),
        ),
        child: ischecked
            ? Icon(
                Icons.check,
                color: themeData.colorScheme.surface,
                size: themeData.textTheme.titleSmall!.fontSize,
              )
            : null,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController titleController,
    required String lable,
  })  : _titleController = titleController,
        _lable = lable;

  final TextEditingController _titleController;
  final String _lable;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        label: Text(_lable),
      ),
    );
  }
}
