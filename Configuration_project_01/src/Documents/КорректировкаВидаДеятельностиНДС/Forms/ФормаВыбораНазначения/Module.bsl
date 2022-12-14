#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	ИспользоватьУчетЗатратПоНаправлениямДеятельности = ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности");
	
	ТолькоЗаказыОрганизации = ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.ТолькоЗаказыОрганизации.Видимость = ТолькоЗаказыОрганизации;
	Элементы.ТолькоЗаказыОрганизации.Заголовок = СтрЗаменить(НСтр("ru = 'Только заказы организации ""%1""'"), "%1", Организация);
	
	Элементы.НаправлениеДеятельности.Видимость = ИспользоватьУчетЗатратПоНаправлениямДеятельности;
	Если ИспользоватьУчетЗатратПоНаправлениямДеятельности Тогда
		Заголовок = НСтр("ru = 'Выбор назначения'");
	Иначе
		Заголовок = НСтр("ru = 'Выбор заказа'");
	КонецЕсли;
	
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация,,, ТолькоЗаказыОрганизации);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПустаяОрганизация", НСтр("ru = '<не используется>'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПустойЗаказ",       НСтр("ru = '<по направлению в целом>'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПустоеНаправление", НСтр("ru = '<без указания направления>'"));
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТолькоЗаказыОрганизацииПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация,,, ТолькоЗаказыОрганизации);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьУсловноеОформление()
	
	// Цвет недоступного текста незаполненных ячеек.
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Заказ");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Организация");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БезЗаказа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НаправлениеДеятельности");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БезНаправленияДеятельности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
КонецПроцедуры

#КонецОбласти
