import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/type.dart';
import '../mock.dart';

class CreateMockGenerator extends GeneratorForAnnotation<Mock> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element.kind != ElementKind.CLASS) {
      return null;
    }

    final classElement = element as ClassElement;

    final result = classElement.fields
        .map((e) {
          // fieldでない場合
          if (e.kind.name != 'FIELD') {
            return '\n${e.displayName}: ${e.constantValue}';
          }
          // fieldの場合
          return '\n${e.displayName}: ${_getMethod(e.type)},';
        })
        .toList()
        .join('');

    return '''
      ${element.name} getMockTo${element.name}() {
        final _faker = Faker();
        return ${element.name}(
          $result
        );
      }
      ''';
  }

  String _getMethod(DartType type) {
    if (type.toString() == 'DateTime') {
      return '_faker.date.dateTime()';
    }

    if (type.isDartCoreInt) {
      return '_faker.randomGenerator.integer(99999)';
    }

    if (type.isDartCoreString) {
      return '_faker.address.toString()';
    }

    if (type.isDynamic) {
      return 'null';
    }

    if (type.isDartCoreDouble) {
      return '_faker.randomGenerator.decimal()';
    }

    if (type.isDartCoreBool) {
      return '_faker.randomGenerator.element([true, false])';
    }
    if (type is InterfaceType) {
      if (type.element.isEnum) {
        return '_faker.randomGenerator.element(${type.displayName}.values)';
      }
    }

    if (type.toString() == 'List') {
      return '[]';
    }

    if (type.isObject) {
      return 'null';
    }

    return 'null';
  }
}
