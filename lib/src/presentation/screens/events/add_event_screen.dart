import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/widgets/app_page_shell.dart';
import 'package:intl/intl.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCommittee;

  final List<String> _committees = ['Design', 'Développement', 'Marketing', 'Finance'];

  @override
  void dispose() {
    _labelController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save event API call
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      isForHomePage: false,
      title: "Ajout d'évènement",
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
                   Text(
                    'Informations générales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.loginTitleColor,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Libellé
                  _buildFormField(
                    label: 'Libellé',
                    controller: _labelController,
                    placeholder: 'Saisir',
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Date
                  _buildDateField(),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Comité
                  _buildDropdownField(
                    label: 'Comité',
                    value: _selectedCommittee,
                    items: _committees,
                    placeholder: 'Sélectionner',
                    onChanged: (value) {
                      setState(() {
                        _selectedCommittee = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  // Description
                  _buildTextAreaField(
                    label: 'Description',
                    controller: _descriptionController,
                    placeholder: 'description',
                  ),
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
          'Date',
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
              hintText: 'JJ/MM/AAAA',
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
          child: DropdownButtonFormField<String>(
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
                child: Text(item),
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
          style:  TextStyle(
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
      onPressed: _saveEvent,
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

