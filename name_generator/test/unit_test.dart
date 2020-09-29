import 'package:flutter_test/flutter_test.dart';

class Cube {
  static int getCube(int integer) => integer * integer * integer;
}

class Factorial {
  static int findFactorial(int integer) {
    int fact = 1;
    for (int i = integer; i > 0; i--) fact *= i;
    return fact;
  }
}

void main() {
  group('Unit Testing', () {
    test('Test 1', () {
      int answer = Cube.getCube(2);
      expect(answer, 8);
    });
    test('Test 2', () {
      int answer = Cube.getCube(3);
      expect(answer, 8);
    });
    test('Test 3', () {
      int answer = Factorial.findFactorial(4);
      expect(answer, 24);
    });
    test('Test 4', () {
      int answer = Factorial.findFactorial(5);
      expect(answer, 24);
    });
  });
}
