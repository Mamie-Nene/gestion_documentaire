class ApiUrl {
  //              ---------------------- Const Var ----------------------
 // static const String baseUrl = 'https://gupe-partenaire.gainde2000.sn/backendGestionDocument/api'; //preprod
  static const String baseUrl = 'http://10.0.2.2:8082/api'; // local
 // static const String baseUrl = 'http://localhost:8082/api'; // local

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

  //              ---------------------- reunion ----------------------
  String getReunionsUrl = '$baseUrl/reunions';


//              ---------------------- iboard ----------------------


  String getMeetingsUrl = '$baseUrl/meetings';
}