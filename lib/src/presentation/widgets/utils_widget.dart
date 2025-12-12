
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestion_documentaire/src/domain/remote/Categorie.dart';
import 'package:gestion_documentaire/src/domain/remote/Event.dart';
import 'package:gestion_documentaire/src/utils/consts/routes/app_routes_name.dart';

import '/src/utils/consts/app_specifications/all_directories.dart';


class UtilsWidget{

  Container bottomNavBarTitle(double textScaleFactor,{
    required String icon,
    required String title,
    required bool condition,
}){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: condition? Colors.white:null,
          borderRadius: BorderRadius.circular(100),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 13,
                height: AppDimensions.sizeboxHeight15,
                child: SvgPicture.asset("asset/images/$icon.svg",color:condition? AppColors.mainAppColor:Colors.grey,),
              ),
              Text(title,
                style: TextStyle(
                  color: condition? AppColors.mainAppColor:Colors.grey,
                  fontSize: textScaleFactor * 13,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.20,
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget evenementGrid(BuildContext context, List<Event> events ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingLarge,
        mainAxisSpacing: AppDimensions.paddingLarge,
        childAspectRatio: 2.4,
        // childAspectRatio: 1.2,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {

        final event = events[index];//evenement[index]

        // List<List<Color>> gradient=[[AppColors.mainBlueFirst, AppColors.secondAppColor],[Colors.purple, Color(0xFFC15BE3)],[Colors.orange, Color(0xFFFFD28C)],[Colors.blue, Color(0xFF92EFFD)],];
        List<IconData> icon = [Icons.folder_open_rounded,Icons.task_alt_rounded,Icons.verified_outlined,Icons.archive_outlined,];

        return InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          onTap: () => Navigator.pushNamed(context,AppRoutesName.documentPage, arguments: {"event": event.id,"subtitle":event.title}),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              //border: Border(top:  BorderSide(color: AppColors.secondAppColor) ),
              //border: Border.all(color: AppColors.secondAppColor),
              /*gradient: LinearGradient(
               colors: gradient[index],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),*/

              borderRadius:
              BorderRadius.circular(AppDimensions.borderRadiusLarge),
              /*boxShadow: [
                BoxShadow(
                  color:gradient[index].last.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],*/
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 0,
                      child: Container(
                        height: 55,
                        width:65,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xff3B82F6).withOpacity(0.1),
                          border: Border.all(color: Color(0xff3B82F6).withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("nov.",style: TextStyle( color: Color(0xff3B82F6), fontSize: 14,fontWeight: FontWeight.bold)),
                            Text("14",style: TextStyle( color: Color(0xff3B82F6), fontSize: 16,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              //color: AppColors.mainblueColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 5,
                                children: [
                                  SvgPicture.asset("asset/images/hour.svg"),

                                  Text("14:00",
                                    style: TextStyle(color: AppColors.textMainPageColor,fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    SvgPicture.asset("asset/images/location.svg"),

                                    Flexible(
                                      child: Text("Salle de réunion A",
                                        style: TextStyle(color: AppColors.textMainPageColor,fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: Color(0xffDEE8EE),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        SvgPicture.asset("asset/images/docs.svg"),
                        Text("1 document(s) lié(s) ",
                          style: TextStyle(color: AppColors.textMainPageColor,fontSize: 12),
                        ),
                      ],
                    ),
                    /*Icon(Icons.arrow_outward_rounded,
                        color: AppColors.mainblueColor, size: 20),*/
                    Row(
                      spacing: 5,
                      children: [
                        Text("Voir les détails",
                          style: TextStyle(color: Color(0xff3B82F6),fontSize: 12),
                        ),
                        SvgPicture.asset("asset/images/arrow_back.svg"),

                      ],
                    ),
                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }

  Widget categoryGrid(BuildContext context,List<Categorie> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingMedium,
        mainAxisSpacing: AppDimensions.paddingMedium,
        childAspectRatio: 2.1,
        // childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index]; //categories[index];
        List<List<Color>> gradient=[[AppColors.mainBlueFirst, AppColors.secondAppColor],[AppColors.accentTeal, Color(0xFF0BB6D9)],[Colors.orange, Color(0xFFFFD28C)],[Color(0xFF4E65FF), Color(0xFF92EFFD)],];
        List<IconData> icon = [Icons.picture_as_pdf_rounded,Icons.article_outlined,Icons.video_camera_back_outlined,Icons.document_scanner,];

        return InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          onTap: () => Navigator.pushNamed(context,AppRoutesName.documentPage,arguments: {"category":index==0? null: category.id,"subtitle":index==0?"Tous les documents":category.name}),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top:  BorderSide(color: AppColors.secondAppColor) ),
              /* gradient: LinearGradient(
                colors: gradient[index],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),*/
              borderRadius:
              BorderRadius.circular(AppDimensions.borderRadiusLarge),
              /* boxShadow: [
                BoxShadow(
                  color: gradient[index].last.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],*/
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: AppColors.secondAppColor.withOpacity(0.2),
                    // color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon[index], color: AppColors.secondAppColor, size: 26),
                ),
                Text(
                  category.name,
                  style: const TextStyle(
                    //color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.arrow_outward_rounded,
                    color:AppColors.mainAppColor,
                    //color: Colors.white70,
                    size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
