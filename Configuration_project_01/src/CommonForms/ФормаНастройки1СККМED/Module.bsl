
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", ПодключаемоеОборудование);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(ПодключаемоеОборудование);
	
	времКаталогОбмена = Неопределено;
	времИмяФайлаВыгрузки = Неопределено;
	времИмяФайлаЗагрузки = Неопределено;
	
	
	Параметры.ПараметрыОборудования.Свойство("КаталогОбмена", времКаталогОбмена);
	Параметры.ПараметрыОборудования.Свойство("ИмяФайлаВыгрузки", времИмяФайлаВыгрузки);
	Параметры.ПараметрыОборудования.Свойство("ИмяФайлаЗагрузки", времИмяФайлаЗагрузки);
	
	КаталогОбмена = 	?(времКаталогОбмена = Неопределено, "", времКаталогОбмена);
	ИмяФайлаВыгрузки = 	?(времИмяФайлаВыгрузки = Неопределено, "ExportData", времИмяФайлаВыгрузки);
	ИмяФайлаЗагрузки = 	?(времИмяФайлаЗагрузки = Неопределено, "ImportData", времИмяФайлаЗагрузки);
	
	ВидОбмена = Перечисления.ВидыТранспортаОфлайнОбмена.FILE
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриОткрытии(ЭтотОбъект, ПодключаемоеОборудование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаталогОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("КаталогОбменаНачалоВыбораЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыборФайла(Оповещение, КаталогОбмена, "ВыборКаталога");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("ВидТранспортаОфлайнОбмена", ВидОбмена);
	
	НовыеЗначениеПараметров.Вставить("КаталогОбмена", 		КаталогОбмена);
	НовыеЗначениеПараметров.Вставить("ИмяФайлаЗагрузки", 	ИмяФайлаЗагрузки);
	НовыеЗначениеПараметров.Вставить("ИмяФайлаВыгрузки", 	ИмяФайлаВыгрузки);
			
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", ПодключаемоеОборудование);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриСохраненииПараметров(
		ЭтотОбъект,
		ПодключаемоеОборудование,
		НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	
	времПараметрыУстройства = Новый Структура;
	времПараметрыУстройства.Вставить("ВидОбмена", ВидОбмена);
	времПараметрыУстройства.Вставить("ИдентификаторУстройства", ПодключаемоеОборудование);
	
	Если ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.FILE") Тогда
		
		времПараметрыУстройства.Вставить("КаталогОбмена", 		КаталогОбмена);
		времПараметрыУстройства.Вставить("ИмяФайлаЗагрузки", 	ИмяФайлаЗагрузки);
		времПараметрыУстройства.Вставить("ИмяФайлаВыгрузки", 	ИмяФайлаВыгрузки);
			
	КонецЕсли;
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду(
		"ТестУстройства",
		ВходныеПараметры,
		ВыходныеПараметры,
		ПодключаемоеОборудование,
		времПараметрыУстройства);
	
	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		И ВыходныеПараметры.Количество() >= 2,
		НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1], "");
	
	Если Результат Тогда
		
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%'");
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС));
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС));
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КаталогОбменаНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		КаталогОбмена = Результат[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНепроверяемыеРеквизитыИзМассива(МассивРеквизитов, МассивНепроверяемыхРеквизитов)
	
	Для Каждого ЭлементМассива Из МассивНепроверяемыхРеквизитов Цикл
	
		ПорядковыйНомер = МассивРеквизитов.Найти(ЭлементМассива);
		Если ПорядковыйНомер <> Неопределено Тогда
			МассивРеквизитов.Удалить(ПорядковыйНомер);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти