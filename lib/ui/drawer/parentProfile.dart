import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:oasisathletic/core/reusable_components/app_background.dart';

class Parentprofile extends StatefulWidget {
  static const routeName = '/parentprofile';
  const Parentprofile({super.key});

  @override
  State<Parentprofile> createState() => _ParentprofileState();
}

class _ParentprofileState extends State<Parentprofile> {
  ProfileSection _currentSection = ProfileSection.general;
  bool _editMode = false;

  void _toggleEdit() {
    setState(() => _editMode = !_editMode);
    if (!_editMode) FocusScope.of(context).unfocus();
  }

  void _selectSection(ProfileSection section) {
    setState(() => _currentSection = section);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Parents Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_editMode ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Stack(
            children: [
              _buildSection(),

              /// ===== CIRCULAR MENU =====
              CircularMenu(
                alignment: Alignment.bottomRight,
                radius: 90.w,
                startingAngleInRadian: 3.0,
                endingAngleInRadian: 4.7,
                toggleButtonColor: Colors.blue,
                toggleButtonIconColor: Colors.white,
                items: ProfileSection.values.map((section) {
                  final isActive = section == _currentSection;
                  return CircularMenuItem(
                    icon: section.icon,
                    iconSize: 16.sp,
                    padding: 10.w,
                    iconColor: isActive ? Colors.white : Colors.blue,
                    color: isActive ? Colors.blue : Colors.white,
                    onTap: () => _selectSection(section),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= SECTION SWITCH =================
  Widget _buildSection() {
    switch (_currentSection) {

    /// ---------- GENERAL ----------
      case ProfileSection.general:
        return _section('General', [
          const SectionTitle('Father Info.'),
          EditableField(
            label: 'Father’s first & last name',
            initialValue: '',
            editMode: _editMode,
            canEdit: false, // 🔒 LOCKED
          ),
          EditableField(
            label: 'Tutor’s first & last name',
            initialValue: '',
            editMode: _editMode,
          ),
          EditableField(
            label: 'Private Address',
            initialValue: '',
            editMode: _editMode,
          ),

          const SectionTitle('Mother Info.'),
          EditableField(
            label: 'Mother’s first & last name',
            initialValue: '',
            editMode: _editMode,
            canEdit: false, // 🔒 LOCKED
          ),
          EditableField(
            label: 'Tutor’s first & last name',
            initialValue: '',
            editMode: _editMode,
          ),
          EditableField(
            label: 'Private Address',
            initialValue: '',
            editMode: _editMode,
          ),
        ]);

    /// ---------- EDUCATION ----------
      case ProfileSection.education:
        return _section('Education', [
          const SectionTitle('Father Info.'),
          EditableField(label: 'School', initialValue: '', editMode: _editMode),
          EditableField(label: 'Diploma', initialValue: '', editMode: _editMode),
          EditableField(label: 'Mother Tongue', initialValue: '', editMode: _editMode),
          EditableField(label: 'Second Language', initialValue: '', editMode: _editMode),
          EditableField(label: 'Third Language', initialValue: '', editMode: _editMode),
          EditableField(label: 'Other Language', initialValue: '', editMode: _editMode),

          const SectionTitle('Mother Info.'),
          EditableField(label: 'School', initialValue: '', editMode: _editMode),
          EditableField(label: 'Diploma', initialValue: '', editMode: _editMode),
          EditableField(label: 'Mother Tongue', initialValue: '', editMode: _editMode),
          EditableField(label: 'Second Language', initialValue: '', editMode: _editMode),
          EditableField(label: 'Third Language', initialValue: '', editMode: _editMode),
          EditableField(label: 'Other', initialValue: '', editMode: _editMode),
        ]);

    /// ---------- WORK ----------
      case ProfileSection.work:
        return _section('Work', [
          const SectionTitle('Father Info.'),
          EditableField(label: 'Area Of Work', initialValue: '', editMode: _editMode),
          EditableField(label: 'The profession', initialValue: '', editMode: _editMode),
          EditableField(label: 'Name of the company', initialValue: '', editMode: _editMode),
          EditableField(label: 'Workplace', initialValue: '', editMode: _editMode),

          const SectionTitle('Mother Info.'),
          EditableField(label: 'Area Of Work', initialValue: '', editMode: _editMode),
          EditableField(label: 'The profession', initialValue: '', editMode: _editMode),
          EditableField(label: 'Name of the company', initialValue: '', editMode: _editMode),
          EditableField(label: 'Workplace', initialValue: '', editMode: _editMode),
        ]);

    /// ---------- CONTACT ----------
      case ProfileSection.contact:
        return _section('Contact', [
          const SectionTitle('Father Info.'),
          EditableField(label: 'Email', initialValue: '', editMode: _editMode),
          EditableField(label: 'Home Tel.', initialValue: '', editMode: _editMode),
          EditableField(label: 'Cell Phone', initialValue: '', editMode: _editMode),

          const SectionTitle('Mother Info.'),
          EditableField(label: 'Email', initialValue: '', editMode: _editMode),
          EditableField(label: 'Home Tel.', initialValue: '', editMode: _editMode),
          EditableField(label: 'Cell Phone', initialValue: '', editMode: _editMode),

          const SectionTitle('Responsable Info.'),
          EditableField(label: 'Email', initialValue: '', editMode: _editMode),
          EditableField(label: 'Cell Phone', initialValue: '', editMode: _editMode),
        ]);

    /// ---------- EMERGENCY ----------
      case ProfileSection.emergency:
        return _section('Emergency', [
          const SectionTitle('First Person'),
          EditableField(label: 'Name', initialValue: '', editMode: _editMode),
          EditableField(label: 'Relation', initialValue: '', editMode: _editMode),
          EditableField(label: 'Home Tel.', initialValue: '', editMode: _editMode),
          EditableField(label: 'Cell Phone', initialValue: '', editMode: _editMode),

          const SectionTitle('Second Person'),
          EditableField(label: 'Name', initialValue: '', editMode: _editMode),
          EditableField(label: 'Relation', initialValue: '', editMode: _editMode),
          EditableField(label: 'Home Tel.', initialValue: '', editMode: _editMode),
          EditableField(label: 'Cell Phone', initialValue: '', editMode: _editMode),

          const SectionTitle('Third Person'),
          EditableField(label: 'Name', initialValue: '', editMode: _editMode),
          EditableField(label: 'Relation', initialValue: '', editMode: _editMode),
        ]);
    }
  }

  Widget _section(String title, List<Widget> fields) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          ...fields,
          SizedBox(height: 40.h),
          Center(
            child: ElevatedButton(
              onPressed: _editMode ? () {} : null,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

/* ========================== SUPPORTING WIDGETS ========================== */

class EditableField extends StatefulWidget {
  final String label;
  final String initialValue;
  final bool editMode;
  final bool canEdit; // 👈 NEW

  const EditableField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.editMode,
    this.canEdit = true,
  });

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditable = widget.editMode && widget.canEdit;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.label, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
              if (!widget.canEdit)
                Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Icon(Icons.lock, size: 14.sp, color: Colors.grey),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          isEditable
              ? TextFormField(
            controller: _controller,
            decoration: const InputDecoration(border: InputBorder.none),
          )
              : Text(
            _controller.text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: widget.canEdit ? Colors.black : Colors.grey.shade600,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(text, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
    );
  }
}

enum ProfileSection { general, contact, work, education, emergency }

extension ProfileSectionIcon on ProfileSection {
  IconData get icon {
    switch (this) {
      case ProfileSection.general:
        return Icons.person;
      case ProfileSection.contact:
        return Icons.phone;
      case ProfileSection.work:
        return Icons.work;
      case ProfileSection.education:
        return Icons.school;
      case ProfileSection.emergency:
        return Icons.warning;
    }
  }
}