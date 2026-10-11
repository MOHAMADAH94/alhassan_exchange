from rest_framework import viewsets
from .models import CurrencyRate
from .serializers import CurrencyRateSerializer

class CurrencyRateViewSet(viewsets.ModelViewSet):
    queryset = CurrencyRate.objects.all()
    serializer_class = CurrencyRateSerializer



from django.http import JsonResponse

def rates_view(request):
    data = [
        {"base_currency": "USD", "target_currency": "EUR", "buy_price": 1.1, "sell_price": 1.2},
        {"base_currency": "SAR", "target_currency": "EGP", "buy_price": 7.5, "sell_price": 7.9},
        {"base_currency": "جنيه", "target_currency": "دولار", "buy_price": 0.031, "sell_price": 0.033},
    ]
    return JsonResponse(data, safe=False, json_dumps_params={'ensure_ascii': False})


from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Branch
from .serializers import BranchSerializer

class BranchViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Branch.objects.all()
    serializer_class = BranchSerializer

    
from django.http import JsonResponse
from .models import Branch

def branch_list(request):
    branches = Branch.objects.all()
    data = [
        {
            'id': branch.id,
            'name': branch.name,
            'city': branch.city,
            'address': branch.address,
        }
        for branch in branches
    ]
    return JsonResponse(data, safe=False)
