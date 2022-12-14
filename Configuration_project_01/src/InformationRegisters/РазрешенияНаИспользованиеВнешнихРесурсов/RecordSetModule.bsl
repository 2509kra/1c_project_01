///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// ОбменДанными.Загрузка не требуется.
	// Запись служебных данных в безопасном режиме запрещена.
	РаботаВБезопасномРежимеСлужебный.ПриЗаписиСлужебныхДанных(ЭтотОбъект);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		ПрограммныйМодуль = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
			Запись.ТипПрограммногоМодуля, Запись.ИдентификаторПрограммногоМодуля);
		Запись.ПредставлениеПрограммногоМодуля = Строка(ПрограммныйМодуль);
		
		Владелец = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
			Запись.ТипВладельца, Запись.ИдентификаторВладельца);
		Запись.ПредставлениеВладельца = Строка(Владелец);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли