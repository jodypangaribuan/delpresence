class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://10.0.2.2:8080'; // Go backend
  static const String campusApiBaseUrl =
      'https://cis.del.ac.id/api'; // Campus API

  // API Endpoints
  static const String loginEndpoint = '$baseUrl/api/v1/auth/login';
  static const String campusAuthEndpoint = '$campusApiBaseUrl/jwt-api/do-auth';

  // Mahasiswa Endpoints
  static const String mahasiswaEndpoint = '$baseUrl/api/v1/mahasiswa';
  static const String mahasiswaCompleteEndpoint =
      '$baseUrl/api/v1/mahasiswa/complete';

  // For iOS simulator - points to host machine's localhost
  // static const String baseUrl = 'http://localhost:8080';

  // For physical devices on same network - use your computer's local IP
  // static const String baseUrl = 'http://192.168.1.100:8080';

  // For production
  // static const String baseUrl = 'https://api.delpresence.com';

  // Campus API endpoints
  static const String campusMahasiswaEndpoint =
      '$campusApiBaseUrl/library-api/mahasiswa';
  static const String campusMahasiswaByNimEndpoint =
      '$campusApiBaseUrl/library-api/get-student-by-nim';
}
