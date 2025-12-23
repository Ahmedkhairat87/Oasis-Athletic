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
  static String getAcademicSupport = "${fixedURL}stdLinksAcademic";
  static String getSchoolAcademicLinks = "${fixedURL}stdAcademicLinks";
  static String getAthleticLinks = "${fixedURL}stdLinksAthletics";



  //APIS from Parents app API.Oasis
  static const fixedURL2 = "https://api1.oasisdemaadi.com/api/";

  static String getNewsLetter = "${fixedURL2}IntNewsLetter";

  //Canteen Charge
  static const getAmountList = "${fixedURL2}chargAmounts";
  static const paymentLinkGeneration = "${fixedURL2}CreateNewVoucher";
  static const paymentHistory = "${fixedURL2}stdCanteenHistory";



//    static let newsLetter = fixedURL + "IntNewsLetter"
/* //Canteen Charge
    static let getAmountList = fixedURL + "chargAmounts"
    static let paymentLinkGeneration = fixedURL + "CreateNewVoucher"
    static let paymentHistory = fixedURL + "stdCanteenHistory"

 */
}