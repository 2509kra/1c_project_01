///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В данной процедуре следует описать дополнительные зависимости объектов метаданных
//   конфигурации, которые будут использоваться для связи настроек отчетов.
//
// Параметры:
//   СвязиОбъектовМетаданных - ТаблицаЗначений:
//       * ПодчиненныйРеквизит - Строка - имя реквизита подчиненного объекта метаданных.
//       * ПодчиненныйТип      - Тип    - тип подчиненного объекта метаданных.
//       * ВедущийТип          - Тип    - тип ведущего объекта метаданных.
//
Процедура ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных) Экспорт
	//++ НЕ ГОСИС
	ОтчетыУТПереопределяемый.ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных);
	//-- НЕ ГОСИС
КонецПроцедуры

// Вызывается в форме отчета и в форме настройки отчета перед выводом настройки 
// для указания дополнительных параметров выбора.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//        - РасширениеУправляемойФормыДляОтчета
//        - Неопределено - форма отчета.
//  СвойстваНастройки - Структура - описание настройки отчета, которая будет выведена в форме отчета, где:
//      * ПолеКД - ПолеКомпоновкиДанных - выводимая настройка.
//      * ОписаниеТипов - ОписаниеТипов - тип выводимой настройки.
//      * ЗначенияДляВыбора - СписокЗначений - указать объекты, которые будут предложены пользователю в списке выбора.
//                            Дополняет список объектов, уже выбранных пользователем ранее.
//                            При этом не следует присваивать в этот параметр новый список значений.
//      * ЗапросЗначенийВыбора - Запрос - указать запрос для выборки объектов, которыми необходимо дополнить 
//                               ЗначенияДляВыбора. Первой колонкой (с индексом 0) должен выбираться объект,
//                               который следует добавить в ЗначенияДляВыбора.Значение.
//                               Для отключения автозаполнения в свойство ЗапросЗначенийВыбора.Текст следует записать
//                               пустую строку.
//      * ОграничиватьВыборУказаннымиЗначениями - Булево - указать Истина, чтобы ограничить выбор пользователя
//                                                значениями, указанными в ЗначенияДляВыбора (его конечным состоянием).
//      * Тип - см. ОтчетыСервер.ТипНастройкиСтрокой.
//
// Пример:
//   1. Для всех настроек типа СправочникСсылка.Пользователи скрыть и не разрешать выбирать помеченных на удаление, 
//   недействительных и служебных пользователей.
//
//   Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Пользователи")) Тогда
//     СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
//     СвойстваНастройки.ЗначенияДляВыбора.Очистить();
//     СвойстваНастройки.ЗапросЗначенийВыбора.Текст =
//       "ВЫБРАТЬ Ссылка ИЗ Справочник.Пользователи
//       |ГДЕ НЕ ПометкаУдаления И НЕ Недействителен И НЕ Служебный";
//   КонецЕсли;
//
//   2. Для настройки "Размер" предусмотреть дополнительное значение для выбора.
//
//   Если СвойстваНастройки.ПолеКД = Новый ПолеКомпоновкиДанных("ПараметрыДанных.Размер") Тогда
//     СвойстваНастройки.ЗначенияДляВыбора.Добавить(10000000, НСтр("ru = 'Больше 10 Мб'"));
//   КонецЕсли;
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	//++ НЕ ГОСИС
	ОтчетыУТПереопределяемый.ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки);
	//-- НЕ ГОСИС
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике и ОтчетыКлиентПереопределяемый.ОбработчикКоманды.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   Отказ - Булево - признак отказа от создания формы.
//   СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
// Пример:
//	//Добавление команды с обработчиком в ОтчетыКлиентПереопределяемый.ОбработчикКоманды:
//	Команда = ФормаОтчета.Команды.Добавить("МояОсобеннаяКоманда");
//	Команда.Действие  = "Подключаемый_Команда";
//	Команда.Заголовок = НСтр("ru = 'Моя команда...'");
//	
//	Кнопка = ФормаОтчета.Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), ФормаОтчета.Элементы.<ИмяПодменю>);
//	Кнопка.ИмяКоманды = Команда.Имя;
//	
//	ФормаОтчета.ПостоянныеКоманды.Добавить(КомандаСоздать.Имя);
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	//++ НЕ ГОСИС
	ОтчетыУТПереопределяемый.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	//-- НЕ ГОСИС
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета и формы настройки отчета.
// См. "Расширение управляемой формы для отчета.ПередЗагрузкойВариантаНаСервере" в синтакс-помощнике.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета или настроек отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - настройки для загрузки в компоновщик настроек.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	//++ НЕ ГОСИС
	ОтчетыУТПереопределяемый.ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД);
	//-- НЕ ГОСИС
КонецПроцедуры

#КонецОбласти
