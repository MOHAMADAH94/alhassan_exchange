from django.contrib import admin
from .models import CurrencyRate
from .models import Branch


@admin.register(CurrencyRate)
class CurrencyRateAdmin(admin.ModelAdmin):
    list_display = ('base_currency', 'target_currency', 'buy_price', 'sell_price', 'updated_at')
    search_fields = ('base_currency', 'target_currency')
    list_filter = ('base_currency', 'target_currency', 'updated_at')




@admin.register(Branch)
class BranchAdmin(admin.ModelAdmin):
    list_display = ('name', 'city', 'address')  # الأعمدة التي تظهر في لوحة التحكم
    search_fields = ('name', 'city')  # إضافة بحث حسب الاسم أو المدينة
