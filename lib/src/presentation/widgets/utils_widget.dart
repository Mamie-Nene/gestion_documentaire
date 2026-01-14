
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestion_documentaire/src/domain/remote/Categorie.dart';
import 'package:gestion_documentaire/src/domain/remote/Document.dart';
import 'package:gestion_documentaire/src/domain/remote/Event.dart';
import 'package:gestion_documentaire/src/presentation/widgets/helper.dart';
import 'package:gestion_documentaire/src/utils/consts/routes/app_routes_name.dart';

import '/src/utils/consts/app_specifications/all_directories.dart';


class UtilsWidget{

  Container iconContainerCard({
    required bool isItWithBorder,
    required Color? bgColor,
    required Widget widget
  }){
    return Container(
      height: 48,
      width: 48,
      padding: isItWithBorder?EdgeInsets.zero:const EdgeInsets.all(AppDimensions.paddingSmall),
      decoration: BoxDecoration(
        border: isItWithBorder?Border.all(color: AppColors.iconBorderColor):null,
       color: isItWithBorder?null:bgColor,
        borderRadius: BorderRadius.circular(isItWithBorder?12:8),
      ),
      child: widget
    );
  }

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


  Widget documentGrid(BuildContext context, Document document) {
    final fileType = Helper().getFileExtension(document.mimeType, document.fileName);
    final fileColor = Helper().getFileTypeColor(fileType);
    final fileIcon = Helper().getFileTypeIcon(fileType);
    final fileSize = Helper().formatFileSize(document.fileName);
    final fileTypeText = Helper().getFileTypeText(fileType);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutesName.viewDocumentPage, arguments: {"document": document},),

      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          border: Border.all(color: AppColors.cardBorderColor),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        child: Row(
          children: [
            SvgPicture.asset("asset/images/$fileIcon.svg",),
            SizedBox(width: 10,), //const SizedBox(height: AppDimensions.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    document.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff212529),
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Text(fileType,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff979797),
                        ),
                      ),
                      SvgPicture.asset("asset/images/dots.svg"),
                      Text(fileSize,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff979797),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                width: 40,
                 padding: const EdgeInsets.all(4.5),
                decoration: BoxDecoration(
                  color:fileColor.withOpacity(0.1),
                  border: Border.all(color: fileColor),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
                ),
                child: Text(fileTypeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: fileColor,fontSize: 10),)//Color(0xffBC3618)
            ),
          ],
        ),
      ),
    );
  }

  Widget evenementGridForViewList(BuildContext context, Iterable<Event> events , bool isItForHomePage) {
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

        final event = events.elementAt(index);
        final DateTime eventDate = Helper().parseEventDate(event.startDate);

        return InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          onTap: () => Navigator.pushNamed(context,AppRoutesName.detailsEventPage, arguments: {"event": event.code,"eventId": event.id,"subtitle":event.title}),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              border: isItForHomePage?null:Border.all(color: AppColors.cardBorderColor),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
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
                          color: AppColors.mainEventsBlueColor.withOpacity(0.1),
                          border: Border.all(color: AppColors.mainEventsBlueColor.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //event date
                            Text(Helper().formatMonth(eventDate),//event date month
                                style: TextStyle( color: AppColors.mainEventsBlueColor, fontSize: 14,fontWeight: FontWeight.bold)),
                            Text(Helper().formatDay(eventDate),//event date day
                                style: TextStyle( color: AppColors.mainEventsBlueColor, fontSize: 16,fontWeight: FontWeight.bold)),
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
                              color: AppColors.textMainPageColor,
                              fontFamily: "Roboto",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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
                                  Text(Helper().formatHour(eventDate),//houre here
                                    style: TextStyle(color:AppColors.textMainPageColor, fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    SvgPicture.asset("asset/images/location.svg"),
                                    Flexible(
                                      child: Text(event.location,
                                        style: TextStyle(color: AppColors.textMainPageColor,fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w400),
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
                        Text("document(s) lié(s) ",
                          style: TextStyle(color: AppColors.textMainPageColor,fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Text("Voir les détails",
                          style: TextStyle(color: AppColors.mainEventsBlueColor,fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w500),
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

  Widget evenementGridForCalendarDay(BuildContext context,DateTime day, bool isCurrentMonth, bool isToday, List<Event> dayEvents) {
    Color? backgroundColor;
    String? labelText;
    Color? labelColor;

    if (isToday) {
      backgroundColor = Colors.green[50];
      labelText = 'Aujourd\'hui';
      labelColor = Colors.green;
    } else if (dayEvents.isNotEmpty) {
      // Use different colors for different events
      final event = dayEvents.first;
      if (event.title.toLowerCase().contains('numerique') || event.title.toLowerCase().contains('numérique')) {
        backgroundColor = Colors.blue[50];
        labelText = event.title;
        labelColor = Colors.blue;
      } else if (event.title.toLowerCase().contains('e-commerce') || event.title.toLowerCase().contains('forum')) {
        backgroundColor = Colors.orange[50];
        labelText = event.title;
        labelColor = Colors.orange;
      } else {
        backgroundColor = Colors.blue[50];
        labelText = event.title;
        labelColor = Colors.blue;
      }
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context,AppRoutesName.detailsEventPage, arguments: {"event": dayEvents.first.code,"eventId": dayEvents.first.id,"subtitle":dayEvents.first.title});
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              day.day.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCurrentMonth ? Colors.black87 : Colors.grey[400],
              ),
            ),
            if (labelText != null && dayEvents.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: labelColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  labelText.length > 15 ? '${labelText.substring(0, 15)}...' : labelText,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],

          ],
        ),
      ),
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
          onTap: () => Navigator.pushNamed(context,AppRoutesName.documentPage,arguments: {"category":index==0? null: category.name,"subtitle":index==0?"Tous les documents":category.name}),
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
