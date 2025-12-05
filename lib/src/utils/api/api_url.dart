class ApiUrl {
  //              ---------------------- Const Var ----------------------
  static const String baseUrl = 'https://gupe-partenaire.gainde2000.sn/backendGestionDocument/api'; // Change this to your API URL

  //              ---------------------- App Routes ----------------------
  String getLoginUrl = '$baseUrl/auth/login';
  String getCategoriesUrl = '$baseUrl/categories';
  String getDocumentsUrl = '$baseUrl/documents';
  String voirDocumentUrl = '$baseUrl/documents/getDocument';


}