import 'package:booksy_app/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:test/test.dart';

void main() {
  test('BookCoverItem NetworkImage si cover es url', () {
    var coverUrl = "https://cualquiercosa/aca";
    var imageWidget = Image(image: getImageWidget(coverUrl));
    expect((imageWidget is NetworkImage), true);
  });
}
