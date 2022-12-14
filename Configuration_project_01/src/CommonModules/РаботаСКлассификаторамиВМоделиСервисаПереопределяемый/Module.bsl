
////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.РаботаВМоделиСервиса.РаботаСКлассификаторами".
// ОбщийМодуль.РаботаСКлассификаторамиВМоделиСервисаПереопределяемый.
//
// Серверные переопределяемые процедуры загрузки классификаторов:
//  - определение алгоритмов обработки областей данных;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяются алгоритмы обработки области после загрузки поставляемых данных
// классификаторов.
//
// Параметры:
//  Идентификатор           - Строка - идентификатор классификатора в сервисе классификаторов.
//                            Определяется в процедуре ПриДобавленииКлассификаторов;
//  Версия                  - Число - номер загруженной версии;
//  ДополнительныеПараметры - Структура - содержит дополнительные параметры обработки,
//                            которые были заполнены в переопределяемом методе
//                            РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора.
//
// Пример:
//	Если Идентификатор = "CentralBankRefinancingRate" Тогда
//		Документы.КомпенсацияЗаЗадержкуЗарплаты.ПерерасчетКомпенсацияЗаЗадержкуЗарплаты();
//	КонецЕсли;
//
Процедура ПриОбработкеОбластиДанных(Идентификатор, Версия, ДополнительныеПараметры) Экспорт
	
	
КонецПроцедуры

#КонецОбласти
