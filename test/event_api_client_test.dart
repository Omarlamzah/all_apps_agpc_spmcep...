import 'package:congress_app/src/config/app_brand.dart';
import 'package:congress_app/src/data/event_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('loads the requested event configuration from Laravel', () async {
    final httpClient = MockClient((request) async {
      expect(
        request.url.toString(),
        'http://localhost:8000/api/v1/events/somcep/config',
      );
      expect(request.headers['Accept'], 'application/json');

      return http.Response(
        '{"data":{"code":"somcep","name":"SOMCEP","full_name":"Remote SOMCEP","branding":{"primary_color":"#2C3373","secondary_color":"#B4E1FA"},"location":"Marrakech","starts_at":"2026-10-15","ends_at":"2026-10-17","features":["program","floor_plan","live_stream"],"president":{"name":"Dr Test","message":"Bienvenue","photo_url":"https://events.test/president.jpg"},"live_stream":{"title":"Direct officiel","description":"Session plénière","source_url":"https://youtube.com/live/abcdefghijk","youtube_video_id":"abcdefghijk","is_live":true,"is_published":true,"comments_enabled":true,"comments_url":"https://events.test/comments"}}}',
        200,
      );
    });
    final api = EventApiClient(
      client: httpClient,
      baseUrl: 'http://localhost:8000/api/v1',
    );

    final brand = await api.fetchBrand('somcep');

    expect(brand.fullName, 'Remote SOMCEP');
    expect(brand.location, 'Marrakech');
    expect(brand.year, '2026');
    expect(brand.supports(AppFeature.floorPlan), isTrue);
    expect(brand.supports(AppFeature.speakers), isFalse);
    expect(brand.presidentName, 'Dr Test');
    expect(brand.presidentMessage, 'Bienvenue');
    expect(brand.presidentPhotoUrl, 'https://events.test/president.jpg');
    expect(brand.hasPresidentContent, isTrue);
    expect(brand.liveStream?.title, 'Direct officiel');
    expect(brand.liveStream?.youtubeVideoId, 'abcdefghijk');
    expect(brand.liveStream?.isLive, isTrue);
    expect(brand.liveStream?.isAvailable, isTrue);
  });
}
