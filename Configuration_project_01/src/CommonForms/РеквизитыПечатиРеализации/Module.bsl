
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,,"ЗакрыватьПриВыборе,ЗакрыватьПриЗакрытииВладельца,КлючНазначенияИспользования, ТаблицаОснованийДляПечати");
	
	Если ТолькоПросмотр Тогда
		
		СтруктураПараметров = ИзменяемыеРеквизиты(Параметры);
		МассивЭлементов = Новый Массив();
		
		Для Каждого ЭлементСтруктуры Из СтруктураПараметров Цикл
			МассивЭлементов.Добавить(ЭлементСтруктуры.Ключ);
		КонецЦикла;
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Истина);
		
	КонецЕсли;
	
	Если Параметры.НеПоказыватьРеквизиты <> Неопределено Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, Параметры.НеПоказыватьРеквизиты, "Видимость", Ложь);
	КонецЕсли;
	
	Если Параметры.ТипОбъекта = "ВозвратТоваровМеждуОрганизациями"
		Или Параметры.ТипОбъекта = "ПередачаТоваровМеждуОрганизациями" Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "БанковскийСчетОрганизацииПолучателя", "Видимость", Параметры.РасчетыЧерезОрганизацию);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "БанковскийСчетКонтрагента", "Видимость", Не Параметры.РасчетыЧерезОрганизацию);
	Иначе
		Если ЗначениеЗаполнено(Параметры.ТаблицаОснованийДляПечати) Тогда 
			ТаблицаОснованийДляПечати.Загрузить(Параметры.ТаблицаОснованийДляПечати.Выгрузить());
		КонецЕсли;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой")
		И Не РеализацияПоЗаказам
		И (Параметры.ТипОбъекта = "РеализацияТоваровУслуг"
			)
		Или Параметры.ТипОбъекта = "ВозвратТоваровПоставщику"
		Или Параметры.ТипОбъекта = "ВыкупВозвратнойТарыКлиентом" Тогда
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АдресДоставки", "Видимость", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияОтступПечатьЛево", "Видимость", Ложь);
		
	КонецЕсли;
	
	Если Параметры.ТипОбъекта = "АктВыполненныхРабот" Тогда
		Заголовок = НСтр("ru = 'Реквизиты печати УПД'");
		
		Элементы.Грузополучатель.Видимость = Ложь;
		Элементы.БанковскийСчетГрузополучателя.Видимость = Ложь;
		Элементы.АдресДоставки.Видимость = Ложь;
		Элементы.ДоверенностьНомер.Видимость = Ложь;
		Элементы.ДоверенностьДата.Видимость = Ложь;
		Элементы.ДоверенностьВыдана.Видимость = Ложь;
		Элементы.ДоверенностьЛицо.Видимость = Ложь;
		Элементы.Грузоотправитель.Видимость = Ложь;
		Элементы.БанковскийСчетГрузоотправителя.Видимость = Ложь;
		Элементы.Отпустил.Видимость = Ложь;
		Элементы.ОтпустилДолжность.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьСписокВыбораОснование();
	ПродажиСервер.ЗаполнитьСписокВыбораАдреса(Элементы.АдресДоставки, Партнер);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗакрытьФормуПринудительно Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не СохранитьПараметры Тогда
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Реквизиты печати реализации товаров и услуг были изменены. Закрыть без сохранения реквизитов?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "НеЗакрывать" Тогда
		СохранитьПараметры = Ложь;
	ИначеЕсли ОтветНаВопрос = "Закрыть" Тогда
		ЗакрытьФормуПринудительно = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если СохранитьПараметры Тогда
		
		СтруктураПараметров = ИзменяемыеРеквизиты(ЭтаФорма);
		ОповеститьОВыборе(СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОснованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОбъектОснование) Тогда
		ОснованиеИзменено = (СокрЛП(Основание) <> СокрЛП(ОбъектОснование));
	Иначе
		ОснованиеИзменено = Ложь;
	КонецЕсли;
	ОбъектОснование = Основание;
	
	ВыбранныеОснования = ТаблицаОснованийДляПечати.НайтиСтроки(Новый Структура("Основание", СокрЛП(Основание)));
	Если ВыбранныеОснования.Количество() > 0 Тогда
		ВыбранноеОснование = ВыбранныеОснования.Получить(0);
		ОснованиеНомер = ВыбранноеОснование.ОснованиеНомер;
		ОснованиеДата  = ВыбранноеОснование.ОснованиеДата;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНомерПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ОбъектОснованиеНомер)Тогда
		ОснованиеИзменено = (СокрЛП(ОснованиеНомер) <> СокрЛП(ОбъектОснованиеНомер));
	Иначе
		ОснованиеИзменено = Ложь;
	КонецЕсли;
	ОбъектОснованиеНомер = ОснованиеНомер;
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеДатаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ОбъектОснованиеДата) Тогда
		ОснованиеИзменено = (СокрЛП(ОснованиеДата) <> СокрЛП(ОбъектОснованиеДата));
	Иначе
		ОснованиеИзменено = Ложь;
	КонецЕсли;
	ОбъектОснованиеДата = ОснованиеДата;
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Грузоотправитель) Тогда
		БанковскийСчетГрузоотправителя = ПолучитьБанковскийСчетКонтрагентаПоУмолчаниюСервер(Грузоотправитель);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Грузополучатель) Тогда
		БанковскийСчетГрузополучателя = ПолучитьБанковскийСчетКонтрагентаПоУмолчаниюСервер(Грузополучатель);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ТолькоПросмотр Тогда
		СохранитьПараметры = Истина;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Функция ИзменяемыеРеквизиты(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("АдресДоставки",                  Источник.АдресДоставки);
	СтруктураПараметров.Вставить("БанковскийСчетГрузоотправителя", Источник.БанковскийСчетГрузоотправителя);
	СтруктураПараметров.Вставить("БанковскийСчетГрузополучателя",  Источник.БанковскийСчетГрузополучателя);
	СтруктураПараметров.Вставить("БанковскийСчетКонтрагента",      Источник.БанковскийСчетКонтрагента);
	СтруктураПараметров.Вставить("БанковскийСчетОрганизацииПолучателя", Источник.БанковскийСчетОрганизацииПолучателя);
	СтруктураПараметров.Вставить("Грузоотправитель",               Источник.Грузоотправитель);
	СтруктураПараметров.Вставить("Грузополучатель",                Источник.Грузополучатель);
	СтруктураПараметров.Вставить("ДоверенностьВыдана",             Источник.ДоверенностьВыдана);
	СтруктураПараметров.Вставить("ДоверенностьДата",               Источник.ДоверенностьДата);
	СтруктураПараметров.Вставить("ДоверенностьЛицо",               Источник.ДоверенностьЛицо);
	СтруктураПараметров.Вставить("ДоверенностьНомер",              Источник.ДоверенностьНомер);
	СтруктураПараметров.Вставить("Основание",                      Источник.Основание);
	СтруктураПараметров.Вставить("ОснованиеДата",                  Источник.ОснованиеДата);
	СтруктураПараметров.Вставить("ОснованиеНомер",                 Источник.ОснованиеНомер);
	СтруктураПараметров.Вставить("Отпустил",                       Источник.Отпустил);
	СтруктураПараметров.Вставить("ОтпустилДолжность",              Источник.ОтпустилДолжность);
	СтруктураПараметров.Вставить("Руководитель",                   Источник.Руководитель);
	СтруктураПараметров.Вставить("ГлавныйБухгалтер",               Источник.ГлавныйБухгалтер);
	СтруктураПараметров.Вставить("БанковскийСчетОрганизации",      Источник.БанковскийСчетОрганизации);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьБанковскийСчетКонтрагентаПоУмолчаниюСервер(Контрагент)
	
	Возврат ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораОснование()
	
	Для Каждого СтрокаТаблицы Из ТаблицаОснованийДляПечати Цикл 
		Элементы.Основание.СписокВыбора.Добавить(СтрокаТаблицы.Основание);
		Если ЗначениеЗаполнено(СтрокаТаблицы.ОснованиеНомер) Тогда
			Элементы.ОснованиеНомер.СписокВыбора.Добавить(СтрокаТаблицы.ОснованиеНомер);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТаблицы.ОснованиеДата) Тогда
			Элементы.ОснованиеДата.СписокВыбора.Добавить(СтрокаТаблицы.ОснованиеДата,Формат(СтрокаТаблицы.ОснованиеДата,"ДЛФ=D"));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
