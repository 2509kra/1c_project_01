#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	ВидРасчетов = ?(Константы.ИспользоватьПартнеровКакКонтрагентов.Получить(), "контрагентами", "партнерами");
	НазваниеОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ведомость расчетов с %1'"),
				ВидРасчетов);
	
	Если Константы.НоваяАрхитектураВзаиморасчетов.Получить() Тогда
		Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВедомостьРасчетовСПартнерами) Тогда
			
			КомандаОтчет = КомандыОтчетов.Добавить();
			
			КомандаОтчет.Менеджер = Метаданные.Отчеты.ВедомостьРасчетовСПартнерами.ПолноеИмя();
			КомандаОтчет.Представление = НазваниеОтчета;
			
			КомандаОтчет.МножественныйВыбор = Истина;
			КомандаОтчет.Важность = "Обычное";
			
			Возврат КомандаОтчет;
			
		КонецЕсли;
	Иначе
		Если ПравоДоступа("Просмотр", Метаданные.Отчеты.РасчетыСПартнерами) Тогда
			
			КомандаОтчет = КомандыОтчетов.Добавить();
			
			КомандаОтчет.Менеджер = Метаданные.Отчеты.РасчетыСПартнерами.ПолноеИмя();
			КомандаОтчет.Представление = НазваниеОтчета;
			
			КомандаОтчет.МножественныйВыбор = Истина;
			КомандаОтчет.Важность = "Обычное";
			
			Возврат КомандаОтчет;
			
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли