from django.shortcuts import render
from django.http import HttpResponse
import random

# Create your views here.
def home(request):
    return render(request,'generator/home.html',{'password':'12312312'})

def about(request):
    return render(request,'generator/about.html',)

def password(request):
    length=int(request.GET.get('length',8))
    characters=list('abcdefhijklmnopqrstuvwxyz')
    if request.GET.get('uppercase'):
        characters.extend(['ABCDEFGHIJKLMNOPQRSUVWXYZ'])
    if request.GET.get('special'):
        characters.extend(['!@#$%^&*():"<>?'])
    if request.GET.get('numbers'):
        characters.extend(list(map(str,[0,1,2,3,4,5,6,7,8,9])))    
    
    password=''
    for i in range(length):
        password+=random.choice(characters)


    return render(request,'generator/password.html',{'password':password})

