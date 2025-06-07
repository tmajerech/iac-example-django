from django.shortcuts import render
from django.views import View
from django.views.generic import TemplateView


# Create your views here.
class DefaultView(TemplateView):
    template_name = "index.html"