import 'dart:collection';

import 'package:pm_vin_decoder/vin_decoder.dart';

// explanation: https://en.wikibooks.org/wiki/Vehicle_Identification_Numbers_(VIN_codes)/Check_digit
final HashMap<String, int> transliterationKeys = HashMap.from({
  'A': 1,
  'J': 1,
  'B': 2,
  'K': 2,
  'S': 2,
  'C': 3,
  'L': 3,
  'T': 3,
  'D': 4,
  'M': 4,
  'U': 4,
  'E': 5,
  'N': 5,
  'V': 5,
  'F': 6,
  'W': 6,
  'G': 7,
  'P': 7,
  'X': 7,
  'H': 8,
  'Y': 8,
  'R': 9,
  'Z': 9,
});

// Order is important here.
final List<int> weightFactors = [
  8, // 1
  7, // 2
  6, // 3
  5, // 4
  4, // 5
  3, // 6
  2, // 7
  10, // 8
  0, // 9
  9, // 10
  8, // 11
  7, // 12
  6, // 13
  5, // 14
  4, // 15
  3, // 16
  2, // 17
];

class VinValidator {
  static int? getCheckValue(String vin) =>
      (vin[8] == 'W') ? 10 : int.tryParse(vin[8]);

  static int? getDigitValue(String digit) =>
      int.tryParse(digit) ?? transliterationKeys[digit];

  // Checks:
  //  * Length == 17
  //  * It contains a checkdigit
  //  * Validates the checksum with the checkdigit.
  static bool isValid(String number) {
    final String vin = VIN.normalize(number);

    if (vin.length != 17) return false;

    final int? checkDigit = getCheckValue(vin);
    if (checkDigit == null) return false;

    int checkSum = 0;

    for (int i = 0; i < 17; i++) {
      final int? value = getDigitValue(vin[i]);
      if (value == null) return false;

      checkSum += value * weightFactors[i];
    }

    return checkSum % 11 == checkDigit;
  }
}
