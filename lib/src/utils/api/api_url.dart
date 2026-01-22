class ApiUrl {
  //              ---------------------- Const Var ----------------------
  static const String baseUrl = 'https://gupe-partenaire.gainde2000.sn/backendGestionDocument/api'; // Change this to your API URL

  //              ---------------------- auth ----------------------
  String getLoginUrl = '$baseUrl/auth/login';
  String getUserInfoUrl = '$baseUrl/users/email';

  // --------------- dashboard ------------

  String getDashboardUrl = '$baseUrl/dashboard/stats';
  //              ---------------------- categorie ----------------------

  String getCategoriesUrl = '$baseUrl/categories';
  //              ---------------------- docs ----------------------

  String getDocumentsUrl = '$baseUrl/documents';
  String getFilterDocumentsUrl = '$baseUrl/documents/filter';
  String getRecentsDocumentsUrl = '$baseUrl/documents/last-four';
  String voirDocumentUrl = '$baseUrl/documents/getDocument';
  String archiverDocumentUrl = '$baseUrl/documents';

//              ---------------------- events ----------------------
  String getEventsUrl = '$baseUrl/events';
  String getRecentsEventsUrl = '$baseUrl/events/last-four';
  String getEventsTimelineUrl = '$baseUrl/event-timelines/event';


}