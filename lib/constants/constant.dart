// Base URL
const String baseUrl = "http://10.0.2.2:5000";

// API URL
const String api = "$baseUrl/apidocs";

// Endpoint Paths
const String customersPath = "$api/customers";
const String authPath = "$api/auth";

// Headers
const Map<String, String> headers = {
  "Content-Type": "application/json; charset=UTF-8",
};
