
import 'package:intl/intl.dart';

extension StringExtension on String {

  String formattedDate() {
    return DateFormat("dd MMM yyyy, h:mm a").format(
        DateTime.parse(this));
  }

}