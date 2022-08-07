import 'package:flutter/material.dart';

class InputFieldDesign {
  static Widget inputField(String label, String hint, TextEditingController? controller,
      {required Widget? widget,
      required FormFieldValidator validator,
      Widget? suffixIcon}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              alignment: Alignment.topLeft,
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 16.0, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: suffixIcon == null ? false : true,
                    autofocus: false,
                    cursorColor: Colors.grey,
                    controller: controller,
                    validator: validator,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: hint,
                      suffixIcon: suffixIcon,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      ),
              ],
            ),
            const SizedBox(
              height: 4.0,
            ),
          ],
        ),
      ),
    );
  }
}
