class AppStrings {
  final String languageCode;

  const AppStrings(this.languageCode);

  bool get isArabic => languageCode == 'ar';

  // App General
  String get appName => 'CupBack';
  String get appSlogan => isArabic
      ? 'اشرب • جمّع • استبدل'
      : 'Drink · Earn · Return';

  // Onboarding & Role Selection
  String get welcomeTitle => isArabic
      ? 'مرحبًا بك في CupBack'
      : 'Welcome to CupBack';
  String get welcomeSubtitle => isArabic
      ? 'منصة ولاء وطلبات المقاهي الذكية في مصر'
      : 'The smart café loyalty & ordering platform in Egypt';
  String get selectRolePrompt => isArabic
      ? 'حدد نوع الحساب للمتابعة:'
      : 'Select account type to continue:';

  // Login & Authentication
  String get loginTitle => isArabic ? 'تسجيل الدخول' : 'Sign In';
  String get loginSubtitle => isArabic
      ? 'سجّل اسمك ورقم هاتفك للوصول لحسابك والاستمتاع بمكافآت القهوة'
      : 'Enter your name & phone to access your account & rewards';
  String get loginButton => isArabic ? 'دخول إلى CupBack' : 'Enter CupBack';
  String get cafeOwnerAutoLoginNote => isArabic
      ? 'ملاحظة: حسابات أصحاب المقاهي يتم اعتمادها مسبقاً من قِبل إدارة التطبيق، والدخول تلقائي برقم الهاتف المعتمد.'
      : 'Note: Café partner accounts are pre-registered by administration, and access their dashboard automatically by phone number.';

  String get roleCustomerDesc => isArabic
      ? 'اطلب قهوتك، جمّع أكواب ورميات، واستبدل الهدايا والعروض.'
      : 'Order coffee, collect stamps & cups, and redeem exclusive rewards.';

  String get roleBusinessTitle => isArabic ? 'صاحب كافيه / بيزنيس' : 'Café Owner / Business';
  String get roleBusinessDesc => isArabic
      ? 'انضم لشبكة كافيهات CupBack، واستقبل طلبات وجمّع زبائنك.'
      : 'Join CupBack partner network, get orders & build customer loyalty.';

  // Fields
  String get nameLabel => isArabic ? 'الاسم بالكامل' : 'Full Name';
  String get nameHint => isArabic ? 'مثال: أحمد محمود' : 'e.g. Ahmed Mahmoud';
  String get phoneLabel => isArabic ? 'رقم الهاتف' : 'Phone Number';
  String get phoneHint => isArabic ? 'مثال: 01012345678' : 'e.g. 01012345678';
  String get businessNameLabel => isArabic ? 'اسم الكافيه / البيزنيس' : 'Café / Business Name';
  String get businessNameHint => isArabic ? 'مثال: مقهى الزيتون' : 'e.g. Zeitoun Café';
  String get ownerContactLabel => isArabic ? 'رقم التواصل مع الأونر (واتساب / هاتف)' : 'Owner Contact Number (WhatsApp / Phone)';
  String get ownerContactHint => isArabic ? 'رقم مباشر للتواصل والتفعيل' : 'Direct number for verification';
  String get ownerContactNote => isArabic
      ? 'سيتواصل معك فريق CupBack هاتفياً أو عبر الواتساب لتأكيد التعاقد وتفعيل الحساب.'
      : 'Our CupBack team will contact you directly to verify & activate your café account.';

  // Buttons
  String get continueAsCustomer => isArabic ? 'دخول إلى CupBack' : 'Enter CupBack';
  String get submitBusinessApplication => isArabic ? 'إرسال طلب الانضمام والتفعيل' : 'Submit Partner Application';
  String get languageToggle => isArabic ? 'English' : 'عربي';

  // Validation
  String get validationNameRequired => isArabic ? 'يرجى إدخال الاسم' : 'Please enter your name';
  String get validationPhoneRequired => isArabic ? 'يرجى إدخال رقم الهاتف' : 'Please enter your phone number';
  String get validationPhoneInvalid => isArabic ? 'يرجى إدخال رقم هاتف صحيح (11 رقم)' : 'Please enter a valid phone number';
  String get validationBusinessNameRequired => isArabic ? 'يرجى إدخال اسم الكافيه' : 'Please enter your café name';
  String get validationOwnerContactRequired => isArabic ? 'يرجى إدخال رقم التواصل للتفعيل' : 'Please enter the owner contact number';

  // Pending Activation Screen
  String get pendingTitle => isArabic ? 'طلبك قيد المراجعة والتفعيل' : 'Application Under Review';
  String get pendingSubtitle => isArabic
      ? 'تم تسجيل بيانات كافيهك بنجاح وسنقوم بالتواصل معك لتفعيله.'
      : 'Your café registration has been received. We will contact you to activate it.';
  String get pendingStatusBadge => isArabic ? 'قيد التدقيق والتفعيل' : 'Pending Activation';
  String get registeredDetailsTitle => isArabic ? 'بيانات الكافيه المسجلة:' : 'Registered Café Details:';
  String get cafeNameText => isArabic ? 'اسم الكافيه:' : 'Café Name:';
  String get ownerNameText => isArabic ? 'المسؤول / المالك:' : 'Owner Name:';
  String get contactPhoneText => isArabic ? 'رقم التواصل:' : 'Contact Phone:';
  String get submissionDateText => isArabic ? 'تاريخ التقديم:' : 'Submission Date:';
  String get stepsTitle => isArabic ? 'الخطوات التالية لتفعيل الكافيه:' : 'Next steps to activate your café:';
  String get step1 => isArabic
      ? 'مراجعة بيانات الكافيه وقائمة المشروبات من قبل فريق CupBack.'
      : 'Review of café details and menu by the CupBack onboarding team.';
  String get step2 => isArabic
      ? 'مكالمة هاتفية أو رسالة واتساب للتحقق من هوية المالك وتحديد نسبة الخصم أو الرميات.'
      : 'Verification phone call or WhatsApp message to set up loyalty rules & discounts.';
  String get step3 => isArabic
      ? 'تفعيل لوحة تحكم الكافيه لاستقبال الطلبات وتأكيد أكواب الزبائن.'
      : 'Full activation of your Café Dashboard to process orders and loyalty stamps.';

  String get contactSupportBtn => isArabic ? 'تواصل مع إدارة CupBack واتساب' : 'Contact CupBack Support via WhatsApp';
  String get securityNotice => isArabic
      ? 'لحماية أمان وسرية بيانات الكافيهات المشتركة، تظل لوحة التحكم مغلقة تماماً حتى اكتمال التدقيق والتفعيل المباشر من إدارة CupBack.'
      : 'For security and confidentiality, the dashboard remains strictly locked until official verification and activation by CupBack.';
  String get switchOrLogoutBtn => isArabic ? 'تسجيل الخروج / تبديل الحساب' : 'Logout / Switch Account';

  // Café Dashboard Strings
  String get cafeDashboardTitle => isArabic ? 'لوحة تحكم الكافيه' : 'Café Partner Portal';
  String get cafeActiveStatus => isArabic ? 'الحساب مفعّل ونشط' : 'Account Active';
  String get scanQrCustomer => isArabic ? 'مسح QR العميل لتسجيل كوب' : 'Scan Customer QR for Stamp';
  String get incomingOrders => isArabic ? 'الطلبات الواردة' : 'Incoming Orders';
  String get todayStats => isArabic ? 'إحصائيات اليوم' : "Today's Summary";
  String get cupsEarnedToday => isArabic ? 'أكواب مسجلة اليوم' : 'Cups Stamped Today';
  String get rewardsRedeemedToday => isArabic ? 'مكافآت مستبدلة' : 'Rewards Redeemed';
  String get revenueToday => isArabic ? 'إجمالي المبيعات' : 'Total Revenue';
}
