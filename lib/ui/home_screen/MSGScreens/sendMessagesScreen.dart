import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasisathletic/core/apiControl/apiManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/colors_Manager.dart';
import '../../../core/model/newMessageModels/Departments/Department.dart';
import '../../../core/model/newMessageModels/Departments/DepartmentEmployee.dart';
import '../../../core/model/newMessageModels/mainCategories/Categories.dart';
import '../../../core/model/newMessageModels/mainCategories/ToTypes.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/services/messagesServices/getDepartmentsServices.dart';
import '../../../core/services/messagesServices/getEmpsServices.dart';
import '../../../core/services/messagesServices/sendMessageServices/sendMessageServices.dart';




/// Messages screen: choose child -> recipient type -> recipient -> subject -> message -> send
class sendMessagesScreen extends StatefulWidget {
  static const routeName = '/sendMessagesScreen';
  const sendMessagesScreen({super.key});

  @override
  State<sendMessagesScreen> createState() => _sendMessagesScreenState();
}



class _sendMessagesScreenState extends State<sendMessagesScreen> {
  // ✅ بيانات من SharedPreferences / API
  List<stdData> students = [];
  stdData? selectedStudent;

  List<ToCategory> allCategories = [];
  List<ToCategory> categories = [];
  ToCategory? selectedCategory;

  List<DepartmentEmployee> employees = [];
  DepartmentEmployee? selectedEmployee;

  bool loadingStudents = true;
  bool loadingCategories = false;
  bool loadingEmployees = false;

  final List<File> attachments = [];
  final int maxAttachments = 5;

  String token = "";

  // === UI state ===
 // RecipientType selectedRecipientType = RecipientType.teacher;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initScreen();

  }

  Future<void> initScreen() async {
    await loadToken();
    await loadStudents();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
  }

  Future<void> loadStudents() async {
    final result = await getStudentsFromPrefs();

    if (result.isNotEmpty) {
      selectedStudent = result.first;
      await loadDepartments(selectedStudent!);
    }

    setState(() {
      students = result;
      loadingStudents = false;
    });

    print("✅ Loaded students: ${students.length}");
    print("✅ Loaded categories count: ${categories.length}");
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }



  Future<List<stdData>> getStudentsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("students");

    if (data == null || data.isEmpty) return [];

    final List decoded = jsonDecode(data);

    return decoded.map((e) => stdData.fromJson(e)).toList();
  }

  Future<void> loadDepartments(stdData student) async {
    setState(() {
      loadingCategories = true;
      categories.clear();
      employees.clear();
      selectedCategory = null;
      selectedEmployee = null;
    });

    try {
      final response = await GetDepartmentsService.GetDepartmentsResponse(
        token: token,
        selectedStd: student.stdId.toString() + "|" + student.oasisAthleticFlag.toString(),

      );

      setState(() {
        categories = response.toTypes ?? [];
        loadingCategories = false;
      });
    } catch (e) {
      print("❌ Error Loading Departments: $e");
      setState(() => loadingCategories = false);
    }
  }

  Future<void> loadEmployees(ToCategory category) async {
    if (selectedStudent == null) return;
    setState(() {
      loadingEmployees = true;
      employees.clear();
      selectedEmployee = null;
    });

    try {
      print(APIManager.getDepartmentsEmps);
      final response = await GetEmpsService.GetEmployeeResponse(
        token: token,
        selectedStd: selectedStudent!.stdId.toString() + "|" + selectedStudent!.oasisAthleticFlag.toString(),
        toCategNo: category.msgCategNo.toString(),
      );

      setState(() {
        employees = response.toDepartment ?? [];
        loadingEmployees = false;
      });
    } catch (e) {
      print("❌ Error Loading Employees: $e");
      setState(() => loadingEmployees = false);
    }
  }

  //image and files attach func
  Future<void> pickAttachment({bool isImage = false}) async {
    if (attachments.length >= maxAttachments) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maximum 5 files allowed")),
      );
      return;
    }

    try {
      if (isImage) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          setState(() {
            attachments.add(File(pickedFile.path));
          });
        }
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
        );

        if (result != null) {
          final files = result.files
              .where((f) => f.path != null)
              .map((f) => File(f.path!))
              .toList();

          setState(() {
            final remaining = maxAttachments - attachments.length;
            attachments.addAll(files.take(remaining));
          });
        }
      }
    } catch (e) {
      print("❌ Attachment Error: $e");
    }
  }



  Future<void> _onSend() async {


    try {
      final response = await SendMessageService.sendMessageWithAttachments(
        token: token,
        empNo: selectedEmployee!.empNo.toString(),
        matNo: selectedEmployee!.matNo.toString(),
        forGrade: selectedStudent!.currentGrade.toString(),
        fromStdId: selectedStudent!.stdId.toString(),
        noteSubject: _subjectController.text,
        body: _messageController.text,
        toType: selectedCategory!.msgCategNo.toString(),
        attachments: attachments,
      );

      final int result = int.tryParse(response.data.toString()) ?? 0;

      if (result > 0) {
        print("✅ Message Sent Successfully with ID: $result");

        // ✅ مسح كل البيانات بعد الإرسال
        _subjectController.clear();
        _messageController.clear();

        setState(() {
          selectedStudent = null;
          selectedCategory = null;
          selectedEmployee = null;

          categories.clear();
          employees.clear();
          attachments.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Message sent successfully"),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ الرجوع لشاشة الرسائل
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
        });

      } else {
        print("❌ API Returned Failure Code: ${response.data}");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Failed to send message"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Send Message Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Server error while sending"),
          backgroundColor: Colors.red,
        ),
      );
    }

    // final child = selectedStudent?.stdFirstname ?? "(no child)";
    // final to = selectedEmployee?.matDesc ?? "(none)";
    // final subject = _subjectController.text.trim();
    // final message = _messageController.text.trim();
    //
    // if (message.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Message body cannot be empty'),
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
    //   return;
    // }
    //
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Sending message to $to for $child'),
    //     behavior: SnackBarBehavior.floating,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryBlue = ColorsManager.primaryGradientStart;

    return Scaffold(
      body: AppBackground(
        useAppBarBlur: false,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SizedBox(height: 6.h),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    SizedBox(width: 8.w),
                    Text('New Message',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.titleLarge?.color,
                        )),
                  ],
                ),
                SizedBox(height: 8.h),

                // --- select student (child) ---
                _sectionTitle('Select child'),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 120.h,
                  child: loadingStudents
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: students.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final selected = selectedStudent?.stdId == student.stdId;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedStudent = student);
                          loadDepartments(student);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 120.w,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: selected ? primaryBlue.withOpacity(0.12) : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: selected ? primaryBlue : Colors.transparent, width: selected ? 1.4 : 0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 32.r,
                                backgroundImage: NetworkImage(student.stdPicture ?? ""),
                                onBackgroundImageError: (_, __) {},
                              ),
                              SizedBox(height: 8.h),
                              Text(student.stdFirstname ?? "", overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 12.h),

                // --- recipient type buttons ---
                _sectionTitle('Send to'),
                SizedBox(height: 8.h),
                _sectionTitle('Choose Department'),
                SizedBox(height: 8.h),

                loadingCategories
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField<ToCategory>(
                  isExpanded: true,
                  value: selectedCategory,
                  hint: const Text("Select Department"),
                  items: categories.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          e.msgCategDesc ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                    if (value != null) loadEmployees(value);
                  },
                ),

                SizedBox(height: 12.h),

                // --- recipient dropdown ---
                _sectionTitle('Choose recipient'),
                SizedBox(height: 8.h),
                DropdownButtonFormField<DepartmentEmployee>(
                  isExpanded: true, // ✅ أهم سطر يمنع الـ overflow
                  value: selectedEmployee,
                  hint: const Text("Select Employee"),
                  items: employees.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          e.matDesc ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // ✅ يمنع الكسر
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedEmployee = value),
                ),

                SizedBox(height: 12.h),

                // --- Subject ---
                _sectionTitle('Subject'),
                TextField(controller: _subjectController, decoration: InputDecoration(hintText: 'Subject (optional)')),

                SizedBox(height: 12.h),

                // --- Message ---
                _sectionTitle('Message'),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(hintText: 'Write your message here...'),
                  ),
                ),

                SizedBox(height: 12.h),

                //attach button
                _sectionTitle('Attachments'),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () => pickAttachment(isImage: true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () => pickAttachment(),
                    ),
                    Text("${attachments.length}/5 attached"),
                  ],
                ),
                SizedBox(height: 12.h),

                // --- Send button ---
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _onSend,
                        icon: const Icon(Icons.send),
                        label: const Text('Send'),
                      ),
                    ),
                  ],
                ),

                if (attachments.isNotEmpty)
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: attachments.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final file = attachments[index];
                        final fileName = file.path.split('/').last;

                        return Stack(
                          children: [
                            Container(
                              width: 90,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  file.path.endsWith(".jpg") ||
                                      file.path.endsWith(".png")
                                      ? Image.file(file, height: 40, fit: BoxFit.cover)
                                      : const Icon(Icons.insert_drive_file, size: 35),

                                  const SizedBox(height: 6),

                                  Text(
                                    fileName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),

                            // زر الحذف
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    attachments.removeAt(index);
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
  );

  // String _labelForType(RecipientType t) {
  //   switch (t) {
  //     case RecipientType.teacher:
  //       return 'Teacher';
  //     case RecipientType.coach:
  //       return 'Coach';
  //     case RecipientType.admin:
  //       return 'Administration';
  //   }
  // }
}

// enum RecipientType { teacher, coach, admin }




//
// class _sendMessagesScreenState extends State<sendMessagesScreen> {
//   // === sample data (replace with real data from your APIs) ===
//   final String sampleChildImage =
//       '/mnt/data/WhatsApp Image 2025-11-24 at 09.18.47.jpeg';
//
//   final List<_Child> children = [
//     _Child(
//       name: 'Malek',
//       avatarPath: '/mnt/data/WhatsApp Image 2025-11-24 at 09.18.47.jpeg',
//     ),
//     _Child(name: 'Mazen', avatarPath: ''),
//   ];
//
//   final List<String> teachers = ['Teacher 1', 'Teacher 2', 'Teacher 3'];
//   final List<String> coaches = ['Coach 1', 'Coach 2'];
//   final List<String> admins = ['Admin 1', 'Admin 2'];
//
//   // === UI state ===
//   int selectedChildIndex = 0;
//   RecipientType selectedRecipientType = RecipientType.teacher;
//   String? selectedRecipient; // teacher/coach/admin
//   final TextEditingController _subjectController = TextEditingController();
//   final TextEditingController _messageController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     // default recipient from teachers list
//     selectedRecipient = teachers.isNotEmpty ? teachers.first : null;
//   }
//
//   @override
//   void dispose() {
//     _subjectController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }
//
//   List<String> get currentRecipientList {
//     switch (selectedRecipientType) {
//       case RecipientType.teacher:
//         return teachers;
//       case RecipientType.coach:
//         return coaches;
//       case RecipientType.admin:
//         return admins;
//     }
//   }
//
//   void _onSend() {
//     // Replace this with your actual send logic / API call
//     final child = children[selectedChildIndex].name;
//     final to = selectedRecipient ?? '(none)';
//     final subject = _subjectController.text.trim();
//     final message = _messageController.text.trim();
//
//     if (message.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Message body cannot be empty'),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }
//
//     // demo toast
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Sending message to $to for $child'),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//
//     // clear inputs on success (optional)
//     // _subjectController.clear();
//     // _messageController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isLight = theme.brightness == Brightness.light;
//
//     final Color primaryBlue =
//     isLight
//         ? ColorsManager.primaryGradientStart
//         : ColorsManager.primaryGradientStartDark;
//     final Color accentMint = ColorsManager.accentMint;
//     final Color accentSky = ColorsManager.accentSky;
//
//     return Scaffold(
//       // App background component used in your app — keeps theme consistent
//       body: AppBackground(
//         useAppBarBlur: false,
//         child: SafeArea(
//           top: true,
//           bottom: true,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12.w),
//             child: Column(
//               children: [
//                 // ---- top app-style row with back button ----
//                 SizedBox(height: 6.h),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 44.w,
//                       height: 44.h,
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         icon: Icon(Icons.arrow_back, size: 22.r, color: theme.iconTheme.color),
//                         onPressed: () {
//                           Navigator.maybePop(context);
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: Text(
//                         'New Message',
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w700,
//                           color: theme.textTheme.titleLarge?.color,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12.w), // keep spacing similar to other screens
//                   ],
//                 ),
//
//                 // ---------- top row: pick child ----------
//                 SizedBox(height: 8.h),
//                 _sectionTitle('Select child'),
//                 SizedBox(height: 8.h),
//                 SizedBox(
//                   height: 120.h,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       final double viewportWidth = constraints.maxWidth;
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(minWidth: viewportWidth),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: children.asMap().entries.map((entry) {
//                               final idx = entry.key;
//                               final c = entry.value;
//                               final bool selected = idx == selectedChildIndex;
//
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 6.w),
//                                 child: GestureDetector(
//                                   onTap: () => setState(() => selectedChildIndex = idx),
//                                   child: AnimatedContainer(
//                                     duration: const Duration(milliseconds: 220),
//                                     width: 120.w,
//                                     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//                                     decoration: BoxDecoration(
//                                       color: selected ? primaryBlue.withOpacity(0.12) : theme.colorScheme.surface,
//                                       borderRadius: BorderRadius.circular(14.r),
//                                       border: Border.all(
//                                         color: selected ? primaryBlue : Colors.transparent,
//                                         width: selected ? 1.4 : 0,
//                                       ),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         _buildAvatar(
//                                           c.avatarPath,
//                                           radius: 32.r,
//                                           borderColor: selected ? primaryBlue : Colors.transparent,
//                                         ),
//                                         SizedBox(height: 8.h),
//                                         Text(
//                                           c.name,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(fontWeight: FontWeight.w700),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 SizedBox(height: 18.h),
//
//                 // ---------- recipient type row: teacher / coach / admin ----------
//                 _sectionTitle('Send to'),
//                 SizedBox(height: 8.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children:
//                   RecipientType.values.map((type) {
//                     final bool isSel = type == selectedRecipientType;
//                     final label = _labelForType(type);
//                     return Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 4.w),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                             isSel
//                                 ? primaryBlue
//                                 : theme.colorScheme.surface,
//                             foregroundColor:
//                             isSel
//                                 ? Colors.white
//                                 : theme.colorScheme.onSurface,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             elevation: isSel ? 6 : 0,
//                             padding: EdgeInsets.symmetric(vertical: 12.h),
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               selectedRecipientType = type;
//                               final list = currentRecipientList;
//                               selectedRecipient =
//                               list.isNotEmpty ? list.first : null;
//                             });
//                           },
//                           child: Text(label, textAlign: TextAlign.center),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//
//                 SizedBox(height: 14.h),
//
//                 // ---------- recipient selector (depends on selected type) ----------
//                 _sectionTitle('Choose recipient'),
//                 SizedBox(height: 8.h),
//                 SizedBox(
//                   height: 110.h,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       final double viewportWidth = constraints.maxWidth;
//                       final list = currentRecipientList; // teachers / coaches / admins
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(minWidth: viewportWidth),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             // 🔑 change to start, center, end, spaceBetween, etc.
//                             children: list.map((name) {
//                               final bool isSel = name == selectedRecipient;
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 6.w),
//                                 child: GestureDetector(
//                                   onTap: () => setState(() => selectedRecipient = name),
//                                   child: AnimatedContainer(
//                                     duration: const Duration(milliseconds: 200),
//                                     width: 140.w,
//                                     padding: EdgeInsets.all(8.w),
//                                     decoration: BoxDecoration(
//                                       color: isSel ? primaryBlue.withOpacity(0.12) : theme.colorScheme.surface,
//                                       borderRadius: BorderRadius.circular(14.r),
//                                       border: Border.all(
//                                         color: isSel ? primaryBlue : Colors.transparent,
//                                         width: isSel ? 1.4 : 0,
//                                       ),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 28.r,
//                                           backgroundColor: theme.colorScheme.surface,
//                                           child: Text(
//                                             _initialsOf(name),
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: primaryBlue,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 8.h),
//                                         Text(
//                                           name,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.center,
//                                           style: const TextStyle(fontWeight: FontWeight.w600),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 SizedBox(height: 12.h),
//
//                 // ---------- Subject ----------
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 6.w),
//                     child: Text(
//                       'Subject',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: primaryBlue,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 TextField(
//                   controller: _subjectController,
//                   decoration: InputDecoration(
//                     hintText: 'Subject (optional)',
//                     filled: true,
//                     fillColor: theme.colorScheme.surface,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                       vertical: 14.h,
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 12.h),
//
//                 // ---------- Message (expandable) ----------
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 6.w),
//                     child: Text(
//                       'Message',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: primaryBlue,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     maxLines: null,
//                     expands: true,
//                     keyboardType: TextInputType.multiline,
//                     decoration: InputDecoration(
//                       hintText: 'Write your message here...',
//                       filled: true,
//                       fillColor: theme.colorScheme.surface,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 12.w,
//                         vertical: 16.h,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 12.h),
//
//                 // ---------- Send button ----------
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: _onSend,
//                         icon: const Icon(Icons.send),
//                         label: const Text('Send'),
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(vertical: 14.h),
//                           backgroundColor: primaryBlue,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 12.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _sectionTitle(String title) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: EdgeInsets.only(left: 6.w),
//         child: Text(
//           title,
//           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAvatar(
//       String path, {
//         required double radius,
//         Color borderColor = Colors.transparent,
//       }) {
//     final Widget avatarChild;
//     if (path.isNotEmpty && File(path).existsSync()) {
//       avatarChild = ClipOval(
//         child: Image.file(
//           File(path),
//           width: radius * 2,
//           height: radius * 2,
//           fit: BoxFit.cover,
//         ),
//       );
//     } else {
//       avatarChild = CircleAvatar(
//         radius: radius,
//         child: Icon(Icons.person, size: radius),
//       );
//     }
//
//     return Container(
//       padding: EdgeInsets.all(3.w),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: borderColor == Colors.transparent ? 0 : 2,
//         ),
//       ),
//       child: avatarChild,
//     );
//   }
//
//   String _initialsOf(String name) {
//     final parts = name.split(' ');
//     if (parts.isEmpty) return '?';
//     if (parts.length == 1) return parts.first.characters.first.toUpperCase();
//     return '${parts.first.characters.first.toUpperCase()}${parts[1].characters.first.toUpperCase()}';
//   }
//
//   String _labelForType(RecipientType t) {
//     switch (t) {
//       case RecipientType.teacher:
//         return 'Teacher';
//       case RecipientType.coach:
//         return 'Coach';
//       case RecipientType.admin:
//         return 'Administration';
//     }
//   }
// }
//
// enum RecipientType { teacher, coach, admin }
//
// class _Child {
//   final String name;
//   final String avatarPath;
//   _Child({required this.name, required this.avatarPath});
// }