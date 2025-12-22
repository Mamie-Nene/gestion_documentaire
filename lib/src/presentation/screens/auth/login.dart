import 'package:flutter/material.dart';

import '/src/presentation/widgets/custom_textfield.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _loginKey = GlobalKey<FormState>();
  final _usernameController=TextEditingController();
  final _passwordController=TextEditingController();
  bool _isPasswordVisible = false;
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor= MediaQuery.textScaleFactorOf(context);
    final size= MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xffEEF2F8),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height/6.4),// vertical 200, horizontal : 16
        child: SingleChildScrollView(
          child: Column( //listView
            children: [
              Container(
                height: size.height/10,
                // padding:const EdgeInsets.symmetric(horizontal: 16.0,),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.APP_LOGO),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.sizeboxHeight30,),

              Text(
                'Connexion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.loginTitleColor,
                  fontSize: textScaleFactor*20,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.20,
                ),
              ),

              SizedBox(height: AppDimensions.sizeboxHeight40,),

              Form(
                  key: _loginKey,
                  child: SizedBox(
                    width: size.width/1.6,
                    child:Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // spacing: size.height/31, //35,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //  spacing: size.height/70, // 12,
                            children: [
                              Text(
                                'Identifiant',
                                style: TextStyle(
                                  color: AppColors.labelTextColorForTextFormField,
                                  fontSize: textScaleFactor*20,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: size.height/70,),
                              CustomFormTextFieldForUsername(placeholder: 'Saisir', controller: _usernameController,),
                            ],
                          ),
                          SizedBox(height: size.height/31,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // spacing: size.height/70,//12,
                            children: [
                              Text(
                                'Mot de passe',
                                style: TextStyle(
                                  color: AppColors.labelTextColorForTextFormField,
                                  fontSize: textScaleFactor*20,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: size.height/70,),
                              CustomFormTextFieldForPassword(
                                placeholder: '*******',
                                controller: _passwordController,
                                passwordVisible:_isPasswordVisible,
                                action:IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ?Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.mainAppColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                    },
                                ),
                              ),
                            ],
                          ),
                        ]
                    ),
                  )
              ),

              SizedBox(height: AppDimensions.sizeboxHeight20,),

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: AppDimensions.sizeboxWidth65),
                  child: const Text(AppText.FORGET_PWD_TEXT,
                    style: TextStyle(
                      color: AppColors.secondAppColor,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.sizeboxHeight10 ),

              Container(
                width:size.width/1.5,
                // height:size.height/14,
                //  height: 85,
                height: size.height/11,
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 17),
                child:  TextButton(
                  style:TextButton.styleFrom(
                    backgroundColor: _isRunning? Colors.grey.shade400 :AppColors.mainAppColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color:_isRunning? Colors.grey : AppColors.mainAppColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed:(){Navigator.of(context).pushNamed(AppRoutesName.homePage);},

                  child: const Text(
                    'Se connecter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ) ;
  }


}
