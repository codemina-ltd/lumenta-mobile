import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/template.dart';
import 'package:mobile/features/templates/template_vars.dart';

void main() {
  group('positional templates', () {
    final t = Template(
      id: 't1',
      name: 'Order update',
      parameterFormat: 'positional',
      body: 'Hi {{1}}, your order {{2}} ships on {{2}}. Thanks {{1}}!',
      variables: const ['customer name', 'order id'],
      bodyExample: const [
        ['Sara', 'A-1009'],
      ],
    );

    test('keys are positional indices, ordered and de-duplicated', () {
      final fields = templateVarFields(t);
      expect(fields.map((f) => f.key).toList(), ['1', '2']);
    });

    test('labels come from variables[] and are never used as keys', () {
      final fields = templateVarFields(t);
      expect(fields[0].label, 'customer name');
      expect(fields[1].label, 'order id');
      // Key stays the index, not the label.
      expect(fields[0].key, '1');
    });

    test('examples map index-for-index from bodyExample[0]', () {
      final fields = templateVarFields(t);
      expect(fields[0].example, 'Sara');
      expect(fields[1].example, 'A-1009');
    });

    test('label falls back to {{n}} when no variable label present', () {
      final bare = t.copyWith(variables: null);
      expect(templateVarFields(bare)[0].label, '{{1}}');
    });
  });

  group('named templates', () {
    final t = Template(
      id: 't2',
      name: 'Welcome',
      parameterFormat: 'named',
      body: 'Hello {{first_name}}, your code is {{order_id}}.',
      bodyExample: const [
        {'param_name': 'first_name', 'example': 'Lena'},
        {'param_name': 'order_id', 'example': 'X-42'},
      ],
    );

    test('keys are the names, in first-appearance order', () {
      final fields = templateVarFields(t);
      expect(fields.map((f) => f.key).toList(), ['first_name', 'order_id']);
      expect(fields.map((f) => f.label).toList(), ['first_name', 'order_id']);
    });

    test('examples are matched by param_name', () {
      final fields = templateVarFields(t);
      expect(fields[0].example, 'Lena');
      expect(fields[1].example, 'X-42');
    });
  });

  group('button fields', () {
    test('COPY_CODE button → coupon_code key', () {
      final t = Template(
        id: 't3',
        name: 'Coupon',
        body: 'Here is your coupon.',
        buttons: const [
          {'type': 'URL', 'text': 'Shop', 'url': 'https://x.y'},
          {'type': 'COPY_CODE', 'text': 'Copy code', 'example': 'SAVE20'},
        ],
      );
      final fields = templateButtonFields(t);
      expect(fields.length, 1);
      expect(fields.single.key, 'coupon_code');
      expect(fields.single.label, 'Copy code');
      expect(fields.single.buttonIndex, 1);
    });

    test('no COPY_CODE button → no fields', () {
      final t = Template(
        id: 't4',
        name: 'Static',
        body: 'No dynamic buttons.',
        buttons: const [
          {'type': 'QUICK_REPLY', 'text': 'Yes'},
        ],
      );
      expect(templateButtonFields(t), isEmpty);
    });
  });

  group('preview', () {
    final t = Template(
      id: 't5',
      name: 'Order update',
      parameterFormat: 'positional',
      body: 'Hi {{1}}, order {{2}} ships soon.',
      variables: const ['customer name', 'order id'],
    );

    test('substitutes filled values', () {
      expect(
        renderPreview(t, {'1': 'Sara', '2': 'A-1009'}),
        'Hi Sara, order A-1009 ships soon.',
      );
    });

    test('falls back to {{label}} for unfilled tokens', () {
      expect(
        renderPreview(t, {'1': 'Sara'}),
        'Hi Sara, order {{order id}} ships soon.',
      );
    });
  });

  group('validation', () {
    final t = Template(
      id: 't6',
      name: 'Order update',
      parameterFormat: 'positional',
      body: 'Hi {{1}}, order {{2}}.',
      variables: const ['customer name', 'order id'],
      buttons: const [
        {'type': 'COPY_CODE', 'text': 'Copy code', 'example': 'SAVE20'},
      ],
    );

    test('missing var labels lists only the blank ones', () {
      expect(missingVarLabels(t, {'1': 'Sara'}), ['order id']);
      expect(missingVarLabels(t, {'1': 'Sara', '2': 'A-1'}), isEmpty);
    });

    test('missing button labels', () {
      expect(missingButtonLabels(t, {}), ['Copy code']);
      expect(missingButtonLabels(t, {'coupon_code': 'SAVE20'}), isEmpty);
    });
  });
}
