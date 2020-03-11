import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'package:build_test/build_test.dart';

import 'example/annotated_generator.dart';

void main() {
  group('TestGenerator', () {
    test('Annotation Check', () async {
      final builder = PartBuilder([const TestGenerator()], '.g.dart');

      final assets = {
        'mock_generator|lib/example/test_annotation.dart': _annotation,
        'mock_generator|lib/example/test_entity.dart': _input,
      };

      final outputs = {
        'mock_generator|lib/example/test_entity.g.dart': _output,
      };

      await testBuilder(
        builder,
        assets,
        outputs: outputs,
      );
    });

    test('Annotation Check2', () async {
      final builder = PartBuilder([const TestGeneratorAnnot()], '.g.dart');

      final assets = {
        'mock_generator|lib/example/test_annotation.dart': _annotation,
        'mock_generator|lib/example/test_entity.dart': _input,
      };

      final outputs = {
        'mock_generator|lib/example/test_entity.g.dart': _output,
      };

      await testBuilder(
        builder,
        assets,
        outputs: outputs,
      );
    });
  });
}

String _input = r'''

import 'package:mock_generator/lib/example/test_annotation.dart';

part 'test_entity.g.dart';

@TestAnnotation()
class TestEntity {
  const TestEntity({
    @required this.intValue,
    @required this.stringValue,
  });

  final int intValue;
  final String stringValue;
}
''';

const _output = r'''
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_entity.dart';

// **************************************************************************
// TestGenerator
// **************************************************************************

// generated
''';

const _annotation = '''
class TestAnnotation {
  const TestAnnotation();
}
''';
