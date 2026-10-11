
from django.db import models

class CurrencyRate(models.Model):
    base_currency = models.CharField(max_length=50)
    target_currency = models.CharField(max_length=50)
    
    buy_price = models.DecimalField(max_digits=10, decimal_places=2)
    sell_price = models.DecimalField(max_digits=10, decimal_places=2)


    previous_buy_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    previous_sell_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)

    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.base_currency} to {self.target_currency}"




class Branch(models.Model):
    name = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    address = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.name} - {self.city}"
