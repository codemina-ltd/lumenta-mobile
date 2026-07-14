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

    test('matches multiple tokens, expanding each to the whole word', () {
      final span = highlightMatches(
        'infrastructure upgrade complete',
        'infra compl',
        null,
      );
      final bolded = span.children!
          .where(isBold)
          .map(textOf)
          .toList();
      // Whole words, not just the matched prefixes: span boundaries inside
      // a word break Arabic letter joining, so hits grow to word edges.
      expect(bolded, ['infrastructure', 'complete']);
    });

    test('never splits inside an Arabic word (letter joining stays intact)',
        () {
      final span = highlightMatches('السمنودي كلينك', 'سم', null);
      final parts = span.children!;
      // One highlighted span carrying the whole first word, then the rest.
      expect(parts.map(textOf).toList(), ['السمنودي', ' كلينك']);
      expect(isBold(parts[0]), isTrue);
      expect(isBold(parts[1]), isFalse);
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

    test('adjacent token hits in one word merge into a single span', () {
      final span = highlightMatches('infrastructure', 'infra struct', null);
      expect(span.children!.map(textOf).toList(), ['infrastructure']);
    });
  });

  group('contentDirection', () {
    test('detects RTL for Arabic and LTR for Latin', () {
      expect(contentDirection('السمنودي كلينك'), TextDirection.rtl);
      expect(contentDirection('Smart Health Clinic'), TextDirection.ltr);
      // Mixed content follows the dominant/first strong direction.
      expect(contentDirection('مرحبا Lumenta'), TextDirection.rtl);
    });
  });
}
