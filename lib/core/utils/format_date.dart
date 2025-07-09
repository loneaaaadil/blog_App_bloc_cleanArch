import 'package:intl/intl.dart';

String FormatDateBydMMMYYYY(DateTime date) {
  return DateFormat('d MMM yyyy').format(date);
}
