class Movie {
  final String title;
  final String year;
  final String poster;
  Movie({this.title, this.year, this.poster});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      poster: json['Poster'],
    );
  }
}
