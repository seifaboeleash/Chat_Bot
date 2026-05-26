/// Typed exception hierarchy for the app.
/// Throw these from the data layer; catch by type in the Cubit.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Thrown when there is no network / the connection timed out.
final class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Thrown when the server returns a non-2xx status code.
final class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
}

/// Thrown when JSON parsing of the response fails.
final class ParseException extends AppException {
  const ParseException(super.message);
}
