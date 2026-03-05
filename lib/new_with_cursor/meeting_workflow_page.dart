import 'package:flutter/material.dart';

import '../src/domain/remote/digidocs/Reunion.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

/// Parcours complet d'une réunion :
/// 1. Choix de la réunion
/// 2. Feuille de présence avec signature électronique
/// 3. Ordre du jour modifiable
/// 4. Consultation des documents joints en mode sécurisé
/// 5. Accès au PV / compte rendu
class MeetingWorkflowPage extends StatefulWidget {
  const MeetingWorkflowPage({super.key});

  @override
  State<MeetingWorkflowPage> createState() => _MeetingWorkflowPageState();
}

class _MeetingWorkflowPageState extends State<MeetingWorkflowPage> {
  int _currentStep = 0;

  Reunion? _selectedReunion;
  bool _attendanceLocked = false;
  final Map<String, bool> _attendance = {}; // participant name -> signed

  final List<TextEditingController> _agendaControllers = [
    TextEditingController(text: 'Présentation du projet'),
    TextEditingController(text: 'Budget'),
    TextEditingController(text: 'Réorganisation'),
  ];

  final List<String> _documents = [
    'ordre_du_jour.pdf',
    'projet_reorganisation.pdf',
    'budget_previsionnel.pdf',
  ];

  List<Reunion> get _reunions => [
        Reunion(
          "1",
          "Réunion Réorganisation Globale Gainde2000",
          "C'est le comité",
          "2025-11-24T08:00:00",
          "2025-11-24T08:00:00",
          "CICAD",
          "123",
          5,
          "ACTIVE",
          ["Comité Stratégique"],
        ),
        Reunion(
          "2",
          "Réunion post opération",
          "C'est le comité",
          "2025-12-05T08:00:00",
          "2025-11-05T08:00:00",
          "CICAD",
          "124",
          3,
          "ACTIVE",
          ["Comité Stratégique"],
        ),
        Reunion(
          "3",
          "Réunion Comité Stratégique",
          "C'est le comité",
          "2025-10-03T08:00:00",
          "2025-11-24T08:00:00",
          "CICAD",
          "125",
          4,
          "ACTIVE",
          ["Comité Stratégique"],
        ),
      ];

  @override
  void dispose() {
    for (final c in _agendaControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.newBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _onStepContinue,
                onStepCancel: _onStepCancel,
                onStepTapped: (index) {
                  // On ne permet pas de sauter des étapes en avant
                  if (index <= _currentStep) {
                    setState(() => _currentStep = index);
                  }
                },
                controlsBuilder: (context, details) {
                  final isLast = _currentStep == 4;
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainAppColor,
                        ),
                        child: Text(isLast ? 'Terminer' : 'Suivant'),
                      ),
                      const SizedBox(width: 8),
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Précédent'),
                        ),
                    ],
                  );
                },
                steps: [
                  Step(
                    title: const Text('Liste des réunions'),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    content: _buildMeetingSelection(),
                  ),
                  Step(
                    title: const Text('Feuille de présence'),
                    isActive: _currentStep >= 1,
                    state: _attendanceLocked
                        ? StepState.complete
                        : StepState.indexed,
                    content: _buildAttendance(),
                  ),
                  Step(
                    title: const Text('Ordre du jour'),
                    isActive: _currentStep >= 2,
                    state: StepState.indexed,
                    content: _buildAgenda(),
                  ),
                  Step(
                    title: const Text('Documents joints'),
                    isActive: _currentStep >= 3,
                    state: StepState.indexed,
                    content: _buildDocuments(context),
                  ),
                  Step(
                    title: const Text('Compte rendu / PV'),
                    isActive: _currentStep >= 4,
                    state: StepState.indexed,
                    content: _buildReport(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xff305A9D),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedReunion?.title ?? 'Parcours réunion',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  '1. Liste → 2. Présence → 3. Ordre du jour → 4. Docs → 5. PV',
                  style: TextStyle(
                    color: Color(0xffDEE8EE),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep == 0 && _selectedReunion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez d\'abord choisir une réunion.')),
      );
      return;
    }

    if (_currentStep == 1 && !_attendanceLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez valider la feuille de présence pour la figer.',
          ),
        ),
      );
      return;
    }

    if (_currentStep < 4) {
      setState(() => _currentStep += 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  Widget _buildMeetingSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sélectionnez la réunion à laquelle vous voulez accéder.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 12),
        ..._reunions.map(
          (reunion) => Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              side: BorderSide(
                color: _selectedReunion?.id == reunion.id
                    ? AppColors.mainAppColor
                    : AppColors.cardBorderColor,
              ),
            ),
            child: ListTile(
              title: Text(
                reunion.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${reunion.location} • ${reunion.startDate}'),
              trailing: _selectedReunion?.id == reunion.id
                  ? const Icon(Icons.check_circle, color: AppColors.mainAppColor)
                  : const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                setState(() {
                  _selectedReunion = reunion;
                  _attendance
                    ..clear()
                    ..addAll({
                      'Président': false,
                      'Directeur Général': false,
                      'Secrétaire': false,
                      'Administrateur': false,
                    });
                  _attendanceLocked = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendance() {
    if (_selectedReunion == null) {
      return const Text(
        'Choisissez d\'abord une réunion pour accéder à la feuille de présence.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.fact_check, color: AppColors.mainAppColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _attendanceLocked
                    ? 'Feuille de présence figée avec les signatures.'
                    : 'Chaque membre émarge numériquement. Une fois validée, la feuille devient un document définitif figé.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._attendance.entries.map(
          (entry) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1565C0),
                child: Text(
                  entry.key.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(entry.key),
              trailing: Icon(
                entry.value ? Icons.check_circle : Icons.border_color,
                color: entry.value ? Colors.green : Colors.grey,
              ),
              onTap: _attendanceLocked
                  ? null
                  : () async {
                      // Ici on pourrait ouvrir une vraie page de signature
                      // Pour l'instant on simule la signature
                      setState(() {
                        _attendance[entry.key] = true;
                      });
                    },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _attendanceLocked
                ? null
                : () {
                    final allSigned =
                        _attendance.values.isNotEmpty && _attendance.values.every((v) => v);
                    if (!allSigned) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Tous les membres n\'ont pas encore émargé.',
                          ),
                        ),
                      );
                      return;
                    }
                    setState(() => _attendanceLocked = true);
                  },
            icon: const Icon(Icons.lock),
            label: const Text('Valider et figer la feuille'),
          ),
        ),
      ],
    );
  }

  Widget _buildAgenda() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ordre du jour reçu avec la convocation. Vous pouvez l\'ouvrir et faire des modifications.',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        ..._agendaControllers.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              controller: entry.value,
              decoration: InputDecoration(
                labelText: 'Point ${entry.key + 1}',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _agendaControllers.add(TextEditingController());
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un point'),
          ),
        ),
      ],
    );
  }

  Widget _buildDocuments(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Les administrateurs ont accès aux documents joints à chaque point de l\'ordre du jour.\n'
          'Les documents sont ouverts dans un viewer sécurisé (pas de téléchargement, '
          'écran protégé, contenu chiffré côté serveur).',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        ..._documents.map(
          (fileName) => Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(fileName),
              subtitle: const Text('Lecture seule sécurisée'),
              trailing: const Icon(Icons.visibility),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutesName.openSecureDocPage,
                  arguments: {'fileName': fileName},
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReport(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'À la fin des discussions, vous pouvez rédiger le compte rendu / PV.',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Ouvrir l\'écran de compte rendu'),
          subtitle: const Text('Rédaction puis génération d\'un PV (PDF)'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutesName.allResolutionPage);
          },
        ),
      ],
    );
  }
}

