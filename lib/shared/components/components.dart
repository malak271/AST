import 'package:ast/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget DefaultButton({
  double width = double.infinity,
  // Color backgroundColor = HexColor('40A76A'),
  required Function function,
  required String text,
  IconData? icon,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: HexColor('40A76A'),
      ),
      width: width,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              icon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );

Widget DefaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String> validator,
  Function? onChange,
  bool isPassword = false,
  required String text,
  IconData? prefix,
}) =>
    TextFormField(
      controller: controller,
      // onChanged: (value) => onChange(value),
      keyboardType: type,
      validator: validator,
      obscureText: isPassword,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('F9F9F9'), width: 2.0),
        ),
        fillColor: HexColor('F5F5F5'),
        filled: true,
        // labelText: text,
        hintText: text,
        labelStyle: TextStyle(
          color: HexColor('AAADB5'),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('40A76A'), width: 2.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
        prefixIcon: Icon(prefix),
      ),
      // style: TextStyle(color:HexColor('40A76A')),
    );

void navigateTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false);
}

SizedBox mySizedBox = SizedBox(
  height: 10,
);

SizedBox mySizedBox20 = SizedBox(
  height: 20,
);

Widget myMaterialButton(text,IconData icon, {required Function function}) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: MyColor.getColor(),
      ),
      child: MaterialButton(
        onPressed: function(),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
