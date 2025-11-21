class ApiUrl {
  //              ---------------------- Const Var ----------------------
  static const String baseUrl = 'https://api.example.com'; // Change this to your API URL

  //              ---------------------- App Routes ----------------------
  String getLoginUrl = '$baseUrl/login';
  String getTasksUrl = '$baseUrl/tasks';
}