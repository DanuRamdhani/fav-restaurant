import 'package:favorite_restaurant/models/restaurant_list.dart';
import 'package:favorite_restaurant/services/rest_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'restaurant_list_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetch Restaurant', () {
    const body =
        '''{
        "error": false,
        "message": "success",
        "count": 20,
        "restaurants": [
          {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description":
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
            "pictureId": "14",
            "city": "Medan",
            "rating": 4.2
          }
        ]
      }''';

    test(
      'returns an Album if the http call completes successfully',
      () async {
        final client = MockClient();

        // arrange
        when(
          client.get(
            Uri.parse('https://restaurant-api.dicoding.dev/list'),
          ),
        ).thenAnswer(
          (_) async => http.Response(body, 200),
        );

        expect(await RestLIstService.fetchRest(client), isA<Restaurant>());
      },
    );

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(
        client.get(
          Uri.parse('https://restaurant-api.dicoding.dev/list'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(RestLIstService.fetchRest(client), throwsException);
    });
  });
}
