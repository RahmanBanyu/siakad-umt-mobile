class ApiEndpoints {
  static const baseUrl = "http://localhost:8080/api";

  //
  static const register = "$baseUrl/register";
  static const login = "$baseUrl/login";
  static const forgotPassword = "$baseUrl/forgot-password";
  static const resetPassword = "$baseUrl/reset-password";

  // User
  static const userProfile = "$baseUrl/me";

  // KRS
  static const krsList = "$baseUrl/krs";
  static const krsDetail = "$baseUrl/krs/detail";

  // KHS
  static const khsList = "$baseUrl/khs";
  static const khsDetail = "$baseUrl/khs/detail";

  // Payment
  static const payments = "$baseUrl/payments";

  // Posts
  static const posts = "$baseUrl/posts";
  static const postDetail = "$baseUrl/posts/detail";
}
