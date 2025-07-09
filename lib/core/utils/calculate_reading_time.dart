int calculateReadingTime(String content) {
  // Average reading speed is about 200-250 words per minute
  final averageReadingSpeed = 200;

  // Split the content into words and count them
  final wordCount = content.split(RegExp(r'\s+')).length;

  // Calculate reading time in minutes
  final readingTimeInMinutes = wordCount / averageReadingSpeed;

  // Return the reading time rounded to the nearest integer
  return readingTimeInMinutes.ceil();
}
