

import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CustomFormTextFieldForUsername extends StatelessWidget {
  // final String labelText;
  final String placeholder;
  final TextEditingController controller;

  const CustomFormTextFieldForUsername( {super.key, required this.placeholder, required this.controller});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height/20,
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F6F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),

      child: TextFormField(
        // textAlign : TextAlign.center,
          controller: controller,
          keyboardType: TextInputType.text,
          inputFormatters:[FilteringTextInputFormatter.deny(RegExp(r'\s'))] ,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez remplir ce champs';
            }
            return null;
          },
          decoration:   InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding:  const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              hintStyle:  const TextStyle(
                color: const Color(0xFFAFB7C7),
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w500,
              ),
              hintText: placeholder
          )
      ),
    );
  }
}

class CustomFormTextFieldForPassword extends StatelessWidget {

  final String placeholder;
  final TextEditingController controller;
  final bool passwordVisible;
  final Widget action;

  const CustomFormTextFieldForPassword( {super.key, required this.placeholder, required this.controller, required this.passwordVisible, required this.action});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height/20,
      width: double.infinity,
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F6F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: TextFormField(
        // textAlign : TextAlign.center,
          controller: controller,
          keyboardType: TextInputType.text,
          inputFormatters:[FilteringTextInputFormatter.deny(RegExp(r'\s'))] ,
          obscureText: !passwordVisible,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez remplir ce champs';
            }
            return null;
          },
          decoration:   InputDecoration(
              suffixIcon:  action,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding:  EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              hintStyle:  const TextStyle(
                  color: const Color(0xFFAFB7C7),
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
              ),
              hintText : placeholder


          )
      ),
    );
  }
}

class CustomTextfieldForDate extends StatelessWidget {
  final TextEditingController dateController;
  final String textForBox;
  final String svgIcons;
  final VoidCallback? action;
  const CustomTextfieldForDate({Key? key, required this.dateController, required this.textForBox, required this.svgIcons,required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width/3,
      padding: EdgeInsets.only(top: 15,left: 10,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child:
      SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: [
                Text(textForBox,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                    readOnly: true,
                    controller: dateController,
                     style:const TextStyle(
                       fontSize: 15
                     ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplir ce champs';
                      }
                      return null;
                      },
                     decoration:  InputDecoration(

                       suffix:  SvgPicture.asset("asset/images/$svgIcons.svg",height: 11,),
                       border: OutlineInputBorder(borderSide: BorderSide.none),
                     ),
                    onTap: action
                  ),
              ],
            ),
          ),

      );
  }
}

class CustomTextfieldForAnnee extends StatelessWidget {
  final TextEditingController anneeController;
  final String textForBox;
  final String svgIcons;

  const CustomTextfieldForAnnee({Key? key, required this.anneeController, required this.textForBox, required this.svgIcons,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width/3,
      padding: EdgeInsets.only(top: 15,left: 10,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child:
      SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: [
                Text(textForBox,
                  textAlign : TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty ||value.length != 4) {
                      return 'Veuillez mettre une année valide!';
                    }
                    return null;
                  },
                  textAlign : TextAlign.center,
                  controller: anneeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter> [ FilteringTextInputFormatter.digitsOnly ],
                  style:const TextStyle(
                      fontSize: 15
                  ),
                  decoration:   InputDecoration(
                    suffix:  SvgPicture.asset("asset/images/$svgIcons.svg",height: 11,),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),

      );
  }
}

class CustomTextfieldForMois extends StatelessWidget {
  final TextEditingController moisController;
  final ValueChanged<String?>? action ;
  final String textForBox;
  final String svgIcons;

  const CustomTextfieldForMois({Key? key, required this.moisController, required this.textForBox, required this.svgIcons, this.action,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width/3,
      padding: EdgeInsets.only(top: 15,left: 10,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child:
      SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: [
                Text(textForBox,
                  textAlign : TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 12,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                 DropdownDatePicker(
                  inputDecoration:InputDecoration(
                    // suffix:  SvgPicture.asset("asset/images/$svgIcons.svg",height: 11,),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                    icon:Icon(Icons.date_range_outlined,size: 14,color: Colors.grey.shade500,),
                    textStyle:const TextStyle(fontSize: 15),
                  isDropdownHideUnderline: true,
                  isFormValidator: true,
                  // startYear: 2024,//endYear: 2024,
                  //width: 10,// selectedDay: 14,  // selectedYear: 2024,
                  selectedMonth: DateTime.now().month,
                  locale:'fr_FR',
                  // dayFlex:1,yearFlex:1,
                  monthFlex:1,
                  showDay: false,
                  showYear: false,
                  onChangedMonth: action

                ),
                /*TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty ||value.length != 4) {
                      return 'Veuillez mettre une année valide!';
                    }
                    return null;
                  },
                  textAlign : TextAlign.center,
                  controller: moisController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter> [ FilteringTextInputFormatter.digitsOnly ],
                  style:const TextStyle(
                      fontSize: 15
                  ),
                  decoration:   InputDecoration(
                    suffix:  SvgPicture.asset("asset/images/$svgIcons.svg",height: 11,),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),*/
              ],
            ),
          ),

      );
  }
}



