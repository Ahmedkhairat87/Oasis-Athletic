import '../msgsModels/Inbox.dart';
import '../msgsModels/Sent.dart';
import 'BaseMessage.dart';

class MessageMapper {
  static BaseMessage fromInbox(Inbox inbox) {
    return BaseMessage(
      studentNom: inbox.studentNom ?? "",
      message: inbox.noteBody ?? "",
      empName: inbox.empName ?? "",
      noteSubject: inbox.noteSubject ?? "",
      actualEditdate: inbox.actualEditdate ?? "",
      enDesc: inbox.enDesc ?? "",
    );
  }

  static BaseMessage fromSent(Sent sent) {
    return BaseMessage(
      studentNom: sent.studentNom ?? "",
      message: sent.noteBody ?? "",
      empName: sent.empName ?? "",
      noteSubject: sent.noteSubject ?? "",
      actualEditdate: sent.actualEditdate ?? "",
      enDesc: sent.enDesc ?? "",
    );
  }
}