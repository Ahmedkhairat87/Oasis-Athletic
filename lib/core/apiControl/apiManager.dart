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

  static String getNewsLetter = "${fixedURL}IntNewsLetter";

  //Canteen Charge
  static const getAmountList = "${fixedURL}chargAmounts";
  static const paymentLinkGeneration = "${fixedURL}CreateNewVoucher";
  static const paymentHistory = "${fixedURL}stdCanteenHistory";

  //Gallery
  static const getGalleryAlbums = "${fixedURL}Parent/GetGalleries";
  static const getAlbumsPhotos = "${fixedURL}Parent/GetGalleriesDetails";
  static const getCartPhotos = "${fixedURL}Parent/GetRequestedGalleries";

  static const requestNewPhoto = "${fixedURL}Parent/GalleriesRequest";
  static const cancelrequestedPhoto = "${fixedURL}Parent/GalleriesCancel";




//    static let newsLetter = fixedURL + "IntNewsLetter"
/* //Canteen Charge
    static let getAmountList = fixedURL + "chargAmounts"
    static let paymentLinkGeneration = fixedURL + "CreateNewVoucher"
    static let paymentHistory = fixedURL + "stdCanteenHistory"

 */
}