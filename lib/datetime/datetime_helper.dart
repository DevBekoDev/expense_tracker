// convertt datetime to string
String convertDateTimetoString(DateTime time) {
  // convert year
  String year = time.year.toString();
  // convert month
  String month = time.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  //convert day
  String day = time.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  // format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
