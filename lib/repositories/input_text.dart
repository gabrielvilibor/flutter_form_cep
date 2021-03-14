import 'package:flutter/material.dart';

class InputText extends StatelessWidget {

  String label;
  TextInputType keyboardType;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  bool password;
  Color color;

  InputText(this.label, this.controller, {this.validator, this. keyboardType, this.password = false, this.color});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: password,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: this.color ?? Colors.grey)
          ),
          labelText: label,
          hintText: label,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: this.color ?? Colors.blueGrey),
          hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: this.color ??  Theme.of(context).primaryColor)),
      style: TextStyle(fontSize: 18, color: this.color ?? Theme.of(context).primaryColor),
      textAlign: TextAlign.left,
    );
  }
}