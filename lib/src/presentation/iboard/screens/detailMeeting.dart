import 'package:flutter/material.dart';

import '/core/utils/date_helper.dart';
import '/src/domain/remote/iboard/ParticipantReunion.dart';
import '/src/utils/api/api_url_iboard.dart';

import '/src/data/remote/iboard/meeting_api.dart';
import '../../../domain/remote/iboard/AgendaMeeting.dart';
import '../../../domain/remote/iboard/FeuillePresence.dart';
import '/src/utils/consts/app_specifications/app_dimensions.dart';
import '../../../domain/remote/iboard/IboardMeetingData.dart';

import '/core/theme/app_colors.dart';


class MeetingDetailsPage extends StatefulWidget {
  final IboardMeetingData meeting;
  MeetingDetailsPage({super.key, required this.meeting});

  @override
  State<MeetingDetailsPage> createState() => _MeetingDetailsPageState();
}

class _MeetingDetailsPageState extends State<MeetingDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ParticipantReunion> participants=[];

  bool _isfeuillePresenceLoading=true;
  bool _isAgendaLoading=false;
  bool _isResolutionLoading=false;

  FeuillePresence? feuillePresence;
  List<AgendaMeeting> agendaMeetings = [];

  feuillePresenceGetted() async {
    await MeetingIboardApi().getFeuillePresence(ApiUrlIboard().getFeuillePresenceByMeetingCodeUrl,meetingCode: widget.meeting.code).then(
            (value) {
              _isfeuillePresenceLoading = false;
              if(value!=null){
                setState(() {
                  feuillePresence = value;
                  participants=feuillePresence!.participants;
                 // _isfeuillePresenceLoading = false;
                });
              }
            }).catchError((error) {
              setState(() {
                _isfeuillePresenceLoading = false;
              });
            });
  }

  agendaGetted() async {
    setState(() {
     _isfeuillePresenceLoading = true;
    });
    await MeetingIboardApi().getListOrdreDuJour( ApiUrlIboard().getAgendaByMeetingCodeUrl,meetingCode:widget.meeting.code).then((value) {
      setState(() {
        agendaMeetings = value ?? [];
       _isAgendaLoading=false;

        debugPrint('Loaded ${agendaMeetings.length} agendas from API');
      });
    }).catchError((error) {
      setState(() {
       _isAgendaLoading = false;
      });
      debugPrint('Error loading agenda: $error');
    });
  }


  @override
  void initState() {
    feuillePresenceGetted();
    agendaGetted();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  //  participants = FeuillePresenceLocalData().participants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(context),
            const SizedBox(height: 24),
            _buildHeader(),
            const SizedBox(height: 20),

            _buildTabs(),
            const SizedBox(height: 32),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                 _buildListPresenceEtEmargement(feuillePresence),
                  _buildDetailReunion()
                ],
              ),
            ),
            _buildBottomActions()
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, size: 18),
          const SizedBox(width: 8),
          Text(
            "Retour aux reunions",
            style: TextStyle(
              color: AppColors.mutedForeground,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Conseil d'Administration",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          /*  const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.15),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                "Convoquée",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )*/
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "CA - ${widget.meeting.title}",
         // "CA - Approbation des comptes Q4 2025",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.meeting.description,
          //"Réunion du conseil d'administration pour l'approbation des comptes du 4eme trimestre.",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mutedForeground,
          ),
        ),

          Padding(
            padding: const EdgeInsets.only(top: 16),
            child:_metaItem(Icons.groups_outlined, "7 membres (Direction Générale, Conseil d'Administration)",),
        ),
      ],
    );
  }

  Widget _buildMeetingMetaInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
         /* _metaItem(
            Icons.calendar_today_outlined,
            "dimanche 15 février 2026",
          ),
          _metaItem(
            Icons.access_time,
            "09:00",
          ),
          _metaItem(
            Icons.location_on_outlined,
            "Salle du Conseil, Siège Social, Dakar",
          ),*/
          _metaItem(
            Icons.groups_outlined,
            "7 membres (Direction Générale, Conseil d'Administration)",
          ),
        ],
      ),
    );
  }

  Widget _metaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.mutedForeground,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
  // ================= TABS =================

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
       // padding:EdgeInsets.all(10),
          labelPadding:EdgeInsets.all(5),
        indicatorPadding:EdgeInsets.all(5),
        controller: _tabController,
        labelColor: AppColors.foreground,
        indicatorColor: AppColors.primary,
        unselectedLabelColor: AppColors.mutedForeground,
        //indicator: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(6),),
        tabs: const [
          Tab(text: "Feuille de présence"),
          Tab(text: "Détails de la réunion"),
        ],
      ),
    );
  }

  // ================= AVANT REUNION =================

  Widget _buildListPresenceEtEmargement(FeuillePresence? feuillepresence) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildConvocationCard(),
          const SizedBox(height: 24),

          _isfeuillePresenceLoading?
          Center(child: CircularProgressIndicator(),)
              :
          feuillePresence == null
              ? const Center(child: Text("La feuille de présence n'a pas encore été créée!"))
              :
          _buildAttendanceSection(feuillePresence),
        ],
      ),
    );
  }

  // ================= Info REUNION =================
  Widget _buildDetailReunion() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ordre du jour",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
          agendaMeetings.isEmpty?
          const Center(child: Text("L'agenda du jour n'a pas encore été créée!"))
              :
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: agendaMeetings.length,
            itemBuilder: (context, index) {

              final agenda = agendaMeetings.elementAt(index);
              final duration = DateHelper.getFormattedDuration(agenda.startTime, agenda.endTime,);

              return _agendaItem(index,agenda.description , duration.toString());
              },
            separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.paddingMedium),
          ),

          _buildAttachmentsSection(),

        ],
      ),
    );
  }

  // ================= CARD =================

  Widget _buildConvocationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.description, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Convocation CA - 15 Fevrier 2026",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Convocation officielle pour la reunion du CA.",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: AppColors.secondary)
        ],
      ),
    );
  }

  // ================= AGENDA =================


  Widget _agendaItem(int number, String title, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$number",
              style: TextStyle(
                color: AppColors.primaryForeground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.foreground,
              ),
            ),
          ),
          Text(
            duration,
            style: TextStyle(color: AppColors.mutedForeground),
          )
        ],
      ),
    );
  }

  // ================= ATTACHMENTS =================

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pieces jointes",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 16),
        _attachmentItem("Etats financiers Q4 2025"),
        _attachmentItem("Rapport commissaire aux comptes"),
      ],
    );
  }

  Widget _attachmentItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.foreground,
              ),
            ),
          ),
          Icon(Icons.lock, size: 16, color: AppColors.mutedForeground)
        ],
      ),
    );
  }

  Widget _buildAttendanceSection(FeuillePresence? feuillePresence) {
    final presentCount = participants.where((p) => p.present).length;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Feuille de presence",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            Text(
              "$presentCount/${participants.length} presents",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // CARD
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: participants
                .map((p) => _attendanceItem(p))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _attendanceItem(ParticipantReunion participant) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Text("MN",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name + Role
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.user,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.foreground,
                    ),
                  ),
                  Text(
                    participant.roleUser,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Button
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                participant.present = !participant.present;
              });
            },
            icon: Icon(
              participant.present
                  ? Icons.check_circle
                  : Icons.person_add_alt_1,
              size: 16,
            ),
            label: Text(
              participant.present ? "Présent" : "Émarger",
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: participant.present
                  ? AppColors.success
                  : AppColors.foreground,
              side: BorderSide(
                color: participant.present
                    ? AppColors.success
                    : AppColors.border,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ================= BOTTOM ACTIONS =================

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () {},
            style:ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium,horizontal:AppDimensions.paddingMedium ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              ),
            ) ,
            child: const Text("Démarrer la réunion"),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.expand_circle_down_outlined),
            label: const Text("Clôre la réunion"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium ,horizontal:AppDimensions.paddingMedium),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              ),
              backgroundColor: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class Participant {
  final String name;
  final String role;
  bool isPresent;

  Participant({
    required this.name,
    required this.role,
    this.isPresent = false,
  });

  String get initials {
    final parts = name.split(" ");
    return parts.length >= 2
        ? "${parts[0][0]}${parts[1][0]}"
        : parts[0][0];
  }
}