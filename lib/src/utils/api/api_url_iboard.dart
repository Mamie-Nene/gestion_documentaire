class ApiUrlIboard {
  //              ---------------------- Const Var ----------------------
  static const String baseUrl = 'https://gupe-partenaire.gainde2000.sn/backendIboard/api'; //preprod
 // static const String baseUrl = 'http://10.0.2.2:8082/api'; // local

  //              ---------------------- auth ----------------------
  String getLoginUrl = '$baseUrl/auth/login';
  String getUserInfoUrl = '$baseUrl/users/email';

  // --------------- dashboard ------------


  String getDashboardUrl = '$baseUrl/dashboard/stats';

  //              ---------------------- docs ----------------------

  String getDocumentsUrl = '$baseUrl/documents';
  String getFilterDocumentsUrl = '$baseUrl/documents/filter';
  String getRecentsDocumentsUrl = '$baseUrl/documents/last-four';
  String voirDocumentUrl = '$baseUrl/documents/getDocument';
  String archiverDocumentUrl = '$baseUrl/documents';


//              ---------------------- iboard ----------------------

//statut meetings ?
  String getMeetingsUrl = '$baseUrl/iboard/meetings';
  String getFeuillePresenceByMeetingCodeUrl = '$baseUrl/iboard/feuille-presence/get-one-by';
  String getAgendaByMeetingCodeUrl = '$baseUrl/iboard/meeting-agenda/all-agenda-by';

 String getListUserGroupsFromUser = '$baseUrl/users/user_assignment_group';
 String ConseilAdministrationCode = 'CA';
 String AGOCode = 'AGO';
 String AGACode = 'AGA';

}