import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '/src/presentation/widgets/app_page_shell.dart';
import '/src/data/remote/category_api.dart';
import '/src/data/remote/events_api.dart';
import '/src/domain/remote/Categorie.dart';
import '/src/domain/remote/Event.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedType;
  String? _selectedCategory;
  String? _selectedEvent;
  String? _selectedStatus;
  File? _selectedFile;

  List<Categorie> _categories = [];
  List<Event> _events = [];
  bool _isLoadingCategories = false;
  bool _isLoadingEvents = false;

  final List<String> _types = ['PDF', 'DOCX', 'XLSX', 'PPTX', 'JPG', 'PNG'];
  final List<String> _statuses = ['Brouillon', 'Publié', 'Archivé'];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadEvents();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  _loadCategories() async {
    setState(() => _isLoadingCategories = true);
    await CategoriesApi().getListCategory(ApiUrl().getCategoriesUrl).then((value) {
      setState(() {
        _categories = value ?? [];
        _isLoadingCategories = false;
      });
    }).catchError((error) {
      setState(() => _isLoadingCategories = false);
    });
  }

  _loadEvents() async {
    setState(() => _isLoadingEvents = true);
    await EventsApi().getListEvents(ApiUrl().getEventsUrl).then((value) {
      setState(() {
        _events = value ?? [];
        _isLoadingEvents = false;
      });
    }).catchError((error) {
      setState(() => _isLoadingEvents = false);
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _saveDocument() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un fichier')),
        );
        return;
      }
      // TODO: Implement save document API call
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      isForHomePage: false,
      title: "Ajout de document",
      whiteColorForMainCardIsHere: true,
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations générales
                   Text(
                    'Informations générales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.loginTitleColor,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Two column grid
                  Row(
                    children: [
                      Expanded(child: _buildFormField(
                        label: 'Titre',
                        controller: _titleController,
                        placeholder: 'Saisir',
                      )),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      Expanded(child: _buildDropdownField(
                        label: 'Type',
                        value: _selectedType,
                        items: _types,
                        placeholder: 'Sélectionner',
                        onChanged: (value) => setState(() => _selectedType = value),
                      )),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Row(
                    children: [
                      Expanded(child: _buildDropdownField(
                        label: 'Catégorie',
                        value: _selectedCategory,
                        items: _categories.map((c) => c.name).toList(),
                        placeholder: 'Sélectionner',
                        isLoading: _isLoadingCategories,
                        onChanged: (value) => setState(() => _selectedCategory = value),
                      )),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      Expanded(child: _buildDropdownField(
                        label: 'Événement',
                        value: _selectedEvent,
                        items: _events.map((e) => e.title).toList(),
                        placeholder: 'Sélectionner',
                        isLoading: _isLoadingEvents,
                        onChanged: (value) => setState(() => _selectedEvent = value),
                      )),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Row(
                    children: [
                      Expanded(child: _buildDateField()),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      Expanded(child: _buildFormField(
                        label: 'Auteur',
                        controller: _authorController,
                        placeholder: 'Saisir',
                      )),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  _buildDropdownField(
                    label: 'Status',
                    value: _selectedStatus,
                    items: _statuses,
                    placeholder: 'Sélectionner',
                    onChanged: (value) => setState(() => _selectedStatus = value),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Description
                  _buildTextAreaField(
                    label: 'Description',
                    controller: _descriptionController,
                    placeholder: 'description',
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Document upload
                  _buildFileUploadSection(),
                  const SizedBox(height: AppDimensions.paddingLarge * 2),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildCancelButton(),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      _buildSaveButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.loginTitleColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFFAFB7C7),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Date d\'ajout',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.loginTitleColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: _selectDate,
            decoration: InputDecoration(
              hintText: 'Saisir',
              hintStyle: const TextStyle(
                color: Color(0xFFAFB7C7),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                onPressed: _selectDate,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String placeholder,
    required ValueChanged<String?> onChanged,
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.loginTitleColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<String>(
                  value: value,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(
                      color: Color(0xFFAFB7C7),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  isExpanded: true,
                ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.loginTitleColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFFAFB7C7),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Document',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.loginTitleColor,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingLarge * 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.upload,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedFile != null
                      ? _selectedFile!.path.split('/').last
                      : 'Joindre un fichier (PDF, JPG, etc.)',
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedFile != null ? Colors.black87 : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Taille maximale autorisée, ex. : 5 Mo',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Annuler',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveDocument,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainAppColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Enregistrer',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

