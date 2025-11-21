
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/src/utils/consts/app_specifications/app_colors.dart';
import '/src/utils/consts/app_specifications/app_dimensions.dart';


class AppResponseMessage  {

  Future<void> createToastMessage(Color textColor, String msg, Color backgroundColor) {
    return Fluttertoast.showToast(
        textColor: textColor,
        msg: msg,
        backgroundColor:backgroundColor,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0,
        gravity: ToastGravity.CENTER
    );
  }

  void errorMessage( String errorMessage){
    createToastMessage(Colors.white,errorMessage,AppColors.mainRedColor);
  }

  void successMessage(String? successMessage){
    createToastMessage(Colors.white,successMessage!,AppColors.mainGreenColor);
  }

  void loadingMessage(String waitingMessage){
    createToastMessage(AppColors.loginTitleColor,waitingMessage,Colors.white);
  }

  Future successAlertDialog(context,function,msg) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              content:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('asset/images/success.png',scale: 4,),
                  SizedBox(height: AppDimensions.sizeboxHeight30,),
                  Text(msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.black54,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )),
                  SizedBox(height: AppDimensions.sizeboxHeight40,),
                ],
              ),
            )
    );
  }

  Future waitAlertDialog(context,function,msg) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            AlertDialog(
              backgroundColor: Colors.white,

              content: SizedBox(
                width: 30,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [

                    CircularProgressIndicator(),
                    //Image.asset('asset/images/wired-outline-332-loader-3.webp',),
                    // SvgPicture.asset('asset/images/generic-loading-svgrepo-com.svg',),

                    SizedBox(width: AppDimensions.sizeboxWidth10,),

                    Text(msg,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black87,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        )
                    ),
                  ],
                ),
              ),
            )
    );
  }
  Future confirmAlertDialog(BuildContext context,String msg, String title,VoidCallback actionForYes) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
                insetPadding:EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  //side:  BorderSide(color: Color(0xFF2A8068)), //the outline color
                  borderRadius:  BorderRadius.circular(10),
                ),

                backgroundColor:Colors.white,

                // backgroundColor:Colors.grey.shade300,

                title:Text(title,
                    //textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    )
                ),
                content:  /*Column(
                mainAxisSize: MainAxisSize.min,
                children: [*/
                Text(msg,
                  //textAlign: TextAlign.center,
                  style:  TextStyle(
                    color: Colors.grey.shade800,
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0,
                  ),
                ),
                /*  Divider()
                ],
              ),*/

                actions: [
                  TextButton(
                      onPressed:actionForYes,
                      //onPressed:()=> Navigator.of(context).pushNamed(routeForYes),
                      child: Text('OUI',style: TextStyle(color:AppColors.mainAppColor,fontSize: MediaQuery.textScaleFactorOf(context)*17),)//20
                  ),
                  TextButton(
                    // onPressed:()=>Navigator.of(context).pop(),
                      onPressed:()=> Navigator.of(context).pop(false),
                      child: Text('NON',style: TextStyle(color:AppColors.mainAppColor,fontSize: MediaQuery.textScaleFactorOf(context)*17),)
                  )
                ],
                actionsAlignment: MainAxisAlignment.end
            )
    );
  }

}
