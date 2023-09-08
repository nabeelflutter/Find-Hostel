import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
        this.textInputType,
        this.preIcon,
        required this.hint,
        required this.controller,
        this.character = ' ',
        this.obsText = false,
        required this.textCapitalization,
        this.validator,
        this.sufixIcon})
      : super(key: key);
  TextEditingController controller = TextEditingController();
  String hint;
  Widget? preIcon;
  Widget? sufixIcon;
   TextCapitalization textCapitalization = TextCapitalization.none;
  bool obsText;
  TextInputType? textInputType;
  String character;
  var validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textCapitalization:textCapitalization ,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        obscureText: obsText,
        validator: validator,
        obscuringCharacter: character,
        keyboardType: textInputType,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabled: true,
          label: Text(hint),
          prefixIcon: preIcon,
          suffixIcon: sufixIcon,
        ),
      ),
    );
  }
}
