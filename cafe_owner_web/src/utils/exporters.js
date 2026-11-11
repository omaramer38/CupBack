/**
 * Professional Excel (.xls) and Universal CSV (.csv) Export Engine
 * Designed for CupBack Cafe Owner Platform
 * Compliant with Microsoft Excel (Windows & Mac), Google Sheets, and Apple Numbers.
 */

export const exportCustomersToExcel = (list = [], options = {}) => {
  const {
    cafeName = 'مقهى الزيتون',
    branchName = 'كفر الشيخ — شارع الجيش',
    lang = 'ar',
    filterLabel = 'الكل'
  } = options;

  const isAr = lang === 'ar';
  const totalSpent = list.reduce((sum, c) => sum + (Number(c.spent) || 0), 0);
  const totalOrders = list.reduce((sum, c) => sum + (Number(c.orders) || 0), 0);
  const vipCount = list.filter((c) => c.segmentKey === 'vip').length;
  const avgSpent = list.length ? Math.round(totalSpent / list.length) : 0;
  const exportDate = new Date().toLocaleDateString(isAr ? 'ar-EG' : 'en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });

  const rowsHtml = list.map((c, idx) => {
    const isEven = idx % 2 === 0;
    const bg = isEven ? '#FFFFFF' : '#FAF6F0';

    let badgeBg = '#F3F4F6';
    let badgeColor = '#374151';
    let badgeBorder = '#D1D5DB';

    if (c.segmentKey === 'vip') {
      badgeBg = '#FEF3C7';
      badgeColor = '#92400E';
      badgeBorder = '#F59E0B';
    } else if (c.segmentKey === 'new') {
      badgeBg = '#ECFDF5';
      badgeColor = '#065F46';
      badgeBorder = '#10B981';
    } else if (c.segmentKey === 'returning') {
      badgeBg = '#EFF6FF';
      badgeColor = '#1E40AF';
      badgeBorder = '#3B82F6';
    } else if (c.segmentKey === 'at_risk') {
      badgeBg = '#FEF2F2';
      badgeColor = '#991B1B';
      badgeBorder = '#EF4444';
    }

    const hasDiscount = c.discount && c.discount !== 'لا يوجد' && c.discount !== 'None';

    return `
      <tr style="background-color: ${bg};">
        <td style="border: 1px solid #E5D5C5; padding: 8px 10px; text-align: center; font-size: 10.5pt; color: #5D493A;">${idx + 1}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; font-weight: bold; font-size: 11pt; color: #2D1C12;">${c.name}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; font-size: 10.5pt; color: #4A3B32;">${c.nameEn || '—'}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; text-align: center; mso-number-format: '\\@'; font-family: monospace; font-size: 10.5pt; color: #2D1C12; direction: ltr;">${c.phone}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 10px; text-align: center;">
          <span style="background-color: ${badgeBg}; color: ${badgeColor}; border: 1px solid ${badgeBorder}; padding: 3px 8px; border-radius: 4px; font-weight: bold; font-size: 9.5pt;">${c.segment}</span>
        </td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 10px; text-align: center; font-weight: bold; font-size: 10.5pt; color: #2D1C12; mso-number-format: '\\#\\,\\#\\#0';">${c.orders || 0}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; text-align: right; font-weight: bold; color: #166534; font-size: 11pt; mso-number-format: '\\#\\,\\#\\#0\\.00';">${(c.spent || 0).toLocaleString('en-US')} ج.م</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; font-size: 10.5pt; color: #3E2B20;">${c.favoriteItem || '—'}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; font-size: 10pt; font-weight: ${hasDiscount ? 'bold' : 'normal'}; color: ${hasDiscount ? '#15803d' : '#8C7B6F'};">${c.discount || 'لا يوجد'}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 10px; text-align: center; font-size: 10pt; color: #5D493A;">${c.memberSince || '2025'}</td>
      </tr>
    `;
  }).join('');

  const template = `
    <html xmlns:o="urn:schemas-microsoft-com:office:office"
          xmlns:x="urn:schemas-microsoft-com:office:excel"
          xmlns="http://www.w3.org/TR/REC-html40">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <!--[if gte mso 9]>
      <xml>
        <x:ExcelWorkbook>
          <x:ExcelWorksheets>
            <x:ExcelWorksheet>
              <x:Name>${isAr ? 'دليل عملاء مقهى الزيتون' : 'Customers Directory'}</x:Name>
              <x:WorksheetOptions>
                ${isAr ? '<x:DisplayRightToLeft/>' : ''}
                <x:Selected/>
                <x:DoNotDisplayGridlines/>
              </x:WorksheetOptions>
            </x:ExcelWorksheet>
          </x:ExcelWorksheets>
        </x:ExcelWorkbook>
      </xml>
      <![endif]-->
      <style>
        body { font-family: 'Segoe UI', Tahoma, Arial, sans-serif; direction: ${isAr ? 'rtl' : 'ltr'}; }
        table { border-collapse: collapse; width: 100%; font-family: 'Segoe UI', Tahoma, Arial, sans-serif; }
      </style>
    </head>
    <body dir="${isAr ? 'rtl' : 'ltr'}">
      <table>
        <!-- Header Banner -->
        <tr>
          <th colspan="10" style="background-color: #2D1C12; color: #FFFFFF; font-size: 16pt; font-weight: bold; text-align: center; height: 50px; vertical-align: middle; border: 1px solid #1A0E08;">
            ☕ ${cafeName} · ${isAr ? 'تقرير وتحليلات العملاء المعتمد' : 'Official Customer CRM Analytics'} (CupBack Platform)
          </th>
        </tr>
        <tr>
          <td colspan="10" style="background-color: #3E2718; color: #F7F4EF; font-size: 10.5pt; text-align: center; height: 28px; vertical-align: middle; border: 1px solid #1A0E08;">
            ${isAr ? `تاريخ الاستخراج: ${exportDate} · الفرع: ${branchName} · نطاق التقرير: ${filterLabel}` : `Export Date: ${exportDate} · Branch: ${branchName} · Scope: ${filterLabel}`}
          </td>
        </tr>
        <tr><td colspan="10" style="height: 12px; background: #FFFFFF; border: none;"></td></tr>

        <!-- KPI Executive Summary Boxes -->
        <tr>
          <td colspan="2" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'إجمالي العملاء المشمولين' : 'Included Customers'}
          </td>
          <td colspan="3" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'إجمالي المبيعات التراكمية' : 'Total Cumulative Revenue'}
          </td>
          <td colspan="2" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'عملاء VIP الدائمون' : 'VIP Regulars'}
          </td>
          <td colspan="3" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'متوسط إنفاق العميل (LTV)' : 'Average Customer LTV'}
          </td>
        </tr>
        <tr>
          <td colspan="2" style="background-color: #FFF8F2; color: #2D1C12; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ${list.length} ${isAr ? 'عميل' : 'patrons'}
          </td>
          <td colspan="3" style="background-color: #FFF8F2; color: #166534; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ${totalSpent.toLocaleString('en-US')} ج.م
          </td>
          <td colspan="2" style="background-color: #FFF8F2; color: #B45309; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ${vipCount} ${isAr ? 'عميل' : 'patrons'}
          </td>
          <td colspan="3" style="background-color: #FFF8F2; color: #2D1C12; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ${avgSpent.toLocaleString('en-US')} ج.م
          </td>
        </tr>
        <tr><td colspan="10" style="height: 14px; background: #FFFFFF; border: none;"></td></tr>

        <!-- Table Columns -->
        <thead>
          <tr style="height: 38px;">
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 50px;">${isAr ? 'م' : '#'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 150px;">${isAr ? 'اسم العميل' : 'Customer Name'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 140px;">${isAr ? 'الاسم بالإنجليزية' : 'English Name'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 140px;">${isAr ? 'رقم الهاتف' : 'Phone Number'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 140px;">${isAr ? 'تصنيف الشريحة' : 'Segment Category'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 90px;">${isAr ? 'الطلبات' : 'Orders'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 140px;">${isAr ? 'إجمالي المشتريات' : 'Total Spent'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 170px;">${isAr ? 'المشروب المفضل' : 'Favorite Drink'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 140px;">${isAr ? 'الخصم / المكافأة النشطة' : 'Active Perk'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 100px;">${isAr ? 'تاريخ العضوية' : 'Member Since'}</th>
          </tr>
        </thead>
        <tbody>
          ${rowsHtml}
        </tbody>
        <tfoot>
          <tr style="background-color: #2D1C12; color: #FFFFFF; font-weight: bold; font-size: 11pt; height: 38px;">
            <td colspan="5" style="border: 1px solid #1A0E08; padding: 8px 12px; text-align: right;">${isAr ? 'المجموع الإجمالي للعملاء المشمولين:' : 'Grand Total for Included Customers:'}</td>
            <td style="border: 1px solid #1A0E08; padding: 8px 10px; text-align: center; color: #F7F4EF;">${totalOrders} ${isAr ? 'طلب' : 'orders'}</td>
            <td style="border: 1px solid #1A0E08; padding: 8px 12px; text-align: right; color: #4ADE80;">${totalSpent.toLocaleString('en-US')} ج.م</td>
            <td colspan="3" style="border: 1px solid #1A0E08; padding: 8px 12px; text-align: center; font-size: 9.5pt; color: #D1BBA7;">CupBack Platform CRM</td>
          </tr>
        </tfoot>
      </table>
    </body>
    </html>
  `;

  const blob = new Blob([template], { type: 'application/vnd.ms-excel;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', `cupback_customers_executive_${new Date().toISOString().slice(0, 10)}.xls`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

export const exportCustomersToCSV = (list = [], options = {}) => {
  const { lang = 'ar' } = options;
  const isAr = lang === 'ar';

  const headers = isAr
    ? ['م', 'كود العميل', 'اسم العميل', 'الاسم بالإنجليزية', 'رقم الهاتف', 'تصنيف الشريحة', 'عدد الطلبات', 'إجمالي الإنفاق (ج.م)', 'المشروب المفضل', 'الخصم النشط', 'تاريخ الانضمام']
    : ['No', 'Customer_ID', 'Customer_Name', 'Name_English', 'Phone', 'Segment', 'Total_Orders', 'Total_Spent_EGP', 'Favorite_Drink', 'Active_Discount', 'Member_Since'];

  const rows = list.map((c, idx) => {
    return [
      idx + 1,
      `"${c.id}"`,
      `"${(c.name || '').replace(/"/g, '""')}"`,
      `"${(c.nameEn || '').replace(/"/g, '""')}"`,
      `"\t${c.phone}"`, // Prepending \t forces Excel to treat as plain string, preserving 010 and spaces
      `"${(c.segment || '').replace(/"/g, '""')}"`,
      c.orders || 0,
      c.spent || 0,
      `"${(c.favoriteItem || '').replace(/"/g, '""')}"`,
      `"${(c.discount || (isAr ? 'لا يوجد' : 'None')).replace(/"/g, '""')}"`,
      `"${c.memberSince || '2025'}"`,
    ].join(',');
  });

  // CRITICAL FIX: \uFEFFsep=,\r\n instructs Excel to split on commas regardless of Windows locale, preventing Column A squashing!
  const csvContent = '\uFEFFsep=,\r\n' + headers.join(',') + '\r\n' + rows.join('\r\n');
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', `cupback_customers_directory_${new Date().toISOString().slice(0, 10)}.csv`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

export const exportSalesToExcel = (salesData = {}, options = {}) => {
  const {
    cafeName = 'مقهى الزيتون',
    range = 'هذا الشهر',
    lang = 'ar'
  } = options;

  const isAr = lang === 'ar';
  const exportDate = new Date().toLocaleDateString(isAr ? 'ar-EG' : 'en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });

  const template = `
    <html xmlns:o="urn:schemas-microsoft-com:office:office"
          xmlns:x="urn:schemas-microsoft-com:office:excel"
          xmlns="http://www.w3.org/TR/REC-html40">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <!--[if gte mso 9]>
      <xml>
        <x:ExcelWorkbook>
          <x:ExcelWorksheets>
            <x:ExcelWorksheet>
              <x:Name>${isAr ? 'تقرير المبيعات والأداء' : 'Sales Report'}</x:Name>
              <x:WorksheetOptions>
                ${isAr ? '<x:DisplayRightToLeft/>' : ''}
                <x:Selected/>
                <x:DoNotDisplayGridlines/>
              </x:WorksheetOptions>
            </x:ExcelWorksheet>
          </x:ExcelWorksheets>
        </x:ExcelWorkbook>
      </xml>
      <![endif]-->
      <style>
        body { font-family: 'Segoe UI', Tahoma, Arial, sans-serif; direction: ${isAr ? 'rtl' : 'ltr'}; }
        table { border-collapse: collapse; width: 100%; font-family: 'Segoe UI', Tahoma, Arial, sans-serif; }
      </style>
    </head>
    <body dir="${isAr ? 'rtl' : 'ltr'}">
      <table>
        <tr>
          <th colspan="6" style="background-color: #2D1C12; color: #FFFFFF; font-size: 16pt; font-weight: bold; text-align: center; height: 50px; vertical-align: middle;">
            📊 ${cafeName} · ${isAr ? 'تقرير المبيعات والتشغيل المالي' : 'Financial & Sales Performance Report'}
          </th>
        </tr>
        <tr>
          <td colspan="6" style="background-color: #3E2718; color: #F7F4EF; font-size: 10.5pt; text-align: center; height: 26px;">
            ${isAr ? `تاريخ التقرير: ${exportDate} · الفترة: ${range}` : `Report Date: ${exportDate} · Period: ${range}`}
          </td>
        </tr>
        <tr><td colspan="6" style="height: 12px; background: #FFFFFF; border: none;"></td></tr>
        <tr>
          <td colspan="2" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'إجمالي المبيعات' : 'Gross Sales'}
          </td>
          <td colspan="1" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'عدد الطلبات' : 'Total Orders'}
          </td>
          <td colspan="1" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'متوسط الطلب' : 'Avg Order'}
          </td>
          <td colspan="2" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'إجمالي الخصومات' : 'Discounts'}
          </td>
        </tr>
        <tr>
          <td colspan="2" style="background-color: #FFF8F2; color: #166534; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ٢٨٤٬٦٤٠ ج.م
          </td>
          <td colspan="1" style="background-color: #FFF8F2; color: #1E40AF; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ٢٬٨٩٤
          </td>
          <td colspan="1" style="background-color: #FFF8F2; color: #2D1C12; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ٩٨٫٣ ج.م
          </td>
          <td colspan="2" style="background-color: #FFF8F2; color: #B91C1C; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            −١٨٬٤٢٠ ج.م
          </td>
        </tr>
        <tr><td colspan="6" style="height: 14px; background: #FFFFFF; border: none;"></td></tr>
        <thead>
          <tr style="height: 36px;">
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; text-align: center; border: 1px solid #8C4D24;">${isAr ? 'البند المالي' : 'Item'}</th>
            <th colspan="2" style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; text-align: center; border: 1px solid #8C4D24;">${isAr ? 'طريقة التحصيل' : 'Method'}</th>
            <th colspan="3" style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; text-align: center; border: 1px solid #8C4D24;">${isAr ? 'القيمة الإجمالية (ج.م)' : 'Total (EGP)'}</th>
          </tr>
        </thead>
        <tbody>
          <tr style="background-color: #FFFFFF;">
            <td style="border: 1px solid #E5D5C5; padding: 9px 12px; font-weight: bold;">طلبات نقدية (كاش الصالة والبار)</td>
            <td colspan="2" style="border: 1px solid #E5D5C5; padding: 9px 12px; text-align: center;">نقدي في الكافيه</td>
            <td colspan="3" style="border: 1px solid #E5D5C5; padding: 9px 12px; text-align: right; font-weight: bold; color: #2D1C12;">٢١٨٬٦٤٠ ج.م</td>
          </tr>
          <tr style="background-color: #FAF6F0;">
            <td style="border: 1px solid #E5D5C5; padding: 9px 12px; font-weight: bold;">طلبات مدفوعة إلكترونياً (تطبيق CupBack)</td>
            <td colspan="2" style="border: 1px solid #E5D5C5; padding: 9px 12px; text-align: center;">محفظة / فيزا</td>
            <td colspan="3" style="border: 1px solid #E5D5C5; padding: 9px 12px; text-align: right; font-weight: bold; color: #166534;">٦٦٬٠٠٠ ج.م</td>
          </tr>
          <tr style="background-color: #FFFFFF;">
            <td style="border: 1px solid #E5D5C5; padding: 9px 12px; font-weight: bold; color: #B91C1C;">إجمالي الخصومات والعروض الترويجية</td>
            <td colspan="2" style="border: 1px solid #E5D5C5; padding: 9px 12px; text-align: center;">أكواد وعروض قرب</td>
            <td colspan="3" style="border: 1px solid #E5D5C5; padding: 9px 12px; text-align: right; font-weight: bold; color: #B91C1C;">−١٨٬٤٢٠ ج.م</td>
          </tr>
        </tbody>
        <tfoot>
          <tr style="background-color: #2D1C12; color: #FFFFFF; font-weight: bold; height: 38px;">
            <td colspan="3" style="border: 1px solid #1A0E08; padding: 9px 12px; text-align: right;">صافي المبيعات المحققة للفترة:</td>
            <td colspan="3" style="border: 1px solid #1A0E08; padding: 9px 12px; text-align: right; color: #4ADE80; font-size: 13pt;">٢٦٦٬٢٢٠ ج.م</td>
          </tr>
        </tfoot>
      </table>
    </body>
    </html>
  `;

  const blob = new Blob([template], { type: 'application/vnd.ms-excel;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', `cupback_sales_report_${new Date().toISOString().slice(0, 10)}.xls`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

export const exportOrdersToExcel = (ordersList = [], options = {}) => {
  const {
    cafeName = 'مقهى الزيتون',
    branchName = 'كفر الشيخ — شارع الجيش',
    periodLabel = 'طلبات اليوم',
    lang = 'ar'
  } = options;

  const isAr = lang === 'ar';
  const totalAmount = ordersList.reduce((sum, o) => {
    const num = typeof o.amount === 'number' ? o.amount : (parseInt(String(o.total || '0').replace(/[^0-9]/g, ''), 10) || 0);
    return sum + num;
  }, 0);

  const completedCount = ordersList.filter((o) => o.state === 'done' || o.status === 'مكتمل').length;
  const preparingCount = ordersList.filter((o) => o.state === 'preparing' || o.status === 'قيد التحضير').length;
  const newCount = ordersList.filter((o) => o.state === 'new' || o.status === 'طلب جديد').length;
  const avgOrder = ordersList.length ? Math.round(totalAmount / ordersList.length) : 0;

  const exportDate = new Date().toLocaleDateString(isAr ? 'ar-EG' : 'en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });

  const stateMap = {
    new: { label: isAr ? 'طلب جديد' : 'New Order', bg: '#FEF3C7', color: '#92400E', border: '#F59E0B' },
    preparing: { label: isAr ? 'قيد التحضير بالبار' : 'Preparing', bg: '#EFF6FF', color: '#1E40AF', border: '#3B82F6' },
    ready: { label: isAr ? 'جاهز للاستلام' : 'Ready', bg: '#F5F3FF', color: '#5B21B6', border: '#8B5CF6' },
    done: { label: isAr ? 'مكتمل ومستلم' : 'Completed', bg: '#ECFDF5', color: '#065F46', border: '#10B981' },
    rejected: { label: isAr ? 'مرفوض' : 'Rejected', bg: '#FEF2F2', color: '#991B1B', border: '#EF4444' }
  };

  const rowsHtml = ordersList.map((o, idx) => {
    const isEven = idx % 2 === 0;
    const bg = isEven ? '#FFFFFF' : '#FAF6F0';
    const st = stateMap[o.state] || { label: o.status || (isAr ? 'مكتمل' : 'Completed'), bg: '#F3F4F6', color: '#374151', border: '#D1D5DB' };
    const amountVal = typeof o.amount === 'number' ? o.amount : (parseInt(String(o.total || '0').replace(/[^0-9]/g, ''), 10) || 0);
    const customerDisplay = isAr ? o.customer : (o.customerEn || o.customer);
    const itemsDisplay = isAr ? o.items : (o.itemsEn || o.items);
    const timeDisplay = isAr ? o.time : (o.timeEn || o.time);

    return `
      <tr style="background-color: ${bg};">
        <td style="border: 1px solid #E5D5C5; padding: 8px 10px; text-align: center; font-size: 10.5pt; color: #5D493A;">${idx + 1}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; font-weight: bold; font-family: monospace; font-size: 11pt; color: #B96D3C; text-align: center;">${o.id}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; font-weight: bold; font-size: 11pt; color: #2D1C12;">${customerDisplay}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; font-size: 10.5pt; color: #4A3B32;">${o.customerEn || '—'}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 14px; font-size: 10.5pt; color: #2D1C12; font-weight: 500;">${itemsDisplay}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; text-align: right; font-weight: bold; color: #166534; font-size: 11pt; mso-number-format: '\\#\\,\\#\\#0\\.00';">${amountVal.toLocaleString('en-US')} ج.م</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 12px; font-size: 10pt; color: #68574C; text-align: center;">${timeDisplay}</td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 10px; text-align: center;">
          <span style="background-color: ${st.bg}; color: ${st.color}; border: 1px solid ${st.border}; padding: 3px 8px; border-radius: 4px; font-weight: bold; font-size: 9.5pt;">${st.label}</span>
        </td>
        <td style="border: 1px solid #E5D5C5; padding: 8px 10px; text-align: center; font-size: 10pt; color: #5D493A;">${o.paymentMethod || (isAr ? 'كاش في الكافيه' : 'Cash')}</td>
      </tr>
    `;
  }).join('');

  const template = `
    <html xmlns:o="urn:schemas-microsoft-com:office:office"
          xmlns:x="urn:schemas-microsoft-com:office:excel"
          xmlns="http://www.w3.org/TR/REC-html40">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <!--[if gte mso 9]>
      <xml>
        <x:ExcelWorkbook>
          <x:ExcelWorksheets>
            <x:ExcelWorksheet>
              <x:Name>${isAr ? 'سجل طلبات مقهى الزيتون' : 'Orders Registry'}</x:Name>
              <x:WorksheetOptions>
                ${isAr ? '<x:DisplayRightToLeft/>' : ''}
                <x:Selected/>
                <x:DoNotDisplayGridlines/>
              </x:WorksheetOptions>
            </x:ExcelWorksheet>
          </x:ExcelWorksheets>
        </x:ExcelWorkbook>
      </xml>
      <![endif]-->
      <style>
        body { font-family: 'Segoe UI', Tahoma, Arial, sans-serif; direction: ${isAr ? 'rtl' : 'ltr'}; }
        table { border-collapse: collapse; width: 100%; font-family: 'Segoe UI', Tahoma, Arial, sans-serif; }
      </style>
    </head>
    <body dir="${isAr ? 'rtl' : 'ltr'}">
      <table>
        <!-- Header Banner -->
        <tr>
          <th colspan="9" style="background-color: #2D1C12; color: #FFFFFF; font-size: 16pt; font-weight: bold; text-align: center; height: 50px; vertical-align: middle; border: 1px solid #1A0E08;">
            ☕ ${cafeName} · ${isAr ? 'سجل وكشف الطلبات المباشرة المعتمد' : 'Live Orders & Kitchen Registry'} (CupBack Platform)
          </th>
        </tr>
        <tr>
          <td colspan="9" style="background-color: #3E2718; color: #F7F4EF; font-size: 10.5pt; text-align: center; height: 28px; vertical-align: middle; border: 1px solid #1A0E08;">
            ${isAr ? `تاريخ التقرير: ${exportDate} · الفرع: ${branchName} · نطاق الفلترة: ${periodLabel}` : `Report Date: ${exportDate} · Branch: ${branchName} · Period Filter: ${periodLabel}`}
          </td>
        </tr>
        <tr><td colspan="9" style="height: 12px; background: #FFFFFF; border: none;"></td></tr>

        <!-- KPI Executive Summary Boxes -->
        <tr>
          <td colspan="2" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'عدد الطلبات المشمولة' : 'Included Orders'}
          </td>
          <td colspan="3" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'إجمالي المبيعات' : 'Total Revenue'}
          </td>
          <td colspan="2" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'الطلبات المكتملة' : 'Completed Orders'}
          </td>
          <td colspan="2" style="background-color: #EBDCD0; color: #5D493A; font-weight: bold; font-size: 10pt; text-align: center; border: 1px solid #D1BBA7; height: 26px;">
            ${isAr ? 'متوسط قيمة الطلب' : 'Average Order'}
          </td>
        </tr>
        <tr>
          <td colspan="2" style="background-color: #FFF8F2; color: #2D1C12; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ${ordersList.length} ${isAr ? 'طلب' : 'orders'}
          </td>
          <td colspan="3" style="background-color: #FFF8F2; color: #166534; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ${totalAmount.toLocaleString('en-US')} ج.م
          </td>
          <td colspan="2" style="background-color: #FFF8F2; color: #1E40AF; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ${completedCount} ${isAr ? 'طلب مكتمل' : 'completed'}
          </td>
          <td colspan="2" style="background-color: #FFF8F2; color: #B45309; font-weight: bold; font-size: 14pt; text-align: center; border: 1px solid #D1BBA7; height: 38px;">
            ${avgOrder.toLocaleString('en-US')} ج.م
          </td>
        </tr>
        <tr><td colspan="9" style="height: 14px; background: #FFFFFF; border: none;"></td></tr>

        <!-- Table Columns -->
        <thead>
          <tr style="height: 38px;">
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 45px;">${isAr ? 'م' : '#'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 100px;">${isAr ? 'رقم الطلب' : 'Order ID'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 140px;">${isAr ? 'اسم العميل' : 'Customer Name'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 130px;">${isAr ? 'الاسم بالإنجليزية' : 'English Name'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 240px;">${isAr ? 'الأصناف والكميات' : 'Ordered Items'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 130px;">${isAr ? 'قيمة الطلب' : 'Amount'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 120px;">${isAr ? 'توقيت الطلب' : 'Order Time'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 130px;">${isAr ? 'حالة الطلب' : 'Status'}</th>
            <th style="background-color: #B96D3C; color: #FFFFFF; font-weight: bold; font-size: 11pt; text-align: center; border: 1px solid #8C4D24; width: 110px;">${isAr ? 'طريقة الدفع' : 'Payment'}</th>
          </tr>
        </thead>
        <tbody>
          ${rowsHtml}
        </tbody>
        <tfoot>
          <tr style="background-color: #2D1C12; color: #FFFFFF; font-weight: bold; font-size: 11pt; height: 38px;">
            <td colspan="5" style="border: 1px solid #1A0E08; padding: 8px 12px; text-align: right;">${isAr ? 'المجموع الإجمالي للطلبات المعروضة:' : 'Grand Total for Orders:'}</td>
            <td style="border: 1px solid #1A0E08; padding: 8px 12px; text-align: right; color: #4ADE80; font-size: 12pt;">${totalAmount.toLocaleString('en-US')} ج.م</td>
            <td colspan="3" style="border: 1px solid #1A0E08; padding: 8px 12px; text-align: center; font-size: 9.5pt; color: #D1BBA7;">CupBack Kitchen & Orders System</td>
          </tr>
        </tfoot>
      </table>
    </body>
    </html>
  `;

  const blob = new Blob([template], { type: 'application/vnd.ms-excel;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', `cupback_orders_report_${new Date().toISOString().slice(0, 10)}.xls`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

export const exportOrdersToCSV = (ordersList = [], options = {}) => {
  const { lang = 'ar' } = options;
  const isAr = lang === 'ar';

  const headers = isAr
    ? ['م', 'رقم الطلب', 'اسم العميل', 'الاسم بالإنجليزية', 'الأصناف والكميات', 'قيمة الطلب (ج.م)', 'توقيت الطلب', 'حالة الطلب', 'طريقة الدفع']
    : ['No', 'Order_ID', 'Customer_Name', 'Name_English', 'Items', 'Amount_EGP', 'Time', 'Status', 'Payment'];

  const rows = ordersList.map((o, idx) => {
    const amountVal = typeof o.amount === 'number' ? o.amount : (parseInt(String(o.total || '0').replace(/[^0-9]/g, ''), 10) || 0);
    return [
      idx + 1,
      `"${o.id}"`,
      `"${(o.customer || '').replace(/"/g, '""')}"`,
      `"${(o.customerEn || '').replace(/"/g, '""')}"`,
      `"${(o.items || '').replace(/"/g, '""')}"`,
      amountVal,
      `"${(o.time || '').replace(/"/g, '""')}"`,
      `"${(o.status || o.state || '').replace(/"/g, '""')}"`,
      `"${(o.paymentMethod || (isAr ? 'كاش في الكافيه' : 'Cash')).replace(/"/g, '""')}"`,
    ].join(',');
  });

  // sep=, header tells Excel to cleanly separate columns on comma
  const csvContent = '\uFEFFsep=,\r\n' + headers.join(',') + '\r\n' + rows.join('\r\n');
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.setAttribute('download', `cupback_orders_${new Date().toISOString().slice(0, 10)}.csv`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
