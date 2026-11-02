/// Converts an episode number into its roman numeral representation.
///
/// Returns an empty string when the episode is missing or not positive.
String romanNumeral(int? number) {
  if (number == null || number <= 0) return '';

  const values = <int>[1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  const symbols = <String>[
    'M',
    'CM',
    'D',
    'CD',
    'C',
    'XC',
    'L',
    'XL',
    'X',
    'IX',
    'V',
    'IV',
    'I',
  ];

  var remaining = number;
  final buffer = StringBuffer();

  for (var i = 0; i < values.length; i++) {
    while (remaining >= values[i]) {
      buffer.write(symbols[i]);
      remaining -= values[i];
    }
  }

  return buffer.toString();
}
