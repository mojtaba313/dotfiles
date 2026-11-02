" غیرفعال کردن شماره خطوط و شماره خطوط نسبی
set nonumber
set norelativenumber

" غیرفعال کردن نوار وضعیت (نوار پایین)
set laststatus=0

" غیرفعال کردن نوار تب (اگر از buffer استفاده می‌کنید)
set showtabline=0

" غیرفعال کردن نشانگرهای ستون کناری (اگر از پلاگین نشانه‌گذاری استفاده می‌کنید)
set signcolumn=no

" غیرفعال کردن برجسته‌سازی خط فعلی (اختیاری، برای مینیمال‌تر شدن)
set nocursorline

" غیرفعال کردن راهنمای دستورات در گوشه پایین راست (اختیاری)
set noruler

" حذف پس‌زمینه ناحیه اصلی متن
highlight Normal guibg=none ctermbg=none
" حذف پس‌زمینه پنجره‌های شناور (مثل منوهای تکمیل خودکار)
highlight NormalFloat guibg=none
" حذف پس‌زمینه ناحیه‌های خالی (تا وقتی فایل را باز می‌کنید پس‌زمینه تیره نبینید)
highlight NonText guibg=none
