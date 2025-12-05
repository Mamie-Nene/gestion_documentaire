import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/data/remote/auth_api.dart';
import 'package:gestion_documentaire/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isRunning = false;




  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: _buildLoginCard(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(AppDimensions.paddingLarge + 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(AppDimensions.borderRadiusLarge + 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          /*Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.mainBackgroundColor,
              shape: BoxShape.circle,
            ),
            child:*/ Image.asset(
              AppImages.APP_LOGO,
              width: 200,
              height: 100,
            ),
          //),
          const SizedBox(height: AppDimensions.paddingLarge + 4),
          // Title
          Text(
            'Connexion',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.loginTitleColor,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            'Vos documents vous attendent',
            style: TextStyle(
              color: AppColors.textMainPageColor,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge + 8),
          // Email field
          Form(
              key: _loginKey,
              child:Column(
                children: [
                  _buildTextField(
                    label: 'Email professionnel',
                    icon: Icons.mail_outline_rounded,
                    controller: _emailController,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  // Password field
                  _buildTextField(
                    label: 'Mot de passe',
                    icon: Icons.lock_outline_rounded,
                    controller: _passwordController,
                    isPassword: true,
                  )
                ],
              )
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          // Remember me row
          _buildRememberRow(),
          const SizedBox(height: AppDimensions.paddingLarge + 4),
          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:_isRunning? null : () async {
                setState(() {
                  _isRunning=true;
                });
                if (_loginKey.currentState!.validate()) {
                  await AuthApi().loginRequest(context, _emailController.text, _passwordController.text, ApiUrl().getLoginUrl);
                }
                setState(() {
                  _isRunning=false;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingMedium + 2,
                ),
                backgroundColor: AppColors.mainAppColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusLarge),
                ),
              ),
              child: const Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          // Sign up row
         // _buildSignUpRow(context),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    final isObscured = isPassword && _obscurePassword;
    return TextField(
      controller: controller,
      obscureText: isObscured,
      style: TextStyle(
        color: AppColors.loginTitleColor,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.textMainPageColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.greyColorForIcon, size: 22),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.greyColorForIcon,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: AppColors.mainBackgroundColorForCustomTextField,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          borderSide: BorderSide(
            color: AppColors.mainAppColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingMedium,
        ),
      ),
    );
  }

  Widget _buildRememberRow() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) => setState(() => _rememberMe = value ?? false),
          activeColor: AppColors.mainAppColor,
          checkColor: Colors.white,
        ),
        Text(
          'Se souvenir de moi',
          style: TextStyle(
            color: AppColors.textMainPageColor,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            'Mot de passe oublié ?',
            style: TextStyle(
              color: AppColors.mainAppColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pas encore de compte ?",
          style: TextStyle(
            color: AppColors.textMainPageColor,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Créer un compte',
            style: TextStyle(
              color: AppColors.mainAppColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
