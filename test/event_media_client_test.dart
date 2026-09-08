import 'package:congress_app/src/data/event_media_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('loads the AGPC media library from the current event API', () async {
    final httpClient = MockClient((request) async {
      expect(
        request.url.toString(),
        'https://events.test/api/public/mobile/events/agpc/media',
      );
      expect(request.headers['Accept'], 'application/json');
      return http.Response(
        '{"data":[{"id":7,"category":"agpc_conferences","title":"Conférence AGPC","media_type":"video","youtube_video_id":"abcdefghijk","youtube_thumbnail_url":"https://i.ytimg.com/vi/abcdefghijk/hqdefault.jpg","is_published":true,"sort_order":0}],"meta":{"categories":[{"key":"agpc_conferences","label":"Conférences AGPC"}],"total":1}}',
        200,
      );
    });
    final client = EventMediaClient(
      client: httpClient,
      baseUrl: 'https://events.test/api/public/mobile',
    );

    final library = await client.fetchLibrary('agpc');

    expect(library.categories.single.label, 'Conférences AGPC');
    expect(library.items.single.title, 'Conférence AGPC');
    expect(
      library.items.single.targetUrl,
      'https://www.youtube.com/watch?v=abcdefghijk',
    );
  });
}
