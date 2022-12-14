///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для подсистемы ПоставляемыеДанныеАбонентов
// общий модуль ПоставляемыеДанныеАбонентовПереопределяемый.
//

#Область ПрограммныйИнтерфейс

// Обработчик полученных данных области.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//  ПотокДанных - ФайловыйПоток - поток данных для обработки.
//  Обработчик  - Строка - идентификатор обработчика полученных данных.
//  ДанныеОбработаны - Булево - признак обработки данных. Устанавливается = Истина, если данные обработаны.
//                     Нельзя устанавливать значение = Ложь, т.к. признак = Истина может быть установлен ранее.
//  КодВозврата - Число - код возврата обработчика из значений РегистрыСведений.СвойстваЗаданий.КодыСостояний()
//  ОписаниеОшибки - Строка - описание ошибки обработки данных, если данные не обработаны.
//
Процедура ОбработатьПолученныеДанныеОбласти(ПотокДанных, Обработчик, ДанныеОбработаны, КодВозврата, ОписаниеОшибки) Экспорт
КонецПроцедуры

#КонецОбласти
