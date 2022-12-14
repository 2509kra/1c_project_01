
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьСписокВыбораПравилФормированияДоговора();
	
	Если Объект.ИспользоватьОтборПоОрганизациям Тогда
		
		ПравилоОтбораСправочников = "Отбор";
		
	Иначе
		
		Если Объект.ВыгружатьУправленческуюОрганизацию Тогда
			ПравилоОтбораСправочников = "УпрОрганизация";
		Иначе
			ПравилоОтбораСправочников = "БезОтбора";
		КонецЕсли;
		
	КонецЕсли;
	
	//Инициализируем доступность ссылок установки дата запрета редактирования и даты запрета получения
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ГруппаДатаЗапретаРедактированияДанных");
	МассивЭлементов.Добавить("ГруппаУстановитьДатуЗапретаПолучения");

	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы,
		МассивЭлементов,
		"Видимость",
		Не ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
		
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("УстановитьДатуЗапретаПолученияДанных");
	МассивЭлементов.Добавить("УстановитьДатуЗапретаИзменений");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		МассивЭлементов,
		"Доступность",
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДатыЗапретаИзменения));
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекстПредупреждения = НСтр("ru = 'Изменены настройки узла ""%1""
		|Сохранить изменений?'");
	ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, Строка(Объект.Наименование));
	
	Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Записать();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациям(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагОтправлятьВидыЦенНоменклатуры(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагСворачиватьДокументыПоСкладуСВыключеннымиФОПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиПриИзменении(Элемент)
	
	Если Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" 
		И Объект.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		
		Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
		
	КонецЕсли;

	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаПриИзменении(Элемент)
	Объект.ПравилаОтправкиДокументов = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковСОтборомПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораСУпрПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораБезУпрПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	Если Не Объект.ВыгружатьУправленческуюОрганизацию
		И Не ПолучитьФункциональнуюОпциюИнтерфейса("ИспользоватьУправленческуюОрганизацию") Тогда
		
		КоллекцияФильтров = Новый Массив;
		
		Накладываемыефильтры = Новый Структура();
		Накладываемыефильтры.Вставить("РеквизитОтбора",    "Ссылка");
		Накладываемыефильтры.Вставить("Условие",           "<>");
		Накладываемыефильтры.Вставить("ИмяПараметра",      "ИсключаемаяСсылка");
		Накладываемыефильтры.Вставить("ЗначениеПараметра", 
			ПредопределенноеЗначение("Справочник.Организации.УправленческаяОрганизация"));
		
		КоллекцияФильтров.Добавить(Накладываемыефильтры);
		
	Иначе
		
		КоллекцияФильтров = Неопределено;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтправляемыхВидовЦенНоменклатуры(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "ВидыЦенНоменклатуры");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "ВидЦенНоменклатуры");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.ВидыЦен");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите виды цен для отправки:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      Неопределено);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	//Страница правила получения данных
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов") Тогда
		
		Элементы.ГруппаСтраницыСоздаватьПартнеровДляНовыхКонтрагентов.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаСоздаватьПартнеровДляНовыхКонтрагентов;
		
	Иначе
		
		Элементы.ГруппаСтраницыСоздаватьПартнеровДляНовыхКонтрагентов.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаСоздаватьПартнеровДляНовыхКонтрагентовПустая;
		
	КонецЕсли;
	
	//Страница правила отправки данных
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаНачалаВыгрузкиДокументов",
		"Доступность",
		Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПереключательДокументыНеОтправлять",
		"Доступность",
		Не Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОписаниеДокументыНеОтправлять",
		"Доступность",
		Не Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости");
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы.ГруппаДокументы.ПодчиненныеЭлементы,
		"ГруппаРежимОтправкиДокументов",
		"Доступность",
		Не Объект.ПравилаОтправкиСправочников = "НеСинхронизировать");
		
	//Видимость отбора по организациям
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаСтраницыОтборПоОрганизациям",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций"));
		
	Если Элементы.ГруппаСтраницыОтборПоОрганизациям.Видимость Тогда
		
		Если Объект.ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
			
			Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОтборПоОрганизациямПустая;
			
		Иначе
			
			Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОтборПоОрганизациям;
			
			Если Объект.ИспользоватьОтборПоОрганизациям Тогда
				
				Элементы.ГруппаСтраницыКомандаВыбораОрганизаций.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаКомандаВыбратьОрганизации;
				
			Иначе
				
				Элементы.ГруппаСтраницыКомандаВыбораОрганизаций.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаКомандаВыбратьОрганизацииПустая;
				
			КонецЕсли;
			
			//Видимость управленческой организации и вариантаотбора
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ГруппаВыборУправленческойОрганизации",
				"Видимость",
				ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию"));
			
			Если Элементы.ГруппаВыборУправленческойОрганизации.Видимость Тогда
				
				Элементы.ГруппаСтраницыВариантВыбораОтбора.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаПереключательОтбора;
				
			Иначе
				
				Элементы.ГруппаСтраницыВариантВыбораОтбора.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаФлагОтбора;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	//Видимость выгружаемых видов цен
	Если Объект.ПравилаОтправкиСправочников = "НеСинхронизировать"
		Или Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
		
		Элементы.ГруппаСтраницыОтправлятьВидыЦенНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьВидыЦенНоменклатурыПустая;
		
	Иначе
		
		Элементы.ГруппаСтраницыОтправлятьВидыЦенНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьВидыЦенНоменклатуры;
		
		Если Объект.ВыгружатьЦеныНоменклатуры 
			И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
			
			Элементы.ГруппаСтраницыКомандаВыбратьВидыЦен.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаКомандаВыбратьВидыЦен;
			
		Иначе
			
			Элементы.ГруппаСтраницыКомандаВыбратьВидыЦен.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаКомандаВыбратьВидыЦенПустая;
			
		КонецЕсли;
		
	КонецЕсли;
	
	//Видимость группы прочее
	Если Объект.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		
		Элементы.ГруппаСтраницыПравилаСозданияДоговоровКонтрагентов.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаПравилаСозданияДоговоровКонтрагентовПустая;
			
		Элементы.ГруппаСтраницыОбобщенныйСклад.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОбобщенныйСкладПустая;
		
	Иначе
		
		Элементы.ГруппаСтраницыПравилаСозданияДоговоровКонтрагентов.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаПравилаСозданияДоговоровКонтрагентов;
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПолеПравилаСозданияДоговоровКонтрагентов",
			"Доступность",
			Элементы.ПолеПравилаСозданияДоговоровКонтрагентов.СписокВыбора.Количество() > 1);
			
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
			
			Элементы.ГруппаСтраницыОбобщенныйСклад.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОбобщенныйСкладПустая;
			
		Иначе
			
			Элементы.ГруппаСтраницыОбобщенныйСклад.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОбобщенныйСклад;
			
			Если ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") 
				Или ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи") Тогда
				
				Элементы.СтраницыВариантовОтображенияОбощенногоСклада.ТекущаяСтраница = 
					Элементы.СтраницаВариантСВключеннымиФО;
				
			Иначе
				
				Элементы.СтраницыВариантовОтображенияОбощенногоСклада.ТекущаяСтраница = 
					Элементы.СтраницаВариантСВыключеннымиФО;
				
				ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы,
					"ПолеОбобщенныйСкладСВыключеннымиФО",
					"Доступность",
					Объект.СворачиватьДокументыПоСкладу);
					
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	
	//Видимость принципа отправки подразделений
	Если Объект.ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		Элементы.ГруппаСтраницыОтправлятьПодразделения.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьПодразделенияПустая;
			
	Иначе
		
		Элементы.ГруппаСтраницыОтправлятьПодразделения.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьПодразделения;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	//Обновим заголовок выбранных организаций
	Если Объект.Организации.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации, ",");
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
	//Обновим заголовок выбранных видов цен
	Если Объект.ВидыЦенНоменклатуры.Количество() > 0 Тогда
		
		ВыбранныеВидыЦен = Объект.ВидыЦенНоменклатуры.Выгрузить().ВыгрузитьКолонку("ВидЦенНоменклатуры");
		
		НовыйЗаголовокВидовЦен = СтрСоединить(ВыбранныеВидыЦен, ",");
		
	Иначе
		
		НовыйЗаголовокВидовЦен = НСтр("ru = 'Выбрать виды цен'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокОтправляемыхВидовЦенНоменклатуры.Заголовок = НовыйЗаголовокВидовЦен;
	
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = Объект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	МассивВыбранныхЗначений  = ТаблицаВыбранныхЗначений.ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Возврат МассивВыбранныхЗначений;
	
КонецФункции

&НаКлиенте
Процедура УстрановитьУсловияОрганиченияСинхронизации()
	
	Если ПравилоОтбораСправочников = "Отбор" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Истина;
		Объект.ВыгружатьУправленческуюОрганизацию = Ложь;
		
	ИначеЕсли ПравилоОтбораСправочников = "УпрОрганизация" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Ложь;
		Объект.ВыгружатьУправленческуюОрганизацию = Истина;
		
	ИначеЕсли ПравилоОтбораСправочников = "БезОтбора" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Ложь;
		Объект.ВыгружатьУправленческуюОрганизацию = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокВыбораПравилФормированияДоговора()
	
	// Сформируем список выбора для реквизита "ПравилаСозданияДоговоровКонтрагентов"
	СписокПравилФормированияДоговора = Элементы.ПолеПравилаСозданияДоговоровКонтрагентов.СписокВыбора;
	
	Если Не (ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") 
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам"))
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам") Тогда
		
		СписокПравилФормированияДоговора.Удалить(СписокПравилФормированияДоговора.НайтиПоЗначению("ПоЗаказам"));
		
		Если Объект.ПравилаСозданияДоговоровКонтрагентов = "ПоЗаказам" Тогда
			Объект.ПравилаСозданияДоговоровКонтрагентов = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСделкиСКлиентами") Тогда
		
		СписокПравилФормированияДоговора.Удалить(СписокПравилФормированияДоговора.НайтиПоЗначению("ПоСделкам"));
		
		Если Объект.ПравилаСозданияДоговоровКонтрагентов = "ПоСделкам" Тогда
			Объект.ПравилаСозданияДоговоровКонтрагентов = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		
		СписокПравилФормированияДоговора.Удалить(СписокПравилФормированияДоговора.НайтиПоЗначению("ПоПартнерам"));
		
		Если Объект.ПравилаСозданияДоговоровКонтрагентов = "ПоПартнерам" Тогда
			Объект.ПравилаСозданияДоговоровКонтрагентов = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Константы.ИспользованиеСоглашенийСКлиентами.Получить() = Перечисления.ИспользованиеСоглашенийСКлиентами.НеИспользовать Тогда
		
		СписокПравилФормированияДоговора.Удалить(СписокПравилФормированияДоговора.НайтиПоЗначению("ПоСоглашениям"));
		
		Если Объект.ПравилаСозданияДоговоровКонтрагентов = "ПоСоглашениям" Тогда
			Объект.ПравилаСозданияДоговоровКонтрагентов = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Если СписокПравилФормированияДоговора.Количество() = 1 Тогда
		Объект.ПравилаСозданияДоговоровКонтрагентов = СписокПравилФормированияДоговора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
