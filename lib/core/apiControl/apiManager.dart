class APIManager {
  static const fixedURL = "https://athapi.oasisdemaadi.com/api/";

  static String loginAPI =  "${fixedURL}Parent/Login";
  static String regStd =  "${fixedURL}regstd";
  //Messages
  static String messagesInbox = "${fixedURL}ParentMSGS_NEW";
  static String getDepartments = "${fixedURL}MSGPrepareNew";
  static String getDepartmentsEmps = "${fixedURL}MSGPrepareChangeCateg";
  static String SendMSGWithATTNew = "${fixedURL}SendMSGWithATTNew";

  //Student Profile Data
  static String getStdLinks = "${fixedURL}stdLinks";

}