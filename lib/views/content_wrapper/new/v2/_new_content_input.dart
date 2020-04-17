import 'package:flutter/material.dart';

class NewContentInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Function(String) validator;
  final InputDecoration decoration;
  final TextStyle style;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final bool multiline;

  NewContentInput({
    @required this.label,
    @required this.hint,
    @required this.controller,
    this.onChanged,
    this.validator,
    this.decoration,
    this.style,
    this.keyboardType,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Color(0xff1a1c28),
                offset: Offset(0.0, 0.0),
              ),
              BoxShadow(
                color: Color(0xff2d3548),
                offset: Offset(0.0, 0.0),
                spreadRadius: -12.0,
                blurRadius: 12.0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: decoration != null
                ? decoration.copyWith(
                    hintText: hint,
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  )
                : InputDecoration(
                    hintText: hint,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  ),
            textCapitalization: TextCapitalization.sentences,
            style: style != null
                ? style.copyWith(fontSize: 14)
                : TextStyle(
                    fontSize: 14,
                  ),
            minLines: multiline ? 7 : null,
            maxLines: multiline ? 7 : null,
            keyboardType: multiline ? TextInputType.multiline : keyboardType,
            validator: validator,
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
