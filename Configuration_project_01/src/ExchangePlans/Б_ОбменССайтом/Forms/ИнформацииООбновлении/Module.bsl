

#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ВерсияУстановленногоМодуля.Заголовок = Параметры.ТекущаяВерсияМодуля;
	
	Элементы.ОбщаяИнформация.Заголовок = Символы.ПС + "Рекомендуется обновить модуль до версии " + Параметры.ИнформацияООбновлении.ВерсияМодуля;
	
	ТаблицаИстории = Параметры.ИнформацияООбновлении.История.Получить();
	ТаблицаИстории.Сортировать("ВерсияМодуля Убыв");

	ИсторияИзменений.Загрузить(ТаблицаИстории);
	
	АдресСсылки	= Параметры.ИнформацияООбновлении.Ссылка;
	
КонецПроцедуры

#КонецОбласти


#Область СобытияЖлементовФормы

&НаКлиенте
Процедура АдресМодуляНажатие(Элемент)
	ПерейтиПоНавигационнойСсылке(АдресСсылки);
КонецПроцедуры

#КонецОбласти



