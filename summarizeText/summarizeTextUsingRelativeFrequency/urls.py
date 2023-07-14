from django.urls import path
from  summarizeTextUsingRelativeFrequency import views

urlpatterns=[
      path('summarizedPatdetails/',views.Summarize.as_view()),
      
]