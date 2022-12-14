#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает складскую группу, если она одна в справочнике.
//
// Возвращаемое значение:
//	СправочникСсылка.СкладскиеГруппыНоменклатуры - найденная складская группа.
//
Функция СкладскаяГруппаНоменклатурыПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	СкладскиеГруппыНоменклатуры.Ссылка КАК СкладскаяГруппаНоменклатуры
	|ИЗ
	|	Справочник.СкладскиеГруппыНоменклатуры КАК СкладскиеГруппыНоменклатуры
	|ГДЕ
	|	НЕ СкладскиеГруппыНоменклатуры.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		СкладскаяГруппаНоменклатуры = Выборка.СкладскаяГруппаНоменклатуры;
	Иначе
		СкладскаяГруппаНоменклатуры = Справочники.СкладскиеГруппыНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Возврат СкладскаяГруппаНоменклатуры;

КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	
	Результат.Добавить("ФизическиРазличаетсяОтНазначения; ФизическиРазличаетсяОтНазначенияСтрока, ФизическиНеРазличаетсяОтНазначенияСтрока");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	НоменклатураВызовСервера.СкладскиеГруппыНоменклатурыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

