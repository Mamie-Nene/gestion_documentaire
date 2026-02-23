
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '/src/utils/consts/app_specifications/all_directories.dart';
import '/conseil_administration/models/participant.dart';
import '/src/presentation/widgets/utils_widget.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class AttendancePage extends StatefulWidget {
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Participant> participants = [
    Participant(name: "Awa Diop"),
    Participant(name: "Mame Nene Ba"),
    Participant(name: "Fatou Ndiaye"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff305A9D),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 50, bottom: 100),
              child: Row(
                children: [
                  UtilsWidget().iconContainerCard(
                    isItWithBorder: true,
                    bgColor: null,
                    widget:IconButton(
                      icon:Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      onPressed:(){Navigator.of(context).pop();},
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text("Liste des membres conviés ",
                              style: TextStyle(
                                color: Color(0xffDEE8EE),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                height: 1.40,
                              ),
                            ),
                          Text("Feuille de présence",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              )
                            //theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600,),
                          ),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: participants.length,
            itemBuilder: (context, index) {
                    final p = participants[index];
                    String firstLetter = p.name.substring(0,1).toUpperCase();
                    return ListTile(
                      leading:  CircleAvatar(
                        backgroundColor:  Color(0xFF1565C0),
                        child:Text(
                          firstLetter,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:MediaQuery.of(context).textScaleFactor*16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(p.name,),// style: const TextStyle(fontWeight: FontWeight.w600)

                      trailing: p.signed
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.edit),
                      onTap: () async {
                        final signed = await  Navigator.pushNamed(context, AppRoutesName.signaturePage);
                        if (signed == true) {
                          setState(() => p.signed = true);
                        }
                      },
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Ordre du jour"),
        icon: const Icon(Icons.list),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutesName.agendaPage);
        },
      ),
    );
  }
}


class FeuillePresencePage extends StatefulWidget {
  final String title;
  const FeuillePresencePage({super.key, required this.title});

  @override
  State<FeuillePresencePage> createState() => _FeuillePresencePageState();
}

class _FeuillePresencePageState extends State<FeuillePresencePage> {
  final SignatureController controller = SignatureController(penStrokeWidth: 3, penColor: Colors.black,);

  marquerPresence(BuildContext context){
   return showModalBottomSheet(
       context:context ,
       backgroundColor:Colors.white,
       isScrollControlled :true,
       useSafeArea:true,
       constraints: BoxConstraints.expand(width:MediaQuery.of(context).size.width, height:MediaQuery.of(context).size.height/2.1),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(20.0),
       ),
       builder: ( context){
         return Container(
           height: MediaQuery.of(context).size.height/2.1,
            padding: EdgeInsets.all(12.0),
            // width:MediaQuery.of(context).size.width ,
            child: Center(
              child: Column(
                spacing: 12,
                children: [
                  Text("Veuillez signer ici pour matérialiser votre présence",style: TextStyle(fontSize: 14),),
                  Expanded(
                    child: Signature(
                      controller: controller,
                      backgroundColor: Colors.grey[200]!,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: controller.clear,
                        child: const Text("Effacer",style: TextStyle(color: Colors.grey),),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenMainAppColor,
                        ),
                        onPressed: () => Navigator.pushNamed(context, AppRoutesName.agendaPage,arguments: {"title": widget.title}),
                        //onPressed: () => Navigator.pop(context, ),
                       // onPressed: () => Navigator.pop(context, true),
                        child: const Text("Valider",style: TextStyle(color: Colors.white),),
                      )
                    ],
                  )
                ],
              ),
            ),
         );
       }
   );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.newBackgroundColor,
        //backgroundColor: Color(0xff305A9D),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    BackButton(),
                    Text(
                      "Feuille de présence",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      ContactTile(context,
                        name: "Mame Néné BA",
                        role: "Président",
                        status: ContactStatus.none,

                      ),
                      ContactTile(context,
                        name: "Modou Diop",
                        role: "Directeur Général",
                        status: ContactStatus.approved,
                      ),
                      ContactTile(context,
                        name: "Cheikh Sow",
                        role: "Secrétaire",
                        status: ContactStatus.rejected,
                      ),
                      ContactTile(context,
                        name: "Mouhamed Diouf",
                        role: "Administrateur",
                        status: ContactStatus.approved,
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    ContactTile( BuildContext context,{
      required String name,
      required String role,
      required ContactStatus status
    }) {
      IconData? icon; Color? color;

      switch (status) {
        case ContactStatus.approved:
          icon = Icons.check_circle;
          color = Colors.green;
          break;
        case ContactStatus.rejected:
          icon = Icons.cancel;
          color = Colors.red;
          break;
        case ContactStatus.none:
          icon = Icons.add_circle;
          color = Colors.grey;
          break;
      }
      String firstLetter = name.substring(0,1).toUpperCase();
      print(firstLetter);
      return ListTile(
        /*leading: CircleAvatar(
        backgroundColor: Color(0xFFEFEFEF),
        child: Icon(Icons.person, color: Colors.grey),
          ),*/
        leading:  CircleAvatar(
          backgroundColor:  Color(0xFF1565C0),
          child:Text(
            firstLetter,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize:MediaQuery.of(context).textScaleFactor*16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(role),
        trailing: IconButton(
          icon: Icon(icon, color: color),
          onPressed: status == ContactStatus.none ? () {marquerPresence(context);} : null,
        ),
      );
    }
}

enum ContactStatus { approved, rejected, none }


