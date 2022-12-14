#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПовторныйЗапуск") Тогда
		Заголовок = НСтр("ru = 'Повторный запуск согласования'");
		Элементы.ГруппаПредупреждение.ТекущаяСтраница = Элементы.ГруппаПредупреждениеПовторныйЗапуск;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetApprovalSheetRequest");
	Запрос.object = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, Параметры.Предмет.type);
	Запрос.object.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, 
		Параметры.Предмет.id, Параметры.Предмет.type);
	Запрос.object.name = Параметры.Предмет.name;
	Ответ = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Для каждого Пункт из Ответ.items Цикл
		Если Пункт.result = "Согласовано" Тогда
			СтрокаЛиста = ЛистСогласования.Добавить();
			СтрокаЛиста.ФИО = Пункт.name;
			СтрокаЛиста.Должность = Пункт.position;
			СтрокаЛиста.Дата = Пункт.date;
			СтрокаЛиста.Результат = Пункт.result;
			СтрокаЛиста.Примечание = Пункт.comment;
		КонецЕсли;
	КонецЦикла;
	
	Если ЛистСогласования.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЛистСогласования.Сортировать("Дата, ФИО");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПрервать(Команда)
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти