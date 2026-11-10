import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/state/app_state.dart';
import '../../core/widgets/pressable_scale.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit(AppState appState) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final isCafeOwner = appState.isCafeOwnerPhone(phone, name);

    _showVerificationModal(context, appState, isCafeOwner, name, phone);
  }

  void _showVerificationModal(
    BuildContext context,
    AppState appState,
    bool isCafeOwner,
    String name,
    String phone,
  ) {
    final isArabic = appState.strings.isArabic;
    final codeController = TextEditingController();
    bool hasError = false;
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5DDD3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCafeOwner
                            ? AppColors.espressoBrown.withValues(alpha: 0.12)
                            : AppColors.caramelAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCafeOwner ? Icons.lock_outline_rounded : Icons.mark_email_read_outlined,
                        color: isCafeOwner ? AppColors.espressoBrown : AppColors.caramelAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCafeOwner
                                ? (isArabic ? 'الرمز السري للفرع 🔒' : 'Branch Security PIN 🔒')
                                : (isArabic ? 'رمز التحقق السريع 📲' : 'Verification Code 📲'),
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.deepRoast,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isCafeOwner
                                ? (isArabic ? 'أدخل الرمز السري المعتمد للكافيه للمتابعة' : 'Enter registered café PIN code')
                                : (isArabic ? 'تم إرسال رمز تحقق سريع عبر رسالة SMS إلى $phone' : 'SMS verification code sent to $phone'),
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.coffeeMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Code Input Field
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  obscureText: isCafeOwner,
                  textAlign: TextAlign.center,
                  maxLength: 4,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 16,
                    color: AppColors.deepRoast,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '• • • •',
                    hintStyle: const TextStyle(letterSpacing: 16, color: Color(0xFFBCAAA4)),
                    filled: true,
                    fillColor: const Color(0xFFFAF8F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE8E0D5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: hasError ? AppColors.error : const Color(0xFFE8E0D5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: hasError ? AppColors.error : (isCafeOwner ? AppColors.espressoBrown : AppColors.caramelAccent),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                if (hasError && errorText != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    errorText!,
                    style: const TextStyle(color: AppColors.error, fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ],

                const SizedBox(height: 12),

                // Helper auto-fill note for smooth testing
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      codeController.text = '1234';
                      setModalState(() {
                        hasError = false;
                      });
                    },
                    icon: const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.caramelDark),
                    label: Text(
                      isArabic ? 'تعبئة الرمز تلقائياً (1234)' : 'Auto-fill code (1234)',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.caramelDark),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: PressableScale(
                    scaleFactor: 0.96,
                    onTap: () {
                      final code = codeController.text.trim();
                      final result = appState.verifyOtpOrPin(
                        name: name,
                        phone: phone,
                        code: code,
                      );

                      if (!result.success) {
                        setModalState(() {
                          hasError = true;
                          errorText = result.errorMessage;
                        });
                        return;
                      }

                      Navigator.pop(ctx);

                      if (result.infoMessage != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.infoMessage!),
                            backgroundColor: AppColors.espressoBrown,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.espressoBrown,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isArabic ? 'تأكيد ومتابعة' : 'Verify & Continue',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final isArabic = strings.isArabic;

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.espressoBrown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.coffee, color: AppColors.creamWhite, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'CupBack',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: AppColors.espressoBrown,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: ActionChip(
              avatar: const Icon(Icons.language, size: 16, color: AppColors.espressoBrown),
              label: Text(
                isArabic ? 'English' : 'عربي',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.espressoBrown,
                ),
              ),
              backgroundColor: AppColors.vanillaLatte.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.vanillaLatte.withValues(alpha: 0.6)),
              ),
              onPressed: () {
                appState.toggleLanguage();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Brand Logo & Welcome Section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.espressoBrown.withValues(alpha: 0.12),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'assets/images/cupback_logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.local_cafe_rounded,
                                size: 44,
                                color: AppColors.caramelAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strings.welcomeTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.espressoBrown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          strings.loginSubtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.espressoBrown.withValues(alpha: 0.75),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Login Form Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.vanillaLatte.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.espressoBrown.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.login_rounded,
                              size: 20,
                              color: AppColors.caramelAccent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              strings.loginTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.espressoBrown,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: AppColors.vanillaLatte),

                        // Name Field
                        _buildTextField(
                          controller: _nameController,
                          label: strings.nameLabel,
                          hint: strings.nameHint,
                          icon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return strings.validationNameRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Phone Field
                        _buildTextField(
                          controller: _phoneController,
                          label: strings.phoneLabel,
                          hint: strings.phoneHint,
                          icon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return strings.validationPhoneRequired;
                            }
                            final digits = value.replaceAll(RegExp(r'\D'), '');
                            if (digits.length < 9) {
                              return strings.validationPhoneInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 26),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => _handleSubmit(appState),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.espressoBrown,
                              foregroundColor: AppColors.creamWhite,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  strings.loginButton,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.creamWhite,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: AppColors.creamWhite,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.espressoBrown,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.espressoBrown,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13,
              color: AppColors.espressoBrown.withValues(alpha: 0.4),
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: AppColors.caramelAccent,
            ),
            filled: true,
            fillColor: AppColors.creamWhite,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.vanillaLatte.withValues(alpha: 0.8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.vanillaLatte.withValues(alpha: 0.8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.caramelAccent, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
