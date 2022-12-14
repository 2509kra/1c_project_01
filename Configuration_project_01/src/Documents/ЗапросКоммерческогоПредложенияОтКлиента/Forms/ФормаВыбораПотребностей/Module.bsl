
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	НастроитьЭлементыФормы();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДокументОснование", Параметры.ДокументОснование, Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "УжеДобавленныеСтроки", Параметры.УжеДобавленныеСтроки, Истина);
	
	УстановитьОтборУжеДобавлено(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьУжеДобавленныеПриИзменении(Элемент)
	
	УстановитьОтборУжеДобавлено(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	МассивИдентификаторовВыбранныхСтрок = Новый Массив;
	
	Для Каждого ВыбраннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл 
		
		МассивИдентификаторовВыбранныхСтрок.Добавить(Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока).ИдентификаторСтрокиЗапроса);
		
	КонецЦикла;
	
	Закрыть(МассивИдентификаторовВыбранныхСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЭлементыФормы()

	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(НСтр("ru = 'Выбор потребностей из'"));
	МассивСтрок.Добавить(" ");
	
	РеквизитыДокументаОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ДокументОснование, 
	                                                                         "Номер, Дата, ВариантУказанияСрокаПоставки");
	
	ПредставлениеЗапросаКП = СтрШаблон(НСтр("ru = 'Запроса № %1 от %2'"),
		РеквизитыДокументаОснования.Номер,
		РеквизитыДокументаОснования.Дата);
	
	ПредставлениеЗапросаКП = Новый ФорматированнаяСтрока(ПредставлениеЗапросаКП,,,,ПолучитьНавигационнуюСсылку(Параметры.ДокументОснование));
	
	МассивСтрок.Добавить(ПредставлениеЗапросаКП);
	
	Элементы.ДокументОснованиеПредставление.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
	
	Если РеквизитыДокументаОснования.ВариантУказанияСрокаПоставки = Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается Тогда
		
		Элементы.СрокПоставки.Видимость = Ложь;
		
	ИначеЕсли РеквизитыДокументаОснования.ВариантУказанияСрокаПоставки = Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяВДняхСМоментаЗаказа Тогда

		Элементы.СрокПоставки.Заголовок = НСтр("ru = 'Срок поставки (дн.)'");
		
	ИначеЕсли РеквизитыДокументаОснования.ВариантУказанияСрокаПоставки = Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяНаОпределеннуюДату Тогда
		
		Элементы.СрокПоставки.Заголовок = НСтр("ru = 'Поставить к дате'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	// Условное оформление динамического списка "Список"
	СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
#Область УжеДобавленнаяСтрока
	
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом уже подобранных строк.'");
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("НомерСтрокиЗапроса");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("НоменклатураПокупателя");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЗапросКоличество");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЗапросЕдиницаИзмерения");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЗапросМаксимальнаяЦена");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЗапросСрокПоставки");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных("УжеДобавлено");
	ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение  = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	
#КонецОбласти

#Область СнятаСРассмотрения
	
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Зачеркивание снятых с рассмотрения строк.'");
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("НомерСтрокиЗапроса");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("НоменклатураПокупателя");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЗапросКоличество");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЗапросЕдиницаИзмерения");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЗапросМаксимальнаяЦена");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЗапросСрокПоставки");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных("СнятСРассмотрения");
	ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение  = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,,,,Истина));
	
#КонецОбласти
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборУжеДобавлено(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, "УжеДобавлено", Ложь, ВидСравненияКомпоновкиДанных.Равно,, Не Форма.ПоказыватьУжеДобавленные);
	
КонецПроцедуры

#КонецОбласти


