///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив Из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("СпособУстановкиКурса");
	Результат.Добавить("Наценка");
	Результат.Добавить("ОсновнаяВалюта");
	Результат.Добавить("ФормулаРасчетаКурса");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	//++ НЕ ГОСИС
	Если Параметры.Свойство("ВалютаОснованияСчетаФактуры") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(ВалютаРегламентированногоУчета);
		
		Если ЗначениеЗаполнено(Параметры.ВалютаОснованияСчетаФактуры)
		 И Параметры.ВалютаОснованияСчетаФактуры <> ВалютаРегламентированногоУчета Тогда
			ДанныеВыбора.Добавить(Параметры.ВалютаОснованияСчетаФактуры);
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	//++ НЕ ГОСИС
	Если ВидФормы = "ФормаСписка" И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		
		Параметры.Вставить("Ключ", ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета());
		ВыбраннаяФорма = "ФормаЭлемента";
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодыВалют() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка,
	|	Валюты.Наименование КАК СимвольныйКод
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.СпособУстановкиКурса <> ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.НаценкаНаКурсДругойВалюты)
	|	И Валюты.СпособУстановкиКурса <> ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.РасчетПоФормуле)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

#КонецОбласти

#КонецЕсли