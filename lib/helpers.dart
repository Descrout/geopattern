import 'dart:math';

class Helpers {
  static int toExactSq(int n) {
    final numBefore = sqrt(n);
    final numCeil = numBefore.ceil();
    return numCeil * numCeil;
  }
}
