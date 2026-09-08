import 'package:congress_app/src/data/event_eposter_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('loads the event e-poster library from the new Laravel API', () async {
    final httpClient = MockClient((request) async {
      expect(
        request.url.toString(),
        'http://localhost:8000/api/public/mobile/events/agpc/eposters',
      );
      expect(request.headers['Accept'], 'application/json');

      return http.Response(
        '{"data":[{"id":7,"poster_number":"P-07","title":"Poster scientifique","authors":"Dr Exemple","category":"Hépatologie","pdf_url":"https://events.test/link/poster.pdf","cover_url":null,"file_size":2048,"comments_count":3}],"meta":{"categories":[{"key":"Hépatologie","label":"Hépatologie"}],"total":1,"all_total":1}}',
        200,
      );
    });
    final api = EventEposterClient(
      client: httpClient,
      baseUrl: 'http://localhost:8000/api/public/mobile',
    );

    final library = await api.fetchLibrary('agpc');

    expect(library.items, hasLength(1));
    expect(library.items.first.displayNumber, 'P-07');
    expect(library.items.first.authors, 'Dr Exemple');
    expect(library.items.first.pdfUrl, 'https://events.test/link/poster.pdf');
    expect(library.items.first.commentsCount, 3);
    expect(library.categories.single.label, 'Hépatologie');
  });

  test('loads comments belonging to one e-poster', () async {
    final api = EventEposterClient(
      client: MockClient((request) async {
        expect(
          request.url.toString(),
          'http://localhost:8000/api/public/mobile/events/agpc/eposters/7/comments',
        );
        return http.Response(
          '{"data":[{"id":2,"author_name":"Sara","content":"Très intéressant","created_at":"2026-09-08T14:00:00Z"}]}',
          200,
        );
      }),
      baseUrl: 'http://localhost:8000/api/public/mobile',
    );

    final comments = await api.fetchComments('agpc', 7);

    expect(comments.single.authorName, 'Sara');
    expect(comments.single.content, 'Très intéressant');
  });

  test('posts a comment on the selected e-poster', () async {
    final api = EventEposterClient(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.body, contains('Omar'));
        return http.Response(
          '{"data":{"id":3,"author_name":"Omar","content":"Merci","created_at":"2026-09-08T14:02:00Z"}}',
          201,
        );
      }),
      baseUrl: 'http://localhost:8000/api/public/mobile',
    );

    final comment = await api.postComment(
      eventCode: 'agpc',
      posterId: 7,
      authorName: 'Omar',
      content: 'Merci',
    );

    expect(comment.id, 3);
  });
}
