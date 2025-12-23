// lib/ui/messages/send_messages_screen.dart
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasisathletic/core/apiControl/apiManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/colors_Manager.dart';
import '../../../core/model/newMessageModels/Departments/DepartmentEmployee.dart';
import '../../../core/model/newMessageModels/mainCategories/ToTypes.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/services/sideMenu/messagesServices/getDepartmentsServices.dart';
import '../../../core/services/sideMenu/messagesServices/getEmpsServices.dart';
import '../../../core/services/sideMenu/messagesServices/sendMessageServices/sendMessageServices.dart';

/// Messages screen: choose child -> recipient type -> recipient -> subject -> message -> send
class sendMessagesScreen extends StatefulWidget {
  static const routeName = '/sendMessagesScreen';
  const sendMessagesScreen({super.key});

  @override
  State<sendMessagesScreen> createState() => _sendMessagesScreenState();
}

class _sendMessagesScreenState extends State<sendMessagesScreen> {
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
        selectedStd: "${student.stdId}|${student.oasisAthleticFlag}",
      );

      setState(() {
        categories = response.toTypes ?? [];
        loadingCategories = false;
      });
    } catch (_) {
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
      final response = await GetEmpsService.GetEmployeeResponse(
        token: token,
        selectedStd: "${selectedStudent!.stdId}|${selectedStudent!.oasisAthleticFlag}",
        toCategNo: category.msgCategNo.toString(),
      );

      setState(() {
        employees = response.toDepartment ?? [];
        loadingEmployees = false;
      });
    } catch (_) {
      setState(() => loadingEmployees = false);
    }
  }

  Future<void> pickAttachment({bool isImage = false}) async {
    if (attachments.length >= maxAttachments) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('max_files_allowed'.tr())),
      );
      return;
    }

    try {
      if (isImage) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() => attachments.add(File(pickedFile.path)));
        }
      } else {
        final result = await FilePicker.platform.pickFiles(allowMultiple: true);
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
    } catch (_) {}
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
          SnackBar(
            content: Text('message_sent_success'.tr()),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('failed_send_message'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('server_error_send'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                    Text(
                      'new_message'.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                _sectionTitle('select_child'.tr()),
                SizedBox(height: 8.h),

                _sectionTitle('send_to'.tr()),
                SizedBox(height: 8.h),
                _sectionTitle('choose_department'.tr()),
                SizedBox(height: 8.h),

                DropdownButtonFormField<ToCategory>(
                  isExpanded: true,
                  initialValue: selectedCategory,
                  hint: Text('select_department'.tr()),
                  items: categories.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.msgCategDesc ?? "", overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                    if (value != null) loadEmployees(value);
                  },
                ),

                SizedBox(height: 12.h),

                _sectionTitle('choose_recipient'.tr()),
                SizedBox(height: 8.h),

                DropdownButtonFormField<DepartmentEmployee>(
                  isExpanded: true,
                  initialValue: selectedEmployee,
                  hint: Text('select_employee'.tr()),
                  items: employees.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.matDesc ?? "", overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedEmployee = value),
                ),

                SizedBox(height: 12.h),

                _sectionTitle('subject'.tr()),
                SizedBox(height: 8.h),

                _GlassTextField(
                  controller: _subjectController,
                  hintText: 'subject_optional'.tr(),
                  minLines: 1,
                  maxLines: 3,
                ),

                SizedBox(height: 12.h),

                _sectionTitle('message'.tr()),
                SizedBox(height: 8.h),

                Expanded(
                  child: _GlassTextField(
                    controller: _messageController,
                    hintText: 'write_message_here'.tr(),
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),

                SizedBox(height: 12.h),

                _sectionTitle('attachments'.tr()),
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
                    Text('attached_count'.tr(args: ['${attachments.length}'])),
                  ],
                ),

                SizedBox(height: 12.h),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _onSend,
                        icon: const Icon(Icons.send),
                        label: Text('send'.tr()),
                      ),
                    ),
                  ],
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
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
  );
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool expands;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  const _GlassTextField({
    required this.controller,
    required this.hintText,
    this.expands = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(12.r);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          padding: EdgeInsets.all(6.w),
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              expands: expands,
              maxLines: expands ? null : maxLines,
              minLines: minLines,
              maxLength: maxLength,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ),
      ),
    );
  }
}