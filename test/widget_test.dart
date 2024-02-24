import 'dart:math';

void main() {
  const int sampleSize = 10;
  const double meanHeight = 150.0;
  const double standardDeviation = 10.0;

  List<Map<String, dynamic>> testData =
      generateTestData(sampleSize, meanHeight, standardDeviation);

  printTable(testData);
}

List<Map<String, dynamic>> generateTestData(
    int sampleSize, double meanHeight, double standardDeviation) {
  List<Map<String, dynamic>> testData = [];

  for (int i = 1; i <= sampleSize; i++) {
    double height = generateHeight(meanHeight, standardDeviation);
    double difference = height - meanHeight;

    testData.add({
      'ID': i,
      '키 (cm)': height.toStringAsFixed(2),
      '평균과의 차이 (cm)': difference.toStringAsFixed(2),
    });
  }

  return testData;
}

double generateHeight(double mean, double standardDeviation) {
  final Random random = Random();
  double u1 = 1.0 - random.nextDouble(); // uniform(0,1] random doubles
  double u2 = 1.0 - random.nextDouble();
  double randStdNormal =
      sqrt(-2.0 * log(u1)) * sin(2.0 * pi * u2); // random normal(0,1)
  return mean +
      standardDeviation * randStdNormal; // random normal(mean,stdDev^2)
}

void printTable(List<Map<String, dynamic>> data) {
  List<String> keys = data.first.keys.toList();
  List<List<String>> rows = [keys];

  for (Map<String, dynamic> entry in data) {
    List<String> row = [];
    for (var key in keys) {
      row.add(entry[key].toString());
    }
    rows.add(row);
  }

  // Get the maximum width of each column
  List<int> columnWidths = List<int>.generate(keys.length, (int index) => 0);
  for (List<String> row in rows) {
    for (int i = 0; i < row.length; i++) {
      if (row[i].length > columnWidths[i]) {
        columnWidths[i] = row[i].length;
      }
    }
  }

  // Print the table
  for (List<String> row in rows) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < row.length; i++) {
      buffer.write(row[i].padRight(columnWidths[i] + 2));
    }
    print(buffer.toString());
  }
}
