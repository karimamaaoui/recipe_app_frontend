class BaseAPI {
  static const String base = "http://127.0.0.1:5000";
  static const String api = "$base/apidocs";
  static const String customersPath = "$api/customers";
  static const String authPath = "$api/auth";

  // Headers as a static constant map
  static const Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
  };
}
