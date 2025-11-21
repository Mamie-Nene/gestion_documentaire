
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
}
