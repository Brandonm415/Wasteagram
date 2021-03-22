import 'package:test/test.dart' as test;
import 'package:wasteagram/models/posts.dart';

void main() {
  test.test('The Posts DTO works properly', () {
    final date = '2021-01-01';
    final url = 'FAKE';
    final items = 1;
    final location = '1.0, 2.0';

    final posts = Posts(dateTime: date, url: url, items: items, location: location);

    test.expect(posts.dateTime, date);
    test.expect(posts.items, items);
    test.expect(posts.url, url);
    test.expect(posts.location, location);
  });


}
