import { useMemo, useState } from 'react';
import {
  exportCustomersToExcel,
  exportCustomersToCSV,
  exportSalesToExcel,
  exportOrdersToExcel,
  exportOrdersToCSV,
} from './utils/exporters.js';

const dict = {
  ar: {
    dashboard: 'الرئيسية',
    orders: 'الطلبات',
    menu: 'المنيو والمخزون',
    customers: 'العملاء',
    offers: 'الخصومات والعروض',
    proximity: 'إشعارات القرب الذكية',
    loyalty: 'برامج الولاء',
    staff: 'الموظفون',
    payroll: 'الرواتب والدفعات',
    branding: 'صفحة الكافيه',
    reports: 'تقارير المبيعات',
    settings: 'إعدادات الكافيه',
    cafeGroup: 'المقهى',
    marketingGroup: 'التسويق والنمو',
    teamGroup: 'إدارة الفريق',
    brandingGroup: 'الهوية والتقارير',
    newBadge: 'جديد',
    demoNotice: 'نسخة تفاعلية · بيانات متصلة محلياً',
    cafeName: 'مقهى الزيتون',
    branchName: 'فرع كفر الشيخ (شارع الجيش)',
    helpTitle: 'محتاج مساعدة؟',
    helpSub: 'فريق CupBack معاك',
    ownerName: 'طارق عبد الله',
    ownerRole: 'مالك الكافيه',
    todayDate: 'الأربعاء، ١١ نوفمبر ٢٠٢٦',
    bannerNotice: 'أنت تتصفح نسخة تفاعلية متكاملة باللغتين العربية والإنجليزية',
    bannerSub: 'جميع الإجراءات (إضافة وحذف وتعديل الطلبات والمنيو وإشعارات القرب وحالة الكافيه) تعمل فورياً.',
    aboutDemo: 'عن النسخة',
    notificationsTitle: 'التنبيهات التشغيلية',
    markAllRead: 'تمييز الكل كمقروء',

    // Dashboard
    dashEyebrow: 'لوحة التحكم الفورية · الأربعاء، ١١ نوفمبر ٢٠٢٦',
    dashTitle: 'صباح الخير يا طارق ☕',
    dashDesc: 'نظرة شاملة ومباشرة على تشغيل كافيهك، المبيعات اللحظية، والطلبات قيد الإنجاز.',
    quickOrderBtn: '＋ طلب كاشير سريع',
    addMenuItemBtn: '＋ إضافة صنف للمنيو',
    viewReportsBtn: 'التقارير المالية',
    shiftActive: 'شيفت الصباح نشط · مقهى الزيتون',
    shiftClosed: 'الكافيه غير متاح لاستقبال الطلبات',
    goodCoffeeDay: 'النهارده يوم مثالي للقهوة.',
    ordersPaused: 'استقبال الطلبات متوقف حالياً.',
    branchStatusLabel: 'حالة الفرع للعملاء في التطبيق:',
    editCafeStatus: 'تعديل حالة الكافيه ⚙',
    proxWidgetTitle: 'حملة إشعار القرب نشطة: سموزي البلوبري في وقت الحر',
    proxWidgetTime: '١:٣٠ م — ٤:٣٠ م',
    proxWidgetSent: 'تم تسليم {n} إشعار بنجاح للعملاء المارين في نطاق ٢٠٠ متر من مقهاك اليوم.',
    previewNotifBtn: 'معاينة الإشعار 📱',
    manageCampBtn: 'إدارة الحملة ←',
    stockAlertTitle: 'تنبيه مخزون: صنف "{name}" غير متوفر',
    stockAlertDesc: 'العملاء لا يمكنهم طلب هذا الصنف حالياً من تطبيق الهاتف.',
    restoreStockBtn: 'إعادة التوفر فوراً ✓',
    stockOkTitle: 'جاهزية المنيو والمخزون',
    stockOkDesc: 'جميع أصناف المنيو الـ {n} متوفرة وجاهزة للطلب بدون أي نواقص.',
    viewMenuBtn: 'المنيو والمخزون ←',
    perfTitle: 'ملخص الأداء والمبيعات',
    perfSub: 'أرقام كافيهك المحدثة لحظة بلحظة خلال ({range})',
    rangeToday: 'اليوم (ساعات اليوم)',
    rangeWeek: 'آخر ٧ أيام (الأسبوع)',
    rangeMonth: 'هذا الشهر (نوفمبر ٢٠٢٦)',
    todaySales: 'مبيعات اليوم',
    weekSales: 'مبيعات الأسبوع',
    monthSales: 'مبيعات الشهر',
    totalOrders: 'عدد الطلبات',
    avgOrder: 'متوسط قيمة الطلب',
    discountsApplied: 'قيمة الخصومات',
    salesTrendTitle: 'حركة المبيعات والطلب',
    salesTrendSub: 'توزيع المبيعات خلال',
    detailedReport: 'التقرير المفصل <b>←</b>',
    topSellingTitle: 'الأصناف الأكثر طلباً',
    topSellingSub: 'المنتجات المتصدرة المبيعات',
    fullMenuLink: 'المنيو بالكامل <b>←</b>',
    liveOrdersTitle: 'الطلبات المباشرة وقيد التنفيذ',
    liveOrdersSub: 'تابع الطلبات واتخذ الإجراء الفوري من هنا',
    allOrdersLink: 'كل الطلبات',

    // Orders Page
    ordersEyebrow: 'التشغيل اليومي وإدارة البار',
    ordersMainTitle: 'إدارة الطلبات المباشرة',
    ordersMainDesc: 'متابعة لحظية لطلبات العملاء، التحكم في سرعة التحضير للباريستا، وتسليم الطلبات فور جاهزيتها.',
    ordersKpiTotal: 'إجمالي الطلبات',
    ordersKpiNew: 'طلبات جديدة تحتاج استجابة',
    ordersKpiPrep: 'قيد التحضير في البار',
    ordersKpiReady: 'جاهزة للاستلام فوراً',
    ordersSearchPlaceholder: 'ابحث برقم الطلب، اسم العميل، أو المشروب...',
    refreshBtn: '↻ تحديث لحظي',
    periodFilter: 'الفترة الزمنية:',
    periodToday: 'طلبات اليوم',
    periodYesterday: 'أمس',
    periodWeek: 'آخر ٧ أيام',
    periodMonth: 'هذا الشهر (نوفمبر)',
    periodAll: 'كل الفترات',
    todayOrdersStat: 'طلبات اليوم الحالي:',
    todayOrdersCountBadge: 'عدد اليوم: {n} طلب',
    todaySalesStat: 'مبيعات اليوم:',
    periodOrdersCount: 'طلبات الفترة:',
    periodSalesCount: 'مبيعات الفترة:',
    filterAll: 'الكل',
    filterNew: 'طلب جديد',
    filterPrep: 'قيد التحضير',
    filterReady: 'جاهز للاستلام',
    filterDone: 'مكتمل',
    filterRejected: 'مرفوض',
    thOrder: 'رقم الطلب',
    thCustomer: 'العميل',
    thItems: 'الأصناف المطلوبة',
    thTime: 'الوقت',
    thTotal: 'الإجمالي',
    thStatus: 'الحالة',
    thAction: 'الإجراء المباشر',
    thBill: 'الفاتورة',
    actAccept: 'قبول وتحضير ✓',
    actReject: 'رفض ✕',
    actReady: 'جاهز للاستلام 🔔',
    actDeliver: 'تسليم للعميل ✓',
    actCompleted: 'مكتمل ومسلّم',
    actViewBill: 'الفاتورة ↗',

    // Menu & Stock Page
    menuEyebrow: 'إدارة المنتجات والمخزون الحي',
    menuMainTitle: 'المنيو وقائمة المشروبات والمخبوزات',
    menuMainDesc: 'تحكم فوري في أصناف كافيهك، الأسعار، التوفر اللحظي للعملاء على التطبيق، مع تنبيهات النواقص وإمكانية التوفير بنقرة واحدة.',
    menuKpiTotal: 'إجمالي أصناف المنيو',
    menuKpiReady: 'جاهزية المنيو للطلب',
    menuKpiReadySub: 'أصناف متوفرة للعملاء الآن',
    menuKpiStockAlert: 'تنبيه النواقص (نفد المخزون)',
    menuKpiStockAlertSub: 'أصناف معطلة على تطبيق العميل',
    menuKpiStar: 'الصنف الأعلى مبيعاً اليوم 🔥',
    menuRestockAll: '⚡ توفير وتنشيط كل النواقص فوراً',
    menuRestockAllDone: 'تم تنشيط وتوفير جميع الأصناف في المنيو بنجاح',
    menuSearchPlaceholder: 'ابحث باسم الصنف (عربي/إنجليزي)، التصنيف، أو السعر...',
    menuSortPopular: 'الأكثر طلباً ومبيعاً 🔥',
    menuSortPriceAsc: 'السعر: من الأقل للأعلى',
    menuSortPriceDesc: 'السعر: من الأعلى للأقل',
    menuSortInStock: 'المتوفر أولاً ✓',
    menuViewGrid: '▦ شبكة البطاقات',
    menuViewTable: '☷ جدول تفصيلي',
    menuAddProduct: '＋ إضافة صنف جديد للمنيو',
    catAll: 'الكل',
    catHotCoffee: '☕ قهوة ساخنة',
    catColdCoffee: '🧊 قهوة باردة ومثلجة',
    catSmoothies: '🫐 سموزي وعصائر',
    catBakery: '🥐 مخبوزات وحلويات',
    catSpecialty: '🍵 ماتشا وسبيشالتي',
    catOutOfStock: '⚡ النواقص فقط',
    catBestSellers: '🔥 الأكثر طلباً',
    statusInStock: 'متوفر للطلب',
    statusOutOfStock: 'نفد من المخزون',
    toggleToOutOfStock: 'تحويل إلى نفد',
    toggleToInStock: 'إعادة التوفير للطلب',
    bestSellerBadge: 'الأكثر طلباً 🔥',
    editProductBtn: 'تعديل الصنف ✎',
    deleteProductBtn: 'حذف',
    salesCountLabel: 'طلب تم بيعه اليوم',
    costMarginLabel: 'هامش الربح',
    calorieLabel: 'سعرة',
    actionsCol: 'الإجراءات',

    // Customers & CRM Page
    custEyebrow: 'علاقات العملاء ونظام الولاء',
    custMainTitle: 'عملاء كافيهك وسجل الولاء',
    custMainDesc: 'تعرف على تفضيلات عملائك، تتبع معدل زياراتهم، كافئ زوارك الدائمين، وأعد تنشيط العملاء الغائبين بعروض فورية.',
    custKpiTotal: 'إجمالي قاعدة العملاء',
    custKpiTotalSub: 'عميل مسجل في CupBack',
    custKpiVip: 'عملاء دائمون و VIP',
    custKpiVipSub: 'معدل ولاء واحتفاظ ٨٦٪',
    custKpiActiveOffers: 'خصومات ومكافآت نشطة',
    custKpiActiveOffersSub: 'عروض فردية وجماعية فعالة',
    custKpiLtv: 'متوسط إنفاق العميل (LTV)',
    custKpiLtvSub: '٣٫٢ طلب أسبوعياً لكل عميل',
    custExportBtn: '↓ تصدير بيانات العملاء',
    custExportDone: 'تم تصدير ملف بيانات العملاء بنجاح (CSV)',
    custNewDiscountBtn: '＋ إنشاء خصم موجه',
    custAddManualBtn: '＋ إضافة عميل جديد',
    custSearchPlaceholder: 'ابحث بالاسم، الإنجليزي، الهاتف، أو المشروب المفضل...',
    custSortSpentDesc: 'الأعلى إنفاقاً (VIP أولاً)',
    custSortOrdersDesc: 'الأكثر طلباً وزيارات',
    custSortRecent: 'الأحدث زيارة وطلباً',
    custSortName: 'أبجدياً بالاسم',
    segAll: 'كل العملاء',
    segVip: '💎 عملاء VIP ودائمون',
    segReturning: '🔄 عملاء عائدون',
    segNew: '🌱 عملاء جدد',
    segAtRisk: '💤 عملاء غائبون (يحتاجون تنشيط)',
    segWithDiscount: '🎁 أصحاب الخصومات',
    thCustName: 'العميل',
    thCustOrders: 'عدد الطلبات',
    thCustSpent: 'إجمالي الإنفاق',
    thCustLast: 'آخر طلب',
    thCustSegment: 'الشريحة والولاء',
    thCustFav: 'المشروب المفضل',
    thCustDiscount: 'الخصم / المكافأة',
    thCustActions: 'الإجراء',
    btnViewCust: 'عرض الملف 👤',
    noDiscount: 'لا يوجد',
    freeDrink: 'مشروب مجاني',
    dormantAlertTitle: 'عملاء غائبون لم يزورونا منذ فترة',
    dormantAlertText: 'لديك عملاء لم يزوروا الفرع منذ أكثر من شهر، أرسل لهم كود خصم لعودتهم فوراً.',
    reengageBtn: '🚀 إرسال كود ترحيبي للغائبين',

    // Proximity Page
    proxEyebrow: 'التسويق المكاني والذكاء الاصطناعي',
    proxMainTitle: 'إشعارات القرب الذكية (Geofencing)',
    proxMainDesc: 'أرسل إشعاراً ذكياً بهاتف العميل تلقائياً عند مروره بالقرب من فرع كافيهك مع مراعاة التوقيت، الطقس، وحدود الأدمن لمنع الإزعاج.',
    proxPreviewPhoneBtn: '📱 معاينة إشعار السموزي على الهاتف',
    proxNewCampBtn: '＋ إنشاء حملة اقتراب جديدة',
    proxPolicyHeader: 'ضوابط منصة CupBack الذكية (متوافقة 100% مع سياسات المتاجر والخصوصية):',
    proxCap: 'سقف العميل: أقصى حد ٣ إشعارات يومياً من كل المنصة',
    proxCooldown: 'فترة التهدئة: ٨ ساعات فاصل زمني إلزامي بين أي إشعارين',
    proxQuota: 'كوتة الكافيه: إشعار ١ فقط يومياً لكل عميل من مقهاك',
    proxLocalCache: 'تخزين محلي آمن: بدون تتبع GPS مستمر أو رفع موقع العميل',
    proxStatDelivered: 'إشعارات تم تسليمها',
    proxStatDeliveredNote: 'محلياً عند الاقتراب',
    proxStatOpenRate: 'معدل الفتح والتفاعل',
    proxStatOpenNote: '٩٧ عميل فتحوا العرض',
    proxStatActiveCamps: 'حملات الاقتراب النشطة',
    proxStatActiveNote: 'معتمدة وجاهزة للعمل',
    proxStatRevenue: 'مبيعات ناتجة',
    proxStatRevenueNote: 'من عروض الاقتراب',
    proxBubbleNotice: '📱 نص التنبيه الظاهر للعميل:',
    proxTimeWindow: '⏰ الموعد:',
    proxRadius: '🎯 النطاق:',
    proxAudience: '👥 الشريحة:',
    proxPerf: '📊 الأداء:',
    proxPreviewMobile: '📱 معاينة الهاتف',
    proxPauseCamp: 'إيقاف مؤقت',
    proxResumeCamp: 'تفعيل الحملة',
    proxEditCamp: 'تعديل البيانات',
    currency: 'ج.م',
  },
  en: {
    dashboard: 'Dashboard',
    orders: 'Orders',
    menu: 'Menu & Stock',
    customers: 'Customers',
    offers: 'Offers & Discounts',
    proximity: 'Smart Proximity',
    loyalty: 'Loyalty Programs',
    staff: 'Staff & Roles',
    payroll: 'Payroll & Cash',
    branding: 'Cafe Profile',
    reports: 'Sales Reports',
    settings: 'Settings',
    cafeGroup: 'Cafe',
    marketingGroup: 'Marketing & Growth',
    teamGroup: 'Team Management',
    brandingGroup: 'Brand & Reports',
    newBadge: 'NEW',
    demoNotice: 'Interactive Prototype · Local Data',
    cafeName: 'Al-Zaytoun Cafe',
    branchName: 'Kafr El-Sheikh (Army St.)',
    helpTitle: 'Need assistance?',
    helpSub: 'CupBack team is here',
    ownerName: 'Tarek Abdullah',
    ownerRole: 'Cafe Owner',
    todayDate: 'Wednesday, Nov 11, 2026',
    bannerNotice: 'You are viewing a fully interactive bilingual version (Arabic & English)',
    bannerSub: 'All CRUD actions (add, edit, delete orders, menu items, proximity notifications, and cafe status) work instantly.',
    aboutDemo: 'About Demo',
    notificationsTitle: 'Operational Alerts',
    markAllRead: 'Mark all as read',

    // Dashboard
    dashEyebrow: 'Real-time Operations · Wednesday, Nov 11, 2026',
    dashTitle: 'Good Morning, Tarek ☕',
    dashDesc: 'Live overview of your cafe operations, real-time revenue, and order progress.',
    quickOrderBtn: '＋ Quick POS Order',
    addMenuItemBtn: '＋ Add Menu Item',
    viewReportsBtn: 'Financial Reports',
    shiftActive: 'Morning Shift Active · Al-Zaytoun Cafe',
    shiftClosed: 'Orders are currently closed',
    goodCoffeeDay: 'Today is a great day for coffee.',
    ordersPaused: 'Order intake is currently paused.',
    branchStatusLabel: 'Branch status for customers in app:',
    editCafeStatus: 'Edit Cafe Status ⚙',
    proxWidgetTitle: 'Active Proximity Campaign: Blueberry Smoothie Rush',
    proxWidgetTime: '1:30 PM — 4:30 PM',
    proxWidgetSent: '{n} notifications delivered to customers within 200m radius today.',
    previewNotifBtn: 'Preview Notification 📱',
    manageCampBtn: 'Manage Campaign →',
    stockAlertTitle: 'Stock Alert: Item "{name}" is Out of Stock',
    stockAlertDesc: 'Customers cannot order this item in the mobile app right now.',
    restoreStockBtn: 'Restore Stock Now ✓',
    stockOkTitle: 'Menu & Inventory Ready',
    stockOkDesc: 'All {n} menu items are in stock and ready to order.',
    viewMenuBtn: 'Menu & Stock →',
    perfTitle: 'Sales & Performance Summary',
    perfSub: 'Real-time metrics updated for ({range})',
    rangeToday: 'Today (Hourly)',
    rangeWeek: 'Last 7 Days (Weekly)',
    rangeMonth: 'This Month (Nov 2026)',
    todaySales: "Today's Sales",
    weekSales: 'Weekly Sales',
    monthSales: 'Monthly Sales',
    totalOrders: 'Total Orders',
    avgOrder: 'Avg Order Value',
    discountsApplied: 'Total Discounts',
    salesTrendTitle: 'Sales & Demand Trend',
    salesTrendSub: 'Sales distribution over',
    detailedReport: 'Detailed Report <b>→</b>',
    topSellingTitle: 'Top Selling Items',
    topSellingSub: 'Highest performing products',
    fullMenuLink: 'Full Menu <b>→</b>',
    liveOrdersTitle: 'Live Orders Feed',
    liveOrdersSub: 'Monitor orders and take instant action here',
    allOrdersLink: 'All Orders',

    // Orders Page
    ordersEyebrow: 'Daily Operations & Barista Workflow',
    ordersMainTitle: 'Live Orders Management',
    ordersMainDesc: 'Real-time tracking of customer orders, preparation workflow, and instant pickup dispatch.',
    ordersKpiTotal: 'Total Today Orders',
    ordersKpiNew: 'New Orders (Action Needed)',
    ordersKpiPrep: 'In Barista Preparation',
    ordersKpiReady: 'Ready for Pickup Now',
    ordersSearchPlaceholder: 'Search by order #, customer name, or drink...',
    refreshBtn: '↻ Live Refresh',
    periodFilter: 'Time Period:',
    periodToday: "Today's Orders",
    periodYesterday: 'Yesterday',
    periodWeek: 'Last 7 Days',
    periodMonth: 'This Month (Nov)',
    periodAll: 'All Time',
    todayOrdersStat: "Today's Orders Count:",
    todayOrdersCountBadge: "Today: {n} orders",
    todaySalesStat: "Today's Sales:",
    periodOrdersCount: 'Period Orders:',
    periodSalesCount: 'Period Sales:',
    filterAll: 'All',
    filterNew: 'New Order',
    filterPrep: 'Preparing',
    filterReady: 'Ready',
    filterDone: 'Completed',
    filterRejected: 'Rejected',
    thOrder: 'Order #',
    thCustomer: 'Customer',
    thItems: 'Items Ordered',
    thTime: 'Time',
    thTotal: 'Total',
    thStatus: 'Status',
    thAction: 'Quick Action',
    thBill: 'Receipt',
    actAccept: 'Accept & Prepare ✓',
    actReject: 'Reject ✕',
    actReady: 'Ready for Pickup 🔔',
    actDeliver: 'Deliver to Customer ✓',
    actCompleted: 'Delivered & Done',
    actViewBill: 'Receipt ↗',

    // Menu & Stock Page
    menuEyebrow: 'Live Catalog & Inventory Management',
    menuMainTitle: 'Menu & Beverage Catalog',
    menuMainDesc: 'Full real-time control over item pricing, stock availability, category curation, and instant out-of-stock recovery.',
    menuKpiTotal: 'Total Menu Items',
    menuKpiReady: 'Menu Readiness Rate',
    menuKpiReadySub: 'active items ready for customers',
    menuKpiStockAlert: 'Out of Stock Alert',
    menuKpiStockAlertSub: 'disabled items on mobile app',
    menuKpiStar: 'Top Best-Seller Today 🔥',
    menuRestockAll: '⚡ Restock & Enable All Items Now',
    menuRestockAllDone: 'All menu items have been successfully marked as in stock',
    menuSearchPlaceholder: 'Search by item name (Ar/En), category, or price...',
    menuSortPopular: 'Best Sellers & Popular 🔥',
    menuSortPriceAsc: 'Price: Low to High',
    menuSortPriceDesc: 'Price: High to Low',
    menuSortInStock: 'In-Stock First ✓',
    menuViewGrid: '▦ Cards Grid',
    menuViewTable: '☷ Detailed Table',
    menuAddProduct: '＋ Add New Menu Item',
    catAll: 'All Items',
    catHotCoffee: '☕ Hot Coffee',
    catColdCoffee: '🧊 Iced Coffee',
    catSmoothies: '🫐 Smoothies & Juices',
    catBakery: '🥐 Bakery & Desserts',
    catSpecialty: '🍵 Matcha & Specialty',
    catOutOfStock: '⚡ Out of Stock',
    catBestSellers: '🔥 Best Sellers',
    statusInStock: 'In Stock',
    statusOutOfStock: 'Out of Stock',
    toggleToOutOfStock: 'Mark as Out',
    toggleToInStock: 'Mark as In Stock',
    bestSellerBadge: 'Best Seller 🔥',
    editProductBtn: 'Edit Item ✎',
    deleteProductBtn: 'Delete',
    salesCountLabel: 'orders sold today',
    costMarginLabel: 'Profit Margin',
    calorieLabel: 'kcal',
    actionsCol: 'Actions',

    // Customers & CRM Page
    custEyebrow: 'Customer Relations & Loyalty CRM',
    custMainTitle: 'Cafe Customers & Loyalty Registry',
    custMainDesc: 'Understand your patrons, monitor visit cadence, reward VIP regulars, and re-engage dormant customers with tailored offers.',
    custKpiTotal: 'Total Customer Base',
    custKpiTotalSub: 'registered CupBack patrons',
    custKpiVip: 'VIP & Loyal Regulars',
    custKpiVipSub: '86% retention & loyalty rate',
    custKpiActiveOffers: 'Active Rewards & Perks',
    custKpiActiveOffersSub: 'individual & group discounts',
    custKpiLtv: 'Avg Customer Spend (LTV)',
    custKpiLtvSub: '3.2 orders weekly per customer',
    custExportBtn: '↓ Export Customer Directory',
    custExportDone: 'Customer directory exported successfully (CSV)',
    custNewDiscountBtn: '＋ Grant Custom Discount',
    custAddManualBtn: '＋ Add New Customer',
    custSearchPlaceholder: 'Search by name, English, phone, or favorite drink...',
    custSortSpentDesc: 'Highest Spenders (VIP first)',
    custSortOrdersDesc: 'Most Orders & Visits',
    custSortRecent: 'Most Recent Visit',
    custSortName: 'Alphabetical (A-Z)',
    segAll: 'All Patrons',
    segVip: '💎 VIP & Loyal',
    segReturning: '🔄 Returning',
    segNew: '🌱 New Customers',
    segAtRisk: '💤 Dormant (At Risk)',
    segWithDiscount: '🎁 With Active Offer',
    thCustName: 'Customer',
    thCustOrders: 'Orders',
    thCustSpent: 'Total Spend',
    thCustLast: 'Last Order',
    thCustSegment: 'Segment & Loyalty',
    thCustFav: 'Favorite Drink',
    thCustDiscount: 'Active Reward',
    thCustActions: 'Action',
    btnViewCust: 'View Profile 👤',
    noDiscount: 'None',
    freeDrink: 'Free Drink',
    dormantAlertTitle: 'Dormant Customers Need Re-engagement',
    dormantAlertText: 'You have customers who have not visited in over a month. Send them a welcome back discount code.',
    reengageBtn: '🚀 Send Welcome Back Offer',

    // Proximity Page
    proxEyebrow: 'Location Marketing & AI',
    proxMainTitle: 'Smart Proximity Notifications (Geofencing)',
    proxMainDesc: 'Automatically trigger personalized offers on customer phones when walking near your cafe, respecting quiet hours and anti-spam limits.',
    proxPreviewPhoneBtn: '📱 Preview Smoothie Notification',
    proxNewCampBtn: '＋ New Proximity Campaign',
    proxPolicyHeader: 'CupBack Platform Smart Governance (100% App Store & Privacy Compliant):',
    proxCap: 'Customer Cap: Max 3 notifications daily platform-wide',
    proxCooldown: 'Cooldown: Mandatory 8-hour gap between any 2 notifications',
    proxQuota: 'Cafe Quota: Exactly 1 notification daily per customer from your cafe',
    proxLocalCache: 'Safe Local Cache: No continuous GPS tracking or live location uploads',
    proxStatDelivered: 'Delivered Notifications',
    proxStatDeliveredNote: 'Locally on proximity',
    proxStatOpenRate: 'Open & Engagement Rate',
    proxStatOpenNote: '97 customers opened offer',
    proxStatActiveCamps: 'Active Proximity Campaigns',
    proxStatActiveNote: 'Approved & ready to trigger',
    proxStatRevenue: 'Generated Revenue',
    proxStatRevenueNote: 'from proximity promotions',
    proxBubbleNotice: '📱 Notification Text Preview:',
    proxTimeWindow: '⏰ Window:',
    proxRadius: '🎯 Radius:',
    proxAudience: '👥 Audience:',
    proxPerf: '📊 Performance:',
    proxPreviewMobile: '📱 Mobile Preview',
    proxPauseCamp: 'Pause Campaign',
    proxResumeCamp: 'Activate Campaign',
    proxEditCamp: 'Edit Campaign',
    currency: 'EGP',
  }
};

const getSections = (lang) => [
  { id: 'home', label: dict[lang].dashboard, icon: '⌂', group: dict[lang].cafeGroup },
  { id: 'orders', label: dict[lang].orders, icon: '▤', badge: '4' },
  { id: 'menu', label: dict[lang].menu, icon: '◫' },
  { id: 'customers', label: dict[lang].customers, icon: '♙' },
  { id: 'offers', label: dict[lang].offers, icon: '％', group: dict[lang].marketingGroup },
  { id: 'proximity', label: dict[lang].proximity, icon: '◎', badge: dict[lang].newBadge },
  { id: 'loyalty', label: dict[lang].loyalty, icon: '✳' },
  { id: 'staff', label: dict[lang].staff, icon: '♧', group: dict[lang].teamGroup },
  { id: 'payroll', label: dict[lang].payroll, icon: '▣' },
  { id: 'branding', label: dict[lang].branding, icon: '✎', group: dict[lang].brandingGroup },
  { id: 'reports', label: dict[lang].reports, icon: '▥' },
  { id: 'settings', label: dict[lang].settings, icon: '⚙' },
];

const initialCustomers = [
  {
    id: 'cust-1',
    name: 'أحمد محمود',
    nameEn: 'Ahmed Mahmoud',
    phone: '010 •••• 2381',
    email: 'ahmed.m@outlook.com',
    orders: 28,
    spent: 6840,
    last: 'منذ ساعتين',
    lastEn: '2 hours ago',
    segment: 'عميل دائم (VIP)',
    segmentKey: 'vip',
    color: 'purple',
    discount: 'خصم 10٪',
    discountEn: '10% Discount',
    favoriteItem: 'فلات وايت أرتيزان',
    favoriteItemEn: 'Artisan Flat White',
    loyaltyPoints: 684,
    memberSince: 'يناير 2025',
    memberSinceEn: 'Jan 2025',
  },
  {
    id: 'cust-2',
    name: 'مريم حسن',
    nameEn: 'Mariam Hassan',
    phone: '010 •••• 9042',
    email: 'mariam.h@gmail.com',
    orders: 16,
    spent: 3920,
    last: 'أمس، 6:20 م',
    lastEn: 'Yesterday, 6:20 PM',
    segment: 'عميل عائد',
    segmentKey: 'returning',
    color: 'amber',
    discount: 'لا يوجد',
    discountEn: 'None',
    favoriteItem: 'سبانش لاتيه مثلج',
    favoriteItemEn: 'Iced Spanish Latte',
    loyaltyPoints: 392,
    memberSince: 'أبريل 2025',
    memberSinceEn: 'Apr 2025',
  },
  {
    id: 'cust-3',
    name: 'عمر إبراهيم',
    nameEn: 'Omar Ibrahim',
    phone: '011 •••• 7710',
    email: 'omar.ibr@gmail.com',
    orders: 9,
    spent: 2160,
    last: 'منذ 3 أيام',
    lastEn: '3 days ago',
    segment: 'عميل عائد',
    segmentKey: 'returning',
    color: 'amber',
    discount: 'خصم 15٪',
    discountEn: '15% Discount',
    favoriteItem: 'كولد برو منقوع 18 ساعة',
    favoriteItemEn: 'Slow Drip Cold Brew',
    loyaltyPoints: 216,
    memberSince: 'يونيو 2025',
    memberSinceEn: 'Jun 2025',
  },
  {
    id: 'cust-4',
    name: 'نور علي',
    nameEn: 'Nour Ali',
    phone: '012 •••• 6115',
    email: 'nour.ali@icloud.com',
    orders: 2,
    spent: 490,
    last: 'منذ أسبوع',
    lastEn: '1 week ago',
    segment: 'عميل جديد',
    segmentKey: 'new',
    color: 'blue',
    discount: 'خصم 15٪ (ترحيب)',
    discountEn: '15% Welcome Offer',
    favoriteItem: 'آيس أمريكانو',
    favoriteItemEn: 'Iced Americano',
    loyaltyPoints: 49,
    memberSince: 'نوفمبر 2026',
    memberSinceEn: 'Nov 2026',
  },
  {
    id: 'cust-5',
    name: 'يوسف خالد',
    nameEn: 'Youssef Khaled',
    phone: '010 •••• 1553',
    email: 'youssef.k@yahoo.com',
    orders: 41,
    spent: 10320,
    last: 'اليوم، 9:15 ص',
    lastEn: 'Today, 9:15 AM',
    segment: 'عميل دائم (VIP)',
    segmentKey: 'vip',
    color: 'purple',
    discount: 'مشروب مجاني',
    discountEn: 'Free Drink Reward',
    favoriteItem: 'كورتادو مزدوج كولومبي',
    favoriteItemEn: 'Double Colombian Cortado',
    loyaltyPoints: 1032,
    memberSince: 'ديسمبر 2024',
    memberSinceEn: 'Dec 2024',
  },
  {
    id: 'cust-6',
    name: 'سارة إبراهيم',
    nameEn: 'Sara Ibrahim',
    phone: '012 •••• 4421',
    email: 'sara.ibrahim@gmail.com',
    orders: 14,
    spent: 3150,
    last: 'اليوم، 10:15 ص',
    lastEn: 'Today, 10:15 AM',
    segment: 'عميل عائد',
    segmentKey: 'returning',
    color: 'amber',
    discount: 'خصم 20٪',
    discountEn: '20% Proximity Perk',
    favoriteItem: 'سموزي بلوبري مثلج',
    favoriteItemEn: 'Blueberry Blast Smoothie',
    loyaltyPoints: 315,
    memberSince: 'فبراير 2025',
    memberSinceEn: 'Feb 2025',
  },
  {
    id: 'cust-7',
    name: 'كريم عاطف',
    nameEn: 'Karim Atef',
    phone: '010 •••• 8829',
    email: 'karim.atef@gmail.com',
    orders: 34,
    spent: 8450,
    last: 'أمس، 9:40 م',
    lastEn: 'Yesterday, 9:40 PM',
    segment: 'عميل دائم (VIP)',
    segmentKey: 'vip',
    color: 'purple',
    discount: 'خصم 10٪',
    discountEn: '10% Discount',
    favoriteItem: 'في 60 مقطر سبيشالتي',
    favoriteItemEn: 'Ethiopian V60 Single Origin',
    loyaltyPoints: 845,
    memberSince: 'يناير 2025',
    memberSinceEn: 'Jan 2025',
  },
  {
    id: 'cust-8',
    name: 'دينا طارق',
    nameEn: 'Dina Tarek',
    phone: '011 •••• 3352',
    email: 'dina.tarek@hotmail.com',
    orders: 19,
    spent: 4580,
    last: 'أمس، 7:15 م',
    lastEn: 'Yesterday, 7:15 PM',
    segment: 'عميل عائد',
    segmentKey: 'returning',
    color: 'amber',
    discount: 'لا يوجد',
    discountEn: 'None',
    favoriteItem: 'آيس وايت موكا كريمي',
    favoriteItemEn: 'Iced White Chocolate Mocha',
    loyaltyPoints: 458,
    memberSince: 'مارس 2025',
    memberSinceEn: 'Mar 2025',
  },
  {
    id: 'cust-9',
    name: 'شريف ممدوح',
    nameEn: 'Sherif Mamdouh',
    phone: '015 •••• 9918',
    email: 'sherif.m@gmail.com',
    orders: 18,
    spent: 4200,
    last: 'منذ 42 يوماً (غائب)',
    lastEn: '42 days ago (Dormant)',
    segment: 'عميل غائب (يحتاج تنشيط)',
    segmentKey: 'at_risk',
    color: 'rose',
    discount: 'لا يوجد',
    discountEn: 'None',
    favoriteItem: 'كولد برو كلاسيك',
    favoriteItemEn: 'Classic Cold Brew',
    loyaltyPoints: 420,
    memberSince: 'نوفمبر 2024',
    memberSinceEn: 'Nov 2024',
  },
  {
    id: 'cust-10',
    name: 'هاني عبد الرحيم',
    nameEn: 'Hany Abdelrahim',
    phone: '010 •••• 6612',
    email: 'hany.abdel@gmail.com',
    orders: 22,
    spent: 5600,
    last: 'اليوم، 11:30 ص',
    lastEn: 'Today, 11:30 AM',
    segment: 'عميل دائم (VIP)',
    segmentKey: 'vip',
    color: 'purple',
    discount: 'لا يوجد',
    discountEn: 'None',
    favoriteItem: 'كابتشينو بريميوم إيطالي',
    favoriteItemEn: 'Italian Cappuccino',
    loyaltyPoints: 560,
    memberSince: 'مايو 2025',
    memberSinceEn: 'May 2025',
  },
  {
    id: 'cust-11',
    name: 'رانيا يوسف',
    nameEn: 'Rania Youssef',
    phone: '012 •••• 7741',
    email: 'rania.y@outlook.com',
    orders: 7,
    spent: 1650,
    last: 'منذ 35 يوماً (غائب)',
    lastEn: '35 days ago (Dormant)',
    segment: 'عميل غائب (يحتاج تنشيط)',
    segmentKey: 'at_risk',
    color: 'rose',
    discount: 'لا يوجد',
    discountEn: 'None',
    favoriteItem: 'تشيز كيك سان سيباستيان',
    favoriteItemEn: 'San Sebastian Cheesecake',
    loyaltyPoints: 165,
    memberSince: 'أغسطس 2025',
    memberSinceEn: 'Aug 2025',
  },
  {
    id: 'cust-12',
    name: 'إيهاب فوزي',
    nameEn: 'Ehab Fawzy',
    phone: '010 •••• 5521',
    email: 'ehab.fawzy@gmail.com',
    orders: 11,
    spent: 2750,
    last: '4 نوفمبر 2026',
    lastEn: 'Nov 4, 2026',
    segment: 'عميل عائد',
    segmentKey: 'returning',
    color: 'amber',
    discount: 'خصم 25 ج.م',
    discountEn: '25 EGP Voucher',
    favoriteItem: 'سبانش لاتيه مثلج',
    favoriteItemEn: 'Iced Spanish Latte',
    loyaltyPoints: 275,
    memberSince: 'يوليو 2025',
    memberSinceEn: 'Jul 2025',
  },
  {
    id: 'cust-13',
    name: 'مروان أشرف',
    nameEn: 'Marwan Ashraf',
    phone: '011 •••• 8901',
    email: 'marwan.a@gmail.com',
    orders: 0,
    spent: 0,
    last: 'لم يطلب بعد (مسجل حديثاً)',
    lastEn: 'Never ordered (New sign-up)',
    segment: 'لم يطلب بعد',
    segmentKey: 'no_orders',
    color: 'gray',
    discount: 'لا يوجد',
    discountEn: 'None',
    favoriteItem: 'تصفح قائمة الكولد برو',
    favoriteItemEn: 'Cold Brew Explorer',
    loyaltyPoints: 0,
    memberSince: 'نوفمبر 2026',
    memberSinceEn: 'Nov 2026',
  },
  {
    id: 'cust-14',
    name: 'ياسمين عادل',
    nameEn: 'Yasmine Adel',
    phone: '012 •••• 1184',
    email: 'yasmine.a@hotmail.com',
    orders: 0,
    spent: 0,
    last: 'لم يطلب بعد (حساب نشط)',
    lastEn: 'Never ordered (Active lead)',
    segment: 'لم يطلب بعد',
    segmentKey: 'no_orders',
    color: 'gray',
    discount: 'لا يوجد',
    discountEn: 'None',
    favoriteItem: 'تصفح المخبوزات والحلويات',
    favoriteItemEn: 'Bakery Explorer',
    loyaltyPoints: 0,
    memberSince: 'نوفمبر 2026',
    memberSinceEn: 'Nov 2026',
  },
];

const products = [
  // 1. قهوة ساخنة (Hot Coffee)
  {
    id: 'prod-1',
    name: 'فلات وايت أرتيزان',
    nameEn: 'Artisan Flat White',
    category: 'قهوة ساخنة',
    categoryEn: 'Hot Coffee',
    price: '78 ج.م',
    priceVal: 78,
    costVal: 24,
    stock: true,
    image: 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=400&h=400&fit=crop',
    isBestSeller: true,
    soldToday: 54,
    calories: 140,
    desc: 'دبل ريستريتو إثيوبي فاخر مع حليب مبخر كريمي وميكروفوم ناعم ورسمة لاتيه آرت.',
    descEn: 'Rich double ristretto with silky velvety microfoam milk.',
  },
  {
    id: 'prod-2',
    name: 'كورتادو مزدوج كولومبي',
    nameEn: 'Double Colombian Cortado',
    category: 'قهوة ساخنة',
    categoryEn: 'Hot Coffee',
    price: '72 ج.م',
    priceVal: 72,
    costVal: 22,
    stock: true,
    image: 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=400&h=400&fit=crop',
    isBestSeller: false,
    soldToday: 29,
    calories: 95,
    desc: 'توازن دقيق 1:1 بين الإسبريسو المركز والحليب المبخر بدرجة حرارة معتدلة.',
    descEn: 'Equal 1:1 balance of espresso and warm steamed milk.',
  },
  {
    id: 'prod-3',
    name: 'كابتشينو بريميوم إيطالي',
    nameEn: 'Italian Cappuccino',
    category: 'قهوة ساخنة',
    categoryEn: 'Hot Coffee',
    price: '75 ج.م',
    priceVal: 75,
    costVal: 23,
    stock: true,
    image: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=400&fit=crop',
    isBestSeller: false,
    soldToday: 38,
    calories: 130,
    desc: 'إسبريسو غني مع رغوة حليب كثيفة ورشة كاكاو بلجيكي خام.',
    descEn: 'Espresso topped with dense thick foam and raw Belgian cocoa dusting.',
  },
  {
    id: 'prod-4',
    name: 'في 60 مقطر سبيشالتي (إثيوبي)',
    nameEn: 'Ethiopian V60 Single Origin',
    category: 'قهوة ساخنة',
    categoryEn: 'Hot Coffee',
    price: '88 ج.م',
    priceVal: 88,
    costVal: 32,
    stock: true,
    image: 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=400&h=400&fit=crop',
    isBestSeller: true,
    soldToday: 41,
    calories: 5,
    desc: 'تقطير يدوي فريش بحبوب يرقاتشيف بنوتات ياسمين وخوخ مع حمضية منعشة متوازنة.',
    descEn: 'Manual pour-over Yirgacheffe with floral jasmine and stone fruit notes.',
  },

  // 2. قهوة باردة ومثلجة (Cold Coffee)
  {
    id: 'prod-5',
    name: 'سبانش لاتيه مثلج',
    nameEn: 'Iced Spanish Latte',
    category: 'قهوة باردة',
    categoryEn: 'Cold Coffee',
    price: '95 ج.م',
    priceVal: 95,
    costVal: 30,
    stock: true,
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=400&fit=crop',
    isBestSeller: true,
    soldToday: 68,
    calories: 260,
    desc: 'مزيج الحليب المكثف المحلى مع الإسبريسو الطازج والثلج الكريستالي، الصنف المفضل دائمًا.',
    descEn: 'Signature sweet condensed milk layered with bold espresso and ice.',
  },
  {
    id: 'prod-6',
    name: 'كولد برو منقوع 18 ساعة',
    nameEn: 'Slow Drip Cold Brew 18h',
    category: 'قهوة باردة',
    categoryEn: 'Cold Coffee',
    price: '88 ج.م',
    priceVal: 88,
    costVal: 26,
    stock: false, // Out of stock to test alert & restock
    image: 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=400&h=400&fit=crop',
    isBestSeller: false,
    soldToday: 18,
    calories: 10,
    desc: 'قهوة منقوعة بالماء البارد لمدة 18 ساعة متواصلة، حمضية منخفضة جداً وقوام سلس كالحرير.',
    descEn: 'Steeped cold for 18 hours, ultra-low acidity and naturally sweet finish.',
  },
  {
    id: 'prod-7',
    name: 'آيس وايت موكا كريمي',
    nameEn: 'Iced White Chocolate Mocha',
    category: 'قهوة باردة',
    categoryEn: 'Cold Coffee',
    price: '92 ج.م',
    priceVal: 92,
    costVal: 31,
    stock: true,
    image: 'https://images.unsplash.com/photo-1572442388796-11668ba67e53?w=400&h=400&fit=crop',
    isBestSeller: false,
    soldToday: 32,
    calories: 290,
    desc: 'شوكولاتة بيضاء سويسرية مع إسبريسو دبل شوت وحليب مثلج مغطى بالكريمة المخفوقة.',
    descEn: 'Swiss white chocolate sauce, double espresso, cold milk and whipped cream.',
  },
  {
    id: 'prod-8',
    name: 'كراميل ماكياتو مثلج',
    nameEn: 'Iced Caramel Macchiato',
    category: 'قهوة باردة',
    categoryEn: 'Cold Coffee',
    price: '96 ج.م',
    priceVal: 96,
    costVal: 32,
    stock: true,
    image: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?w=400&h=400&fit=crop',
    isBestSeller: true,
    soldToday: 47,
    calories: 250,
    desc: 'فانيلا مدغشقر مع حليب بارد وثلج وإسبريسو علوي مع خيوط صوص الكراميل الغني.',
    descEn: 'Madagascar vanilla, chilled milk, topped with espresso and buttery caramel drizzle.',
  },

  // 3. سموزي وعصائر (Smoothies & Juices)
  {
    id: 'prod-9',
    name: 'سموزي بلوبري مثلج',
    nameEn: 'Blueberry Blast Smoothie',
    category: 'سموزي وعصائر',
    categoryEn: 'Smoothies & Juices',
    price: '85 ج.م',
    priceVal: 85,
    costVal: 27,
    stock: true,
    image: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=400&h=400&fit=crop',
    isBestSeller: true,
    soldToday: 73,
    calories: 210,
    desc: 'توت أزرق طبيعي 100% مع زبادي يوناني وعسل نقي وقطع ثلج مجروش، منقذ أيام الصيف.',
    descEn: 'Pure wild blueberries blended with Greek yogurt and natural clover honey.',
  },
  {
    id: 'prod-10',
    name: 'مانجو باشن فروت سموزي',
    nameEn: 'Mango Passion Fruit Slush',
    category: 'سموزي وعصائر',
    categoryEn: 'Smoothies & Juices',
    price: '82 ج.م',
    priceVal: 82,
    costVal: 25,
    stock: true,
    image: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400&h=400&fit=crop',
    isBestSeller: false,
    soldToday: 35,
    calories: 195,
    desc: 'مانجو تومي فريش مع لمسة باشن استوائية حامضة ومنعشة تروق البال.',
    descEn: 'Tropical ripe mango and tangy passionfruit purée blended with ice.',
  },
  {
    id: 'prod-11',
    name: 'موهيتو ليمون ونعناع كلاسيك',
    nameEn: 'Classic Lime & Mint Mojito',
    category: 'سموزي وعصائر',
    categoryEn: 'Smoothies & Juices',
    price: '68 ج.م',
    priceVal: 68,
    costVal: 18,
    stock: true,
    image: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400&h=400&fit=crop',
    isBestSeller: false,
    soldToday: 27,
    calories: 110,
    desc: 'شرائح ليمون أضاليا طازج ونعناع بلدي فريش مع صودا فوارة وسيرب قصب السكر.',
    descEn: 'Crisp fresh lime and garden mint muddled with sparkling club soda.',
  },
  {
    id: 'prod-12',
    name: 'سموزي أفوكادو بالعسل والمكسرات',
    nameEn: 'Avocado Honey Nut Smoothie',
    category: 'سموزي وعصائر',
    categoryEn: 'Smoothies & Juices',
    price: '98 ج.م',
    priceVal: 98,
    costVal: 38,
    stock: false, // Out of stock to demonstrate multiple out-of-stock items
    image: 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400&h=400&fit=crop',
    isBestSeller: false,
    soldToday: 14,
    calories: 340,
    desc: 'أفوكادو كريمي طازج مضروب بالحليب وعسل الموالح ومغطى برشة لوز وعين جمل محمص.',
    descEn: 'Creamy Haas avocado blended with fresh milk, honey and toasted almonds.',
  },

  // 4. مخبوزات وحلويات (Bakery & Desserts)
  {
    id: 'prod-13',
    name: 'كرواسون زبدة فرنسي فاخر',
    nameEn: 'French Butter Croissant',
    category: 'مخبوزات',
    categoryEn: 'Bakery',
    price: '62 ج.م',
    priceVal: 62,
    costVal: 19,
    stock: true,
    image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=400&fit=crop',
    isBestSeller: true,
    soldToday: 62,
    calories: 270,
    desc: 'مخبوز طازج يومياً بزبدة فرنسية أصلية مورقة بطبقات مقرمشة وهشة تذوب في الفم.',
    descEn: 'Freshly baked daily with authentic French butter and flaky golden layers.',
  },
  {
    id: 'prod-14',
    name: 'كوكيز شوكولاتة بلجيكية دبل',
    nameEn: 'Double Belgian Choc Cookie',
    category: 'مخبوزات',
    categoryEn: 'Bakery',
    price: '45 ج.م',
    priceVal: 45,
    costVal: 14,
    stock: true,
    image: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400&h=400&fit=crop',
    isBestSeller: false,
    soldToday: 49,
    calories: 230,
    desc: 'كوكيز نيويورك دافئ مقرمش من الحواف وغني بقطع شوكولاتة بلجيكية داكنة ذائبة بالقلب.',
    descEn: 'NYC style soft-baked cookie packed with melting Belgian dark chocolate chunks.',
  },
  {
    id: 'prod-15',
    name: 'تشيز كيك سان سيباستيان',
    nameEn: 'San Sebastian Basque Cheesecake',
    category: 'مخبوزات',
    categoryEn: 'Bakery',
    price: '110 ج.م',
    priceVal: 110,
    costVal: 40,
    stock: true,
    image: 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400&h=400&fit=crop',
    isBestSeller: true,
    soldToday: 31,
    calories: 380,
    desc: 'تشيز كيك الباسك الإسباني المحروق من الوجه مع قوام كريمي غني، يقدم مع صوص شوكولاتة بلجيكي دافئ.',
    descEn: 'Classic Basque burnt cheesecake with a molten creamy center and warm chocolate sauce.',
  },

  // 5. ماتشا وسبيشالتي (Matcha & Specialty)
  {
    id: 'prod-16',
    name: 'آيس ماتشا لاتيه ياباني احتفالي',
    nameEn: 'Ceremonial Iced Matcha Latte',
    category: 'ماتشا وسبيشالتي',
    categoryEn: 'Matcha & Specialty',
    price: '105 ج.م',
    priceVal: 105,
    costVal: 35,
    stock: true,
    image: 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400&h=400&fit=crop',
    isBestSeller: true,
    soldToday: 44,
    calories: 160,
    desc: 'بودرة ماتشا أوخي احتفالية مستوردة من أوجي كيوتو باليابان مخفوقة تقليدياً مع حليب الشوفان.',
    descEn: 'Premium ceremonial Grade Uji matcha whisked with chilled oat milk.',
  },
];

const initialProximityCampaigns = [
  {
    id: 'camp-1',
    name: 'سموزي البلوبري في عز الحر 🫐',
    product: 'سموزي بلوبري مثلج',
    category: 'مشروبات باردة',
    image: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=480&h=300&fit=crop',
    discount: 'خصم 20٪',
    radius: 200,
    startTime: '13:30',
    endTime: '16:30',
    timeLabel: '١:٣٠ م — ٤:٣٠ م (فترة الذروة والحرارة)',
    title: 'الجو نار ومحتاج تروق؟ ☀️🫐',
    body: 'سموزي البلوبري المثلج مستنيك بخصم 20% في مقهى الزيتون.. الحق روق بيه وأنت مروّح قبل البيت!',
    status: 'active',
    statusLabel: 'نشط ومعتمد',
    targetSegment: 'جميع العملاء المارين بالنطاق',
    sentCount: 148,
    openCount: 42,
    cooldownHours: 8,
    dailyLimit: 1,
    branch: 'فرع كفر الشيخ (شارع الجيش)',
  },
  {
    id: 'camp-2',
    name: 'قهوة الصباح والنشاط ☕',
    product: 'سبانش لاتيه',
    category: 'قهوة باردة',
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=480&h=300&fit=crop',
    discount: 'خصم 15٪',
    radius: 250,
    startTime: '08:00',
    endTime: '11:30',
    timeLabel: '٨:٠٠ ص — ١١:٣٠ ص (شيفت الصباح والدوام)',
    title: 'صباحك نشاط وقهوة تظبط يومك! ☕✨',
    body: 'قهوتك السريعة جاهزة بخصم 15% في فرعنا وأنت في طريقك للشغل بدون أي انتظار.',
    status: 'active',
    statusLabel: 'نشط ومعتمد',
    targetSegment: 'عملاء الصباح والعمل',
    sentCount: 194,
    openCount: 55,
    cooldownHours: 8,
    dailyLimit: 1,
    branch: 'فرع كفر الشيخ (شارع الجيش)',
  },
  {
    id: 'camp-3',
    name: 'عرض الرجوع للعملاء القدامى 🥐',
    product: 'كرواسون زبدة',
    category: 'مخبوزات وقهوة',
    image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=480&h=300&fit=crop',
    discount: 'خصم 25 ج.م',
    radius: 150,
    startTime: '17:00',
    endTime: '22:00',
    timeLabel: '٥:٠٠ م — ١٠:٠٠ م (الفترة المسائية)',
    title: 'وحشتنا قهوتك ولمتنا! 🥐',
    body: 'لك خصم 25 ج.م على طلبك المسائي لما تنورنا النهاردة بمقهى الزيتون.',
    status: 'draft',
    statusLabel: 'مسودة (بانتظار مراجعة الأدمن)',
    targetSegment: 'عملاء لم يزورونا منذ أسبوعين',
    sentCount: 0,
    openCount: 0,
    cooldownHours: 8,
    dailyLimit: 1,
    branch: 'فرع كفر الشيخ (شارع الجيش)',
  }
];

const orderStatusMap = {
  ar: {
    new: 'طلب جديد',
    preparing: 'قيد التحضير',
    ready: 'جاهز للاستلام',
    done: 'مكتمل',
    rejected: 'مرفوض',
  },
  en: {
    new: 'New Order',
    preparing: 'Preparing',
    ready: 'Ready for Pickup',
    done: 'Completed',
    rejected: 'Rejected',
  }
};

const orders = [
  // اليوم (Today - Nov 11, 2026)
  { id: '#1048', customer: 'مريم حسن', customerEn: 'Mariam Hassan', items: 'سبانش لاتيه × 2، كوكيز × 1', itemsEn: 'Spanish Latte × 2, Cookies × 1', time: 'منذ 3 دقائق', timeEn: '3 mins ago', total: '252 ج.م', totalEn: '252 EGP', amount: 252, date: '2026-11-11', period: 'today', status: 'طلب جديد', state: 'new' },
  { id: '#1047', customer: 'أحمد محمود', customerEn: 'Ahmed Mahmoud', items: 'فلات وايت × 1، كرواسون × 2', itemsEn: 'Flat White × 1, Croissant × 2', time: 'منذ 8 دقائق', timeEn: '8 mins ago', total: '202 ج.م', totalEn: '202 EGP', amount: 202, date: '2026-11-11', period: 'today', status: 'قيد التحضير', state: 'preparing' },
  { id: '#1046', customer: 'نور علي', customerEn: 'Nour Ali', items: 'آيس أمريكانو × 1', itemsEn: 'Iced Americano × 1', time: 'منذ 14 دقيقة', timeEn: '14 mins ago', total: '70 ج.م', totalEn: '70 EGP', amount: 70, date: '2026-11-11', period: 'today', status: 'جاهز للاستلام', state: 'ready' },
  { id: '#1045', customer: 'يوسف خالد', customerEn: 'Youssef Khaled', items: 'كولد برو × 2', itemsEn: 'Cold Brew × 2', time: 'منذ 21 دقيقة', timeEn: '21 mins ago', total: '176 ج.م', totalEn: '176 EGP', amount: 176, date: '2026-11-11', period: 'today', status: 'قيد التحضير', state: 'preparing' },
  { id: '#1044', customer: 'هاني عبد الرحيم', customerEn: 'Hany Abdelrahim', items: 'كابتشينو × 2، تشيز كيك × 1', itemsEn: 'Cappuccino × 2, Cheesecake × 1', time: 'اليوم، 11:30 ص', timeEn: 'Today, 11:30 AM', total: '220 ج.م', totalEn: '220 EGP', amount: 220, date: '2026-11-11', period: 'today', status: 'مكتمل', state: 'done' },
  { id: '#1043', customer: 'سارة إبراهيم', customerEn: 'Sara Ibrahim', items: 'سموزي بلوبري مثلج × 1', itemsEn: 'Iced Blueberry Smoothie × 1', time: 'اليوم، 10:15 ص', timeEn: 'Today, 10:15 AM', total: '85 ج.م', totalEn: '85 EGP', amount: 85, date: '2026-11-11', period: 'today', status: 'مكتمل', state: 'done' },

  // أمس (Yesterday - Nov 10, 2026)
  { id: '#1042', customer: 'كريم عاطف', customerEn: 'Karim Atef', items: 'فلات وايت × 2', itemsEn: 'Flat White × 2', time: 'أمس، 9:40 م', timeEn: 'Yesterday, 9:40 PM', total: '156 ج.م', totalEn: '156 EGP', amount: 156, date: '2026-11-10', period: 'yesterday', status: 'مكتمل', state: 'done' },
  { id: '#1041', customer: 'دينا طارق', customerEn: 'Dina Tarek', items: 'سبانش لاتيه × 1، كوكيز × 2', itemsEn: 'Spanish Latte × 1, Cookies × 2', time: 'أمس، 7:15 م', timeEn: 'Yesterday, 7:15 PM', total: '165 ج.م', totalEn: '165 EGP', amount: 165, date: '2026-11-10', period: 'yesterday', status: 'مكتمل', state: 'done' },
  { id: '#1040', customer: 'حسام حسن', customerEn: 'Hossam Hassan', items: 'آيس أمريكانو × 2', itemsEn: 'Iced Americano × 2', time: 'أمس، 3:30 م', timeEn: 'Yesterday, 3:30 PM', total: '140 ج.م', totalEn: '140 EGP', amount: 140, date: '2026-11-10', period: 'yesterday', status: 'مكتمل', state: 'done' },
  { id: '#1039', customer: 'شريف ممدوح', customerEn: 'Sherif Mamdouh', items: 'كولد برو × 1', itemsEn: 'Cold Brew × 1', time: 'أمس، 1:00 م', timeEn: 'Yesterday, 1:00 PM', total: '88 ج.م', totalEn: '88 EGP', amount: 88, date: '2026-11-10', period: 'yesterday', status: 'مرفوض', state: 'rejected' },

  // آخر ٧ أيام (Earlier this week)
  { id: '#1038', customer: 'محمود سمير', customerEn: 'Mahmoud Samir', items: 'موكا مثلجة × 2، كرواسون × 1', itemsEn: 'Iced Mocha × 2, Croissant × 1', time: '8 نوفمبر (منذ 3 أيام)', timeEn: 'Nov 8 (3 days ago)', total: '215 ج.م', totalEn: '215 EGP', amount: 215, date: '2026-11-08', period: 'week', status: 'مكتمل', state: 'done' },
  { id: '#1037', customer: 'رانيا يوسف', customerEn: 'Rania Youssef', items: 'كورتادو ساخن × 1', itemsEn: 'Hot Cortado × 1', time: '7 نوفمبر (منذ 4 أيام)', timeEn: 'Nov 7 (4 days ago)', total: '65 ج.م', totalEn: '65 EGP', amount: 65, date: '2026-11-07', period: 'week', status: 'مكتمل', state: 'done' },
  { id: '#1036', customer: 'أميرة عادل', customerEn: 'Amira Adel', items: 'فلات وايت × 1، براونيز × 1', itemsEn: 'Flat White × 1, Brownies × 1', time: '6 نوفمبر (منذ 5 أيام)', timeEn: 'Nov 6 (5 days ago)', total: '145 ج.م', totalEn: '145 EGP', amount: 145, date: '2026-11-06', period: 'week', status: 'مكتمل', state: 'done' },

  // هذا الشهر (November 1-5)
  { id: '#1035', customer: 'إيهاب فوزي', customerEn: 'Ehab Fawzy', items: 'سبانش لاتيه × 3', itemsEn: 'Spanish Latte × 3', time: '4 نوفمبر 2026', timeEn: 'Nov 4, 2026', total: '285 ج.م', totalEn: '285 EGP', amount: 285, date: '2026-11-04', period: 'month', status: 'مكتمل', state: 'done' },
  { id: '#1034', customer: 'منى عزمي', customerEn: 'Mona Azmy', items: 'أمريكانو ساخن × 2', itemsEn: 'Hot Americano × 2', time: '2 نوفمبر 2026', timeEn: 'Nov 2, 2026', total: '120 ج.م', totalEn: '120 EGP', amount: 120, date: '2026-11-02', period: 'month', status: 'مكتمل', state: 'done' },
];

const money = (n) => new Intl.NumberFormat('ar-EG').format(n) + ' ج.م';

function App() {
  const [lang, setLang] = useState('ar');
  const t = (k) => dict[lang]?.[k] || dict.ar?.[k] || k;
  const sections = useMemo(() => getSections(lang), [lang]);
  const [active, setActive] = useState('home');
  const [customers, setCustomers] = useState(initialCustomers);
  const [search, setSearch] = useState('');
  const [range, setRange] = useState('اليوم');
  const [notice, setNotice] = useState('');
  const [modal, setModal] = useState(null);
  const [onlyUnavailable, setOnlyUnavailable] = useState(false);
  const [productRows, setProductRows] = useState(products);
  const [ordersRows, setOrdersRows] = useState(orders);
  const [published, setPublished] = useState(false);
  const [brandColor, setBrandColor] = useState('#b96d3c');
  const [brandFont, setBrandFont] = useState('Cairo');
  const [proximityCampaigns, setProximityCampaigns] = useState(initialProximityCampaigns);
  const [cafeStatus, setCafeStatus] = useState({
    isOpen: true,
    stateKey: 'open',
    label: 'مفتوح لاستقبال الطلبات',
    note: 'الشيفت يسير بانتظام واستقبال الطلبات متاح لجميع العملاء.',
    badgeColor: '#4b9a73',
  });
  const [notifications, setNotifications] = useState([
    { id: 1, title: 'طلب جديد #1048 من مريم حسن', time: 'منذ 3 دقائق', unread: true, type: 'order' },
    { id: 2, title: 'تنبيه مخزون: صنف كولد برو نفد', time: 'منذ نصف ساعة', unread: true, type: 'stock' },
    { id: 3, title: 'حملة سموزي البلوبري حققت 148 تسليم', time: 'اليوم، 2:30 م', unread: false, type: 'campaign' },
  ]);
  const [showNotifications, setShowNotifications] = useState(false);

  const current = sections.find((item) => item.id === active) || sections[0];
  const filteredCustomers = useMemo(() => customers.filter((customer) => `${customer.name} ${customer.phone}`.includes(search.trim())), [customers, search]);
  const filteredProducts = onlyUnavailable ? productRows.filter((product) => !product.stock) : productRows;
  const notify = (message) => { setNotice(message); window.setTimeout(() => setNotice(''), 2800); };

  function advanceOrder(id) {
    setOrdersRows((rows) => rows.map((order) => {
      if (order.id !== id) return order;
      const nextState = order.state === 'new' ? 'preparing' : order.state === 'preparing' ? 'ready' : 'done';
      const nextStatus = orderStatusMap[lang]?.[nextState] || orderStatusMap.ar[nextState];
      return { ...order, state: nextState, status: nextStatus };
    }));
    notify(lang === 'ar' ? `تم تحديث حالة الطلب ${id} بنجاح` : `Order ${id} status updated successfully`);
  }

  function rejectOrder(id, reason) {
    setOrdersRows((rows) => rows.map((order) => order.id === id ? { ...order, state: 'rejected', status: orderStatusMap[lang]?.rejected || 'مرفوض', rejectionReason: reason } : order));
    setModal(null);
    notify(lang === 'ar' ? `تم رفض الطلب ${id} مع إشعار العميل بالسبب` : `Order ${id} rejected with reason`);
  }

  function saveDiscount(payload) {
    let targetType = 'single';
    let targetCustomer = '';
    let selectedCustomers = [];
    let discountType = 'نسبة';
    let discountVal = '15';
    let customTitle = '';
    let conflictPolicy = 'best_offer'; // 'best_offer' | 'override' | 'exclude_existing'
    let minOrder = 0;
    let maxCap = 0;
    let validUntil = '2026-11-30';
    let maxUsages = 1;

    if (typeof payload === 'object' && payload !== null && payload.targetType) {
      targetType = payload.targetType;
      targetCustomer = payload.targetCustomer || '';
      discountType = payload.type || 'نسبة';
      discountVal = payload.value || '15';
      customTitle = payload.title || '';
      conflictPolicy = payload.conflictPolicy || 'best_offer';
      minOrder = Number(payload.minOrder) || 0;
      maxCap = Number(payload.maxCap) || 0;
      validUntil = payload.validUntil || '2026-11-30';
      maxUsages = Number(payload.maxUsages) || 1;
    } else if (typeof payload === 'string') {
      targetCustomer = payload;
      discountVal = arguments[1] || '10';
      discountType = arguments[2] || 'نسبة';
      customTitle = arguments[3] || '';
    }

    const discountText = discountType === 'free' ? 'مشروب مجاني' : discountType === 'نسبة' ? `خصم ${discountVal}٪` : `خصم ${discountVal} ج.م`;
    const discountTextEn = discountType === 'free' ? 'Free Drink' : discountType === 'نسبة' ? `${discountVal}% Discount` : `${discountVal} EGP Voucher`;

    // Determine target customer names based on audience selection
    let targetNames = [];
    if (targetType === 'single') {
      if (targetCustomer) targetNames = [targetCustomer];
    } else if (targetType === 'all') {
      targetNames = customers.map((c) => c.name);
    } else if (targetType === 'no_orders') {
      targetNames = customers.filter((c) => (c.orders || 0) === 0 || c.segmentKey === 'no_orders').map((c) => c.name);
    } else if (targetType === 'new') {
      targetNames = customers.filter((c) => c.segmentKey === 'new' || ((c.orders || 0) > 0 && (c.orders || 0) <= 3)).map((c) => c.name);
    } else if (targetType === 'vip') {
      targetNames = customers.filter((c) => c.segmentKey === 'vip').map((c) => c.name);
    } else if (targetType === 'at_risk') {
      targetNames = customers.filter((c) => c.segmentKey === 'at_risk').map((c) => c.name);
    } else if (targetType === 'returning') {
      targetNames = customers.filter((c) => c.segmentKey === 'returning').map((c) => c.name);
    }

    if (!targetNames.length) {
      notify(lang === 'ar' ? 'لم يتم العثور على أي عملاء مطابقين لهذه الشريحة' : 'No customers matched this target selection');
      return;
    }

    let updatedCount = 0;
    let protectedCount = 0;
    let excludedCount = 0;

    setCustomers((rows) =>
      rows.map((cust) => {
        if (!targetNames.includes(cust.name)) return cust;

        const hasExisting = cust.discount && cust.discount !== 'لا يوجد' && cust.discount !== 'None';

        // Conflict Resolution Logic (Anti-Stacking Enforcement)
        if (hasExisting) {
          if (conflictPolicy === 'exclude_existing') {
            excludedCount++;
            return cust; // Skip customers who already have an offer
          }

          if (conflictPolicy === 'best_offer') {
            // Anti-Stacking: Never add up discounts! Keep the higher one
            if (cust.discount === 'مشروب مجاني' || cust.discountEn === 'Free Drink') {
              protectedCount++;
              return cust; // Keep free drink, don't mix or downgrade
            }

            const currentNum = parseInt(cust.discount.replace(/[^0-9]/g, ''), 10) || 0;
            const newNum = parseInt(discountVal.toString().replace(/[^0-9]/g, ''), 10) || 0;

            if (discountType === 'free') {
              // Upgraded to free drink perk
              updatedCount++;
              return {
                ...cust,
                discount: discountText,
                discountEn: discountTextEn,
                discountTitle: customTitle || cust.discountTitle,
                minOrder,
                maxCap,
                validUntil,
                color: 'green',
              };
            }

            if (newNum <= currentNum) {
              // Current discount is already better or equal. Protected from stacking/downgrading!
              protectedCount++;
              return cust;
            }
          }
        }

        // Apply new discount (either override mode, upgraded best offer, or fresh customer)
        updatedCount++;
        return {
          ...cust,
          discount: discountText,
          discountEn: discountTextEn,
          discountTitle: customTitle || cust.discountTitle,
          minOrder,
          maxCap,
          validUntil,
          color: 'green',
        };
      })
    );

    setModal(null);
    const feedbackMsg =
      lang === 'ar'
        ? `تم تفعيل (${discountText}) لـ ${updatedCount} عميل ${protectedCount > 0 ? `(مع حماية ${protectedCount} عميل من تضارب الخصومات ومضاعفتها)` : ''} 🛡️`
        : `Activated (${discountTextEn}) for ${updatedCount} patrons ${protectedCount > 0 ? `(${protectedCount} protected from stacking)` : ''} 🛡️`;
    notify(feedbackMsg);
  }

  function addCustomer(newCust) {
    const record = {
      id: `cust-${Date.now()}`,
      name: newCust.name,
      nameEn: newCust.nameEn || newCust.name,
      phone: newCust.phone || '010 •••• 0000',
      email: newCust.email || `${newCust.nameEn ? newCust.nameEn.toLowerCase().replace(/\s+/g, '.') : 'user'}@cupback.com`,
      orders: 1,
      spent: parseInt(newCust.initialSpend || '75', 10),
      last: lang === 'ar' ? 'اليوم' : 'Today',
      lastEn: 'Today',
      segment: newCust.segment || (lang === 'ar' ? 'عميل جديد' : 'New Customer'),
      segmentKey: 'new',
      color: 'blue',
      discount: 'لا يوجد',
      discountEn: 'None',
      favoriteItem: newCust.favoriteItem || 'فلات وايت أرتيزان',
      favoriteItemEn: newCust.favoriteItemEn || 'Artisan Flat White',
      loyaltyPoints: Math.round(parseInt(newCust.initialSpend || '75', 10) * 0.1),
      memberSince: lang === 'ar' ? 'نوفمبر 2026' : 'Nov 2026',
      memberSinceEn: 'Nov 2026',
    };
    setCustomers((rows) => [record, ...rows]);
    setModal(null);
    notify(lang === 'ar' ? `تمت إضافة العميل "${newCust.name}" بنجاح` : `Customer "${newCust.name}" added successfully`);
  }

  function toggleCampaign(id) {
    setProximityCampaigns((rows) => rows.map((c) => {
      if (c.id !== id) return c;
      const next = c.status === 'active' ? 'paused' : 'active';
      return { ...c, status: next, statusLabel: next === 'active' ? 'نشط ومعتمد' : 'موقوف مؤقتاً' };
    }));
    notify('تم تحديث حالة حملة الإشعار المكاني');
  }

  function saveCampaign(campData) {
    if (campData.id) {
      setProximityCampaigns((rows) => rows.map((c) => c.id === campData.id ? { ...c, ...campData } : c));
      notify('تم تحديث بيانات الحملة بنجاح');
    } else {
      const created = {
        ...campData,
        id: `camp-${Date.now()}`,
        status: 'draft',
        statusLabel: 'مسودة (بانتظار مراجعة الأدمن)',
        sentCount: 0,
        openCount: 0,
        cooldownHours: 8,
        dailyLimit: 1,
        branch: 'فرع كفر الشيخ (شارع الجيش)',
      };
      setProximityCampaigns((rows) => [created, ...rows]);
      notify('تم إنشاء حملة الاقتراب بنجاح وجاهزة للمراجعة');
    }
    setModal(null);
  }

  function saveProduct(productData) {
    const rawPrice = parseInt(productData.price.toString().replace(/[^0-9]/g, ''), 10) || 75;
    if (productData.isEdit) {
      setProductRows((rows) => rows.map((p) => p.name === productData.originalName ? {
        ...p,
        name: productData.name,
        nameEn: productData.nameEn || p.nameEn || productData.name,
        category: productData.category,
        categoryEn: productData.categoryEn || p.categoryEn || productData.category,
        price: `${rawPrice} ج.م`,
        priceVal: rawPrice,
        costVal: productData.costVal || p.costVal || Math.round(rawPrice * 0.32),
        image: productData.image,
        stock: productData.stock,
        desc: productData.desc || p.desc,
        descEn: productData.descEn || p.descEn,
        calories: productData.calories || p.calories || 160,
      } : p));
      notify(`تم تعديل بيانات صنف "${productData.name}" بنجاح`);
    } else {
      const newProduct = {
        id: `prod-${Date.now()}`,
        name: productData.name,
        nameEn: productData.nameEn || productData.name,
        category: productData.category,
        categoryEn: productData.categoryEn || productData.category,
        price: `${rawPrice} ج.م`,
        priceVal: rawPrice,
        costVal: productData.costVal || Math.round(rawPrice * 0.32),
        image: productData.image || 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=400&fit=crop',
        stock: productData.stock !== false,
        desc: productData.desc || 'صنف جديد مميز مضاف حديثاً لقائمة المقهى.',
        descEn: productData.descEn || 'Freshly added signature item on the cafe menu.',
        isBestSeller: false,
        soldToday: 0,
        calories: productData.calories || 160,
      };
      setProductRows((rows) => [newProduct, ...rows]);
      notify(`تمت إضافة صنف "${productData.name}" إلى المنيو بنجاح`);
    }
    setModal(null);
  }

  function deleteProduct(productName) {
    setProductRows((rows) => rows.filter((p) => p.name !== productName));
    notify(`تم حذف صنف "${productName}" من المنيو`);
    setModal(null);
  }

  function createQuickOrder(orderData) {
    const newId = `#${1048 + ordersRows.length + 1}`;
    const newOrder = {
      id: newId,
      customer: orderData.customerName || 'عميل صالة (طلب نقدي)',
      customerEn: orderData.customerName || 'Walk-in Customer (Cash)',
      items: orderData.itemsSummary,
      itemsEn: orderData.itemsSummary,
      time: 'الآن',
      timeEn: 'Just now',
      total: `${orderData.total} ج.م`,
      totalEn: `${orderData.total} EGP`,
      amount: Number(orderData.total) || 0,
      date: '2026-11-11',
      period: 'today',
      status: 'طلب جديد',
      state: 'new',
    };
    setOrdersRows((rows) => [newOrder, ...rows]);
    setNotifications((notifs) => [
      { id: Date.now(), title: `طلب جديد ${newId} من ${newOrder.customer}`, time: 'الآن', unread: true, type: 'order' },
      ...notifs
    ]);
    notify(`تم تسجيل الطلب ${newId} بقيمة ${newOrder.total}`);
    setModal(null);
  }

  function updateCafeStatus(statusData) {
    setCafeStatus(statusData);
    notify(`تم تحديث حالة الكافيه: ${statusData.label}`);
    setModal(null);
  }

  return <div className={`app-shell ${lang === 'en' ? 'ltr-mode' : 'rtl-mode'}`} dir={lang === 'en' ? 'ltr' : 'rtl'}>
    <aside className="sidebar">
      <div className="brand-lockup"><div className="brand-mark"><span>c</span></div><div><strong>cupback</strong><small>{lang === 'ar' ? 'بوابة الكافيه' : 'Cafe Portal'}</small></div></div>
      <div className="demo-chip"><span className="pulse"/> {t('demoNotice')}</div>
      <div className="cafe-switch"><div className="cafe-avatar">ز</div><div className="cafe-name"><strong>{t('cafeName')}</strong><span>{t('branchName')}</span></div><span className="chevron">⌄</span></div>
      <nav className="nav-list" aria-label={lang === 'ar' ? 'القائمة الرئيسية' : 'Main Menu'}>
        {sections.map((section, index) => <div key={section.id}>
          {section.group && <div className="nav-group">{section.group}</div>}
          <button className={`nav-item ${active === section.id ? 'active' : ''}`} onClick={() => setActive(section.id)}>
            <span className="nav-icon">{section.icon}</span><span>{section.label}</span>{section.badge && <span className="nav-badge">{section.badge}</span>}
          </button>
        </div>)}
      </nav>
      <div className="sidebar-bottom"><div className="help-card"><span className="help-icon">?</span><div><strong>{t('helpTitle')}</strong><small>{t('helpSub')}</small></div><span>↗</span></div><div className="user-mini"><div className="user-avatar">ط</div><div><strong>{t('ownerName')}</strong><small>{t('ownerRole')}</small></div><button className="dots" title={lang === 'ar' ? 'المزيد' : 'More'}>···</button></div></div>
    </aside>

    <main className="main-area">
      <header className="topbar">
        <div className="breadcrumb">
          <span>{t('cafeName')}</span><b>/</b><strong>{current.label}</strong>
        </div>
        <div className="top-actions">
          <span className="today-date">{t('todayDate')}</span>
          <div className="notification-bell-wrap">
            <button
              className="icon-button notification"
              aria-label={t('notificationsTitle')}
              onClick={() => setShowNotifications(!showNotifications)}
            >
              ♧{notifications.some((n) => n.unread) && <i />}
            </button>
            {showNotifications && (
              <div className="notif-dropdown">
                <div className="notif-drop-head">
                  <strong>{t('notificationsTitle')}</strong>
                  <button
                    onClick={() => {
                      setNotifications((list) => list.map((item) => ({ ...item, unread: false })));
                      notify(lang === 'ar' ? 'تم تعيين كل التنبيهات كمقروءة' : 'All alerts marked as read');
                    }}
                  >
                    {t('markAllRead')}
                  </button>
                </div>
                <div className="notif-drop-items">
                  {notifications.map((n) => (
                    <div
                      key={n.id}
                      className={`notif-drop-item ${n.unread ? 'unread' : ''}`}
                      onClick={() => {
                        if (n.type === 'order') setActive('orders');
                        if (n.type === 'stock') setActive('menu');
                        if (n.type === 'campaign') setActive('proximity');
                        setShowNotifications(false);
                      }}
                    >
                      <span className="notif-drop-indicator" />
                      <div>
                        <strong>{n.title}</strong>
                        <small>{n.time}</small>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
          <span className="top-divider" />
          <button
            className="language-toggle-btn"
            onClick={() => {
              const next = lang === 'ar' ? 'en' : 'ar';
              setLang(next);
              notify(next === 'en' ? 'Switched to English interface' : 'تم التحويل إلى الواجهة العربية');
            }}
            title={lang === 'ar' ? 'Switch to English' : 'التحويل للعربية'}
          >
            🌐 <span>{lang === 'ar' ? 'English' : 'عربي'}</span>
          </button>
        </div>
      </header>

      <div className="demo-banner">
        <span>ⓘ</span>
        <div>
          <strong>{t('bannerNotice')}</strong>
          <span>{t('bannerSub')}</span>
        </div>
        <button onClick={() => setActive('settings')}>{t('aboutDemo')}</button>
        <button className="banner-close" onClick={(e) => e.currentTarget.parentElement.remove()} aria-label={lang === 'ar' ? 'إغلاق' : 'Close'}>×</button>
      </div>

      <div className="page-content">
        {active === 'home' && (
          <Dashboard
            range={range}
            setRange={setRange}
            setActive={setActive}
            ordersRows={ordersRows}
            onAdvance={advanceOrder}
            onReject={(order) => setModal({ type: 'reject', order })}
            products={productRows}
            proximityCampaigns={proximityCampaigns}
            cafeStatus={cafeStatus}
            openModal={setModal}
            setProductRows={setProductRows}
            notify={notify}
            lang={lang}
            t={t}
          />
        )}
        {active === 'orders' && (
          <OrdersPage
            rows={ordersRows}
            onAdvance={advanceOrder}
            onReject={(order) => setModal({ type: 'reject', order })}
            openModal={setModal}
            notify={notify}
            lang={lang}
            t={t}
          />
        )}
        {active === 'menu' && (
          <MenuPage
            rows={productRows}
            setRows={setProductRows}
            openModal={setModal}
            notify={notify}
            lang={lang}
            t={t}
          />
        )}
        {active === 'customers' && (
          <CustomersPage
            customers={customers}
            setCustomers={setCustomers}
            openModal={setModal}
            notify={notify}
            lang={lang}
            t={t}
          />
        )}
        {active === 'offers' && <OffersPage openModal={setModal} notify={notify} />}
        {active === 'proximity' && (
          <ProximityPage
            campaigns={proximityCampaigns}
            onToggle={toggleCampaign}
            openModal={setModal}
            notify={notify}
            lang={lang}
            t={t}
          />
        )}
        {active === 'loyalty' && <LoyaltyPage openModal={setModal} notify={notify} />}
        {active === 'staff' && <StaffPage openModal={setModal} notify={notify} />}
        {active === 'payroll' && <PayrollPage openModal={setModal} notify={notify} />}
        {active === 'branding' && <BrandingPage color={brandColor} setColor={setBrandColor} font={brandFont} setFont={setBrandFont} published={published} setPublished={setPublished} notify={notify} />}
        {active === 'reports' && <ReportsPage range={range} setRange={setRange} notify={notify} />}
        {active === 'settings' && <SettingsPage notify={notify} />}
      </div>
    </main>
    {notice && <div className="toast"><span>✓</span>{notice}</div>}
    {modal && (
      <Modal
        modal={modal}
        close={() => setModal(null)}
        setModal={setModal}
        customers={customers}
        products={productRows}
        onSaveDiscount={saveDiscount}
        onAddCustomer={addCustomer}
        onSaveCampaign={saveCampaign}
        onSaveProduct={saveProduct}
        onDeleteProduct={deleteProduct}
        onCreateOrder={createQuickOrder}
        onUpdateCafeStatus={updateCafeStatus}
        onAdvanceOrder={advanceOrder}
        onReject={rejectOrder}
        notify={notify}
        lang={lang}
        t={t}
      />
    )}
  </div>;
}

function PageHeading({ eyebrow, title, description, action, children }) {
  return <div className="page-heading"><div><div className="eyebrow">{eyebrow}</div><h1>{title}</h1><p>{description}</p></div><div className="heading-actions">{children}{action}</div></div>;
}

function Dashboard({
  range,
  setRange,
  setActive,
  ordersRows,
  onAdvance,
  onReject,
  products,
  proximityCampaigns,
  cafeStatus,
  openModal,
  setProductRows,
  notify,
  lang = 'ar',
  t,
}) {
  const [orderFilter, setOrderFilter] = useState('all');

  const metrics = useMemo(() => {
    if (range === 'اليوم' || range === 'Today') {
      return {
        sales: '١٢٬٤٨٠',
        salesEn: '12,480',
        orders: ordersRows.length > 4 ? `${ordersRows.length + 120}` : '١٢٦',
        ordersEn: ordersRows.length > 4 ? `${ordersRows.length + 120}` : '126',
        avg: '٩٩٫٠',
        avgEn: '99.0',
        discounts: '١٬٢٦٠',
        discountsEn: '1,260',
        salesDelta: '+١٢٫٨٪',
        salesDeltaEn: '+12.8%',
        salesSub: 'مقارنة بأمس',
        salesSubEn: 'vs yesterday',
        chartTotal: '١٢٬٤٨٠',
        chartTotalEn: '12,480',
        chartDelta: '↑ ٨٪ عن أمس',
        chartDeltaEn: '↑ 8% vs yesterday',
        activeProximitySent: 148,
      };
    }
    if (range === 'آخر ٧ أيام' || range === 'Last 7 Days') {
      return {
        sales: '٨٤٬٢٥٠',
        salesEn: '84,250',
        orders: '٨٥٢',
        ordersEn: '852',
        avg: '٩٨٫٨',
        avgEn: '98.8',
        discounts: '٨٬٩٢٠',
        discountsEn: '8,920',
        salesDelta: '+١٥٫٣٪',
        salesDeltaEn: '+15.3%',
        salesSub: 'عن الأسبوع الماضي',
        salesSubEn: 'vs last week',
        chartTotal: '٨٤٬٢٥٠',
        chartTotalEn: '84,250',
        chartDelta: '↑ ١٢٪ عن الأسبوع الماضي',
        chartDeltaEn: '↑ 12% vs last week',
        activeProximitySent: 742,
      };
    }
    return {
      sales: '٢٨٤٬٦٤٠',
      salesEn: '284,640',
      orders: '٢٬٨٩٤',
      ordersEn: '2,894',
      avg: '٩٨٫٣',
      avgEn: '98.3',
      discounts: '١٨٬٤٢٠',
      discountsEn: '18,420',
      salesDelta: '+١٨٫٤٪',
      salesDeltaEn: '+18.4%',
      salesSub: 'عن الشهر الماضي',
      salesSubEn: 'vs last month',
      chartTotal: '٢٨٤٬٦٤٠',
      chartTotalEn: '284,640',
      chartDelta: '↑ ١٦٪ عن الشهر الماضي',
      chartDeltaEn: '↑ 16% vs last month',
      activeProximitySent: 2840,
    };
  }, [range, ordersRows.length]);

  const cards = [
    {
      label: (range === 'اليوم' || range === 'Today') ? t('todaySales') : (range === 'آخر ٧ أيام' || range === 'Last 7 Days') ? t('weekSales') : t('monthSales'),
      value: lang === 'en' ? metrics.salesEn : metrics.sales,
      suffix: t('currency'),
      delta: lang === 'en' ? metrics.salesDeltaEn : metrics.salesDelta,
      icon: '↗',
      tone: 'gold',
      sub: lang === 'en' ? metrics.salesSubEn : metrics.salesSub
    },
    {
      label: t('totalOrders'),
      value: lang === 'en' ? metrics.ordersEn : metrics.orders,
      suffix: lang === 'ar' ? 'طلب' : 'orders',
      delta: '+8.2%',
      icon: '▤',
      tone: 'blue',
      sub: lang === 'ar' ? 'طلبات مسجلة' : 'logged orders'
    },
    {
      label: t('avgOrder'),
      value: lang === 'en' ? metrics.avgEn : metrics.avg,
      suffix: t('currency'),
      delta: '+4.1%',
      icon: '◉',
      tone: 'green',
      sub: lang === 'ar' ? 'لكل طلب' : 'per order'
    },
    {
      label: t('discountsApplied'),
      value: lang === 'en' ? metrics.discountsEn : metrics.discounts,
      suffix: t('currency'),
      delta: lang === 'ar' ? 'خصومات مطبقة' : 'applied discounts',
      icon: '％',
      tone: 'rose',
      sub: lang === 'ar' ? 'على طلبات مكتملة' : 'on completed orders'
    },
  ];

  const filteredOrders = useMemo(() => {
    if (orderFilter === 'all') return ordersRows;
    return ordersRows.filter((o) => o.state === orderFilter);
  }, [ordersRows, orderFilter]);

  const outOfStockItem = products.find((p) => !p.stock);

  return (
    <>
      <PageHeading
        eyebrow={t('dashEyebrow')}
        title={t('dashTitle')}
        description={t('dashDesc')}
      >
        <button className="button button-primary" onClick={() => openModal({ type: 'new_order' })}>
          ＋ <span>{t('quickOrderBtn')}</span>
        </button>
        <button className="button button-secondary" onClick={() => openModal({ type: 'product' })}>
          ＋ <span>{t('addMenuItemBtn')}</span>
        </button>
        <button className="button button-secondary" onClick={() => setActive('reports')}>
          ▥ <span>{t('viewReportsBtn')}</span>
        </button>
      </PageHeading>

      {/* شريط حالة الكافيه والشيفت التفاعلي */}
      <div className={`welcome-strip ${!cafeStatus.isOpen ? 'closed-strip' : ''}`}>
        <div className="welcome-copy">
          <div className="welcome-kicker">
            <span className="live-dot" style={{ background: cafeStatus.badgeColor, boxShadow: `0 0 0 3px ${cafeStatus.badgeColor}33` }} />
            {cafeStatus.isOpen ? t('shiftActive') : t('shiftClosed')}
          </div>
          <strong>{cafeStatus.isOpen ? t('goodCoffeeDay') : t('ordersPaused')}</strong>
          <span>{cafeStatus.note}</span>
        </div>
        <div className="welcome-decoration">
          <div className="cup-steam">〰</div>
          <div className="cup">☕</div>
        </div>
        <div className="welcome-status">
          <span>{t('branchStatusLabel')}</span>
          <strong>
            <i style={{ background: cafeStatus.badgeColor }} /> {cafeStatus.label}
          </strong>
          <button onClick={() => openModal({ type: 'cafe_status', currentStatus: cafeStatus })}>
            {t('editCafeStatus')} <span>⚙</span>
          </button>
        </div>
      </div>

      {/* شريط التنبيهات والويدجت التشغيلي السريع */}
      <div className="dashboard-operational-strip">
        <div className="op-widget proximity-widget">
          <div className="op-icon">🫐</div>
          <div className="op-content">
            <div className="op-title">
              <strong>{t('proxWidgetTitle')}</strong>
              <span className="op-tag">{t('proxWidgetTime')}</span>
            </div>
            <p>{t('proxWidgetSent').replace('{n}', metrics.activeProximitySent)}</p>
          </div>
          <div className="op-actions">
            <button
              className="button button-secondary compact-btn"
              onClick={() => openModal({ type: 'proximity_preview', campaign: proximityCampaigns[0] })}
            >
              📱 <span>{t('previewNotifBtn')}</span>
            </button>
            <button className="button button-secondary compact-btn" onClick={() => setActive('proximity')}>
              {t('manageCampBtn')}
            </button>
          </div>
        </div>

        {outOfStockItem ? (
          <div className="op-widget alert-widget">
            <div className="op-icon warning">⚠️</div>
            <div className="op-content">
              <strong>{t('stockAlertTitle').replace('{name}', outOfStockItem.name)}</strong>
              <p>{t('stockAlertDesc')}</p>
            </div>
            <button
              className="button button-primary compact-btn"
              onClick={() => {
                setProductRows((rows) => rows.map((p) => p.name === outOfStockItem.name ? { ...p, stock: true } : p));
                notify(lang === 'ar' ? `تمت إعادة توفر صنف "${outOfStockItem.name}" في المنيو` : `Item "${outOfStockItem.name}" restocked in menu`);
              }}
            >
              {t('restoreStockBtn')}
            </button>
          </div>
        ) : (
          <div className="op-widget ok-widget">
            <div className="op-icon ok">✓</div>
            <div className="op-content">
              <strong>{t('stockOkTitle')}</strong>
              <p>{t('stockOkDesc').replace('{n}', products.length)}</p>
            </div>
            <button className="button button-secondary compact-btn" onClick={() => setActive('menu')}>
              {t('viewMenuBtn')}
            </button>
          </div>
        )}
      </div>

      {/* ملخص الأرقام مع فلتر الفترة */}
      <div className="section-row">
        <div>
          <h2>{t('perfTitle')}</h2>
          <span>{t('perfSub').replace('{range}', range)}</span>
        </div>
        <select className="select-control" value={range} onChange={(e) => setRange(e.target.value)}>
          <option value={lang === 'ar' ? 'اليوم' : 'Today'}>{t('rangeToday')}</option>
          <option value={lang === 'ar' ? 'آخر ٧ أيام' : 'Last 7 Days'}>{t('rangeWeek')}</option>
          <option value={lang === 'ar' ? 'هذا الشهر' : 'This Month'}>{t('rangeMonth')}</option>
        </select>
      </div>

      <div className="stats-grid">
        {cards.map((card) => (
          <div className="stat-card" key={card.label}>
            <div className="stat-top">
              <span>{card.label}</span>
              <i className={`stat-icon ${card.tone}`}>{card.icon}</i>
            </div>
            <div className="stat-number">
              {card.value}
              <small>{card.suffix}</small>
            </div>
            <div className="stat-foot">
              <span className="delta">{card.delta}</span>
              <span>{card.sub}</span>
              <span className="sparkline">⌁⌁⌁</span>
            </div>
          </div>
        ))}
      </div>

      {/* المخطط والأكثر مبيعاً */}
      <div className="dashboard-grid">
        <section className="panel sales-panel">
          <div className="panel-heading">
            <div>
              <h2>{t('salesTrendTitle')}</h2>
              <span>{t('salesTrendSub')} {range}</span>
            </div>
            <button className="more-button" onClick={() => setActive('reports')} dangerouslySetInnerHTML={{ __html: t('detailedReport') }} />
          </div>
          <div className="chart-total">
            <strong>
              {lang === 'en' ? metrics.chartTotalEn : metrics.chartTotal} <small>{t('currency')}</small>
            </strong>
            <span className="delta">{lang === 'en' ? metrics.chartDeltaEn : metrics.chartDelta}</span>
          </div>
          <SalesChart range={range} lang={lang} />
        </section>

        <section className="panel category-panel">
          <div className="panel-heading">
            <div>
              <h2>{t('topSellingTitle')}</h2>
              <span>{t('topSellingSub')}</span>
            </div>
            <button className="more-button" onClick={() => setActive('menu')} dangerouslySetInnerHTML={{ __html: t('fullMenuLink') }} />
          </div>
          <div className="top-selling-list">
            {products.slice(0, 4).map((prod, idx) => (
              <div className="product-rank-row" key={prod.name}>
                <span className="rank-num">0{idx + 1}</span>
                <img src={prod.image} alt={prod.name} />
                <div className="product-rank-info">
                  <strong>{prod.name}</strong>
                  <span>{prod.category} · {prod.price}</span>
                </div>
                <div className="product-rank-metrics">
                  <b>{idx === 0 ? (lang === 'ar' ? '٢٤٨' : '248') : idx === 1 ? (lang === 'ar' ? '١٩٢' : '192') : idx === 2 ? (lang === 'ar' ? '١٥٦' : '156') : (lang === 'ar' ? '١١٤' : '114')} <small>{lang === 'ar' ? 'طلب' : 'orders'}</small></b>
                  <button
                    className="edit-mini-btn"
                    onClick={() => openModal({ type: 'product', product: prod })}
                    title={lang === 'ar' ? 'تعديل هذا المنتج' : 'Edit item'}
                  >
                    {lang === 'ar' ? 'تعديل ✎' : 'Edit ✎'}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </section>
      </div>

      {/* جدول الطلبات مع تحكم مباشر */}
      <section className="panel recent-orders">
        <div className="panel-heading">
          <div>
            <h2>{t('liveOrdersTitle')}</h2>
            <span>{t('liveOrdersSub')}</span>
          </div>
          <div className="heading-actions">
            <button className="button button-primary compact-btn" onClick={() => openModal({ type: 'new_order' })}>
              ＋ {t('quickOrderBtn')}
            </button>
            <button className="more-button" onClick={() => setActive('orders')}>
              {t('allOrdersLink')} ({ordersRows.length}) <b>{lang === 'en' ? '→' : '←'}</b>
            </button>
          </div>
        </div>

        <div className="filter-tabs table-filters-inside">
          {[
            { id: 'all', label: t('filterAll') },
            { id: 'new', label: t('filterNew'), count: ordersRows.filter((o) => o.state === 'new').length },
            { id: 'preparing', label: t('filterPrep') },
            { id: 'ready', label: t('filterReady') },
          ].map((f) => (
            <button key={f.id} className={orderFilter === f.id ? 'selected' : ''} onClick={() => setOrderFilter(f.id)}>
              {f.label} {f.count > 0 && <b>{f.count}</b>}
            </button>
          ))}
        </div>

        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>{t('thOrder')}</th>
                <th>{t('thCustomer')}</th>
                <th>{t('thItems')}</th>
                <th>{t('thTime')}</th>
                <th>{t('thTotal')}</th>
                <th>{t('thStatus')}</th>
                <th>{t('thAction')}</th>
                <th>{t('thBill')}</th>
              </tr>
            </thead>
            <tbody>
              {filteredOrders.slice(0, 5).map((order) => {
                const customerName = lang === 'en' && order.customerEn ? order.customerEn : order.customer;
                const itemsText = lang === 'en' && order.itemsEn ? order.itemsEn : order.items;
                const timeText = lang === 'en' && order.timeEn ? order.timeEn : order.time;
                const totalText = typeof order.total === 'number' ? `${order.total} ${t('currency')}` : (lang === 'en' && order.totalEn ? order.totalEn : order.total);
                const statusLabel = orderStatusMap[lang]?.[order.state] || order.status;

                return (
                  <tr key={order.id}>
                    <td className="order-id">
                      <button
                        className="order-id-link"
                        onClick={() => openModal({ type: 'order_detail', order })}
                        title={lang === 'ar' ? 'عرض الفاتورة' : 'View receipt'}
                      >
                        {order.id}
                      </button>
                    </td>
                    <td><strong>{customerName}</strong></td>
                    <td className="muted-cell">{itemsText}</td>
                    <td className="muted-cell">{timeText}</td>
                    <td><strong>{totalText}</strong></td>
                    <td>
                      <span className={`status-pill ${order.state}`}>{statusLabel}</span>
                    </td>
                    <td>
                      {order.state === 'new' ? (
                        <div className="order-actions">
                          <button className="table-action approve-btn" onClick={() => onAdvance(order.id)}>
                            {t('actAccept')}
                          </button>
                          <button className="table-action reject-action" onClick={() => onReject(order)}>
                            {t('actReject')}
                          </button>
                        </div>
                      ) : order.state === 'preparing' ? (
                        <button className="table-action ready-btn" onClick={() => onAdvance(order.id)}>
                          {t('actReady')}
                        </button>
                      ) : order.state === 'ready' ? (
                        <button className="table-action done-btn" onClick={() => onAdvance(order.id)}>
                          {t('actDeliver')}
                        </button>
                      ) : (
                        <span className="muted-cell">{t('actCompleted')}</span>
                      )}
                    </td>
                    <td>
                      <button
                        className="table-action subtle-action view-receipt-btn"
                        onClick={() => openModal({ type: 'order_detail', order })}
                        title={lang === 'ar' ? 'عرض فاتورة الطلب' : 'View Receipt'}
                      >
                        {t('actViewBill')}
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </section>
    </>
  );
}

function SalesChart({ range, lang = 'ar' }) {
  const chartConfig = useMemo(() => {
    if (range === 'اليوم' || range === 'Today') {
      return {
        path: "M0 130 C60 140 100 110 160 85 S260 70 340 50 S440 65 520 30 S620 40 720 20",
        fill: "M0 130 C60 140 100 110 160 85 S260 70 340 50 S440 65 520 30 S620 40 720 20 V180 H0Z",
        xLabels: lang === 'en' ? ['8 AM', '11 AM', '2 PM', '5 PM', '8 PM', '11 PM'] : ['٨ ص', '١١ ص', '٢ م', '٥ م', '٨ م', '١١ م'],
        yLabels: lang === 'en' ? ['3k', '2k', '1k', '0'] : ['٣ آلاف', '٢ ألف', '١ ألف', '٠'],
      };
    }
    if (range === 'آخر ٧ أيام' || range === 'Last 7 Days') {
      return {
        path: "M0 144 C44 120 52 128 84 112 S142 138 168 92 S220 100 252 78 S302 104 336 63 S390 75 420 51 S468 86 504 60 S552 87 588 40 S642 67 672 25 S700 35 720 18",
        fill: "M0 144 C44 120 52 128 84 112 S142 138 168 92 S220 100 252 78 S302 104 336 63 S390 75 420 51 S468 86 504 60 S552 87 588 40 S642 67 672 25 S700 35 720 18 V180 H0Z",
        xLabels: lang === 'en' ? ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'] : ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'],
        yLabels: lang === 'en' ? ['15k', '10k', '5k', '0'] : ['١٥ ألف', '١٠ آلاف', '٥ آلاف', '٠'],
      };
    }
    return {
      path: "M0 150 C80 135 150 120 240 95 S380 90 480 55 S600 45 720 15",
      fill: "M0 150 C80 135 150 120 240 95 S380 90 480 55 S600 45 720 15 V180 H0Z",
      xLabels: lang === 'en' ? ['Week 1', 'Week 2', 'Week 3', 'Week 4'] : ['الأسبوع ١', 'الأسبوع ٢', 'الأسبوع ٣', 'الأسبوع ٤'],
      yLabels: lang === 'en' ? ['80k', '50k', '20k', '0'] : ['٨٠ ألف', '٥٠ ألف', '٢٠ ألف', '٠'],
    };
  }, [range, lang]);

  return (
    <div className="chart">
      <div className="chart-y">
        {chartConfig.yLabels.map((lbl) => (
          <span key={lbl}>{lbl}</span>
        ))}
      </div>
      <div className="chart-plot">
        <div className="chart-grid">
          <i />
          <i />
          <i />
          <i />
        </div>
        <svg viewBox="0 0 720 180" preserveAspectRatio="none" role="img" aria-label="منحنى المبيعات">
          <defs>
            <linearGradient id="fill" x1="0" x2="0" y1="0" y2="1">
              <stop offset="0%" stopColor="#c57a42" stopOpacity=".24" />
              <stop offset="100%" stopColor="#c57a42" stopOpacity="0" />
            </linearGradient>
          </defs>
          <path d={chartConfig.fill} fill="url(#fill)" />
          <path
            d={chartConfig.path}
            fill="none"
            stroke="#b96d3c"
            strokeWidth="3.5"
            vectorEffect="non-scaling-stroke"
            strokeLinecap="round"
          />
        </svg>
        <div className="chart-x">
          {chartConfig.xLabels.map((lbl) => (
            <span key={lbl}>{lbl}</span>
          ))}
        </div>
      </div>
    </div>
  );
}

function OrdersPage({ rows, onAdvance, onReject, openModal, notify, lang = 'ar', t }) {
  const [period, setPeriod] = useState('today');
  const [filter, setFilter] = useState('all');
  const [search, setSearch] = useState('');

  // 1. Calculate Today's dedicated metrics (Always visible for fast operational awareness)
  const todayOrders = useMemo(() => {
    return rows.filter((r) => r.period === 'today' || r.date === '2026-11-11');
  }, [rows]);

  const todayCount = todayOrders.length;
  const todayRevenue = todayOrders.reduce((sum, r) => sum + (r.amount || parseInt(r.total) || 0), 0);
  const todayNewCount = todayOrders.filter((r) => r.state === 'new').length;
  const todayPrepCount = todayOrders.filter((r) => r.state === 'preparing').length;
  const todayReadyCount = todayOrders.filter((r) => r.state === 'ready').length;

  // 2. Filter orders by selected Period ('today', 'yesterday', 'week', 'month', 'all')
  const periodOrders = useMemo(() => {
    return rows.filter((order) => {
      if (period === 'today') return order.period === 'today' || order.date === '2026-11-11';
      if (period === 'yesterday') return order.period === 'yesterday' || order.date === '2026-11-10';
      if (period === 'week') return ['today', 'yesterday', 'week'].includes(order.period);
      if (period === 'month') return ['today', 'yesterday', 'week', 'month'].includes(order.period);
      return true; // 'all'
    });
  }, [rows, period]);

  const periodTotalCount = periodOrders.length;
  const periodRevenue = periodOrders.reduce((sum, r) => sum + (r.amount || parseInt(r.total) || 0), 0);
  const periodNewCount = periodOrders.filter((r) => r.state === 'new').length;
  const periodPrepCount = periodOrders.filter((r) => r.state === 'preparing').length;
  const periodReadyCount = periodOrders.filter((r) => r.state === 'ready').length;

  // 3. Filter by Status & Search within the chosen period
  const filtered = useMemo(() => {
    return periodOrders.filter((order) => {
      // Status filter
      if (filter !== 'all' && order.state !== filter) return false;
      // Search filter
      if (search.trim()) {
        const query = search.toLowerCase().trim();
        const customerName = (lang === 'en' && order.customerEn ? order.customerEn : order.customer).toLowerCase();
        const items = (lang === 'en' && order.itemsEn ? order.itemsEn : order.items).toLowerCase();
        const id = order.id.toLowerCase();
        return id.includes(query) || customerName.includes(query) || items.includes(query);
      }
      return true;
    });
  }, [periodOrders, filter, search, lang]);

  const periodOptions = [
    { id: 'today', label: t('periodToday'), icon: '☀️' },
    { id: 'yesterday', label: t('periodYesterday'), icon: '⏳' },
    { id: 'week', label: t('periodWeek'), icon: '📅' },
    { id: 'month', label: t('periodMonth'), icon: '🗓️' },
    { id: 'all', label: t('periodAll'), icon: '♾️' },
  ];

  const filterTabs = [
    { id: 'all', label: t('filterAll'), count: periodTotalCount },
    { id: 'new', label: t('filterNew'), count: periodNewCount, badgeColor: '#b96d3c' },
    { id: 'preparing', label: t('filterPrep'), count: periodPrepCount, badgeColor: '#4d7b9d' },
    { id: 'ready', label: t('filterReady'), count: periodReadyCount, badgeColor: '#7c538f' },
    { id: 'done', label: t('filterDone'), count: periodOrders.filter((r) => r.state === 'done').length },
    { id: 'rejected', label: t('filterRejected'), count: periodOrders.filter((r) => r.state === 'rejected').length },
  ];

  const getPeriodTitle = () => {
    if (period === 'today') return lang === 'ar' ? 'إجمالي طلبات اليوم' : "Today's Orders";
    if (period === 'yesterday') return lang === 'ar' ? 'إجمالي طلبات أمس' : "Yesterday's Orders";
    if (period === 'week') return lang === 'ar' ? 'طلبات آخر ٧ أيام' : "Last 7 Days Orders";
    if (period === 'month') return lang === 'ar' ? 'طلبات هذا الشهر' : "This Month Orders";
    return lang === 'ar' ? 'إجمالي كل الطلبات' : 'All Recorded Orders';
  };

  const handleExportOrdersExcel = (customList = null) => {
    const listToExport = customList || filtered;
    exportOrdersToExcel(listToExport, {
      cafeName: lang === 'ar' ? 'مقهى الزيتون' : 'Al-Zaytoun Cafe',
      branchName: lang === 'ar' ? 'كفر الشيخ — شارع الجيش' : 'Kafr El-Sheikh — El-Geesh St.',
      periodLabel: getPeriodTitle(),
      lang,
    });
    notify(lang === 'ar' ? 'تم تنزيل تقرير الطلبات التنفيذي (Excel) بنجاح 📊' : 'Orders Excel report downloaded successfully 📊');
  };

  const handleExportOrdersCSV = (customList = null) => {
    const listToExport = customList || filtered;
    exportOrdersToCSV(listToExport, { lang });
    notify(lang === 'ar' ? 'تم تنزيل ملف CSV الطلبات المنظم بنجاح 📄' : 'Orders CSV file downloaded successfully 📄');
  };

  return (
    <>
      <PageHeading
        eyebrow={t('ordersEyebrow')}
        title={t('ordersMainTitle')}
        description={t('ordersMainDesc')}
      >
        <div className="header-export-actions">
          <button
            type="button"
            className="export-pill-btn excel-btn"
            onClick={() => handleExportOrdersExcel(filtered)}
            title={lang === 'ar' ? 'تنزيل مباشر لتقرير طلبات الإكسيل المصمم' : 'Direct download of styled Excel report'}
          >
            📊 {lang === 'ar' ? 'Excel فاخر' : 'Executive Excel'}
          </button>
          <button
            type="button"
            className="export-pill-btn"
            onClick={() => handleExportOrdersCSV(filtered)}
            title={lang === 'ar' ? 'تنزيل مباشر لملف CSV الطلبات المنظم بدون تداخل أعمدة' : 'Direct download of clean CSV'}
          >
            📄 {lang === 'ar' ? 'CSV منظم' : 'Clean CSV'}
          </button>
          <button
            type="button"
            className="export-pill-btn"
            onClick={() => openModal({
              type: 'export_orders',
              filteredList: filtered,
              allList: rows,
              periodLabel: getPeriodTitle()
            })}
            title={lang === 'ar' ? 'مركز خيارات ونطاق تصدير تقارير الطلبات' : 'Open Orders Export Center'}
          >
            ⚙️ {lang === 'ar' ? 'خيارات التصدير' : 'Export Center'}
          </button>
        </div>
        <button className="button button-secondary" onClick={() => notify(lang === 'ar' ? 'تم تحديث قائمة الطلبات لحظياً ✓' : 'Orders refreshed successfully ✓')}>
          ↻ <span>{t('refreshBtn')}</span>
        </button>
        <button className="button button-primary" onClick={() => openModal({ type: 'new_order' })}>
          ＋ <span>{t('quickOrderBtn')}</span>
        </button>
      </PageHeading>

      {/* شريط الفلترة الزمنية التفاعلي ومؤشر طلبات اليوم الحي */}
      <div className="orders-period-bar">
        <div className="period-segmented-wrap">
          <span className="period-label">
            <i className="period-icon">📅</i> {t('periodFilter')}
          </span>
          <div className="period-pill-buttons">
            {periodOptions.map((opt) => (
              <button
                key={opt.id}
                className={`period-pill ${period === opt.id ? 'active' : ''}`}
                onClick={() => setPeriod(opt.id)}
              >
                <span className="opt-emoji">{opt.icon}</span>
                <span>{opt.label}</span>
                {opt.id === 'today' ? (
                  <b className="today-micro-count">{todayCount}</b>
                ) : (
                  <small className="opt-count">
                    {opt.id === 'yesterday'
                      ? rows.filter((r) => r.period === 'yesterday').length
                      : opt.id === 'week'
                      ? rows.filter((r) => ['today', 'yesterday', 'week'].includes(r.period)).length
                      : opt.id === 'month'
                      ? rows.filter((r) => ['today', 'yesterday', 'week', 'month'].includes(r.period)).length
                      : rows.length}
                  </small>
                )}
              </button>
            ))}
          </div>
        </div>

        {/* كارت العدد اللحظي لليوم */}
        <div className="today-live-badge-widget">
          <div className="live-badge-icon">☕</div>
          <div className="live-badge-content">
            <div className="live-badge-header">
              <span>{t('todayOrdersStat')}</span>
              <strong>{todayCount} {lang === 'ar' ? 'طلب' : 'orders'}</strong>
              <span className="live-rev-chip">{todayRevenue} {t('currency')}</span>
            </div>
            <div className="live-badge-stats">
              <span className="micro-status new">{todayNewCount} {lang === 'ar' ? 'جديد' : 'new'}</span>
              <span className="micro-status prep">{todayPrepCount} {lang === 'ar' ? 'بالبار' : 'bar'}</span>
              <span className="micro-status ready">{todayReadyCount} {lang === 'ar' ? 'جاهز' : 'ready'}</span>
            </div>
          </div>
        </div>
      </div>

      {/* 4 كروت مؤشرات الأداء المتجاوبة مع الفترة الزمنية */}
      <div className="stats-grid orders-kpi-grid">
        <div className="stat-card" onClick={() => setFilter('all')} style={{ cursor: 'pointer' }}>
          <div className="stat-top">
            <span>{getPeriodTitle()}</span>
            <i className="stat-icon gold">▤</i>
          </div>
          <div className="stat-number">
            {periodTotalCount} <small>{lang === 'ar' ? 'طلب' : 'orders'}</small>
          </div>
          <div className="stat-foot">
            <span className="delta">
              ⚡ {t('todayOrdersCountBadge').replace('{n}', todayCount)}
            </span>
            <span>{lang === 'ar' ? `المبيعات: ${periodRevenue} ج.م` : `Sales: ${periodRevenue} EGP`}</span>
          </div>
        </div>

        <div className="stat-card" onClick={() => setFilter('new')} style={{ cursor: 'pointer' }}>
          <div className="stat-top">
            <span>{t('ordersKpiNew')}</span>
            <i className="stat-icon rose">🔔</i>
          </div>
          <div className="stat-number" style={{ color: periodNewCount > 0 ? '#b96d3c' : undefined }}>
            {periodNewCount} <small>{lang === 'ar' ? 'يحتاج استجابة' : 'action required'}</small>
          </div>
          <div className="stat-foot">
            <span className="delta" style={{ background: '#fdf0ee', color: '#b55a50' }}>
              {periodNewCount > 0 ? (lang === 'ar' ? 'فوري' : 'Urgent') : '0'}
            </span>
            <span>{lang === 'ar' ? 'في الانتظار' : 'pending'}</span>
          </div>
        </div>

        <div className="stat-card" onClick={() => setFilter('preparing')} style={{ cursor: 'pointer' }}>
          <div className="stat-top">
            <span>{t('ordersKpiPrep')}</span>
            <i className="stat-icon blue">☕</i>
          </div>
          <div className="stat-number">
            {periodPrepCount} <small>{lang === 'ar' ? 'في البار' : 'at the bar'}</small>
          </div>
          <div className="stat-foot">
            <span className="delta" style={{ background: '#eaf2fa', color: '#456f96' }}>
              {lang === 'ar' ? 'جاري التحضير' : 'In progress'}
            </span>
            <span>{lang === 'ar' ? 'للباريستا' : 'barista'}</span>
          </div>
        </div>

        <div className="stat-card" onClick={() => setFilter('ready')} style={{ cursor: 'pointer' }}>
          <div className="stat-top">
            <span>{t('ordersKpiReady')}</span>
            <i className="stat-icon green">✓</i>
          </div>
          <div className="stat-number" style={{ color: periodReadyCount > 0 ? '#43836a' : undefined }}>
            {periodReadyCount} <small>{lang === 'ar' ? 'جاهز للتسليم' : 'ready for pickup'}</small>
          </div>
          <div className="stat-foot">
            <span className="delta" style={{ background: '#e9f3ec', color: '#3e7d56' }}>
              {lang === 'ar' ? 'في انتظار العميل' : 'awaiting customer'}
            </span>
          </div>
        </div>
      </div>

      {/* Orders Filter & Search Toolbar */}
      <div className="orders-toolbar-wrap">
        <div className="filter-tabs compact orders-tabs">
          {filterTabs.map((tab) => (
            <button
              key={tab.id}
              className={filter === tab.id ? 'selected' : ''}
              onClick={() => setFilter(tab.id)}
            >
              {tab.label}
              {tab.count > 0 && (
                <b style={tab.badgeColor ? { background: tab.badgeColor, color: '#fff', borderRadius: '4px', padding: '1px 5px', marginLeft: 4, marginRight: 4 } : undefined}>
                  {tab.count}
                </b>
              )}
            </button>
          ))}
        </div>

        <div className="searchbox orders-search">
          <span>⌕</span>
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder={t('ordersSearchPlaceholder')}
          />
          {search && (
            <button className="search-clear-btn" onClick={() => setSearch('')}>×</button>
          )}
        </div>
      </div>

      {/* Orders Table Panel */}
      <section className="panel table-panel">
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>{t('thOrder')}</th>
                <th>{t('thCustomer')}</th>
                <th>{t('thItems')}</th>
                <th>{t('thTime')}</th>
                <th>{t('thTotal')}</th>
                <th>{t('thStatus')}</th>
                <th>{t('thAction')}</th>
                <th>{t('thBill')}</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((order) => {
                const customerName = lang === 'en' && order.customerEn ? order.customerEn : order.customer;
                const itemsText = lang === 'en' && order.itemsEn ? order.itemsEn : order.items;
                const timeText = lang === 'en' && order.timeEn ? order.timeEn : order.time;
                const totalText = typeof order.total === 'number' ? `${order.total} ${t('currency')}` : (lang === 'en' && order.totalEn ? order.totalEn : order.total);
                const statusLabel = orderStatusMap[lang]?.[order.state] || order.status;

                return (
                  <tr key={order.id} className={`order-row state-${order.state}`}>
                    <td className="order-id">
                      <button
                        className="order-id-link"
                        onClick={() => openModal({ type: 'order_detail', order })}
                        title={lang === 'ar' ? 'عرض تفاصيل الفاتورة' : 'View receipt'}
                      >
                        {order.id}
                      </button>
                    </td>
                    <td>
                      <div className="customer-cell">
                        <div className="customer-avatar">
                          {customerName ? customerName[0] : 'ع'}
                        </div>
                        <div>
                          <strong>{customerName}</strong>
                          <small>{order.state === 'new' ? (lang === 'ar' ? 'طلب جديد' : 'New order') : (lang === 'ar' ? 'عميل مقهى' : 'Cafe customer')}</small>
                        </div>
                      </div>
                    </td>
                    <td className="items-cell">
                      <span>{itemsText}</span>
                    </td>
                    <td className="muted-cell">{timeText}</td>
                    <td>
                      <strong className="order-total-val">{totalText}</strong>
                    </td>
                    <td>
                      <span className={`status-pill ${order.state}`}>{statusLabel}</span>
                    </td>
                    <td>
                      {order.state === 'new' ? (
                        <div className="order-actions">
                          <button className="table-action approve-btn" onClick={() => onAdvance(order.id)}>
                            {t('actAccept')}
                          </button>
                          <button className="table-action reject-action" onClick={() => onReject(order)}>
                            {t('actReject')}
                          </button>
                        </div>
                      ) : order.state === 'preparing' ? (
                        <button className="table-action ready-btn" onClick={() => onAdvance(order.id)}>
                          {t('actReady')}
                        </button>
                      ) : order.state === 'ready' ? (
                        <button className="table-action done-btn" onClick={() => onAdvance(order.id)}>
                          {t('actDeliver')}
                        </button>
                      ) : order.state === 'rejected' ? (
                        <span className="rejected-badge">{lang === 'ar' ? 'مرفوض ✕' : 'Rejected ✕'}</span>
                      ) : (
                        <span className="muted-cell">{t('actCompleted')}</span>
                      )}
                    </td>
                    <td>
                      <button
                        className="table-action subtle-action view-receipt-btn"
                        onClick={() => openModal({ type: 'order_detail', order })}
                        title={lang === 'ar' ? 'معاينة الفاتورة' : 'View Receipt'}
                      >
                        {t('actViewBill')}
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
          {filtered.length === 0 && (
            <div className="empty-state orders-empty">
              <span className="empty-icon">☕</span>
              <strong>{lang === 'ar' ? 'لا توجد طلبات مطابقة لهذه الفترة' : 'No matching orders in this period'}</strong>
              <p>{lang === 'ar' ? 'جرّب التبديل لفترة أخرى مثل "هذا الشهر" أو "كل الفترات" لرؤية باقي الطلبات.' : 'Try switching to another period like "This Month" or "All Time".'}</p>
              <button className="button button-secondary compact-btn" onClick={() => { setPeriod('all'); setFilter('all'); setSearch(''); }}>
                {lang === 'ar' ? 'عرض كل الطلبات' : 'Show All Orders'}
              </button>
            </div>
          )}
        </div>
      </section>
    </>
  );
}

function MenuPage({ rows, setRows, openModal, notify, lang = 'ar', t }) {
  const [search, setSearch] = useState('');
  const [selectedCat, setSelectedCat] = useState('all');
  const [sortBy, setSortBy] = useState('popular');
  const [viewMode, setViewMode] = useState('grid'); // 'grid' | 'table'

  // Metric computations
  const totalCount = rows.length;
  const inStockCount = rows.filter((p) => p.stock).length;
  const outOfStockCount = rows.filter((p) => !p.stock).length;
  const readinessPct = Math.round((inStockCount / (totalCount || 1)) * 100);

  // Best seller product (by sold count)
  const starProduct = useMemo(() => {
    if (!rows.length) return null;
    return [...rows].sort((a, b) => (b.soldToday || 0) - (a.soldToday || 0))[0];
  }, [rows]);

  // Categories definitions with dynamic counts
  const categories = [
    { id: 'all', label: t('catAll'), icon: '✨', count: totalCount },
    { id: 'hot', label: t('catHotCoffee'), icon: '☕', count: rows.filter((p) => p.category === 'قهوة ساخنة').length },
    { id: 'cold', label: t('catColdCoffee'), icon: '🧊', count: rows.filter((p) => p.category === 'قهوة باردة').length },
    { id: 'smoothie', label: t('catSmoothies'), icon: '🫐', count: rows.filter((p) => p.category === 'سموزي وعصائر').length },
    { id: 'bakery', label: t('catBakery'), icon: '🥐', count: rows.filter((p) => p.category === 'مخبوزات').length },
    { id: 'specialty', label: t('catSpecialty'), icon: '🍵', count: rows.filter((p) => p.category === 'ماتشا وسبيشالتي').length },
    { id: 'out_of_stock', label: t('catOutOfStock'), icon: '⚡', count: outOfStockCount, highlight: outOfStockCount > 0 },
    { id: 'best_sellers', label: t('catBestSellers'), icon: '🔥', count: rows.filter((p) => p.isBestSeller).length },
  ];

  // Restock All out of stock items
  const handleRestockAll = () => {
    setRows((items) => items.map((it) => ({ ...it, stock: true })));
    notify(t('menuRestockAllDone'));
  };

  // Toggle single item stock
  const handleToggleStock = (productName) => {
    setRows((items) =>
      items.map((it) => {
        if (it.name === productName) {
          const nextState = !it.stock;
          notify(
            lang === 'ar'
              ? `صنف "${it.name}" أصبح الآن ${nextState ? 'متوفراً للطلب' : 'معطلاً (نفد)'}`
              : `Item "${it.nameEn || it.name}" is now ${nextState ? 'In Stock' : 'Out of Stock'}`
          );
          return { ...it, stock: nextState };
        }
        return it;
      })
    );
  };

  // Delete product
  const handleDelete = (product) => {
    const displayName = lang === 'ar' ? product.name : (product.nameEn || product.name);
    if (window.confirm(lang === 'ar' ? `هل أنت متأكد من حذف صنف "${displayName}" نهائياً من المنيو؟` : `Are you sure you want to permanently delete "${displayName}" from the menu?`)) {
      setRows((items) => items.filter((it) => it.name !== product.name));
      notify(lang === 'ar' ? `تم حذف صنف "${displayName}"` : `Deleted item "${displayName}"`);
    }
  };

  // Filtering & Sorting
  const filteredProducts = useMemo(() => {
    let result = [...rows];

    // Category filter
    if (selectedCat === 'hot') result = result.filter((p) => p.category === 'قهوة ساخنة');
    else if (selectedCat === 'cold') result = result.filter((p) => p.category === 'قهوة باردة');
    else if (selectedCat === 'smoothie') result = result.filter((p) => p.category === 'سموزي وعصائر');
    else if (selectedCat === 'bakery') result = result.filter((p) => p.category === 'مخبوزات');
    else if (selectedCat === 'specialty') result = result.filter((p) => p.category === 'ماتشا وسبيشالتي');
    else if (selectedCat === 'out_of_stock') result = result.filter((p) => !p.stock);
    else if (selectedCat === 'best_sellers') result = result.filter((p) => p.isBestSeller);

    // Search filter
    if (search.trim()) {
      const q = search.trim().toLowerCase();
      result = result.filter((p) =>
        (p.name && p.name.toLowerCase().includes(q)) ||
        (p.nameEn && p.nameEn.toLowerCase().includes(q)) ||
        (p.category && p.category.toLowerCase().includes(q)) ||
        (p.categoryEn && p.categoryEn.toLowerCase().includes(q)) ||
        (p.desc && p.desc.toLowerCase().includes(q)) ||
        (p.price && p.price.toLowerCase().includes(q))
      );
    }

    // Sorting
    if (sortBy === 'popular') {
      result.sort((a, b) => (b.soldToday || 0) - (a.soldToday || 0));
    } else if (sortBy === 'price_asc') {
      result.sort((a, b) => (a.priceVal || 0) - (b.priceVal || 0));
    } else if (sortBy === 'price_desc') {
      result.sort((a, b) => (b.priceVal || 0) - (a.priceVal || 0));
    } else if (sortBy === 'stock') {
      result.sort((a, b) => (b.stock ? 1 : 0) - (a.stock ? 1 : 0));
    }

    return result;
  }, [rows, selectedCat, search, sortBy]);

  return (
    <>
      <PageHeading
        eyebrow={t('menuEyebrow')}
        title={t('menuMainTitle')}
        description={t('menuMainDesc')}
      >
        {outOfStockCount > 0 && (
          <button className="button button-secondary" onClick={handleRestockAll}>
            {t('menuRestockAll')}
          </button>
        )}
        <button className="button button-primary" onClick={() => openModal({ type: 'product' })}>
          {t('menuAddProduct')}
        </button>
      </PageHeading>

      {/* 4 Top KPI Summary Cards */}
      <div className="stats-grid menu-stats-grid">
        {/* Card 1: Total Items */}
        <div className="stat-card stat-card-rich">
          <div className="stat-card-header">
            <span className="stat-icon-wrap" style={{ background: 'rgba(185, 109, 60, 0.12)', color: '#b96d3c' }}>📋</span>
            <span className="stat-tag">{totalCount} {lang === 'ar' ? 'صنفاً' : 'items'}</span>
          </div>
          <div className="stat-card-title">{t('menuKpiTotal')}</div>
          <div className="stat-card-val-row">
            <span className="stat-main-number">{totalCount}</span>
            <span className="stat-unit">{lang === 'ar' ? 'صنف مسجل' : 'in catalog'}</span>
          </div>
          <div className="stat-sub-info">
            <span>5 {lang === 'ar' ? 'تصنيفات رئيسية نشطة' : 'active main categories'}</span>
          </div>
        </div>

        {/* Card 2: Readiness Rate */}
        <div className="stat-card stat-card-rich">
          <div className="stat-card-header">
            <span className="stat-icon-wrap" style={{ background: 'rgba(46, 125, 50, 0.12)', color: '#2e7d32' }}>⚡</span>
            <span className="stat-tag success-tag">{readinessPct}% {lang === 'ar' ? 'جاهزية' : 'Ready'}</span>
          </div>
          <div className="stat-card-title">{t('menuKpiReady')}</div>
          <div className="stat-card-val-row">
            <span className="stat-main-number">{readinessPct}%</span>
            <span className="stat-unit">({inStockCount}/{totalCount})</span>
          </div>
          <div className="menu-progress-track">
            <div className="menu-progress-bar" style={{ width: `${readinessPct}%` }} />
          </div>
          <div className="stat-sub-info">
            <span>{inStockCount} {t('menuKpiReadySub')}</span>
          </div>
        </div>

        {/* Card 3: Out of Stock Alert & Fast Restock */}
        <div className={`stat-card stat-card-rich ${outOfStockCount > 0 ? 'alert-border' : ''}`}>
          <div className="stat-card-header">
            <span className="stat-icon-wrap" style={{ background: outOfStockCount > 0 ? 'rgba(211, 47, 47, 0.12)' : 'rgba(46, 125, 50, 0.12)', color: outOfStockCount > 0 ? '#d32f2f' : '#2e7d32' }}>
              {outOfStockCount > 0 ? '⚠️' : '✓'}
            </span>
            <span className={`stat-tag ${outOfStockCount > 0 ? 'danger-tag' : 'success-tag'}`}>
              {outOfStockCount > 0 ? `${outOfStockCount} ${lang === 'ar' ? 'نواقص' : 'Out'}` : (lang === 'ar' ? 'مكتمل' : 'All Stocked')}
            </span>
          </div>
          <div className="stat-card-title">{t('menuKpiStockAlert')}</div>
          <div className="stat-card-val-row">
            <span className={`stat-main-number ${outOfStockCount > 0 ? 'text-danger' : 'text-success'}`}>{outOfStockCount}</span>
            <span className="stat-unit">{lang === 'ar' ? 'أصناف معطلة' : 'items disabled'}</span>
          </div>
          <div className="stat-sub-info" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span>{outOfStockCount > 0 ? t('menuKpiStockAlertSub') : (lang === 'ar' ? 'كل الأصناف متاحة للعملاء' : 'All items are ready')}</span>
            {outOfStockCount > 0 && (
              <button className="mini-restock-btn" onClick={handleRestockAll}>
                ⚡ {lang === 'ar' ? 'توفير الكل' : 'Restock'}
              </button>
            )}
          </div>
        </div>

        {/* Card 4: Star Product (Best Seller) */}
        {starProduct && (
          <div className="stat-card stat-card-rich star-card">
            <div className="stat-card-header">
              <span className="stat-icon-wrap" style={{ background: 'rgba(230, 81, 0, 0.12)', color: '#e65100' }}>🔥</span>
              <span className="stat-tag fire-tag">{t('bestSellerBadge')}</span>
            </div>
            <div className="stat-card-title">{t('menuKpiStar')}</div>
            <div className="star-product-body">
              <img src={starProduct.image} alt={starProduct.name} className="star-thumb" />
              <div className="star-info">
                <strong>{lang === 'ar' ? starProduct.name : (starProduct.nameEn || starProduct.name)}</strong>
                <small>{starProduct.price} · {starProduct.soldToday} {t('salesCountLabel')}</small>
              </div>
            </div>
            <div className="stat-sub-info">
              <span>{lang === 'ar' ? `إجمالي المبيعات اليومية: ${(starProduct.soldToday || 0) * (starProduct.priceVal || 85)} ج.م` : `Daily Revenue: ${(starProduct.soldToday || 0) * (starProduct.priceVal || 85)} EGP`}</span>
            </div>
          </div>
        )}
      </div>

      {/* Categories Navigation Ribbon */}
      <div className="menu-categories-ribbon">
        {categories.map((cat) => {
          const isSelected = selectedCat === cat.id;
          return (
            <button
              key={cat.id}
              className={`cat-pill-btn ${isSelected ? 'active' : ''} ${cat.highlight ? 'has-alert' : ''}`}
              onClick={() => setSelectedCat(cat.id)}
            >
              <span className="cat-icon">{cat.icon}</span>
              <span className="cat-label">{cat.label}</span>
              <span className="cat-count-badge">{cat.count}</span>
            </button>
          );
        })}
      </div>

      {/* Interactive Toolbar */}
      <div className="menu-toolbar-pro">
        <div className="menu-search-wrap">
          <span className="search-icon">⌕</span>
          <input
            type="text"
            className="menu-search-input"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder={t('menuSearchPlaceholder')}
          />
          {search && (
            <button className="clear-search-btn" onClick={() => setSearch('')}>✕</button>
          )}
        </div>

        <div className="menu-toolbar-controls">
          {/* Sorting Dropdown */}
          <div className="sort-selector-wrap">
            <label className="sort-label">⇅ {lang === 'ar' ? 'الترتيب:' : 'Sort:'}</label>
            <select
              className="menu-select-box"
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
            >
              <option value="popular">{t('menuSortPopular')}</option>
              <option value="price_asc">{t('menuSortPriceAsc')}</option>
              <option value="price_desc">{t('menuSortPriceDesc')}</option>
              <option value="stock">{t('menuSortInStock')}</option>
            </select>
          </div>

          {/* View Mode Toggle: Grid vs Table */}
          <div className="view-mode-toggle">
            <button
              className={`view-btn ${viewMode === 'grid' ? 'active' : ''}`}
              onClick={() => setViewMode('grid')}
              title={t('menuViewGrid')}
            >
              ▦ {lang === 'ar' ? 'بطاقات' : 'Cards'}
            </button>
            <button
              className={`view-btn ${viewMode === 'table' ? 'active' : ''}`}
              onClick={() => setViewMode('table')}
              title={t('menuViewTable')}
            >
              ☷ {lang === 'ar' ? 'جدول' : 'Table'}
            </button>
          </div>

          {/* Quick Counter */}
          <div className="items-counter-chip">
            <b>{filteredProducts.length}</b> {lang === 'ar' ? 'أصناف معروضة' : 'items shown'}
          </div>
        </div>
      </div>

      {/* Grid View Mode */}
      {viewMode === 'grid' && (
        <div className="products-grid-pro">
          {filteredProducts.map((product) => {
            const isOutOfStock = !product.stock;
            const displayName = lang === 'ar' ? product.name : (product.nameEn || product.name);
            const secondaryName = lang === 'ar' ? product.nameEn : product.name;
            const displayCategory = lang === 'ar' ? product.category : (product.categoryEn || product.category);
            const displayDesc = lang === 'ar' ? product.desc : (product.descEn || product.desc);

            return (
              <article
                className={`product-card-pro ${isOutOfStock ? 'is-out-of-stock' : ''}`}
                key={product.id || product.name}
              >
                {/* Image & Floating Badges */}
                <div className="prod-thumb-container">
                  <img src={product.image} alt={displayName} className="prod-img" loading="lazy" />
                  
                  {/* Category Pill Tag */}
                  <span className="prod-cat-badge">{displayCategory}</span>

                  {/* Best Seller Flame Badge */}
                  {product.isBestSeller && (
                    <span className="prod-flame-badge" title={t('bestSellerBadge')}>
                      🔥 {t('bestSellerBadge')}
                    </span>
                  )}

                  {/* Stock State Badge Overlay */}
                  <span className={`prod-stock-pill ${isOutOfStock ? 'depleted' : 'available'}`}>
                    <span className="pulse-dot" />
                    {isOutOfStock ? t('statusOutOfStock') : t('statusInStock')}
                  </span>
                </div>

                {/* Card Content Body */}
                <div className="prod-body-pro">
                  <div className="prod-title-group">
                    <h3 className="prod-title-main">{displayName}</h3>
                    {secondaryName && <span className="prod-title-sub">{secondaryName}</span>}
                  </div>

                  {displayDesc && (
                    <p className="prod-description" title={displayDesc}>
                      {displayDesc}
                    </p>
                  )}

                  {/* Meta Specs Row */}
                  <div className="prod-specs-row">
                    <span className="spec-item">
                      🔥 <b>{product.soldToday || 0}</b> {t('salesCountLabel')}
                    </span>
                    {product.calories && (
                      <span className="spec-item">
                        ⚡ <b>{product.calories}</b> {t('calorieLabel')}
                      </span>
                    )}
                  </div>

                  {/* Pricing and Stock Toggle Section */}
                  <div className="prod-footer-pro">
                    <div className="prod-price-box">
                      <strong className="prod-price-val">{product.price}</strong>
                      {product.costVal && (
                        <small className="prod-profit-margin">
                          {t('costMarginLabel')}: {Math.round(((product.priceVal - product.costVal) / product.priceVal) * 100)}%
                        </small>
                      )}
                    </div>

                    {/* Instant Interactive Stock Toggle Switch */}
                    <button
                      type="button"
                      className={`interactive-stock-switch ${product.stock ? 'is-active' : 'is-inactive'}`}
                      onClick={() => handleToggleStock(product.name)}
                      title={product.stock ? t('toggleToOutOfStock') : t('toggleToInStock')}
                    >
                      <span className="switch-slider" />
                      <span className="switch-text">
                        {product.stock ? t('statusInStock') : t('statusOutOfStock')}
                      </span>
                    </button>
                  </div>

                  {/* Action Buttons Row */}
                  <div className="prod-actions-row">
                    <button
                      type="button"
                      className="prod-btn-edit"
                      onClick={() => openModal({ type: 'product', product })}
                    >
                      {t('editProductBtn')}
                    </button>
                    <button
                      type="button"
                      className="prod-btn-delete"
                      onClick={() => handleDelete(product)}
                      title={t('deleteProductBtn')}
                    >
                      🗑
                    </button>
                  </div>
                </div>
              </article>
            );
          })}
        </div>
      )}

      {/* Table View Mode */}
      {viewMode === 'table' && (
        <section className="panel menu-table-panel">
          <div className="table-wrap">
            <table className="menu-pro-table">
              <thead>
                <tr>
                  <th>{lang === 'ar' ? 'الصنف' : 'Item'}</th>
                  <th>{lang === 'ar' ? 'التصنيف' : 'Category'}</th>
                  <th>{lang === 'ar' ? 'السعر' : 'Price'}</th>
                  <th>{t('costMarginLabel')}</th>
                  <th>{lang === 'ar' ? 'المبيعات اليومية' : 'Daily Sales'}</th>
                  <th>{lang === 'ar' ? 'حالة التوفر' : 'Stock Availability'}</th>
                  <th>{t('actionsCol')}</th>
                </tr>
              </thead>
              <tbody>
                {filteredProducts.map((product) => {
                  const displayName = lang === 'ar' ? product.name : (product.nameEn || product.name);
                  const displayCategory = lang === 'ar' ? product.category : (product.categoryEn || product.category);
                  const isOutOfStock = !product.stock;

                  return (
                    <tr key={product.id || product.name} className={isOutOfStock ? 'row-out-of-stock' : ''}>
                      <td>
                        <div className="table-product-cell">
                          <img src={product.image} alt={displayName} className="table-product-thumb" />
                          <div className="table-product-info">
                            <strong>{displayName}</strong>
                            <small>{lang === 'ar' ? product.nameEn : product.name}</small>
                            {product.isBestSeller && <span className="mini-fire-badge">🔥 {t('bestSellerBadge')}</span>}
                          </div>
                        </div>
                      </td>
                      <td>
                        <span className="table-cat-tag">{displayCategory}</span>
                      </td>
                      <td>
                        <strong className="table-price-val">{product.price}</strong>
                      </td>
                      <td>
                        <span className="table-margin-val">
                          {product.costVal ? `${Math.round(((product.priceVal - product.costVal) / product.priceVal) * 100)}%` : '65%'}
                        </span>
                      </td>
                      <td>
                        <span className="table-sold-badge">
                          {product.soldToday || 0} {lang === 'ar' ? 'طلب' : 'orders'}
                        </span>
                      </td>
                      <td>
                        <button
                          type="button"
                          className={`interactive-stock-switch ${product.stock ? 'is-active' : 'is-inactive'}`}
                          onClick={() => handleToggleStock(product.name)}
                        >
                          <span className="switch-slider" />
                          <span className="switch-text">{product.stock ? t('statusInStock') : t('statusOutOfStock')}</span>
                        </button>
                      </td>
                      <td>
                        <div className="table-actions-cell">
                          <button
                            type="button"
                            className="table-action subtle-action"
                            onClick={() => openModal({ type: 'product', product })}
                          >
                            ✎ {lang === 'ar' ? 'تعديل' : 'Edit'}
                          </button>
                          <button
                            type="button"
                            className="table-action reject-action"
                            onClick={() => handleDelete(product)}
                            title={t('deleteProductBtn')}
                          >
                            ✕
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </section>
      )}

      {/* Empty Search / Filter State */}
      {filteredProducts.length === 0 && (
        <div className="empty-state-pro">
          <div className="empty-state-icon">☕</div>
          <h3>{lang === 'ar' ? 'لا توجد أصناف مطابقة للبحث أو التصفية الحالية' : 'No menu items match your search or filter'}</h3>
          <p>{lang === 'ar' ? 'جرّب كتابة اسم آخر أو اختيار تصنيف مختلف من القائمة أعلاه.' : 'Try searching for another term or selecting a different category above.'}</p>
          <div className="empty-state-actions">
            <button
              className="button button-secondary"
              onClick={() => {
                setSearch('');
                setSelectedCat('all');
              }}
            >
              ↻ {lang === 'ar' ? 'إعادة ضبط كل الفلاتر' : 'Reset All Filters'}
            </button>
            <button
              className="button button-primary"
              onClick={() => openModal({ type: 'product' })}
            >
              {t('menuAddProduct')}
            </button>
          </div>
        </div>
      )}
    </>
  );
}

function CustomersPage({ customers = [], setCustomers, openModal, notify, lang = 'ar', t }) {
  const [search, setSearch] = useState('');
  const [selectedSeg, setSelectedSeg] = useState('all');
  const [sortBy, setSortBy] = useState('spent');

  // Counts
  const totalCount = 1284; // Platform total
  const currentTotal = customers.length;
  const vipCount = customers.filter((c) => c.segmentKey === 'vip').length;
  const returningCount = customers.filter((c) => c.segmentKey === 'returning').length;
  const newCount = customers.filter((c) => c.segmentKey === 'new').length;
  const atRiskCount = customers.filter((c) => c.segmentKey === 'at_risk').length;
  const withDiscountCount = customers.filter((c) => c.discount && c.discount !== 'لا يوجد' && c.discount !== 'None').length;

  // Segment Tabs with live dynamic counts
  const segmentTabs = [
    { id: 'all', label: t('segAll'), icon: '👥', count: currentTotal },
    { id: 'vip', label: t('segVip'), icon: '💎', count: vipCount },
    { id: 'returning', label: t('segReturning'), icon: '🔄', count: returningCount },
    { id: 'new', label: t('segNew'), icon: '🌱', count: newCount },
    { id: 'at_risk', label: t('segAtRisk'), icon: '💤', count: atRiskCount, highlight: atRiskCount > 0 },
    { id: 'discount', label: t('segWithDiscount'), icon: '🎁', count: withDiscountCount },
  ];

  // Filtering & Sorting
  const filteredCustomers = useMemo(() => {
    let result = [...customers];

    // Segment filter
    if (selectedSeg === 'vip') result = result.filter((c) => c.segmentKey === 'vip');
    else if (selectedSeg === 'returning') result = result.filter((c) => c.segmentKey === 'returning');
    else if (selectedSeg === 'new') result = result.filter((c) => c.segmentKey === 'new');
    else if (selectedSeg === 'at_risk') result = result.filter((c) => c.segmentKey === 'at_risk');
    else if (selectedSeg === 'discount') result = result.filter((c) => c.discount && c.discount !== 'لا يوجد' && c.discount !== 'None');

    // Search filter
    if (search.trim()) {
      const q = search.trim().toLowerCase();
      result = result.filter((c) =>
        (c.name && c.name.toLowerCase().includes(q)) ||
        (c.nameEn && c.nameEn.toLowerCase().includes(q)) ||
        (c.phone && c.phone.includes(q)) ||
        (c.email && c.email.toLowerCase().includes(q)) ||
        (c.favoriteItem && c.favoriteItem.toLowerCase().includes(q)) ||
        (c.favoriteItemEn && c.favoriteItemEn.toLowerCase().includes(q))
      );
    }

    // Sorting
    if (sortBy === 'spent') {
      result.sort((a, b) => (b.spent || 0) - (a.spent || 0));
    } else if (sortBy === 'orders') {
      result.sort((a, b) => (b.orders || 0) - (a.orders || 0));
    } else if (sortBy === 'recent') {
      // Keep recent first
    } else if (sortBy === 'name') {
      result.sort((a, b) => a.name.localeCompare(b.name, 'ar'));
    }

    return result;
  }, [customers, selectedSeg, search, sortBy]);

  // Professional Customer Exporters
  const handleExportExcel = (customList = null) => {
    const listToExport = customList || filteredCustomers;
    exportCustomersToExcel(listToExport, {
      cafeName: lang === 'ar' ? 'مقهى الزيتون' : 'Al-Zaytoun Cafe',
      branchName: lang === 'ar' ? 'كفر الشيخ — شارع الجيش' : 'Kafr El-Sheikh — El-Geesh St.',
      lang,
      filterLabel: selectedSeg === 'all' ? (lang === 'ar' ? 'كافة الفئات' : 'All') : selectedSeg,
    });
    notify(lang === 'ar' ? 'تم تنزيل تقرير Excel التنفيذي المنسق بنجاح 📊' : 'Executive Excel report downloaded successfully 📊');
  };

  const handleExportCSV = (customList = null) => {
    const listToExport = customList || filteredCustomers;
    exportCustomersToCSV(listToExport, { lang });
    notify(lang === 'ar' ? 'تم تنزيل ملف CSV المطور والمتوافق مع الأعمدة بنجاح 📄' : 'Universal CSV file downloaded successfully 📄');
  };

  // Re-engage all at-risk customers
  const handleReengageAtRisk = () => {
    setCustomers((rows) =>
      rows.map((c) =>
        c.segmentKey === 'at_risk'
          ? {
              ...c,
              discount: 'خصم 20٪ ترحيبي',
              discountEn: '20% Welcome Back Offer',
              color: 'green',
            }
          : c
      )
    );
    notify(lang === 'ar' ? 'تم إرسال كود خصم ترحيبي 20% لجميع العملاء الغائبين بنجاح 🚀' : 'Sent 20% welcome-back offer to dormant customers 🚀');
  };

  return (
    <>
      <PageHeading
        eyebrow={t('custEyebrow')}
        title={t('custMainTitle')}
        description={t('custMainDesc')}
      >
        <div className="header-export-actions">
          <button
            type="button"
            className="export-pill-btn excel-btn"
            onClick={() => handleExportExcel(filteredCustomers)}
            title={lang === 'ar' ? 'تنزيل مباشر لتقرير إكسيل المصمم التنفيذي' : 'Direct download of styled Excel report'}
          >
            📊 {lang === 'ar' ? 'Excel فاخر' : 'Executive Excel'}
          </button>
          <button
            type="button"
            className="export-pill-btn"
            onClick={() => handleExportCSV(filteredCustomers)}
            title={lang === 'ar' ? 'تنزيل مباشر لملف CSV المنظم بدون تداخل أعمدة' : 'Direct download of clean CSV'}
          >
            📄 {lang === 'ar' ? 'CSV منظم' : 'Clean CSV'}
          </button>
          <button
            type="button"
            className="export-pill-btn"
            onClick={() => openModal({ type: 'export_customers', filteredList: filteredCustomers, allList: customers })}
            title={lang === 'ar' ? 'مركز خيارات ونطاق تصدير التقارير' : 'Open Reports & Export Center'}
          >
            ⚙️ {lang === 'ar' ? 'خيارات التصدير' : 'Export Center'}
          </button>
        </div>
        <button className="button button-primary" onClick={() => openModal({ type: 'discount', customers })}>
          {t('custNewDiscountBtn')}
        </button>
        <button className="button button-secondary" onClick={() => openModal({ type: 'new_customer' })}>
          {t('custAddManualBtn')}
        </button>
      </PageHeading>

      {/* 4 Supercharged Top KPI Cards */}
      <div className="stats-grid customer-stats-grid">
        {/* Card 1: Total Customer Base */}
        <div className="stat-card stat-card-rich">
          <div className="stat-card-header">
            <span className="stat-icon-wrap" style={{ background: 'rgba(185, 109, 60, 0.12)', color: '#b96d3c' }}>👥</span>
            <span className="stat-tag success-tag">↑ ٨٫٤٪ {lang === 'ar' ? 'نمو شهري' : 'growth'}</span>
          </div>
          <div className="stat-card-title">{t('custKpiTotal')}</div>
          <div className="stat-card-val-row">
            <span className="stat-main-number">{lang === 'ar' ? '١٬٢٨٤' : '1,284'}</span>
            <span className="stat-unit">{lang === 'ar' ? 'عميل نشط' : 'active patrons'}</span>
          </div>
          <div className="stat-sub-info">
            <span>{currentTotal} {t('custKpiTotalSub')}</span>
          </div>
        </div>

        {/* Card 2: VIP & Loyal Patrons */}
        <div className="stat-card stat-card-rich">
          <div className="stat-card-header">
            <span className="stat-icon-wrap" style={{ background: 'rgba(124, 58, 237, 0.12)', color: '#7c3aed' }}>💎</span>
            <span className="stat-tag" style={{ background: '#f3e8ff', color: '#6b21a8' }}>
              ٢٤٫٦٪ {lang === 'ar' ? 'نسبة VIP' : 'VIP Share'}
            </span>
          </div>
          <div className="stat-card-title">{t('custKpiVip')}</div>
          <div className="stat-card-val-row">
            <span className="stat-main-number">{lang === 'ar' ? '٣١٦' : '316'}</span>
            <span className="stat-unit">({vipCount} {lang === 'ar' ? 'عملاء في الفرع' : 'in branch'})</span>
          </div>
          <div className="menu-progress-track">
            <div className="menu-progress-bar" style={{ width: '86%', background: 'linear-gradient(90deg, #7c3aed 0%, #b96d3c 100%)' }} />
          </div>
          <div className="stat-sub-info">
            <span>{t('custKpiVipSub')}</span>
          </div>
        </div>

        {/* Card 3: Active Rewards & Perks */}
        <div className="stat-card stat-card-rich">
          <div className="stat-card-header">
            <span className="stat-icon-wrap" style={{ background: 'rgba(46, 125, 50, 0.12)', color: '#2e7d32' }}>🎁</span>
            <span className="stat-tag success-tag">
              {withDiscountCount} {lang === 'ar' ? 'خصومات سارية' : 'active perks'}
            </span>
          </div>
          <div className="stat-card-title">{t('custKpiActiveOffers')}</div>
          <div className="stat-card-val-row">
            <span className="stat-main-number text-success">{withDiscountCount + 39}</span>
            <span className="stat-unit">{lang === 'ar' ? 'عرض مخصص' : 'active perks'}</span>
          </div>
          <div className="stat-sub-info">
            <span>{t('custKpiActiveOffersSub')}</span>
          </div>
        </div>

        {/* Card 4: Avg Customer Spend (LTV) */}
        <div className="stat-card stat-card-rich">
          <div className="stat-card-header">
            <span className="stat-icon-wrap" style={{ background: 'rgba(217, 119, 6, 0.12)', color: '#d97706' }}>💳</span>
            <span className="stat-tag fire-tag">٣٫٢ {lang === 'ar' ? 'طلب/أسبوع' : 'orders/wk'}</span>
          </div>
          <div className="stat-card-title">{t('custKpiLtv')}</div>
          <div className="stat-card-val-row">
            <span className="stat-main-number">{lang === 'ar' ? '٤٨٦' : '486'}</span>
            <span className="stat-unit">{t('currency')} / {lang === 'ar' ? 'لكل عميل' : 'patron'}</span>
          </div>
          <div className="stat-sub-info">
            <span>{t('custKpiLtvSub')}</span>
          </div>
        </div>
      </div>

      {/* Smart Dormant Re-engagement Banner */}
      {atRiskCount > 0 && (
        <div className="customer-reengage-banner">
          <div className="reengage-icon">🚀</div>
          <div className="reengage-text">
            <strong>{t('dormantAlertTitle')} ({atRiskCount} {lang === 'ar' ? 'عملاء' : 'patrons'})</strong>
            <p>{t('dormantAlertText')}</p>
          </div>
          <button className="reengage-action-btn" onClick={handleReengageAtRisk}>
            {t('reengageBtn')}
          </button>
        </div>
      )}

      {/* Segment Navigation Ribbon */}
      <div className="menu-categories-ribbon">
        {segmentTabs.map((tab) => {
          const isSelected = selectedSeg === tab.id;
          return (
            <button
              key={tab.id}
              className={`cat-pill-btn ${isSelected ? 'active' : ''} ${tab.highlight ? 'has-alert' : ''}`}
              onClick={() => setSelectedSeg(tab.id)}
            >
              <span className="cat-icon">{tab.icon}</span>
              <span className="cat-label">{tab.label}</span>
              <span className="cat-count-badge">{tab.count}</span>
            </button>
          );
        })}
      </div>

      {/* Modern Toolbar Pro */}
      <div className="menu-toolbar-pro">
        <div className="menu-search-wrap">
          <span className="search-icon">⌕</span>
          <input
            type="text"
            className="menu-search-input"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder={t('custSearchPlaceholder')}
          />
          {search && (
            <button className="clear-search-btn" onClick={() => setSearch('')}>✕</button>
          )}
        </div>

        <div className="menu-toolbar-controls">
          <div className="sort-selector-wrap">
            <label className="sort-label">⇅ {lang === 'ar' ? 'ترتيب العملاء:' : 'Sort:'}</label>
            <select
              className="menu-select-box"
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
            >
              <option value="spent">{t('custSortSpentDesc')}</option>
              <option value="orders">{t('custSortOrdersDesc')}</option>
              <option value="recent">{t('custSortRecent')}</option>
              <option value="name">{t('custSortName')}</option>
            </select>
          </div>

          <div className="items-counter-chip">
            <b>{filteredCustomers.length}</b> {lang === 'ar' ? 'عميل معروض' : 'customers listed'}
          </div>
        </div>
      </div>

      {/* Customer CRM Table Panel */}
      <section className="panel customer-panel-pro">
        <div className="table-wrap">
          <table className="customer-pro-table">
            <thead>
              <tr>
                <th>{t('thCustName')}</th>
                <th>{t('thCustFav')}</th>
                <th>{t('thCustOrders')}</th>
                <th>{t('thCustSpent')}</th>
                <th>{lang === 'ar' ? 'نقاط الولاء' : 'Points'}</th>
                <th>{t('thCustLast')}</th>
                <th>{t('thCustSegment')}</th>
                <th>{t('thCustDiscount')}</th>
                <th>{t('thCustActions')}</th>
              </tr>
            </thead>
            <tbody>
              {filteredCustomers.map((customer) => {
                const displayName = lang === 'ar' ? customer.name : (customer.nameEn || customer.name);
                const isVip = customer.segmentKey === 'vip';
                const isAtRisk = customer.segmentKey === 'at_risk';
                const favDrink = lang === 'ar' ? customer.favoriteItem : (customer.favoriteItemEn || customer.favoriteItem);
                const lastTime = lang === 'ar' ? customer.last : (customer.lastEn || customer.last);
                const hasDiscount = customer.discount && customer.discount !== 'لا يوجد' && customer.discount !== 'None';

                return (
                  <tr key={customer.id || customer.name} className={isAtRisk ? 'row-at-risk' : isVip ? 'row-vip' : ''}>
                    {/* Customer Info Cell */}
                    <td>
                      <div className="customer-cell-pro">
                        <div className={`customer-avatar-pro ${customer.segmentKey || 'regular'}`}>
                          <span>{customer.name[0]}</span>
                          {isVip && <span className="vip-crown-badge" title="عميل VIP">👑</span>}
                        </div>
                        <div className="customer-meta-col">
                          <strong className="customer-name-text">
                            {displayName}
                            {isVip && <span className="vip-text-tag">VIP</span>}
                          </strong>
                          <span className="customer-phone-text">{customer.phone}</span>
                          {customer.email && <small className="customer-email-text">{customer.email}</small>}
                        </div>
                      </div>
                    </td>

                    {/* Favorite Drink */}
                    <td>
                      <span className="fav-drink-pill" title={favDrink}>
                        ☕ {favDrink || (lang === 'ar' ? 'سبانش لاتيه' : 'Spanish Latte')}
                      </span>
                    </td>

                    {/* Orders count */}
                    <td>
                      <div className="orders-badge-cell">
                        <b>{customer.orders}</b>
                        <small>{lang === 'ar' ? 'طلب' : 'orders'}</small>
                      </div>
                    </td>

                    {/* Total spent */}
                    <td>
                      <strong className="customer-spent-val">
                        {money(customer.spent)}
                      </strong>
                    </td>

                    {/* Loyalty Points */}
                    <td>
                      <span className="loyalty-pts-badge">
                        ⭐ {customer.loyaltyPoints || Math.round(customer.spent * 0.1)}
                      </span>
                    </td>

                    {/* Last visit */}
                    <td>
                      <span className={`last-visit-tag ${isAtRisk ? 'dormant' : ''}`}>
                        {lastTime}
                      </span>
                    </td>

                    {/* Segment Badge */}
                    <td>
                      <span className={`segment-tag-pro ${customer.segmentKey || 'regular'}`}>
                        {isVip ? '💎 ' : customer.segmentKey === 'returning' ? '🔄 ' : customer.segmentKey === 'new' ? '🌱 ' : customer.segmentKey === 'at_risk' ? '💤 ' : ''}
                        {lang === 'ar' ? customer.segment : (customer.segmentKey === 'vip' ? 'VIP & Loyal' : customer.segmentKey === 'returning' ? 'Returning' : customer.segmentKey === 'new' ? 'New' : 'Dormant')}
                      </span>
                    </td>

                    {/* Active Discount */}
                    <td>
                      {hasDiscount ? (
                        <button
                          type="button"
                          className="customer-discount-tag active-tag"
                          onClick={() => openModal({ type: 'discount', customer })}
                          title={lang === 'ar' ? 'تعديل الخصم' : 'Edit discount'}
                        >
                          🎁 {lang === 'ar' ? customer.discount : (customer.discountEn || customer.discount)}
                        </button>
                      ) : (
                        <button
                          type="button"
                          className="grant-discount-link"
                          onClick={() => openModal({ type: 'discount', customer })}
                        >
                          ＋ {lang === 'ar' ? 'منح خصم' : 'Grant Offer'}
                        </button>
                      )}
                    </td>

                    {/* Action Button */}
                    <td>
                      <button
                        type="button"
                        className="customer-view-profile-btn"
                        onClick={() => openModal({ type: 'customer', customer })}
                      >
                        {t('btnViewCust')}
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>

          {filteredCustomers.length === 0 && (
            <div className="empty-state-pro">
              <div className="empty-state-icon">👥</div>
              <h3>{lang === 'ar' ? 'لا يوجد عملاء مطابقين للبحث' : 'No patrons match your search'}</h3>
              <p>{lang === 'ar' ? 'جرّب البحث باسم آخر أو إزالة التصفية الحالية.' : 'Try a different search term or reset current filters.'}</p>
              <div className="empty-state-actions">
                <button
                  className="button button-secondary"
                  onClick={() => {
                    setSearch('');
                    setSelectedSeg('all');
                  }}
                >
                  ↻ {lang === 'ar' ? 'إعادة ضبط الفلاتر' : 'Reset Filters'}
                </button>
                <button
                  className="button button-primary"
                  onClick={() => openModal({ type: 'new_customer' })}
                >
                  {t('custAddManualBtn')}
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Footer pagination simulation */}
        <div className="table-pagination-pro">
          <span>{lang === 'ar' ? `عرض ${filteredCustomers.length} من أصل ١٬٢٨٤ عميل مسجل` : `Showing ${filteredCustomers.length} of 1,284 total patrons`}</span>
          <div className="pagination-pages">
            <button disabled className="page-nav-btn">‹ {lang === 'ar' ? 'السابق' : 'Prev'}</button>
            <button className="page-num-btn active">١</button>
            <button className="page-num-btn">٢</button>
            <button className="page-num-btn">٣</button>
            <button className="page-nav-btn">{lang === 'ar' ? 'التالي' : 'Next'} ›</button>
          </div>
        </div>
      </section>
    </>
  );
}

function OffersPage({ openModal, notify }) {
  const offers = [{ title: 'أهلاً بيك أول مرة', detail: 'خصم للعميل الجديد على أول طلب', tag: 'عملاء جدد', value: 'خصم ١٥٪', uses: '٨٤ / ٢٠٠', ends: 'ينتهي ٣٠ نوفمبر', on: true }, { title: 'رجعنا نوحشك', detail: 'عرض للعملاء اللي غابوا أكتر من شهر', tag: 'عملاء غير نشطين', value: 'خصم ٢٥ ج.م', uses: '٣١ / ١٠٠', ends: 'ينتهي ١٥ نوفمبر', on: true }, { title: 'سبت القهوة علينا', detail: 'مشروب مجاني بعد ٥ طلبات مكتملة', tag: 'عملاء دائمون', value: 'مكافأة ولاء', uses: '١٩ / غير محدود', ends: 'بدون تاريخ انتهاء', on: false }];
  return <><PageHeading eyebrow="التسويق والنمو" title="الخصومات والعروض" description="جهّز عروض توصل للعميل المناسب في الوقت المناسب."><button className="button button-primary" onClick={() => openModal({ type: 'offer' })}>＋ <span>إنشاء عرض</span></button></PageHeading><div className="offer-summary"><div><span>عروض نشطة</span><strong>٠٢</strong></div><div><span>استخدامات هذا الشهر</span><strong>١١٥</strong></div><div><span>مبيعات من العروض</span><strong>١٨٬٦٤٠ <small>ج.م</small></strong></div><div><span>توفير للعملاء</span><strong>٣٬٢٨٠ <small>ج.م</small></strong></div></div><div className="offers-list">{offers.map((offer) => <article className="offer-card" key={offer.title}><div className="offer-art"><span>{offer.value.includes('ولاء') ? '✳' : '٪'}</span></div><div className="offer-info"><div className="offer-topline"><span className="segment-tag amber">{offer.tag}</span><span className={`offer-state ${offer.on ? 'live' : ''}`}><i/>{offer.on ? 'نشط' : 'مسودة'}</span></div><h3>{offer.title}</h3><p>{offer.detail}</p><div className="offer-meta"><span>♧ {offer.uses} استخدام</span><span>◷ {offer.ends}</span><b>{offer.value}</b></div></div><div className="offer-actions"><button className="dots" onClick={() => notify('تم فتح خيارات العرض')}>···</button><button className="table-action" onClick={() => openModal({ type: 'offer', offer })}>{offer.on ? 'تعديل العرض' : 'استكمال الإعداد'}</button></div></article>)}</div></>;
}

function ProximityPage({ campaigns, onToggle, openModal, notify, lang = 'ar', t }) {
  const [filter, setFilter] = useState('all');
  const filtered = campaigns.filter((c) => {
    if (filter === 'active') return c.status === 'active';
    if (filter === 'paused') return c.status === 'paused';
    if (filter === 'draft') return c.status === 'draft';
    return true;
  });

  const filterTabs = [
    { id: 'all', label: t('filterAll') },
    { id: 'active', label: lang === 'ar' ? 'نشط' : 'Active' },
    { id: 'paused', label: lang === 'ar' ? 'موقوف' : 'Paused' },
    { id: 'draft', label: lang === 'ar' ? 'مسودة' : 'Draft' },
  ];

  return (
    <>
      <PageHeading
        eyebrow={t('proxEyebrow')}
        title={t('proxMainTitle')}
        description={t('proxMainDesc')}
      >
        <button className="button button-secondary" onClick={() => openModal({ type: 'proximity_preview', campaign: campaigns[0] })}>
          📱 <span>{t('proxPreviewPhoneBtn')}</span>
        </button>
        <button className="button button-primary" onClick={() => openModal({ type: 'proximity_form' })}>
          ＋ <span>{t('proxNewCampBtn')}</span>
        </button>
      </PageHeading>

      <div className="proximity-policy-banner">
        <div className="policy-badge-icon">🛡️</div>
        <div className="policy-content">
          <strong>{t('proxPolicyHeader')}</strong>
          <div className="policy-grid">
            <div className="policy-pill">
              <span className="pill-dot" />
              <span>{t('proxCap')}</span>
            </div>
            <div className="policy-pill">
              <span className="pill-dot" />
              <span>{t('proxCooldown')}</span>
            </div>
            <div className="policy-pill">
              <span className="pill-dot" />
              <span>{t('proxQuota')}</span>
            </div>
            <div className="policy-pill">
              <span className="pill-dot" />
              <span>{t('proxLocalCache')}</span>
            </div>
          </div>
        </div>
      </div>

      <div className="stats-grid proximity-stats">
        <StatCard title={t('proxStatDelivered')} amount={lang === 'ar' ? '٣٤٢' : '342'} note={t('proxStatDeliveredNote')} tone="gold" currency={t('currency')} />
        <StatCard title={t('proxStatOpenRate')} amount={lang === 'ar' ? '٢٨٫٣٪' : '28.3%'} note={t('proxStatOpenNote')} tone="green" currency="%" />
        <StatCard title={t('proxStatActiveCamps')} amount={`${campaigns.filter(c => c.status === 'active').length}`} note={t('proxStatActiveNote')} tone="blue" currency={lang === 'ar' ? 'حملات' : 'camps'} />
        <StatCard title={t('proxStatRevenue')} amount={lang === 'ar' ? '٨٬٤٥٠' : '8,450'} note={t('proxStatRevenueNote')} tone="rose" currency={t('currency')} />
      </div>

      <div className="filter-tabs">
        {filterTabs.map((f) => (
          <button key={f.id} className={filter === f.id ? 'selected' : ''} onClick={() => setFilter(f.id)}>
            {f.label} {f.id === 'all' && <b>{campaigns.length}</b>}
          </button>
        ))}
      </div>

      <div className="proximity-campaigns-list">
        {filtered.map((camp) => (
          <article className="proximity-card" key={camp.id}>
            <div className="proximity-thumb">
              <img src={camp.image} alt={camp.name} />
              <span className="proximity-discount-badge">{camp.discount}</span>
            </div>

            <div className="proximity-details">
              <div className="proximity-header-row">
                <div className="proximity-title-wrap">
                  <h3>{camp.name}</h3>
                  <span className="proximity-branch">📍 {camp.branch}</span>
                </div>
                <div className="proximity-status-wrap">
                  <span className={`status-pill ${camp.status === 'active' ? 'completed' : camp.status === 'paused' ? 'preparing' : 'new'}`}>
                    <i /> {camp.status === 'active' ? (lang === 'ar' ? 'نشط ومعتمد' : 'Active & Approved') : camp.status === 'paused' ? (lang === 'ar' ? 'موقوف مؤقتاً' : 'Paused') : (lang === 'ar' ? 'مسودة' : 'Draft')}
                  </span>
                </div>
              </div>

              <div className="proximity-bubble">
                <div className="bubble-header">
                  <span>{t('proxBubbleNotice')}</span>
                  <strong>{camp.title}</strong>
                </div>
                <p>{camp.body}</p>
              </div>

              <div className="proximity-meta-row">
                <div className="proximity-meta-chip">
                  <span>{t('proxTimeWindow')}</span>
                  <b>{camp.timeLabel}</b>
                </div>
                <div className="proximity-meta-chip">
                  <span>{t('proxRadius')}</span>
                  <b>{camp.radius} {lang === 'ar' ? 'متر' : 'meters'}</b>
                </div>
                <div className="proximity-meta-chip">
                  <span>{t('proxAudience')}</span>
                  <b>{camp.targetSegment}</b>
                </div>
                <div className="proximity-meta-chip highlight">
                  <span>{t('proxPerf')}</span>
                  <b>{camp.sentCount} {lang === 'ar' ? 'إشعار' : 'sent'} · {camp.openCount} {lang === 'ar' ? 'فتح' : 'opened'}</b>
                </div>
              </div>
            </div>

            <div className="proximity-actions-col">
              <button
                className="button button-secondary preview-mobile-btn"
                onClick={() => openModal({ type: 'proximity_preview', campaign: camp })}
                title={lang === 'ar' ? 'معاينة شكل الإشعار على شاشة قفل الموبايل' : 'Preview lockscreen notification'}
              >
                📱 <span>{t('proxPreviewMobile')}</span>
              </button>
              <button
                className={`table-action ${camp.status === 'active' ? 'reject-action' : ''}`}
                onClick={() => onToggle(camp.id)}
              >
                {camp.status === 'active' ? t('proxPauseCamp') : t('proxResumeCamp')}
              </button>
              <button
                className="table-action"
                onClick={() => openModal({ type: 'proximity_form', campaign: camp })}
              >
                {t('proxEditCamp')}
              </button>
            </div>
          </article>
        ))}
      </div>
    </>
  );
}

function LoyaltyPage({ openModal, notify }) {
  return <><PageHeading eyebrow="الاحتفاظ بالعملاء" title="برامج الولاء" description="حوّل كل زيارة لسبب يخلي عميلك يرجع تاني."><button className="button button-primary" onClick={() => openModal({ type: 'loyalty' })}>＋ <span>برنامج جديد</span></button></PageHeading><div className="loyalty-hero"><div><span className="eyebrow">برنامجك الأساسي</span><h2>كل ٦ أكواب، السابع علينا ☕</h2><p>اجمع ختم مع كل طلب مكتمل، واستبدلهم بمشروب مجاني من اختيارك.</p><div className="loyalty-numbers"><div><strong>٧٨٤</strong><span>مشترك نشط</span></div><div><strong>١٢٦</strong><span>مكافأة مستبدلة</span></div><div><strong>٨٩٪</strong><span>نسبة العودة</span></div></div></div><div className="stamp-visual"><div className="stamp-grid">{Array.from({ length: 7 }, (_, i) => <span className={i < 5 ? 'stamped' : ''} key={i}>{i < 5 ? '✓' : '☕'}</span>)}</div><small>مثال كارت العميل</small></div></div><section className="panel loyalty-program"><div className="panel-heading"><div><h2>البرامج الحالية</h2><span>برامج الولاء الخاصة بمقهى الزيتون</span></div><button className="more-button" onClick={() => notify('إعدادات البرنامج التجريبي')}>إدارة البرامج ←</button></div><div className="program-row"><div className="program-icon">✳</div><div className="program-text"><strong>كارت الأكواب</strong><span>مكافأة: مشروب مجاني بعد ٦ طلبات</span></div><span className="status-pill completed">نشط</span><button className="table-action" onClick={() => openModal({ type: 'loyalty' })}>تعديل البرنامج</button></div><div className="program-row"><div className="program-icon violet">♧</div><div className="program-text"><strong>مكافأة عميلنا الدائم</strong><span>خصم ١٠٪ بعد ١٢ طلب مكتمل</span></div><span className="status-pill completed">نشط</span><button className="table-action" onClick={() => openModal({ type: 'loyalty' })}>تعديل البرنامج</button></div></section></>;
}

function StaffPage({ openModal, notify }) {
  const staff = [{ n: 'سارة مصطفى', role: 'مديرة الفرع', p: 'إدارة الطلبات · المنيو · العملاء', status: 'نشط', initials: 'س' }, { n: 'كريم عادل', role: 'باريستا', p: 'الطلبات · توفر المنتجات', status: 'نشط', initials: 'ك' }, { n: 'منة الله سامي', role: 'كاشير', p: 'الطلبات · تأكيد استلام الكاش', status: 'نشط', initials: 'م' }, { n: 'زياد حسن', role: 'باريستا', p: 'الطلبات · توفر المنتجات', status: 'موقوف', initials: 'ز' }];
  return <><PageHeading eyebrow="فريق العمل" title="الموظفون والصلاحيات" description="أضف فريقك وحدد بدقة كل شخص يقدر يعمل إيه."><button className="button button-primary" onClick={() => openModal({ type: 'staff' })}>＋ <span>إضافة موظف</span></button></PageHeading><div className="staff-callout"><span>ⓘ</span><div><strong>إدارة صلاحيات آمنة</strong><small>الموظف يشوف بس الأقسام والإجراءات اللي سمحت له بيها. الرواتب متاحة للمالك فقط افتراضيًا.</small></div></div><section className="panel"><div className="table-heading"><div className="searchbox"><span>⌕</span><input placeholder="ابحث عن موظف..."/></div><button className="button button-secondary" onClick={() => notify('فلاتر الموظفين')}>كل الحالات⌄</button></div><div className="table-wrap"><table><thead><tr><th>الموظف</th><th>الدور</th><th>الصلاحيات</th><th>الحالة</th><th>آخر نشاط</th><th/></tr></thead><tbody>{staff.map((person, i) => <tr key={person.n}><td><div className="customer-cell"><div className="customer-avatar">{person.initials}</div><div><strong>{person.n}</strong><small>010 •••• {2381 + i * 127}</small></div></div></td><td>{person.role}</td><td className="muted-cell">{person.p}</td><td><span className={`status-pill ${person.status === 'نشط' ? 'completed' : 'rejected'}`}>{person.status}</span></td><td>اليوم، ٩:١٥ ص</td><td><button className="dots" onClick={() => openModal({ type: 'staff', employee: person })}>···</button></td></tr>)}</tbody></table></div></section></>;
}

function PayrollPage({ openModal, notify }) {
  const [month, setMonth] = useState('نوفمبر ٢٠٢٦');
  const staff = [{ n: 'سارة مصطفى', title: 'مديرة الفرع', salary: 12000, paid: 6000 }, { n: 'كريم عادل', title: 'باريستا', salary: 7500, paid: 7500 }, { n: 'منة الله سامي', title: 'كاشير', salary: 6800, paid: 0 }, { n: 'زياد حسن', title: 'باريستا', salary: 7000, paid: 3500 }];
  return <><PageHeading eyebrow="الإدارة المالية" title="الرواتب والدفعات" description="تابع الراتب الشهري لكل موظف وسجّل الدفعات النقدية."><select className="select-control" value={month} onChange={(e) => setMonth(e.target.value)}><option>نوفمبر ٢٠٢٦</option><option>أكتوبر ٢٠٢٦</option><option>سبتمبر ٢٠٢٦</option></select><button className="button button-secondary" onClick={() => notify('تم تجهيز كشف الرواتب التجريبي')}>↓ <span>تصدير كشف الشهر</span></button></PageHeading><div className="cash-note"><span>▣</span><div><strong>تسجيل نقدي فقط في V1</strong><small>تسجيل الدفعة يوثق استلام الكاش، ولا ينفذ تحويلًا بنكيًا أو دفعًا إلكترونيًا.</small></div></div><div className="stats-grid payroll-stats"><StatCard title="إجمالي رواتب الشهر" amount="٣٣٬٣٠٠" note="٤ موظفين" tone="gold"/><StatCard title="المدفوع نقدًا" amount="١٧٬٠٠٠" note="دفعات مسجلة" tone="green"/><StatCard title="المتبقي" amount="١٦٬٣٠٠" note="على ٣ موظفين" tone="rose"/></div><section className="panel"><div className="panel-heading"><div><h2>كشف الرواتب · {month}</h2><span>الدفعات النقدية المسجلة لهذا الشهر</span></div><button className="more-button" onClick={() => notify('لا توجد ورديات أو تسجيل حضور في V1')}>طريقة الحساب <b>ⓘ</b></button></div><div className="table-wrap"><table><thead><tr><th>الموظف</th><th>الراتب الشهري</th><th>المدفوع كاش</th><th>المتبقي</th><th>حالة السداد</th><th>الإجراء</th></tr></thead><tbody>{staff.map((person) => <tr key={person.n}><td><div className="customer-cell"><div className="customer-avatar">{person.n[0]}</div><div><strong>{person.n}</strong><small>{person.title}</small></div></div></td><td>{money(person.salary)}</td><td>{money(person.paid)}</td><td><b>{money(person.salary - person.paid)}</b></td><td><span className={`status-pill ${person.paid === person.salary ? 'completed' : person.paid ? 'preparing' : 'new'}`}>{person.paid === person.salary ? 'مدفوع بالكامل' : person.paid ? 'مدفوع جزئيًا' : 'غير مدفوع'}</span></td><td><button className="table-action" onClick={() => openModal({ type: 'payment', employee: person, month })}>تسجيل دفعة كاش</button></td></tr>)}</tbody></table></div></section><p className="footnote">لا يوجد حضور أو انصراف أو احتساب ساعات عمل في الإصدار الأول.</p></>;
}

function StatCard({ title, amount, note, tone }) { return <div className="stat-card"><div className="stat-top"><span>{title}</span><i className={`stat-icon ${tone}`}>▣</i></div><div className="stat-number">{amount}<small>ج.م</small></div><div className="stat-foot">{note}</div></div>; }

function BrandingPage({ color, setColor, font, setFont, published, setPublished, notify }) {
  return <><PageHeading eyebrow="هوية الكافيه" title="صفحة كافيهك" description="خصص شكل صفحتك اللي بيشوفها العملاء داخل تطبيق CupBack."><span className={`status-pill ${published ? 'completed' : 'preparing'}`}>{published ? 'آخر التغييرات منشورة' : 'تغييرات غير منشورة'}</span><button className="button button-primary" onClick={() => { setPublished(true); notify('تم نشر تغييرات المظهر التجريبية'); }}>نشر التغييرات</button></PageHeading><div className="branding-layout"><section className="panel brand-form"><div className="panel-heading"><div><h2>معلومات الكافيه</h2><span>المعلومات الأساسية الظاهرة للعميل</span></div></div><label className="field-label">اسم الكافيه</label><input className="text-input" defaultValue="مقهى الزيتون"/><label className="field-label">وصف قصير</label><textarea className="text-input textarea" defaultValue="قهوة مختصة ومخبوزات طازة، معمولة بحب في قلب كفر الشيخ."/><div className="image-upload-row"><div><label className="field-label">صورة الغلاف</label><small>مقاس مقترح ١٢٠٠ × ٥٠٠</small></div><button className="upload-button" onClick={() => notify('رفع الصور يحتاج ربط التخزين')}>↥ <span>تغيير الصورة</span></button></div><div className="image-preview" style={{ backgroundImage: `linear-gradient(90deg,rgba(30,18,10,.08),rgba(30,18,10,.45)),url(https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=900&h=300&fit=crop)` }}><span className="preview-logo">ز</span><span className="preview-caption">مقهى الزيتون</span><span className="preview-subcaption">قهوة مختصة ومخبوزات طازة</span></div><div className="form-divider"/><h3>ألوان صفحة الكافيه</h3><p className="form-hint">تظهر اختياراتك في صفحة مقهاك فقط.</p><div className="swatches">{['#b96d3c', '#2e6b52', '#6b5a8e', '#2b6474', '#262626'].map((shade) => <button aria-label={`لون ${shade}`} className={color === shade ? 'chosen' : ''} key={shade} style={{ backgroundColor: shade }} onClick={() => { setColor(shade); setPublished(false); }}/>) }<label className="custom-color">＋<input type="color" value={color} onChange={(e) => { setColor(e.target.value); setPublished(false); }}/></label></div><label className="field-label font-label">خط صفحة الكافيه</label><select className="select-control full-width" value={font} onChange={(e) => { setFont(e.target.value); setPublished(false); }}><option>Cairo</option><option>Plus Jakarta Sans</option></select><div className="form-actions"><button className="button button-secondary" onClick={() => notify('حُفظت مسودة المظهر في العرض التجريبي')}>حفظ كمسودة</button><button className="button button-primary" onClick={() => { setPublished(true); notify('تم نشر تغييرات المظهر التجريبية'); }}>حفظ ونشر</button></div></section><section className="preview-column"><div className="preview-label"><span>معاينة صفحة العميل</span><button onClick={() => notify('المعاينة مخصصة لشاشة الهاتف')}>▯ هاتف</button></div><div className="phone-frame"><div className="phone-status"><span>٩:٤١</span><span>●●● ▰</span></div><div className="phone-cover" style={{ backgroundImage: 'linear-gradient(180deg,transparent 50%,rgba(0,0,0,.55)),url(https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=500&h=240&fit=crop)' }}><button>←</button></div><div className="phone-cafe" style={{ fontFamily: font }}><div className="phone-logo" style={{ background: color }}>ز</div><div className="phone-title"><strong>مقهى الزيتون</strong><span>قهوة مختصة · مخبوزات</span><small>● مفتوح الآن · كفر الشيخ</small></div><div className="phone-rating">★ ٤٫٨</div><div className="phone-tabs"><b style={{ color, borderColor: color }}>المنيو</b><span>عن الكافيه</span><span>التقييمات</span></div><div className="phone-section">الأكثر طلبًا <span>عرض الكل</span></div>{products.slice(0, 2).map((p) => <div className="phone-product" key={p.name}><img src={p.image} alt=""/><div><b>{p.name}</b><small>اختيار العملاء</small><strong>{p.price}</strong></div><button style={{ color, borderColor: color }}>＋</button></div>)}</div></div><p className="preview-warning">المعاينة محلية. يتطلب النشر الحقيقي دعم إعدادات المظهر من تطبيق العميل والـAPI.</p></section></div></>;
}

function ReportsPage({ range, setRange, notify }) {
  const [from, setFrom] = useState('2026-11-01'); const [to, setTo] = useState('2026-11-11'); const [applied, setApplied] = useState(false);

  const handleExportSalesExcelClick = () => {
    exportSalesToExcel({}, { cafeName: 'مقهى الزيتون', range, lang: 'ar' });
    notify('تم تنزيل تقرير مبيعات Excel التنفيذي بنجاح 📊');
  };

  const handleExportSalesCSVClick = () => {
    const csvContent = '\uFEFFsep=,\r\n' + [
      '"البند المالي","طريقة التحصيل","القيمة (ج.م)"',
      '"طلبات نقدية (كاش الصالة والبار)","نقدي",218640',
      '"طلبات إلكترونية (تطبيق CupBack)","محفظة/فيزا",66000',
      '"إجمالي الخصومات والعروض","خصومات",-18420',
      '"صافي المبيعات المحققة","الصافي",266220',
    ].join('\r\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', `cupback_sales_report_${range}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    notify('تم تنزيل ملف CSV المبيعات المتوافق بنجاح 📄');
  };

  return <><PageHeading eyebrow="الأداء المالي" title="تقارير المبيعات" description="راجع أداء كافيهك حسب اليوم أو الشهر أو أي فترة تختارها.">
    <div className="header-export-actions">
      <button className="export-pill-btn excel-btn" onClick={handleExportSalesExcelClick}>📊 <span>Excel فاخر</span></button>
      <button className="export-pill-btn" onClick={handleExportSalesCSVClick}>📄 <span>CSV منظم</span></button>
    </div>
  </PageHeading><section className="panel report-filter"><div><label className="field-label">الفترة</label><select className="select-control" value={range} onChange={(e) => setRange(e.target.value)}><option>اليوم</option><option>هذا الشهر</option><option>فترة مخصصة</option></select></div>{range === 'فترة مخصصة' && <><div><label className="field-label">من تاريخ</label><input className="date-input" type="date" value={from} onChange={(e) => setFrom(e.target.value)}/></div><div><label className="field-label">إلى تاريخ</label><input className="date-input" type="date" value={to} onChange={(e) => setTo(e.target.value)}/></div></>}<button className="button button-primary" onClick={() => { setApplied(true); notify('تم تطبيق الفترة على بيانات العرض'); }}>تطبيق الفلاتر</button><button className="button button-secondary" onClick={() => { setRange('هذا الشهر'); setApplied(false); }}>مسح</button></section><div className="report-applied">{applied ? `الفترة المختارة: ${from} — ${to}` : `عرض تجريبي · ${range}`}</div><div className="stats-grid report-stats"><StatCard title="إجمالي المبيعات" amount="٢٨٤٬٦٤٠" note="من الطلبات المكتملة" tone="gold"/><StatCard title="عدد الطلبات" amount="٢٬٨٩٤" note="طلب مكتمل" tone="blue"/><StatCard title="متوسط الطلب" amount="٩٨٫٣" note="ج.م لكل طلب" tone="green"/><StatCard title="الخصومات" amount="١٨٬٤٢٠" note="ج.م مطبقة للعملاء" tone="rose"/></div><div className="dashboard-grid"><section className="panel sales-panel"><div className="panel-heading"><div><h2>المبيعات حسب اليوم</h2><span>إجمالي الطلبات المكتملة فقط</span></div><button className="more-button" onClick={() => notify('تنزيل PDF تجريبي')}>تنزيل PDF ↓</button></div><SalesChart/></section><section className="panel category-panel report-breakdown"><div className="panel-heading"><div><h2>ملخص الفترة</h2><span>توزيع قيمة المبيعات</span></div></div><div className="breakdown-row"><span>طلبات نقدية</span><b>٢١٨٬٦٤٠ ج.م</b></div><div className="breakdown-row"><span>طلبات إلكترونية</span><b>٦٦٬٠٠٠ ج.م</b></div><div className="breakdown-row discount-row"><span>الخصومات</span><b>−١٨٬٤٢٠ ج.م</b></div><div className="breakdown-total"><span>صافي المبيعات</span><b>٢٦٦٬٢٢٠ ج.م</b></div></section></div></>;
}

function SettingsPage({ notify }) {
  return <><PageHeading eyebrow="إدارة الكافيه" title="الإعدادات" description="حدّث معلومات الكافيه ومواعيد استقبال الطلبات."/><div className="settings-grid"><section className="panel settings-card"><div className="settings-symbol">◷</div><h3>مواعيد العمل</h3><p>حدد ساعات الفتح والإغلاق وأيام الإجازة. مواعيدك بتظهر للعميل في صفحة الكافيه.</p><div className="hours-row"><span>الأحد – الخميس</span><b>٨:٠٠ ص — ١٢:٠٠ ص</b></div><div className="hours-row"><span>الجمعة – السبت</span><b>١٠:٠٠ ص — ٢:٠٠ ص</b></div><button className="table-action" onClick={() => notify('تعديل ساعات العمل في العرض التجريبي')}>تعديل المواعيد</button></section><section className="panel settings-card"><div className="settings-symbol">♧</div><h3>معلومات التواصل</h3><p>وسائل التواصل والعنوان اللي بيشوفها عملاء كافيهك.</p><div className="hours-row"><span>رقم التواصل</span><b>010 •••• 5671</b></div><div className="hours-row"><span>المنطقة</span><b>كفر الشيخ</b></div><button className="table-action" onClick={() => notify('تعديل المعلومات في العرض التجريبي')}>تعديل المعلومات</button></section><section className="panel settings-card"><div className="settings-symbol">◉</div><h3>حالة استقبال الطلبات</h3><p>تقدر توقف استقبال طلبات جديدة مؤقتًا في أي وقت.</p><div className="open-setting"><span className="live-dot"/> الكافيه مفتوح</div><button className="table-action" onClick={() => notify('تم تبديل حالة العرض التجريبي')}>إغلاق مؤقت</button></section><section className="panel settings-card"><div className="settings-symbol">♙</div><h3>بيانات النشاط</h3><p>إدارة اسم ووصف وصور صفحة الكافيه الظاهرة داخل التطبيق.</p><button className="table-action" onClick={() => notify('اذهب إلى صفحة الكافيه من القائمة')}>إدارة صفحة الكافيه</button></section></div></>;
}

function Modal({
  modal,
  close,
  setModal,
  customers,
  products = [],
  onSaveDiscount,
  onAddCustomer,
  onSaveCampaign,
  onSaveProduct,
  onDeleteProduct,
  onCreateOrder,
  onUpdateCafeStatus,
  onAdvanceOrder,
  onReject,
  notify,
  lang = 'ar',
  t,
}) {
  const [value, setValue] = useState('10');
  const [type, setType] = useState('نسبة');
  const [title, setTitle] = useState('');
  const customer = modal.customer || {};
  const [targetCustomer, setTargetCustomer] = useState(customer.name || '');
  const [reason, setReason] = useState('');

  // Flexible Custom Discount states
  const [discountAudience, setDiscountAudience] = useState(customer.name ? 'single' : 'all');
  const [minSpend, setMinSpend] = useState('0');
  const [maxCap, setMaxCap] = useState('0');
  const [conflictPolicy, setConflictPolicy] = useState('best_offer'); // 'best_offer' | 'override' | 'exclude_existing'
  const [discountExpiry, setDiscountExpiry] = useState('2026-11-30');
  const [discountMaxUsages, setDiscountMaxUsages] = useState('1');

  // Dynamic targeting list calculation for real-time conflict analysis
  const targetedCustomerList = useMemo(() => {
    if (modal.type !== 'discount') return [];
    const list = modal.customers || customers || [];
    if (discountAudience === 'single') {
      const cName = targetCustomer || customer.name;
      return list.filter((c) => c.name === cName);
    }
    if (discountAudience === 'all') return list;
    if (discountAudience === 'no_orders') return list.filter((c) => (c.orders || 0) === 0 || c.segmentKey === 'no_orders');
    if (discountAudience === 'new') return list.filter((c) => c.segmentKey === 'new' || ((c.orders || 0) > 0 && (c.orders || 0) <= 3));
    if (discountAudience === 'vip') return list.filter((c) => c.segmentKey === 'vip');
    if (discountAudience === 'at_risk') return list.filter((c) => c.segmentKey === 'at_risk');
    if (discountAudience === 'returning') return list.filter((c) => c.segmentKey === 'returning');
    return list;
  }, [modal.type, modal.customers, customers, discountAudience, targetCustomer, customer.name]);

  const targetHasDiscountCount = targetedCustomerList.filter((c) => c.discount && c.discount !== 'لا يوجد' && c.discount !== 'None').length;

  // New Customer states
  const [newCustName, setNewCustName] = useState('');
  const [newCustNameEn, setNewCustNameEn] = useState('');
  const [newCustPhone, setNewCustPhone] = useState('010 •••• ');
  const [newCustSpend, setNewCustSpend] = useState('85');
  const [newCustSegment, setNewCustSegment] = useState('عميل جديد');
  const [newCustFav, setNewCustFav] = useState('فلات وايت أرتيزان');
  const [exportScope, setExportScope] = useState('filtered');

  // Proximity form states
  const campaign = modal.campaign || {};
  const [campName, setCampName] = useState(campaign.name || '');
  const [campProduct, setCampProduct] = useState(campaign.product || products[0]?.name || 'سموزي بلوبري مثلج');
  const [campDiscount, setCampDiscount] = useState(campaign.discount || 'خصم 20٪');
  const [campRadius, setCampRadius] = useState(campaign.radius || 200);
  const [campStartTime, setCampStartTime] = useState(campaign.startTime || '13:30');
  const [campEndTime, setCampEndTime] = useState(campaign.endTime || '16:30');
  const [campTitle, setCampTitle] = useState(campaign.title || 'الجو نار ومحتاج تروق؟ ☀️🫐');
  const [campBody, setCampBody] = useState(campaign.body || 'سموزي البلوبري المثلج مستنيك بخصم 20% في مقهى الزيتون وأنت مروّح!');
  const [campSegment, setCampSegment] = useState(campaign.targetSegment || 'جميع العملاء المارين بالنطاق');

  // Cafe Status states
  const currentStatus = modal.currentStatus || {};
  const [statusKey, setStatusKey] = useState(currentStatus.stateKey || 'open');
  const [statusNote, setStatusNote] = useState(currentStatus.note || 'الشيفت يسير بانتظام واستقبال الطلبات متاح لجميع العملاء.');

  // Quick POS Order states
  const [posCustomer, setPosCustomer] = useState('عميل صالة (طلب نقدي)');
  const [posItems, setPosItems] = useState({});

  // Product CRUD states
  const editingProduct = modal.product;
  const [prodName, setProdName] = useState(editingProduct?.name || '');
  const [prodNameEn, setProdNameEn] = useState(editingProduct?.nameEn || '');
  const [prodCategory, setProdCategory] = useState(editingProduct?.category || 'قهوة باردة');
  const [prodPrice, setProdPrice] = useState(editingProduct?.price?.replace(/[^0-9]/g, '') || '85');
  const [prodStock, setProdStock] = useState(editingProduct ? editingProduct.stock : true);
  const [prodDesc, setProdDesc] = useState(editingProduct?.desc || '');
  const [prodDescEn, setProdDescEn] = useState(editingProduct?.descEn || '');
  const [prodImage, setProdImage] = useState(editingProduct?.image || 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=400&h=400&fit=crop');

  const selectedProdObj = products.find((p) => p.name === campProduct) || products[0] || {};

  // Image Presets for Quick Selection
  const imagePresets = [
    { label: 'سموزي بلوبري', url: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=320&h=320&fit=crop' },
    { label: 'سبانش لاتيه', url: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=320&h=320&fit=crop' },
    { label: 'فلات وايت ساخن', url: 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=320&h=320&fit=crop' },
    { label: 'كولد برو منعش', url: 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=320&h=320&fit=crop' },
    { label: 'كرواسون زبدة', url: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=320&h=320&fit=crop' },
    { label: 'كوكيز شوكولاتة', url: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=320&h=320&fit=crop' },
  ];

  // File Upload Handler
  const handleFileUpload = (e) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (event) => {
        setProdImage(event.target.result);
        notify('تم تحميل الصورة بنجاح');
      };
      reader.readAsDataURL(file);
    }
  };

  // Pos order total calculation
  const posTotal = useMemo(() => {
    return Object.entries(posItems).reduce((sum, [pName, qty]) => {
      if (qty <= 0) return sum;
      const found = products.find((p) => p.name === pName);
      const num = parseInt(found?.price?.replace(/[^0-9]/g, '') || '0', 10) || 75;
      return sum + (num * qty);
    }, 0);
  }, [posItems, products]);

  const save = () => {
    if (modal.type === 'discount') {
      if (discountAudience === 'single' && !targetCustomer && !customer.name) {
        return notify(lang === 'ar' ? 'اختار العميل المستهدف أولاً' : 'Please select target customer first');
      }
      return onSaveDiscount({
        targetType: discountAudience,
        targetCustomer: targetCustomer || customer.name,
        type,
        value: type === 'free' ? '0' : value,
        title: title.trim() || (type === 'free' ? 'مشروب مجاني ترحيبي' : `عرض كافيه الزيتون ${value}٪`),
        conflictPolicy,
        minOrder: Number(minSpend) || 0,
        maxCap: Number(maxCap) || 0,
        validUntil: discountExpiry,
        maxUsages: Number(discountMaxUsages) || 1,
      });
    }
    if (modal.type === 'new_customer') {
      if (!newCustName.trim()) return notify('اسم العميل مطلوب');
      return onAddCustomer({
        name: newCustName.trim(),
        nameEn: newCustNameEn.trim(),
        phone: newCustPhone.trim(),
        initialSpend: newCustSpend,
        segment: newCustSegment,
        favoriteItem: newCustFav,
      });
    }
    if (modal.type === 'reject') {
      if (!reason.trim()) return notify('اكتب سبب رفض الطلب قبل التأكيد');
      return onReject(modal.order.id, reason.trim());
    }
    if (modal.type === 'proximity_form') {
      if (!campName.trim()) return notify('اكتب اسم الحملة أولاً');
      if (!campTitle.trim() || !campBody.trim()) return notify('عنوان ونص الإشعار مطلوبان');
      return onSaveCampaign({
        id: campaign.id,
        name: campName,
        product: campProduct,
        category: selectedProdObj.category || 'مشروبات',
        image: selectedProdObj.image || 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=480&h=300&fit=crop',
        discount: campDiscount,
        radius: Number(campRadius),
        startTime: campStartTime,
        endTime: campEndTime,
        timeLabel: `${campStartTime} — ${campEndTime}`,
        title: campTitle,
        body: campBody,
        targetSegment: campSegment,
      });
    }
    if (modal.type === 'cafe_status') {
      const statusMap = {
        open: { label: 'مفتوح لاستقبال الطلبات', badgeColor: '#4b9a73', isOpen: true },
        busy: { label: 'ضغط طلبات (وقت تحضير +١٥ د)', badgeColor: '#b96d3c', isOpen: true },
        break: { label: 'استراحة مؤقتة (٣٠ دقيقة)', badgeColor: '#caa042', isOpen: false },
        closed: { label: 'مغلق لباقي اليوم', badgeColor: '#b55a50', isOpen: false },
      };
      const chosen = statusMap[statusKey];
      return onUpdateCafeStatus({
        isOpen: chosen.isOpen,
        stateKey: statusKey,
        label: chosen.label,
        note: statusNote.trim() || 'لا توجد ملاحظات إضافية.',
        badgeColor: chosen.badgeColor,
      });
    }
    if (modal.type === 'new_order') {
      const activeItems = Object.entries(posItems).filter(([_, qty]) => qty > 0);
      if (activeItems.length === 0) return notify('برجاء اختيار صنف واحد على الأقل للطلب');
      const summary = activeItems.map(([name, qty]) => `${name} × ${qty}`).join('، ');
      return onCreateOrder({
        customerName: posCustomer.trim() || 'عميل صالة (طلب نقدي)',
        itemsSummary: summary,
        total: posTotal,
      });
    }
    if (modal.type === 'product') {
      if (!prodName.trim()) return notify('اسم الصنف بالعربي مطلوب');
      if (!prodPrice.trim()) return notify('سعر الصنف مطلوب');
      return onSaveProduct({
        isEdit: !!editingProduct,
        originalName: editingProduct?.name,
        name: prodName.trim(),
        nameEn: prodNameEn.trim() || prodName.trim(),
        category: prodCategory,
        price: prodPrice.trim(),
        image: prodImage,
        stock: prodStock,
        desc: prodDesc.trim(),
        descEn: prodDescEn.trim(),
      });
    }
    close();
    notify('تم حفظ التغيير في العرض التجريبي');
  };

  const modalTitle = () => {
    if (modal.type === 'discount') return customer.name ? (lang === 'ar' ? `خصم خاص لـ ${customer.name}` : `Special Discount for ${customer.name}`) : (lang === 'ar' ? 'إنشاء خصم موجه' : 'Create Custom Discount');
    if (modal.type === 'customer') return lang === 'ar' ? `الملف الشامل: ${customer.name || 'العميل'}` : `Customer Profile: ${customer.nameEn || customer.name || 'Customer'}`;
    if (modal.type === 'new_customer') return lang === 'ar' ? 'إضافة عميل جديد لقاعدة بيانات الكافيه' : 'Add New Customer to Directory';
    if (modal.type === 'payment') return lang === 'ar' ? `دفعة راتب · ${modal.employee?.n}` : `Salary Payment · ${modal.employee?.n}`;
    if (modal.type === 'reject') return lang === 'ar' ? `رفض الطلب ${modal.order.id}` : `Reject Order ${modal.order.id}`;
    if (modal.type === 'product') return editingProduct ? (lang === 'ar' ? `تعديل صنف: ${editingProduct.name}` : `Edit Item: ${editingProduct.name}`) : (lang === 'ar' ? 'إضافة صنف جديد للمنيو' : 'Add New Menu Item');
    if (modal.type === 'staff') return lang === 'ar' ? 'إضافة موظف' : 'Add Staff Member';
    if (modal.type === 'offer') return lang === 'ar' ? 'إنشاء عرض' : 'Create Offer';
    if (modal.type === 'proximity_preview') return lang === 'ar' ? 'معاينة إشعار الهاتف الذكي (Lock Screen)' : 'Smart Lock Screen Notification Preview';
    if (modal.type === 'proximity_form') return campaign.id ? (lang === 'ar' ? 'تعديل حملة الإشعار المكاني' : 'Edit Proximity Campaign') : (lang === 'ar' ? 'إنشاء حملة إشعار اقتراب جديدة' : 'Create New Proximity Campaign');
    if (modal.type === 'cafe_status') return lang === 'ar' ? 'تعديل حالة فرع الكافيه' : 'Update Cafe Live Status';
    if (modal.type === 'new_order') return lang === 'ar' ? 'تسجيل طلب كاشير جديد (POS)' : 'Quick POS Order Entry';
    if (modal.type === 'order_detail') return lang === 'ar' ? `تفاصيل الفاتورة · ${modal.order.id}` : `Order Receipt · ${modal.order.id}`;
    return lang === 'ar' ? 'إعداد البرنامج' : 'Configure';
  };

  const isWide = ['proximity_preview', 'proximity_form', 'new_order', 'product', 'customer', 'new_customer', 'discount'].includes(modal.type);

  return (
    <div className="modal-backdrop" role="presentation" onMouseDown={(e) => e.target === e.currentTarget && close()}>
      <section className={`modal-card ${isWide ? 'wide-modal' : ''}`} role="dialog" aria-modal="true" aria-labelledby="modal-title">
        <div className="modal-heading">
          <div>
            <span className="eyebrow">
              {modal.type === 'cafe_status'
                ? 'التشغيل الحي'
                : modal.type === 'new_order'
                ? 'نقطة البيع (POS)'
                : modal.type === 'product'
                ? 'المنيو والمخزون'
                : modal.type === 'order_detail'
                ? 'إدارة الطلبات'
                : modal.type === 'proximity_preview'
                ? 'المعاينة الحية'
                : modal.type === 'proximity_form'
                ? 'إشعارات القرب الذكية'
                : 'إدارة الكافيه'}
            </span>
            <h2 id="modal-title">{modalTitle()}</h2>
          </div>
          <button className="modal-close" onClick={close} aria-label="إغلاق">×</button>
        </div>

        {/* 1. Cafe Status Modal */}
        {modal.type === 'cafe_status' && (
          <div className="cafe-status-form">
            <p className="form-lead">اختر الحالة التشغيلية الحالية لفرع كفر الشيخ، وستنعكس فورياً للعملاء في التطبيق:</p>
            <div className="status-selector-grid">
              <label className={`status-option ${statusKey === 'open' ? 'selected green' : ''}`}>
                <input type="radio" name="status" value="open" checked={statusKey === 'open'} onChange={() => setStatusKey('open')} />
                <span className="status-indicator-dot open" />
                <div>
                  <strong>مفتوح واستقبال الطلبات متاح</strong>
                  <small>الوضع الطبيعي: الطلبات تصل للباريستا فوراً بأوقات التحضير المعتادة.</small>
                </div>
              </label>

              <label className={`status-option ${statusKey === 'busy' ? 'selected amber' : ''}`}>
                <input type="radio" name="status" value="busy" checked={statusKey === 'busy'} onChange={() => setStatusKey('busy')} />
                <span className="status-indicator-dot busy" />
                <div>
                  <strong>ضغط طلبات وساعات ذروة (+١٥ دقيقة تحضير)</strong>
                  <small>ينبه العميل قبل الطلب باحتمال تأخر الاستلام نظراً للازدحام في الفرع.</small>
                </div>
              </label>

              <label className={`status-option ${statusKey === 'break' ? 'selected yellow' : ''}`}>
                <input type="radio" name="status" value="break" checked={statusKey === 'break'} onChange={() => setStatusKey('break')} />
                <span className="status-indicator-dot break" />
                <div>
                  <strong>استراحة مؤقتة (صلاة / تعقيم ٣٠ دقيقة)</strong>
                  <small>يمنع العملاء مؤقتاً من إرسال طلبات جديدة مع عداد تنازلي لإعادة الفتح.</small>
                </div>
              </label>

              <label className={`status-option ${statusKey === 'closed' ? 'selected red' : ''}`}>
                <input type="radio" name="status" value="closed" checked={statusKey === 'closed'} onChange={() => setStatusKey('closed')} />
                <span className="status-indicator-dot closed" />
                <div>
                  <strong>مغلق لباقي اليوم</strong>
                  <small>يظهر الفرع كمغلق في خريطة وقائمة كافيهات CupBack.</small>
                </div>
              </label>
            </div>

            <label className="field-label">رسالة أو ملاحظة تظهر للعملاء في التطبيق</label>
            <textarea
              className="text-input textarea"
              value={statusNote}
              onChange={(e) => setStatusNote(e.target.value)}
              placeholder="اكتب ملاحظة توضيحية للعميل..."
            />

            <div className="modal-actions">
              <button className="button button-secondary" onClick={close}>إلغاء</button>
              <button className="button button-primary" onClick={save}>حفظ ونشر الحالة فوراً</button>
            </div>
          </div>
        )}

        {/* 2. New Quick Order (POS) Modal */}
        {modal.type === 'new_order' && (
          <div className="quick-order-form">
            <div className="order-customer-row">
              <label className="field-label">اسم العميل / الطاولة</label>
              <input
                className="text-input"
                value={posCustomer}
                onChange={(e) => setPosCustomer(e.target.value)}
                placeholder="مثال: أحمد محمود أو طاولة 4"
              />
            </div>

            <div className="pos-products-list">
              <div className="pos-list-title">اختر الأصناف من المنيو:</div>
              <div className="pos-grid">
                {products.map((p) => {
                  const qty = posItems[p.name] || 0;
                  return (
                    <div className="pos-item-card" key={p.name}>
                      <img src={p.image} alt={p.name} />
                      <div className="pos-item-info">
                        <strong>{p.name}</strong>
                        <span>{p.price}</span>
                      </div>
                      <div className="pos-qty-controls">
                        <button
                          type="button"
                          className="qty-btn"
                          onClick={() => setPosItems((prev) => ({ ...prev, [p.name]: Math.max(0, qty - 1) }))}
                          disabled={qty === 0}
                        >
                          −
                        </button>
                        <span className="qty-val">{qty}</span>
                        <button
                          type="button"
                          className="qty-btn plus"
                          onClick={() => setPosItems((prev) => ({ ...prev, [p.name]: qty + 1 }))}
                        >
                          ＋
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            <div className="pos-summary-bar">
              <div>
                <span>إجمالي الطلب:</span>
                <strong>{posTotal} ج.م</strong>
              </div>
              <div className="modal-actions">
                <button className="button button-secondary" onClick={close}>إلغاء</button>
                <button className="button button-primary" onClick={save} disabled={posTotal === 0}>
                  تأكيد وتسجيل الطلب ✓
                </button>
              </div>
            </div>
          </div>
        )}

        {/* 3. Order Details / Bill Modal */}
        {modal.type === 'order_detail' && (
          <div className="order-detail-view">
            <div className="receipt-header">
              <div className="receipt-logo">CupBack</div>
              <h3>{t('cafeName')} · {t('branchName')}</h3>
              <span>{lang === 'ar' ? 'رقم الطلب:' : 'Order ID:'} <strong>{modal.order.id}</strong></span>
              <span>{lang === 'ar' ? 'الوقت:' : 'Time:'} <strong>{lang === 'en' && modal.order.timeEn ? modal.order.timeEn : modal.order.time}</strong></span>
            </div>

            <div className="receipt-box">
              <div className="receipt-row head">
                <span>{lang === 'ar' ? 'الصنف والبيان' : 'Item & Description'}</span>
                <span>{lang === 'ar' ? 'الحالة' : 'Status'}</span>
              </div>
              <div className="receipt-items-text">
                {lang === 'en' && modal.order.itemsEn ? modal.order.itemsEn : modal.order.items}
              </div>
              <div className="receipt-row total-row">
                <span>{lang === 'ar' ? 'الإجمالي النهائي المستحق:' : 'Total Amount Due:'}</span>
                <b>{typeof modal.order.total === 'number' ? `${modal.order.total} ${t('currency')}` : (lang === 'en' && modal.order.totalEn ? modal.order.totalEn : modal.order.total)}</b>
              </div>
            </div>

            <div className="order-status-timeline">
              <span>{lang === 'ar' ? 'الحالة الحالية:' : 'Current Status:'} <strong className={`status-pill ${modal.order.state}`}>{orderStatusMap[lang]?.[modal.order.state] || modal.order.status}</strong></span>
              <span>{lang === 'ar' ? 'العميل:' : 'Customer:'} <strong>{lang === 'en' && modal.order.customerEn ? modal.order.customerEn : modal.order.customer}</strong></span>
            </div>

            <div className="modal-actions">
              {modal.order.state === 'new' && (
                <>
                  <button className="button button-primary" onClick={() => { onAdvanceOrder(modal.order.id); close(); }}>
                    {t('actAccept')}
                  </button>
                  <button className="table-action reject-action" onClick={() => setModal({ type: 'reject', order: modal.order })}>
                    {t('actReject')}
                  </button>
                </>
              )}
              {modal.order.state === 'preparing' && (
                <button className="button button-primary" onClick={() => { onAdvanceOrder(modal.order.id); close(); }}>
                  {t('actReady')}
                </button>
              )}
              {modal.order.state === 'ready' && (
                <button className="button button-primary" onClick={() => { onAdvanceOrder(modal.order.id); close(); }}>
                  {t('actDeliver')}
                </button>
              )}
              <button className="button button-secondary" onClick={close}>
                {lang === 'ar' ? 'إغلاق الفاتورة' : 'Close Receipt'}
              </button>
            </div>
          </div>
        )}

        {/* 4. Complete Product CRUD Modal */}
        {modal.type === 'product' && (
          <div className="product-form-layout">
            <div className="product-fields-col">
              <div className="field-pair">
                <div>
                  <label className="field-label">اسم الصنف (بالعربية) <b className="required-mark">*</b></label>
                  <input
                    className="text-input"
                    value={prodName}
                    onChange={(e) => setProdName(e.target.value)}
                    placeholder="مثال: سموزي بلوبري مثلج"
                  />
                </div>
                <div>
                  <label className="field-label">اسم الصنف (English)</label>
                  <input
                    className="text-input"
                    value={prodNameEn}
                    onChange={(e) => setProdNameEn(e.target.value)}
                    placeholder="e.g. Blueberry Blast Smoothie"
                  />
                </div>
              </div>

              <div className="field-pair">
                <div>
                  <label className="field-label">التصنيف</label>
                  <select
                    className="select-control full-width"
                    value={prodCategory}
                    onChange={(e) => setProdCategory(e.target.value)}
                  >
                    <option value="قهوة ساخنة">☕ قهوة ساخنة</option>
                    <option value="قهوة باردة">🧊 قهوة باردة ومثلجة</option>
                    <option value="سموزي وعصائر">🫐 سموزي وعصائر</option>
                    <option value="مخبوزات">🥐 مخبوزات وحلويات</option>
                    <option value="ماتشا وسبيشالتي">🍵 ماتشا وسبيشالتي</option>
                  </select>
                </div>
                <div>
                  <label className="field-label">السعر (ج.م) <b className="required-mark">*</b></label>
                  <input
                    className="text-input"
                    type="number"
                    value={prodPrice}
                    onChange={(e) => setProdPrice(e.target.value)}
                    placeholder="مثال: 85"
                  />
                </div>
              </div>

              <label className="field-label">وصف مختصر للصنف</label>
              <textarea
                className="text-input textarea"
                value={prodDesc}
                onChange={(e) => setProdDesc(e.target.value)}
                placeholder="اكتب مكونات أو لمسة الصنف الخاصة لجذب العملاء..."
                rows={2}
              />

              <div className="stock-checkbox-wrap">
                <label className="stock-toggle-label">
                  <input
                    type="checkbox"
                    checked={prodStock}
                    onChange={(e) => setProdStock(e.target.checked)}
                  />
                  <span>الصنف متوفر حالياً في المنيو ومتاح لطلب العملاء على التطبيق</span>
                </label>
              </div>

              <label className="field-label">صورة الصنف</label>
              <div className="image-input-methods">
                <input
                  className="text-input"
                  value={prodImage}
                  onChange={(e) => setProdImage(e.target.value)}
                  placeholder="رابط الصورة (URL)"
                />
                <label className="upload-file-btn">
                  ↥ رفع صورة من الجهاز
                  <input type="file" accept="image/*" onChange={handleFileUpload} style={{ display: 'none' }} />
                </label>
              </div>

              <div className="preset-images-strip">
                <small>أو اختر صورة جاهزة سريعة:</small>
                <div className="preset-thumbs">
                  {imagePresets.map((pr) => (
                    <img
                      key={pr.label}
                      src={pr.url}
                      alt={pr.label}
                      title={pr.label}
                      className={prodImage === pr.url ? 'chosen' : ''}
                      onClick={() => setProdImage(pr.url)}
                    />
                  ))}
                </div>
              </div>
            </div>

            <div className="product-preview-col">
              <span className="preview-heading">معاينة كارت الصنف في المنيو:</span>
              <div className="product-card mini-preview">
                <img src={prodImage} alt="معاينة" />
                <div className="product-body">
                  <div className="product-title">
                    <div>
                      <strong>{prodName || 'اسم الصنف'}</strong>
                      <span>{prodCategory}</span>
                    </div>
                  </div>
                  <div className="product-footer">
                    <b>{prodPrice ? `${prodPrice} ج.م` : '—'}</b>
                    <span className={`stock-toggle ${prodStock ? 'on' : ''}`}>
                      <i />{prodStock ? 'متوفر' : 'نفد'}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <div className="modal-actions full-row space-between">
              {editingProduct && (
                <button
                  type="button"
                  className="table-action reject-action"
                  onClick={() => {
                    if (window.confirm(`هل أنت متأكد من حذف صنف "${editingProduct.name}"؟`)) {
                      onDeleteProduct(editingProduct.name);
                    }
                  }}
                >
                  🗑 حذف هذا الصنف من المنيو
                </button>
              )}
              <div style={{ display: 'flex', gap: '8px', marginRight: 'auto' }}>
                <button className="button button-secondary" onClick={close}>إلغاء</button>
                <button className="button button-primary" onClick={save}>
                  {editingProduct ? 'حفظ التعديلات' : 'إضافة الصنف للمنيو'}
                </button>
              </div>
            </div>
          </div>
        )}

        {/* 5. Proximity Preview Modal */}
        {modal.type === 'proximity_preview' && (
          <div className="phone-preview-wrap">
            <div className="lockscreen-mockup">
              <div className="lockscreen-top">
                <span className="lockscreen-time">٢:١٥</span>
                <span className="lockscreen-date">الأربعاء، ١١ نوفمبر</span>
              </div>

              <div className="lockscreen-notif">
                <div className="notif-header">
                  <div className="notif-app-icon">c</div>
                  <div className="notif-app-info">
                    <strong>CupBack • مقهى الزيتون</strong>
                    <small>منذ دقيقة واحدة • إشعار اقتراب ذكي</small>
                  </div>
                  <span className="notif-time-badge">الآن</span>
                </div>
                <div className="notif-body">
                  <h4>{modal.campaign?.title}</h4>
                  <p>{modal.campaign?.body}</p>
                  {modal.campaign?.image && (
                    <div className="notif-image-wrap">
                      <img src={modal.campaign.image} alt="صورة العرض" />
                      <span className="notif-discount-tag">{modal.campaign.discount}</span>
                    </div>
                  )}
                </div>
                <div className="notif-actions">
                  <button className="notif-btn primary" onClick={() => notify('محاكاة: تم فتح تطبيق CupBack على صفحة العرض والطلب السريع')}>
                    ☕ استلم العرض الآن
                  </button>
                  <button className="notif-btn" onClick={close}>
                    لاحقاً
                  </button>
                </div>
              </div>

              <div className="lockscreen-bottom-hint">
                <span>مرر لأعلى لفتح تطبيق CupBack والطلب فوراً</span>
              </div>
            </div>

            <div className="preview-explanation">
              <h3>💡 كيف يعمل هذا الإشعار للعميل؟</h3>
              <ul>
                <li><strong>الزناد (Trigger):</strong> العميل يقترب من الكافيه (نطاق {modal.campaign?.radius || 200} متر).</li>
                <li><strong>الوقت الذكي:</strong> تم إطلاقه لأن الساعة حالياً بين {modal.campaign?.timeLabel || '١:٣٠ م — ٤:٣٠ م'}.</li>
                <li><strong>الخصوصية:</strong> تم التحقق محلياً بدون رفع إحداثيات العميل للسيرفر.</li>
                <li><strong>الضوابط:</strong> استهلك 1 من كوتة الكافيه اليومية، ولن يتكرر لنفس العميل قبل 8 ساعات.</li>
              </ul>
              <div className="modal-actions">
                <button className="button button-primary" onClick={close}>إغلاق المعاينة</button>
              </div>
            </div>
          </div>
        )}

        {/* 6. Proximity Form Modal */}
        {modal.type === 'proximity_form' && (
          <div className="proximity-form-wrap">
            <div className="form-fields-col">
              <label className="field-label">اسم الحملة الداخلي</label>
              <input
                className="text-input"
                value={campName}
                onChange={(e) => setCampName(e.target.value)}
                placeholder="مثال: سموزي البلوبري في وقت الحر"
              />

              <div className="field-pair">
                <div>
                  <label className="field-label">المنتج المرتبط من المنيو</label>
                  <select
                    className="select-control full-width"
                    value={campProduct}
                    onChange={(e) => setCampProduct(e.target.value)}
                  >
                    {products.map((p) => (
                      <option key={p.name} value={p.name}>{p.name} ({p.price})</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="field-label">قيمة / شارة الخصم</label>
                  <input
                    className="text-input"
                    value={campDiscount}
                    onChange={(e) => setCampDiscount(e.target.value)}
                    placeholder="مثال: خصم 20٪ أو خصم 15 ج.م"
                  />
                </div>
              </div>

              <div className="field-pair">
                <div>
                  <label className="field-label">وقت بداية التفعيل</label>
                  <input
                    className="text-input"
                    type="time"
                    value={campStartTime}
                    onChange={(e) => setCampStartTime(e.target.value)}
                  />
                </div>
                <div>
                  <label className="field-label">وقت نهاية التفعيل</label>
                  <input
                    className="text-input"
                    type="time"
                    value={campEndTime}
                    onChange={(e) => setCampEndTime(e.target.value)}
                  />
                </div>
              </div>

              <div className="field-pair">
                <div>
                  <label className="field-label">نطاق الاستشعار (متر)</label>
                  <select
                    className="select-control full-width"
                    value={campRadius}
                    onChange={(e) => setCampRadius(e.target.value)}
                  >
                    <option value="100">100 متر (قريب جداً)</option>
                    <option value="150">150 متر (محيط الشارع)</option>
                    <option value="200">200 متر (موصى به)</option>
                    <option value="300">300 متر (أقصى نطاق)</option>
                  </select>
                </div>
                <div>
                  <label className="field-label">الشريحة المستهدفة</label>
                  <select
                    className="select-control full-width"
                    value={campSegment}
                    onChange={(e) => setCampSegment(e.target.value)}
                  >
                    <option value="جميع العملاء المارين بالنطاق">جميع العملاء</option>
                    <option value="عملاء دائمون فقط">عملاء دائمون فقط</option>
                    <option value="عملاء لم يزورونا منذ فترة">عملاء غائبون (Re-engagement)</option>
                  </select>
                </div>
              </div>

              <label className="field-label">عنوان الإشعار (موجز وجذاب)</label>
              <input
                className="text-input"
                value={campTitle}
                onChange={(e) => setCampTitle(e.target.value)}
                placeholder="مثال: الجو نار ومحتاج تروق؟ ☀️🫐"
                maxLength={60}
              />

              <label className="field-label">نص الإشعار المقترح</label>
              <textarea
                className="text-input textarea"
                value={campBody}
                onChange={(e) => setCampBody(e.target.value)}
                placeholder="اكتب رسالة تدعو العميل للمرور على الكافيه قبل الذهاب للبيت"
                maxLength={160}
              />
              <small className="field-counter">{campBody.length} / 160 حرف</small>
            </div>

            <div className="form-preview-col">
              <div className="preview-card-title">معاينة مباشرة لشكل التنبيه:</div>
              <div className="lockscreen-notif compact">
                <div className="notif-header">
                  <div className="notif-app-icon">c</div>
                  <div className="notif-app-info">
                    <strong>CupBack • مقهى الزيتون</strong>
                    <small>الآن</small>
                  </div>
                </div>
                <div className="notif-body">
                  <h4>{campTitle || 'عنوان الإشعار...'}</h4>
                  <p>{campBody || 'نص الإشعار سيظهر هنا...'}</p>
                  {selectedProdObj.image && (
                    <div className="notif-image-wrap">
                      <img src={selectedProdObj.image} alt={selectedProdObj.name} />
                      <span className="notif-discount-tag">{campDiscount}</span>
                    </div>
                  )}
                </div>
              </div>
              <div className="inline-note">
                ⓘ سيتم فحص الحملة واعتمادها من قبل أدمن المنصة لضمان عدم تكرار الإشعارات والتوافق مع معايير المتجر.
              </div>
            </div>

            <div className="modal-actions full-row">
              <button className="button button-secondary" onClick={close}>إلغاء</button>
              <button className="button button-primary" onClick={save}>حفظ وإرسال للمراجعة</button>
            </div>
          </div>
        )}

        {/* 7. Comprehensive Customer Profile Modal */}
        {modal.type === 'customer' && (
          <div className="customer-profile-layout">
            <div className="customer-profile-header">
              <div className={`customer-avatar-xl ${customer.segmentKey || 'regular'}`}>
                <span>{customer.name?.[0]}</span>
                {customer.segmentKey === 'vip' && <span className="profile-vip-crown" title="عميل VIP">👑</span>}
              </div>
              <div className="customer-profile-names">
                <div className="profile-name-row">
                  <h2>{lang === 'ar' ? customer.name : (customer.nameEn || customer.name)}</h2>
                  <span className={`segment-tag-pro ${customer.segmentKey || 'regular'}`}>
                    {customer.segmentKey === 'vip' ? '💎 ' : customer.segmentKey === 'returning' ? '🔄 ' : customer.segmentKey === 'new' ? '🌱 ' : customer.segmentKey === 'at_risk' ? '💤 ' : ''}
                    {lang === 'ar' ? customer.segment : (customer.segmentKey === 'vip' ? 'VIP Regular' : customer.segmentKey === 'returning' ? 'Returning' : customer.segmentKey === 'new' ? 'New Customer' : 'Dormant')}
                  </span>
                </div>
                <div className="profile-contact-row">
                  <span>📞 {customer.phone}</span>
                  {customer.email && <span>✉️ {customer.email}</span>}
                  <span>📅 {lang === 'ar' ? `عضو منذ ${customer.memberSince || 'يناير 2025'}` : `Member since ${customer.memberSinceEn || 'Jan 2025'}`}</span>
                </div>
              </div>
            </div>

            {/* 3 Metric Tiles */}
            <div className="profile-kpi-grid">
              <div className="profile-kpi-tile">
                <span className="kpi-label">{lang === 'ar' ? 'إجمالي المشتريات' : 'Total Spent'}</span>
                <strong className="kpi-number">{money(customer.spent || 0)}</strong>
                <small className="kpi-note">{lang === 'ar' ? 'قيمة إنفاق تراكمية' : 'Lifetime value'}</small>
              </div>
              <div className="profile-kpi-tile">
                <span className="kpi-label">{lang === 'ar' ? 'عدد الطلبات' : 'Total Orders'}</span>
                <strong className="kpi-number">{customer.orders || 1}</strong>
                <small className="kpi-note">{lang === 'ar' ? 'آخر طلب ' + (customer.last || 'مؤخراً') : 'Last: ' + (customer.lastEn || 'recent')}</small>
              </div>
              <div className="profile-kpi-tile">
                <span className="kpi-label">{lang === 'ar' ? 'نقاط ولاء CupBack' : 'Loyalty Points'}</span>
                <strong className="kpi-number text-gold">⭐ {customer.loyaltyPoints || Math.round((customer.spent || 0) * 0.1)}</strong>
                <small className="kpi-note">{lang === 'ar' ? 'جاهزة للاستبدال' : 'Redeemable'}</small>
              </div>
            </div>

            {/* Favorite Drink & Active Offer */}
            <div className="profile-pref-grid">
              <div className="profile-pref-box">
                <span className="pref-title">☕ {lang === 'ar' ? 'المشروب والتفضيل المفضل:' : 'Favorite Beverage:'}</span>
                <strong>{lang === 'ar' ? (customer.favoriteItem || 'فلات وايت أرتيزان') : (customer.favoriteItemEn || customer.favoriteItem || 'Artisan Flat White')}</strong>
                <p>{lang === 'ar' ? 'يطلب هذا الصنف في أكثر من ٧٠٪ من زياراته للمقهى.' : 'Orders this item in over 70% of visits.'}</p>
              </div>

              <div className="profile-pref-box">
                <span className="pref-title">🎁 {lang === 'ar' ? 'الخصم / المكافأة النشطة:' : 'Active Perk / Discount:'}</span>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px', marginTop: '4px' }}>
                  <strong className={customer.discount && customer.discount !== 'لا يوجد' && customer.discount !== 'None' ? 'text-success' : 'text-muted'}>
                    {lang === 'ar' ? (customer.discount || 'لا يوجد خصم نشط') : (customer.discountEn || customer.discount || 'No active discount')}
                  </strong>
                  <button
                    className="grant-discount-link"
                    onClick={() => setModal({ type: 'discount', customer })}
                  >
                    ✏️ {lang === 'ar' ? 'تعديل أو منح خصم' : 'Change Discount'}
                  </button>
                </div>
                <p>{lang === 'ar' ? 'يتم تطبيق الخصم تلقائياً عند طلب العميل عبر تطبيق CupBack.' : 'Automatically applied in customer app checkout.'}</p>
              </div>
            </div>

            {/* Simulated Recent Orders Timeline */}
            <div className="profile-recent-orders">
              <div className="recent-orders-heading">
                <span>📋 {lang === 'ar' ? 'سجل آخر طلبات العميل في مقهى الزيتون:' : 'Recent Orders at Al-Zaytoun Cafe:'}</span>
              </div>
              <div className="recent-orders-list">
                <div className="recent-order-item">
                  <div className="ro-left">
                    <strong>#1048 · {lang === 'ar' ? (customer.favoriteItem || 'سبانش لاتيه × 2') : (customer.favoriteItemEn || 'Spanish Latte × 2')}</strong>
                    <small>{lang === 'ar' ? customer.last : (customer.lastEn || customer.last)}</small>
                  </div>
                  <strong className="ro-amount">190 ج.م</strong>
                </div>
                <div className="recent-order-item">
                  <div className="ro-left">
                    <strong>#1032 · {lang === 'ar' ? 'فلات وايت × 1، كرواسون زبدة × 1' : 'Flat White × 1, Croissant × 1'}</strong>
                    <small>{lang === 'ar' ? 'منذ 5 أيام' : '5 days ago'}</small>
                  </div>
                  <strong className="ro-amount">140 ج.م</strong>
                </div>
              </div>
            </div>

            {/* Modal Actions */}
            <div className="modal-actions space-between">
              <div style={{ display: 'flex', gap: '8px' }}>
                <button
                  type="button"
                  className="button button-secondary"
                  onClick={() => {
                    navigator.clipboard?.writeText(customer.phone);
                    notify(lang === 'ar' ? `تم نسخ هاتف ${customer.name} للحافظة` : `Copied phone of ${customer.name}`);
                  }}
                >
                  📞 {lang === 'ar' ? 'نسخ الهاتف' : 'Copy Phone'}
                </button>
                <button
                  type="button"
                  className="button button-secondary"
                  onClick={() => notify(lang === 'ar' ? `محاكاة: فتح محادثة WhatsApp مع ${customer.name}` : `Simulated: Opening WhatsApp chat with ${customer.name}`)}
                >
                  💬 {lang === 'ar' ? 'مراسلة واتساب' : 'WhatsApp'}
                </button>
              </div>
              <div style={{ display: 'flex', gap: '8px' }}>
                <button
                  type="button"
                  className="button button-primary"
                  onClick={() => setModal({ type: 'discount', customer })}
                >
                  🎁 {lang === 'ar' ? 'إنشاء خصم للعميل' : 'Grant Discount'}
                </button>
                <button type="button" className="button button-secondary" onClick={close}>
                  {lang === 'ar' ? 'إغلاق' : 'Close'}
                </button>
              </div>
            </div>
          </div>
        )}

        {/* 8. Comprehensive & Flexible Custom Discount Modal */}
        {modal.type === 'discount' && (
          <div className="discount-form-wrap flex-discount-layout">
            {/* 1. Target Audience Selector */}
            <div className="discount-section">
              <label className="field-label bold-label">
                👥 {lang === 'ar' ? 'لمن تريد إرسال هذا الخصم؟ (الجمهور المستهدف):' : 'Who should receive this discount? (Target Audience):'}
              </label>
              
              <div className="audience-pills-grid">
                {[
                  { id: 'all', icon: '📢', label: lang === 'ar' ? 'جميع العملاء (الكل)' : 'All Patrons (Broadcast)', desc: lang === 'ar' ? 'إرسال لكافة المسجلين بالكافيه' : 'Sent to all cafe patrons' },
                  { id: 'single', icon: '👤', label: lang === 'ar' ? 'عميل واحد محدد' : 'Single Specific Customer', desc: lang === 'ar' ? 'اختيار عميل بعينه بالاسم أو الهاتف' : 'Search and select one patron' },
                  { id: 'no_orders', icon: '🌱', label: lang === 'ar' ? 'لم يطلبوا قط (0 طلبات)' : 'Never Ordered (0 Orders)', desc: lang === 'ar' ? 'مسجلين لم يطلبوا قط لتحفيز أول طلب' : 'Signed-up but never ordered' },
                  { id: 'new', icon: '✨', label: lang === 'ar' ? 'العملاء الجدد (1 - 3 طلبات)' : 'New Patrons (1-3 Orders)', desc: lang === 'ar' ? 'ترحيب وتشجيع لتكرار الزيارة' : 'Encourage next visits' },
                  { id: 'vip', icon: '💎', label: lang === 'ar' ? 'العملاء الدائمون والقدامى VIP' : 'VIP & Loyal Regulars', desc: lang === 'ar' ? 'أعلى إنفاق وأصحاب الزيارات الدائمة' : 'Highest spenders & regulars' },
                  { id: 'at_risk', icon: '💤', label: lang === 'ar' ? 'العملاء الغائبون (> 30 يوم)' : 'Dormant (> 30 Days)', desc: lang === 'ar' ? 'إعادة تنشيط وجذب الغائبين' : 'Re-engage lost customers' },
                  { id: 'returning', icon: '🔄', label: lang === 'ar' ? 'العملاء العائدون' : 'Returning Customers', desc: lang === 'ar' ? 'زيارات مستمرة منتظمة' : 'Steady patrons' },
                ].map((aud) => {
                  const isChosen = discountAudience === aud.id;
                  return (
                    <button
                      key={aud.id}
                      type="button"
                      className={`audience-pill-card ${isChosen ? 'chosen' : ''}`}
                      onClick={() => setDiscountAudience(aud.id)}
                    >
                      <div className="aud-top">
                        <span className="aud-icon">{aud.icon}</span>
                        <strong className="aud-label">{aud.label}</strong>
                      </div>
                      <small className="aud-desc">{aud.desc}</small>
                    </button>
                  );
                })}
              </div>

              {/* Single Customer Selector */}
              {discountAudience === 'single' && (
                <div className="sub-audience-selector">
                  <label className="field-label">{lang === 'ar' ? 'ابحث واختر العميل المستفيد بالاسم أو رقم الهاتف:' : 'Search & select target patron by name or phone:'}</label>
                  <select
                    className="select-control full-width"
                    value={targetCustomer || customer.name || ''}
                    onChange={(e) => setTargetCustomer(e.target.value)}
                  >
                    <option value="">{lang === 'ar' ? 'اختر عميلاً من القائمة...' : 'Select a customer...'}</option>
                    {(modal.customers || customers).map((person) => (
                      <option value={person.name} key={person.name}>
                        {person.name} ({person.segment}) · {person.phone} {person.discount && person.discount !== 'لا يوجد' && person.discount !== 'None' ? `[عنده ${person.discount}]` : ''}
                      </option>
                    ))}
                  </select>
                </div>
              )}

              {/* Live Target & Conflict Analyzer Pill */}
              <div className="audience-impact-banner">
                <div className="impact-stats">
                  <span className="impact-pill count-pill">
                    🎯 <b>{targetedCustomerList.length}</b> {lang === 'ar' ? 'عميل مستهدف' : 'patrons targeted'}
                  </span>
                  {targetHasDiscountCount > 0 ? (
                    <span className="impact-pill warning-pill">
                      ⚠️ <b>{targetHasDiscountCount}</b> {lang === 'ar' ? 'منهم لديهم خصم نشط حالياً' : 'already have active discounts'}
                    </span>
                  ) : (
                    <span className="impact-pill safe-pill">
                      ✓ {lang === 'ar' ? 'جميعهم لا يملكون خصومات حالية' : 'No existing discount conflicts'}
                    </span>
                  )}
                </div>
                <small className="impact-note">
                  🛡️ {lang === 'ar' ? 'نظام الحماية مفعل: لن تتراكم الخصومات حسابياً معاً أبداً لحماية هامش ربح الكافيه.' : 'Anti-stacking enabled: Discounts never sum up together to protect cafe margins.'}
                </small>
              </div>
            </div>

            {/* 2. Offer Title & Discount Parameters */}
            <div className="discount-section">
              <label className="field-label bold-label">{lang === 'ar' ? 'عنوان أو مناسبة العرض:' : 'Offer Title / Occasion:'}</label>
              <input
                className="text-input"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder={lang === 'ar' ? 'مثال: خصم استعادة العملاء الغائبين، أو ترحيب بالعميل الجديد' : 'e.g. Welcome Back Offer or VIP Loyalty Perk'}
              />

              <div className="field-pair">
                <div>
                  <label className="field-label">{lang === 'ar' ? 'نوع الخصم' : 'Discount Type'}</label>
                  <select className="select-control full-width" value={type} onChange={(e) => setType(e.target.value)}>
                    <option value="نسبة">{lang === 'ar' ? 'نسبة مئوية (%)' : 'Percentage (%)'}</option>
                    <option value="مبلغ ثابت">{lang === 'ar' ? 'مبلغ ثابت (ج.م)' : 'Fixed Cash Voucher (EGP)'}</option>
                    <option value="free">{lang === 'ar' ? '☕ مشروب مجاني ترحيبي' : '☕ Free Welcome Drink'}</option>
                  </select>
                </div>
                {type !== 'free' ? (
                  <div>
                    <label className="field-label">
                      {lang === 'ar' ? `قيمة الخصم (${type === 'نسبة' ? '٪' : 'ج.م'})` : `Discount Value (${type === 'نسبة' ? '%' : 'EGP'})`} <b className="required-mark">*</b>
                    </label>
                    <input
                      className="text-input"
                      inputMode="numeric"
                      value={value}
                      onChange={(e) => setValue(e.target.value)}
                      placeholder={type === 'نسبة' ? '20' : '25'}
                    />
                  </div>
                ) : (
                  <div>
                    <label className="field-label">{lang === 'ar' ? 'المشروب المجاني المسموح به' : 'Eligible Free Drink'}</label>
                    <input className="text-input" disabled value={lang === 'ar' ? 'أي مشروب من اختيار العميل' : 'Any beverage of patron choice'} />
                  </div>
                )}
              </div>

              {/* Min Spend & Max Cap Row */}
              <div className="field-pair">
                <div>
                  <label className="field-label">
                    {lang === 'ar' ? 'الحد الأدنى للطلب (ج.م)' : 'Minimum Order (EGP)'}
                  </label>
                  <input
                    className="text-input"
                    type="number"
                    value={minSpend}
                    onChange={(e) => setMinSpend(e.target.value)}
                    placeholder="0"
                  />
                  <small className="field-hint">{lang === 'ar' ? '0 = بدون حد أدنى لقيمة السلة' : '0 = No minimum order requirement'}</small>
                </div>
                <div>
                  <label className="field-label">
                    {lang === 'ar' ? 'سقف أقصى للخصم (ج.م) [Cap]' : 'Max Discount Cap (EGP)'}
                  </label>
                  <input
                    className="text-input"
                    type="number"
                    value={maxCap}
                    onChange={(e) => setMaxCap(e.target.value)}
                    placeholder="0"
                  />
                  <small className="field-hint">{lang === 'ar' ? 'يحمي الكافيه عند النسب المئوية العالية (0 = مفتوح)' : 'Limits max discount amount on high tickets'}</small>
                </div>
              </div>
            </div>

            {/* 3. Anti-Stacking & Conflict Resolution Policy (The Core Logic!) */}
            <div className="discount-section conflict-policy-section">
              <div className="section-title-wrap">
                <span className="shield-icon">🛡️</span>
                <div>
                  <strong className="section-title">
                    {lang === 'ar' ? 'سياسة حماية الكافيه من تضارب ومضاعفة الخصومات:' : 'Anti-Stacking & Conflict Resolution Policy:'}
                  </strong>
                  <span className="section-subtitle">
                    {lang === 'ar' ? 'كيف يتعامل النظام إذا كان العميل يملك خصماً بالفعل؟ (لن يتم جمع الخصومات معاً إطلاقاً)' : 'How should the platform handle patrons with active offers? (Discounts never stack)'}
                  </span>
                </div>
              </div>

              <div className="conflict-options-list">
                <label className={`conflict-option-card ${conflictPolicy === 'best_offer' ? 'selected' : ''}`}>
                  <input
                    type="radio"
                    name="conflictPolicy"
                    value="best_offer"
                    checked={conflictPolicy === 'best_offer'}
                    onChange={() => setConflictPolicy('best_offer')}
                  />
                  <div className="conflict-text">
                    <strong>
                      {lang === 'ar' ? '🌟 تطبيق الخصم الأقوى فقط (Best Offer Wins) [موصى به]' : '🌟 Apply Highest Value Offer Only (Recommended)'}
                    </strong>
                    <p>
                      {lang === 'ar'
                        ? 'العميل يستفيد من العرض الأقوى دون تجميع! (مثال: لو العميل عنده 20% وجاءه 30%، يحصل على 30% فقط وليس 50%. والمشروب المجاني لا يجمع مع خصم مالي).'
                        : 'Patron gets the best single discount without stacking (e.g. 20% + 30% becomes 30%, never 50%. Free drink is never combined with cash codes).'}
                    </p>
                  </div>
                </label>

                <label className={`conflict-option-card ${conflictPolicy === 'exclude_existing' ? 'selected' : ''}`}>
                  <input
                    type="radio"
                    name="conflictPolicy"
                    value="exclude_existing"
                    checked={conflictPolicy === 'exclude_existing'}
                    onChange={() => setConflictPolicy('exclude_existing')}
                  />
                  <div className="conflict-text">
                    <strong>
                      {lang === 'ar' ? '⛔ استثناء وحماية من لديهم خصم نشط (Exclude Active)' : '⛔ Exclude Customers With Active Offers (Budget Shield)'}
                    </strong>
                    <p>
                      {lang === 'ar'
                        ? 'يُرسل الخصم فقط للعملاء المحرومين من العروض، ولا يمس أي عميل لديه بالفعل خصم سارٍ.'
                        : 'Only grants this perk to customers who currently have no active discounts.'}
                    </p>
                  </div>
                </label>

                <label className={`conflict-option-card ${conflictPolicy === 'override' ? 'selected' : ''}`}>
                  <input
                    type="radio"
                    name="conflictPolicy"
                    value="override"
                    checked={conflictPolicy === 'override'}
                    onChange={() => setConflictPolicy('override')}
                  />
                  <div className="conflict-text">
                    <strong>
                      {lang === 'ar' ? '🔄 استبدال إجباري بالخصم الجديد (Override All)' : '🔄 Force Override With New Discount'}
                    </strong>
                    <p>
                      {lang === 'ar'
                        ? 'الخصم الجديد يلغي فوراً أي خصم قديم للعميل المستهدف ويحل محله.'
                        : 'The new discount replaces and overrides any previous discount for targeted patrons.'}
                    </p>
                  </div>
                </label>
              </div>
            </div>

            {/* 4. Validity & Usage Limits */}
            <div className="discount-section">
              <div className="field-pair">
                <div>
                  <label className="field-label">{lang === 'ar' ? 'صلاحية الخصم حتى' : 'Valid Until'}</label>
                  <input
                    className="date-input"
                    type="date"
                    value={discountExpiry}
                    onChange={(e) => setDiscountExpiry(e.target.value)}
                  />
                </div>
                <div>
                  <label className="field-label">{lang === 'ar' ? 'أقصى عدد مرات استخدام للعميل' : 'Max Uses Per Customer'}</label>
                  <input
                    className="text-input"
                    type="number"
                    min="1"
                    max="10"
                    value={discountMaxUsages}
                    onChange={(e) => setDiscountMaxUsages(e.target.value)}
                  />
                </div>
              </div>
            </div>

            <div className="modal-actions full-row space-between">
              <button className="button button-secondary" onClick={close}>
                {lang === 'ar' ? 'إلغاء' : 'Cancel'}
              </button>
              <button className="button button-primary" onClick={save}>
                {lang === 'ar' ? `حفظ وتفعيل الخصم لـ (${targetedCustomerList.length}) عميل 🚀` : `Activate Discount for (${targetedCustomerList.length}) Patrons 🚀`}
              </button>
            </div>
          </div>
        )}

        {/* 8b. Add New Customer Modal */}
        {modal.type === 'new_customer' && (
          <div className="new-customer-form-wrap">
            <div className="field-pair">
              <div>
                <label className="field-label">{lang === 'ar' ? 'اسم العميل (بالعربية)' : 'Customer Name (Ar)'} <b className="required-mark">*</b></label>
                <input
                  className="text-input"
                  value={newCustName}
                  onChange={(e) => setNewCustName(e.target.value)}
                  placeholder="مثال: حسام الدين حسن"
                />
              </div>
              <div>
                <label className="field-label">{lang === 'ar' ? 'الاسم بالإنجليزية' : 'Name in English'}</label>
                <input
                  className="text-input"
                  value={newCustNameEn}
                  onChange={(e) => setNewCustNameEn(e.target.value)}
                  placeholder="e.g. Hossam Hassan"
                />
              </div>
            </div>

            <div className="field-pair">
              <div>
                <label className="field-label">{lang === 'ar' ? 'رقم الهاتف' : 'Phone Number'}</label>
                <input
                  className="text-input"
                  value={newCustPhone}
                  onChange={(e) => setNewCustPhone(e.target.value)}
                  placeholder="010 •••• 1234"
                />
              </div>
              <div>
                <label className="field-label">{lang === 'ar' ? 'قيمة المشتريات الأولية (ج.م)' : 'Initial Spend (EGP)'}</label>
                <input
                  className="text-input"
                  type="number"
                  value={newCustSpend}
                  onChange={(e) => setNewCustSpend(e.target.value)}
                  placeholder="85"
                />
              </div>
            </div>

            <div className="field-pair">
              <div>
                <label className="field-label">{lang === 'ar' ? 'تصنيف الشريحة' : 'Customer Segment'}</label>
                <select
                  className="select-control full-width"
                  value={newCustSegment}
                  onChange={(e) => setNewCustSegment(e.target.value)}
                >
                  <option value="عميل جديد">{lang === 'ar' ? 'عميل جديد (New)' : 'New Customer'}</option>
                  <option value="عميل دائم (VIP)">{lang === 'ar' ? 'عميل دائم VIP' : 'VIP Regular'}</option>
                  <option value="عميل عائد">{lang === 'ar' ? 'عميل عائد' : 'Returning'}</option>
                </select>
              </div>
              <div>
                <label className="field-label">{lang === 'ar' ? 'المشروب المفضل' : 'Favorite Drink'}</label>
                <input
                  className="text-input"
                  value={newCustFav}
                  onChange={(e) => setNewCustFav(e.target.value)}
                  placeholder="مثال: فلات وايت أرتيزان"
                />
              </div>
            </div>

            <div className="modal-actions">
              <button className="button button-secondary" onClick={close}>{lang === 'ar' ? 'إلغاء' : 'Cancel'}</button>
              <button className="button button-primary" onClick={save}>{lang === 'ar' ? 'إضافة العميل للقاعدة' : 'Add Customer'}</button>
            </div>
          </div>
        )}

        {/* 8.5. Reports & Data Export Center Modal */}
        {modal.type === 'export_customers' && (() => {
          const filteredList = modal.filteredList || [];
          const allList = modal.allList || modal.customers || customers || [];
          const activeList = exportScope === 'filtered' ? filteredList : allList;

          const totalSpend = activeList.reduce((acc, c) => acc + (Number(c.spent) || 0), 0);
          const totalOrders = activeList.reduce((acc, c) => acc + (Number(c.orders) || 0), 0);
          const vipPatrons = activeList.filter((c) => c.segmentKey === 'vip').length;
          const avgSpend = activeList.length ? Math.round(totalSpend / activeList.length) : 0;

          return (
            <div className="export-modal-wrap">
              {/* Scope Selector */}
              <div className="export-scope-box">
                <label className="field-label bold-label">
                  🎯 {lang === 'ar' ? 'حدد نطاق العملاء المطلوب تضمينهم في التقرير:' : 'Select customers to include in report:'}
                </label>
                <div className="scope-options-row">
                  <label className={`scope-radio-label ${exportScope === 'filtered' ? 'active' : ''}`}>
                    <input
                      type="radio"
                      name="exportScope"
                      checked={exportScope === 'filtered'}
                      onChange={() => setExportScope('filtered')}
                    />
                    <span>
                      {lang === 'ar'
                        ? `العملاء المعروضون حالياً حسب البحث/الشريحة (${filteredList.length} عميل)`
                        : `Current Filtered Patrons (${filteredList.length})`}
                    </span>
                  </label>

                  <label className={`scope-radio-label ${exportScope === 'all' ? 'active' : ''}`}>
                    <input
                      type="radio"
                      name="exportScope"
                      checked={exportScope === 'all'}
                      onChange={() => setExportScope('all')}
                    />
                    <span>
                      {lang === 'ar'
                        ? `كافة عملاء مقهى الزيتون المسجلين (${allList.length} عميل)`
                        : `All Registered Cafe Patrons (${allList.length})`}
                    </span>
                  </label>
                </div>
              </div>

              {/* Dynamic KPI Summary */}
              <div className="export-kpi-summary">
                <div className="export-kpi-item">
                  <span>{lang === 'ar' ? 'العملاء في التقرير' : 'Total Patrons'}</span>
                  <strong>{activeList.length}</strong>
                </div>
                <div className="export-kpi-item">
                  <span>{lang === 'ar' ? 'إجمالي المبيعات' : 'Total Revenue'}</span>
                  <strong className="highlight">{totalSpend.toLocaleString('en-US')} ج.م</strong>
                </div>
                <div className="export-kpi-item">
                  <span>{lang === 'ar' ? 'عملاء VIP' : 'VIP Patrons'}</span>
                  <strong>{vipPatrons}</strong>
                </div>
                <div className="export-kpi-item">
                  <span>{lang === 'ar' ? 'متوسط الطلبات' : 'Total Orders'}</span>
                  <strong>{totalOrders}</strong>
                </div>
              </div>

              {/* 2 Export Format Cards */}
              <div className="export-format-grid">
                {/* Format 1: Executive Excel */}
                <div className="export-card excel">
                  <span className="export-card-badge">⭐ {lang === 'ar' ? 'موصى به للإدارة' : 'Executive Choice'}</span>
                  <div>
                    <div className="export-card-head">
                      <span className="export-icon">📊</span>
                      <div>
                        <h4>{lang === 'ar' ? 'تقرير Excel التنفيذي المنسق' : 'Styled Executive Excel'}</h4>
                        <small>{lang === 'ar' ? 'صيغة Microsoft Excel Workbook (.xls)' : 'Native Styled Workbook (.xls)'}</small>
                      </div>
                    </div>
                    <ul className="export-card-features" style={{ marginTop: '12px' }}>
                      <li><span>🎨</span> {lang === 'ar' ? 'منسق بألوان وهوية مقهى الزيتون الفاخرة' : 'Branded in cafe signature roast & caramel'}</li>
                      <li><span>🔄</span> {lang === 'ar' ? 'اتجاه عربي (RTL) تلقائي في Microsoft Excel' : 'Automatic RTL layout & Arabic typography'}</li>
                      <li><span>🏷️</span> {lang === 'ar' ? 'بادجات ملونة لكل شريحة (VIP، عائد، جديد، غائب)' : 'Color-coded customer segment badges'}</li>
                      <li><span>💰</span> {lang === 'ar' ? 'تنسيق عملة (ج.م) وحفظ أرقام الهواتف كنص' : 'Phone numbers preserved with leading zeros'}</li>
                      <li><span>📈</span> {lang === 'ar' ? 'مؤشرات الأداء (KPIs) وصف الإجمالي العام' : 'Executive KPI summary & total footer row'}</li>
                    </ul>
                  </div>
                  <button
                    type="button"
                    className="export-download-btn excel-action"
                    onClick={() => {
                      exportCustomersToExcel(activeList, {
                        cafeName: lang === 'ar' ? 'مقهى الزيتون' : 'Al-Zaytoun Cafe',
                        branchName: lang === 'ar' ? 'كفر الشيخ — شارع الجيش' : 'Kafr El-Sheikh — El-Geesh St.',
                        lang,
                        filterLabel: exportScope === 'filtered' ? (lang === 'ar' ? 'تصفية مخصصة' : 'Filtered') : (lang === 'ar' ? 'كافة العملاء' : 'All')
                      });
                      notify(lang === 'ar' ? 'تم تنزيل تقرير Excel التنفيذي بنجاح 📊' : 'Executive Excel downloaded 📊');
                    }}
                  >
                    <span>📊</span> {lang === 'ar' ? 'تحميل تقرير Excel المصمم فوراً' : 'Download Executive Excel'}
                  </button>
                </div>

                {/* Format 2: Universal Clean CSV */}
                <div className="export-card csv">
                  <span className="export-card-badge">⚡ {lang === 'ar' ? 'معالج sep=, بدون تداخل' : 'Universal sep=, Clean'}</span>
                  <div>
                    <div className="export-card-head">
                      <span className="export-icon">📄</span>
                      <div>
                        <h4>{lang === 'ar' ? 'ملف CSV المطور القياسي' : 'Universal Clean CSV'}</h4>
                        <small>{lang === 'ar' ? 'صيغة الجداول القياسية (.csv)' : 'Standard CSV File (.csv)'}</small>
                      </div>
                    </div>
                    <ul className="export-card-features" style={{ marginTop: '12px' }}>
                      <li><span>✅</span> {lang === 'ar' ? 'حل مشكلة دمج وتداخل الأعمدة في عمود A نهائياً' : 'Fixes Column A squashing with sep=, header'}</li>
                      <li><span>🌐</span> {lang === 'ar' ? 'متوافق 100% مع Excel, Google Sheets, Numbers' : '100% compatible with Excel, Sheets & Numbers'}</li>
                      <li><span>🔤</span> {lang === 'ar' ? 'ترميز UTF-8 مع BOM يمنع تشوه الحروف العربية' : 'UTF-8 BOM ensures zero Arabic garbling'}</li>
                      <li><span>📱</span> {lang === 'ar' ? 'حفظ أرقام الهواتف كاملة بدون تحويلها لمعادلات' : 'Phone formatting safely escaped'}</li>
                      <li><span>🔗</span> {lang === 'ar' ? 'جاهز للاستيراد الفوري في أي نظام CRM أو تسويق' : 'Ready for external CRM import & bulk tools'}</li>
                    </ul>
                  </div>
                  <button
                    type="button"
                    className="export-download-btn csv-action"
                    onClick={() => {
                      exportCustomersToCSV(activeList, { lang });
                      notify(lang === 'ar' ? 'تم تنزيل ملف CSV المطور بنجاح 📄' : 'Universal CSV downloaded 📄');
                    }}
                  >
                    <span>📄</span> {lang === 'ar' ? 'تحميل ملف CSV المنظم فوراً' : 'Download Clean CSV'}
                  </button>
                </div>
              </div>

              {/* Trust Note */}
              <div className="export-trust-note">
                <span>🛡️</span>
                <span>
                  {lang === 'ar'
                    ? 'كلا الملفين مصممان وفق أعلى المعايير القياسية لضمان الفتح التلقائي النظيف على أي جهاز كمبيوتر أو هاتف ذكي.'
                    : 'Both files are optimized with standard headers to open cleanly across all platforms.'}
                </span>
              </div>

              <div className="modal-actions">
                <button type="button" className="button button-secondary" onClick={close}>
                  {lang === 'ar' ? 'إغلاق النافذة' : 'Close'}
                </button>
              </div>
            </div>
          );
        })()}

        {/* 8.6. Orders Export Center Modal */}
        {modal.type === 'export_orders' && (() => {
          const filteredList = modal.filteredList || [];
          const allList = modal.allList || [];
          const activeList = exportScope === 'filtered' ? filteredList : allList;

          const totalAmount = activeList.reduce((sum, o) => {
            const num = typeof o.amount === 'number' ? o.amount : (parseInt(String(o.total || '0').replace(/[^0-9]/g, ''), 10) || 0);
            return sum + num;
          }, 0);

          const completedCount = activeList.filter((o) => o.state === 'done' || o.status === 'مكتمل').length;
          const avgOrder = activeList.length ? Math.round(totalAmount / activeList.length) : 0;

          return (
            <div className="export-modal-wrap">
              {/* Scope Selector */}
              <div className="export-scope-box">
                <label className="field-label bold-label">
                  🎯 {lang === 'ar' ? 'حدد نطاق الطلبات المطلوب تصديرها:' : 'Select orders range to export:'}
                </label>
                <div className="scope-options-row">
                  <label className={`scope-radio-label ${exportScope === 'filtered' ? 'active' : ''}`}>
                    <input
                      type="radio"
                      name="exportOrderScope"
                      checked={exportScope === 'filtered'}
                      onChange={() => setExportScope('filtered')}
                    />
                    <span>
                      {lang === 'ar'
                        ? `الطلبات المعروضة حالياً [${modal.periodLabel || 'الفترة المحددة'}] (${filteredList.length} طلب)`
                        : `Current Filtered Orders (${filteredList.length})`}
                    </span>
                  </label>

                  <label className={`scope-radio-label ${exportScope === 'all' ? 'active' : ''}`}>
                    <input
                      type="radio"
                      name="exportOrderScope"
                      checked={exportScope === 'all'}
                      onChange={() => setExportScope('all')}
                    />
                    <span>
                      {lang === 'ar'
                        ? `سجل كافة الطلبات المحفوظة (${allList.length} طلب)`
                        : `All Recorded Orders (${allList.length})`}
                    </span>
                  </label>
                </div>
              </div>

              {/* Dynamic KPI Summary */}
              <div className="export-kpi-summary">
                <div className="export-kpi-item">
                  <span>{lang === 'ar' ? 'الطلبات المشمولة' : 'Total Orders'}</span>
                  <strong>{activeList.length}</strong>
                </div>
                <div className="export-kpi-item">
                  <span>{lang === 'ar' ? 'إجمالي المبيعات' : 'Total Sales'}</span>
                  <strong className="highlight">{totalAmount.toLocaleString('en-US')} ج.م</strong>
                </div>
                <div className="export-kpi-item">
                  <span>{lang === 'ar' ? 'الطلبات المكتملة' : 'Completed'}</span>
                  <strong>{completedCount}</strong>
                </div>
                <div className="export-kpi-item">
                  <span>{lang === 'ar' ? 'متوسط قيمة الطلب' : 'Avg Order'}</span>
                  <strong>{avgOrder.toLocaleString('en-US')} ج.م</strong>
                </div>
              </div>

              {/* 2 Export Format Cards */}
              <div className="export-format-grid">
                {/* Format 1: Executive Excel */}
                <div className="export-card excel">
                  <span className="export-card-badge">⭐ {lang === 'ar' ? 'موصى به للإدارة والمحاسبة' : 'Executive Choice'}</span>
                  <div>
                    <div className="export-card-head">
                      <span className="export-icon">📊</span>
                      <div>
                        <h4>{lang === 'ar' ? 'تقرير طلبات Excel المنسق' : 'Styled Orders Excel Report'}</h4>
                        <small>{lang === 'ar' ? 'صيغة Microsoft Excel Workbook (.xls)' : 'Native Styled Workbook (.xls)'}</small>
                      </div>
                    </div>
                    <ul className="export-card-features" style={{ marginTop: '12px' }}>
                      <li><span>🎨</span> {lang === 'ar' ? 'منسق بهوية مقهى الزيتون وكروت المؤشرات' : 'Branded in cafe roast theme with KPI cards'}</li>
                      <li><span>🔄</span> {lang === 'ar' ? 'اتجاه عربي (RTL) تلقائي في Microsoft Excel' : 'Automatic RTL layout & Arabic typography'}</li>
                      <li><span>🏷️</span> {lang === 'ar' ? 'بادجات ملونة لحالات الطلبات (مكتمل، بالبار، جديد)' : 'Color-coded order status badges'}</li>
                      <li><span>💰</span> {lang === 'ar' ? 'تنسيق العملة والأرقام وحساب المجموع تلقائياً' : 'Automated currency formatting & totals row'}</li>
                      <li><span>📋</span> {lang === 'ar' ? 'تفاصيل الأصناف والكميات وأوقات الاستلام' : 'Complete items breakdown and order times'}</li>
                    </ul>
                  </div>
                  <button
                    type="button"
                    className="export-download-btn excel-action"
                    onClick={() => {
                      exportOrdersToExcel(activeList, {
                        cafeName: lang === 'ar' ? 'مقهى الزيتون' : 'Al-Zaytoun Cafe',
                        branchName: lang === 'ar' ? 'كفر الشيخ — شارع الجيش' : 'Kafr El-Sheikh — El-Geesh St.',
                        periodLabel: exportScope === 'filtered' ? (modal.periodLabel || 'الفترة المحددة') : 'كافة الطلبات',
                        lang,
                      });
                      notify(lang === 'ar' ? 'تم تنزيل تقرير الطلبات التنفيذي (Excel) بنجاح 📊' : 'Orders Excel downloaded 📊');
                    }}
                  >
                    <span>📊</span> {lang === 'ar' ? 'تحميل تقرير Excel للطلبات فوراً' : 'Download Orders Excel'}
                  </button>
                </div>

                {/* Format 2: Universal Clean CSV */}
                <div className="export-card csv">
                  <span className="export-card-badge">⚡ {lang === 'ar' ? 'معالج sep=, بدون تداخل' : 'Universal sep=, Clean'}</span>
                  <div>
                    <div className="export-card-head">
                      <span className="export-icon">📄</span>
                      <div>
                        <h4>{lang === 'ar' ? 'ملف CSV الطلبات القياسي' : 'Universal Clean Orders CSV'}</h4>
                        <small>{lang === 'ar' ? 'صيغة الجداول القياسية (.csv)' : 'Standard CSV File (.csv)'}</small>
                      </div>
                    </div>
                    <ul className="export-card-features" style={{ marginTop: '12px' }}>
                      <li><span>✅</span> {lang === 'ar' ? 'حل مشكلة دمج وتداخل الأعمدة في عمود A نهائياً' : 'Fixes Column A squashing with sep=, header'}</li>
                      <li><span>🌐</span> {lang === 'ar' ? 'متوافق 100% مع Excel, Google Sheets, Numbers' : '100% compatible with Excel, Sheets & Numbers'}</li>
                      <li><span>🔤</span> {lang === 'ar' ? 'ترميز UTF-8 مع BOM يمنع تشوه الحروف العربية' : 'UTF-8 BOM ensures zero Arabic garbling'}</li>
                      <li><span>🧾</span> {lang === 'ar' ? 'رقم الطلب والعميل والقيمة مفصولة بدقة' : 'Clean columns for order ID, customer, amount'}</li>
                      <li><span>🔗</span> {lang === 'ar' ? 'جاهز للاستيراد في برامج المحاسبة الخارجية' : 'Ready for external accounting import'}</li>
                    </ul>
                  </div>
                  <button
                    type="button"
                    className="export-download-btn csv-action"
                    onClick={() => {
                      exportOrdersToCSV(activeList, { lang });
                      notify(lang === 'ar' ? 'تم تنزيل ملف CSV الطلبات المنظم بنجاح 📄' : 'Orders CSV downloaded 📄');
                    }}
                  >
                    <span>📄</span> {lang === 'ar' ? 'تحميل ملف CSV الطلبات فوراً' : 'Download Orders CSV'}
                  </button>
                </div>
              </div>

              {/* Trust Note */}
              <div className="export-trust-note">
                <span>🛡️</span>
                <span>
                  {lang === 'ar'
                    ? 'التقارير متوافقة ومجهزة للطباعة والمحاسبة والمطابقة مع كاشير البار والإدارة المالية.'
                    : 'Reports are verified and ready for cashier matching, printing, and accounting.'}
                </span>
              </div>

              <div className="modal-actions">
                <button type="button" className="button button-secondary" onClick={close}>
                  {lang === 'ar' ? 'إغلاق النافذة' : 'Close'}
                </button>
              </div>
            </div>
          );
        })()}

        {/* 9. Order Reject Modal */}
        {modal.type === 'reject' && (
          <>
            <div className="payment-summary">
              <span>رقم الطلب</span><strong>{modal.order.id}</strong>
              <span>العميل</span><strong>{modal.order.customer}</strong>
              <span>قيمة الطلب</span><strong>{modal.order.total}</strong>
            </div>
            <label className="field-label">سبب الرفض <b className="required-mark">*</b></label>
            <textarea className="text-input textarea" value={reason} onChange={(e) => setReason(e.target.value)} placeholder="اختار أو اكتب سبب واضح للعميل" required />
            <div className="inline-note">لازم تسجل سببًا قبل رفض الطلب. سيتم إظهاره للعميل.</div>
            <div className="modal-actions">
              <button className="button button-secondary" onClick={close}>إلغاء</button>
              <button className="button button-primary" onClick={save}>تأكيد الرفض</button>
            </div>
          </>
        )}

        {/* 10. Staff Payment Modal */}
        {modal.type === 'payment' && (
          <>
            <div className="payment-summary">
              <span>الموظف</span><strong>{modal.employee?.n}</strong>
              <span>الراتب الشهري</span><strong>{money(modal.employee?.salary || 0)}</strong>
              <span>المدفوع حتى الآن</span><strong>{money(modal.employee?.paid || 0)}</strong>
              <span>الشهر المستحق</span><strong>{modal.month}</strong>
            </div>
            <label className="field-label">مبلغ الدفعة النقدية</label>
            <input className="text-input" inputMode="numeric" placeholder="المبلغ بالجنيه المصري" />
            <label className="field-label">تاريخ الاستلام</label>
            <input className="date-input full-width" type="date" defaultValue="2026-11-11" />
            <label className="field-label">ملاحظة (اختياري)</label>
            <input className="text-input" placeholder="مثال: الدفعة الأولى من الشهر" />
            <div className="inline-note">بتسجيل الدفعة، أنت تؤكد استلام المبلغ نقدًا من الموظف.</div>
            <div className="modal-actions">
              <button className="button button-secondary" onClick={close}>إلغاء</button>
              <button className="button button-primary" onClick={save}>تسجيل الدفعة</button>
            </div>
          </>
        )}

        {/* 11. Generic forms */}
        {['offer', 'loyalty', 'staff'].includes(modal.type) && (
          <>
            <label className="field-label">الاسم</label>
            <input className="text-input" value={title} onChange={(e) => setTitle(e.target.value)} placeholder={modal.type === 'staff' ? 'اسم الموظف' : 'اكتب الاسم هنا'} />
            <div className="inline-note">النموذج التفاعلي للعرض فقط. الحفظ الدائم سيتاح بعد تجهيز خدمة الـAPI.</div>
            <div className="modal-actions">
              <button className="button button-secondary" onClick={close}>إلغاء</button>
              <button className="button button-primary" onClick={save}>حفظ التغيير</button>
            </div>
          </>
        )}
      </section>
    </div>
  );
}

export default App;
