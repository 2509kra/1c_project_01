
&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.КодРегион	= Сред(Объект.Организация.КПП,1,2);	
	
КонецПроцедуры // Процедура ОрганизацияПриИзмененииНаСервере()

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры // Процедура ОрганизацияПриИзменении(Элемент)

