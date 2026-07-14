import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/client_search.dart';
import 'package:mobile/features/search/search_screen.dart';

void main() {
  group('ClientSearchResult json', () {
    test('parses the /search/clients result shape', () {
      final result = ClientSearchResult.fromJson(const {
        'client': {
          'id': 'c1',
          'phoneNumber': '201062866442',
          'profileName': 'InShape Clinic',
        },
        'score': 150,
        'matches': [
          {'source': 'name', 'snippet': 'InShape Clinic'},
          {
            'source': 'customField',
            'snippet': 'platinum elite',
            'fieldLabel': 'Membership tier',
          },
        ],
      });

      expect(result.client.id, 'c1');
      expect(result.score, 150);
      expect(result.matches, hasLength(2));
      expect(result.matches[1].fieldLabel, 'Membership tier');
      // fieldLabel is optional — absent on non-customField matches.
      expect(result.matches[0].fieldLabel, isNull);
    });
  });

  group('highlightMatches', () {
    String? textOf(InlineSpan s) => (s as TextSpan).text;
    bool isBold(InlineSpan s) =>
        (s as TextSpan).style?.fontWeight == FontWeight.w700;

    test('bolds each query token, case-insensitively', () {
      final span = highlightMatches('Dear Mr. Kallas', 'kallas', null);
      final parts = span.children!;
      expect(parts.map(textOf).toList(), ['Dear Mr. ', 'Kallas']);
      expect(isBold(parts[0]), isFalse);
      expect(isBold(parts[1]), isTrue);
    });

    test('matches multiple tokens independently', () {
      final span = highlightMatches(
        'infrastructure upgrade complete',
        'infra compl',
        null,
      );
      final bolded = span.children!
          .where(isBold)
          .map(textOf)
          .toList();
      expect(bolded, ['infra', 'compl']);
    });

    test('returns plain span when nothing matches or query is empty', () {
      expect(highlightMatches('hello', 'zzz', null).children, isNull);
      expect(highlightMatches('hello', '   ', null).children, isNull);
      expect(highlightMatches('hello', '   ', null).text, 'hello');
    });

    test('regex metacharacters in the query are treated literally', () {
      final span = highlightMatches('price (usd)', '(usd)', null);
      final bolded = span.children!.where(isBold).map(textOf).toList();
      expect(bolded, ['(usd)']);
    });
  });
}
