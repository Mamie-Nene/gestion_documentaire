class ApiUrl {
  //              ---------------------- Const Var ----------------------
  static const String baseUrl = 'https://gupe-partenaire.gainde2000.sn/backendGestionDocument/api'; // Change this to your API URL

  //              ---------------------- auth ----------------------
  String getLoginUrl = '$baseUrl/auth/login';
  String getUserInfoUrl = '$baseUrl/users/email';
  //              ---------------------- categorie ----------------------

  String getCategoriesUrl = '$baseUrl/categories';
  //              ---------------------- docs ----------------------

  String getDocumentsUrl = '$baseUrl/documents';
  String voirDocumentUrl = '$baseUrl/documents/getDocument';

//              ---------------------- events ----------------------
  String getEventsUrl = '$baseUrl/events';


}