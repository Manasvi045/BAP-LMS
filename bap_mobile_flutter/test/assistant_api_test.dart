// Smoke tests for the assistant SSE client.
//
// We can't hit openrouter.ai in CI, so we verify the SSE parser against a
// canned event stream served by a mock http.Client. The mock server pumps
// several "data: {...}\n\n" chunks plus the [DONE] terminator and asserts
// that streamChat() yields the concatenated delta text.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:bap_mobile/services/assistant/api.dart';
import 'package:bap_mobile/services/assistant/config.dart';

void main() {
  test('streamChat parses SSE events and concatenates deltas', () async {
    const sseBody = 'data: {"choices":[{"delta":{"content":"Hello"}}]}\n\n'
        'data: {"choices":[{"delta":{"content":", world"}}]}\n\n'
        'data: {"choices":[{"delta":{"content":"!"}}]}\n\n'
        'data: [DONE]\n\n';
    final client = MockClient((http.Request req) async {
      expect(req.url.toString(), AssistantConfig.endpoint);
      expect(req.headers['Authorization'], 'Bearer test-key');
      expect(req.headers['Content-Type'], 'application/json');
      final body = jsonDecode(req.body) as Map<String, dynamic>;
      expect(body['stream'], true);
      expect(body['model'], AssistantConfig.model);
      return http.Response(
        sseBody,
        200,
        headers: {'Content-Type': 'text/event-stream'},
      );
    });

    final deltas = <String>[];
    await for (final d in streamChat(StreamOptions(
      apiKey: 'test-key',
      messages: const [WireChatMessage(role: WireRole.user, content: 'hi')],
      client: client,
    ))) {
      deltas.add(d);
    }
    expect(deltas.join(''), 'Hello, world!');
  });

  test('streamChat throws AssistantError(invalid_key) on 401', () async {
    final client = MockClient((http.Request req) async {
      return http.Response('unauthorized', 401);
    });

    await expectLater(
      streamChat(StreamOptions(
        apiKey: 'bad',
        messages: const [WireChatMessage(role: WireRole.user, content: 'hi')],
        client: client,
      )).drain<void>(),
      throwsA(isA<AssistantError>()
          .having((e) => e.code, 'code', errInvalidKey)
          .having((e) => e.status, 'status', 401)),
    );
  });

  test('streamChat throws AssistantError(no_key) on empty key', () async {
    final stream = streamChat(StreamOptions(
      apiKey: '',
      messages: const [WireChatMessage(role: WireRole.user, content: 'hi')],
    ));
    await expectLater(
      stream.drain<void>(),
      throwsA(isA<AssistantError>().having((e) => e.code, 'code', errNoKey)),
    );
  });

  test('testKey throws AssistantError(invalid_key) on 401', () async {
    final client = MockClient((http.Request req) async {
      return http.Response('unauthorized', 401);
    });
    expect(
      () => testKey('bad', client: client),
      throwsA(isA<AssistantError>().having((e) => e.code, 'code', errInvalidKey)),
    );
  });

  test('testKey returns void on 200', () async {
    final client = MockClient((http.Request req) async {
      return http.Response('{"choices":[{"message":{"content":"OK"}}]}', 200);
    });
    await testKey('good', client: client);
  });
}