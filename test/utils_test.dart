import 'package:booksy_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  group('Utils hexToColor', () {
    test(' devuelve el color correcto', () {
      var stringColor = "#2196F3"; // azul
      var expectedColor = const Color(0x662196F3);
      var colorActual = hexToColor(stringColor, Colors.black);

      expect(colorActual, expectedColor);
    });

    test('color por defect si el string es malformado', () {
      var hexMalformed = "cualquiercosa";
      var defaultColor = Colors.black;
      var colorActual = hexToColor(hexMalformed, defaultColor);

      expect(colorActual, defaultColor);
    });

    test('color con alpha devuelve alpha 66', () {
      var colorWithAlpha = "#552196F3";
      var expectedColor = const Color(0x662196F3);
      var colorActual = hexToColor(colorWithAlpha, Colors.black);

      expect(colorActual, expectedColor);
    });

    test('malformed string devuelve default color', () {
      var malformedString = "#1122";
      var defaultColor = Colors.black;
      var colorActual = hexToColor(malformedString, defaultColor);

      expect(colorActual, defaultColor);
    });
  });
}
