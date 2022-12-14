///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список доступных значений для поля "ВидОбновления".
//
// Возвращаемое значение:
//   Массив из Строка - список доступных значений.
//
Функция ПолучитьЗначенияДопустимыхВидовОбновления() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Заполнение контрагентов на мониторинге");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли