import 'package:congress_app/src/data/live_comment_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('loads live comments', () async {
    final client = LiveCommentClient(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        return http.Response(
          '[{"id":3,"author_name":"Sara","content":"Merci","created_at":"2026-09-08T10:30:00Z"}]',
          200,
        );
      }),
    );

    final comments = await client.fetch('https://events.test/comments');

    expect(comments, hasLength(1));
    expect(comments.single.authorName, 'Sara');
    expect(comments.single.content, 'Merci');
  });

  test('posts the participant name and comment', () async {
    final client = LiveCommentClient(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.body, contains('Omar'));
        expect(request.body, contains('Excellent direct'));
        return http.Response(
          '{"id":4,"author_name":"Omar","content":"Excellent direct","created_at":"2026-09-08T10:31:00Z"}',
          201,
        );
      }),
    );

    final comment = await client.post(
      url: 'https://events.test/comments',
      authorName: 'Omar',
      content: 'Excellent direct',
    );

    expect(comment.id, 4);
    expect(comment.authorName, 'Omar');
  });
}
