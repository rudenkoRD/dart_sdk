// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_support.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(CamelCaseExtensionsTest);
  });
}

@reflectiveTest
class CamelCaseExtensionsTest extends LintRuleTest {
  @override
  String get lintRule => 'camel_case_extensions';

  @FailingTest(
      issue: 'https://github.com/dart-lang/linter/issues/4898',
      reason:
          "ParserErrorCode.EXTRANEOUS_MODIFIER [27, 7, Can't have modifier 'augment' here.]")
  test_augmentationExtension_lowerCase() async {
    newFile('$testPackageLibPath/a.dart', r'''
import augment 'test.dart';

extension e on Object { }
''');

    await assertNoDiagnostics(r'''
library augment 'a.dart';

augment extension e { }
''');
  }

  test_lowerCase() async {
    await assertDiagnostics(r'''
extension fooBar on Object {}
''', [
      lint(10, 6),
    ]);
  }

  test_underscore() async {
    await assertDiagnostics(r'''
extension Foo_Bar on Object { }
''', [
      lint(10, 7),
    ]);
  }

  test_unnamed() async {
    await assertNoDiagnostics(r'''
extension on Object { }
''');
  }

  test_wellFormed() async {
    await assertNoDiagnostics(r'''
extension FooBar on Object { }
''');
  }
}
