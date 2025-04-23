class Error {
  final String code;
  final String message;

  Error({required this.code, required this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(code: json['code'] ?? '', message: json['message'] ?? '');
  }
}

class Result<T> {
  final T? data;
  final List<Error> errors;
  final bool successful;

  Result({this.data, required this.errors, required this.successful});

  factory Result.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return Result<T>(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: (json['errors'] as List).map((e) => Error.fromJson(e)).toList(),
      successful: json['successful'],
    );
  }
}
