
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ЗначениеГеографическогоРегиона", ЗначениеТекущегоРегиона);
	
	СтруктураГеоСхемы = Константы.ГеографическаяСхемаДляОтчетов.Получить().Получить();
	Если СтруктураГеоСхемы <> Неопределено Тогда
		СтруктураГеоСхемы.Свойство("ГеоСхема", ГеоСхема);
		ЗагрузитьОбъектыГеоСхемы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГеографическиеРегионыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОсуществитьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ГеографическиеРегионыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОсуществитьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбор(Команда)
	
	ОсуществитьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОсуществитьВыбор()
	
	ТекущиеДанные = Элементы.ГеографическиеРегионы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("ЗначениеГеографическогоРегиона, НазваниеГеографическогоРегиона",
		ТекущиеДанные.ЗначениеГеографическогоРегиона, ТекущиеДанные.НазваниеГеографическогоРегиона);
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьОбъектыГеоСхемы()
	
	ВыбиратьГорода = Ложь; // Города будут выбраны только для схемы регионов России со всеми городами
	Если ГеоСхема.Слои.Найти("Регионы России") <> Неопределено
		И ГеоСхема.Слои.Найти("Города") <> Неопределено Тогда
		Города = ГеоСхема.Слои.Города;
		НеСтолицы = Города.ВыбратьОбъекты(Новый Структура(Города.Серии.Столица.Имя, Ложь));
		Если НеСтолицы.Количество() Тогда
			ВыбиратьГорода = Истина;
			СоответствиеРегионовГородам = Новый Соответствие;
		КонецЕсли;
	КонецЕсли;
	
	СписокРегионов = Новый СписокЗначений;
	
	Слой = ГеоСхема.Слои[0];
	
	ЕстьСерияНазвание = Ложь;
	СерияНазвание = Слой.Серии.Найти("Название");
	Если СерияНазвание <> Неопределено Тогда
		ЕстьСерияНазвание = Истина;
	КонецЕсли;
	
	Для каждого Объект Из Слой.Объекты Цикл
		
		Если ЕстьСерияНазвание Тогда
			НазваниеОбъекта = Слой.ПолучитьЗначение(Объект, СерияНазвание);
			НовыйРегион = СписокРегионов.Добавить(Объект.Значение, НазваниеОбъекта.Значение);
		Иначе
			НовыйРегион = СписокРегионов.Добавить(Объект.Значение, Объект.Значение);
		КонецЕсли;

		Если ВыбиратьГорода Тогда
			ЕстьСерияНазваниеГорода = Ложь;
			СерияНазваниеГорода = Города.Серии.Найти("Название");
			Если СерияНазваниеГорода <> Неопределено Тогда
				ЕстьСерияНазваниеГорода = Истина;
			КонецЕсли;
			
			СписокГородов = Новый СписокЗначений;
			ГородаРегиона = Города.ВыбратьОбъекты(Новый Структура(Города.Серии.КОД_КЛАДР_РЕГИОНА.Имя, Объект.Значение));
			Для каждого ГородРегиона Из ГородаРегиона Цикл
				Если ЕстьСерияНазваниеГорода Тогда
					НазваниеГорода = Города.ПолучитьЗначение(ГородРегиона, СерияНазваниеГорода);
					СписокГородов.Добавить(ГородРегиона.Значение, НазваниеГорода.Значение);
				Иначе
					СписокГородов.Добавить(ГородРегиона.Значение, ГородРегиона.Значение);
				КонецЕсли;
			КонецЦикла;
			СписокГородов.СортироватьПоПредставлению();
			СоответствиеРегионовГородам.Вставить(НовыйРегион.ПолучитьИдентификатор(), СписокГородов);
		КонецЕсли;
		
	КонецЦикла;
	
	СписокРегионов.СортироватьПоПредставлению();
	
	ЭлементыРегион = ГеографическиеРегионы.ПолучитьЭлементы();
	ИДСтроки = 0;
	
	Для каждого Регион Из СписокРегионов Цикл
		ЭлементРегион = ЭлементыРегион.Добавить();
		ЭлементРегион.ЗначениеГеографическогоРегиона = Регион.Значение;
		ЭлементРегион.НазваниеГеографическогоРегиона = Регион.Представление;
		Если ЗначениеТекущегоРегиона <> Неопределено
			И Регион.Значение = ЗначениеТекущегоРегиона Тогда // запомним для дальнейшего позиционирования строки
			ИДСтроки = ЭлементРегион.ПолучитьИдентификатор();
		КонецЕсли;
		Если ВыбиратьГорода Тогда
			ЭлементыГород = ЭлементРегион.ПолучитьЭлементы();
			СписокГородов = СоответствиеРегионовГородам.Получить(Регион.ПолучитьИдентификатор());
			Для каждого Город Из СписокГородов Цикл
				ЭлементГород = ЭлементыГород.Добавить();
				ЭлементГород.ЗначениеГеографическогоРегиона = Город.Значение;
				ЭлементГород.НазваниеГеографическогоРегиона = Город.Представление;
				Если ЗначениеТекущегоРегиона <> Неопределено
					И Город.Значение = ЗначениеТекущегоРегиона Тогда // запомним для дальнейшего позиционирования строки
					ИДСтроки = ЭлементГород.ПолучитьИдентификатор();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ГеографическиеРегионы.ТекущаяСтрока = ИДСтроки;
	
КонецПроцедуры

#КонецОбласти