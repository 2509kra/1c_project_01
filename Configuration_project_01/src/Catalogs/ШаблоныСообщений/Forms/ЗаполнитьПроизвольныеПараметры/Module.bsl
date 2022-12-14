///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Предмет = Параметры.Предмет;
	ДобавитьЭлементыФормыПараметровШаблона(Параметры.Шаблон);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Результат = Новый Соответствие;
	
	Для Каждого ИмяРеквизита Из СписокРеквизитов Цикл
		Результат.Вставить(ИмяРеквизита.Значение, ЭтотОбъект[ИмяРеквизита.Значение])
	КонецЦикла;
	
	Закрыть(Результат);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьЭлементыФормыПараметровШаблона(Шаблон)
	
	ДобавляемыеРеквизиты = Новый Массив;
	Если Шаблон.ШаблонПоВнешнейОбработке Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
			ВнешнийОбъект = МодульДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(Шаблон.ВнешняяОбработка);
			ПараметрыШаблона = ВнешнийОбъект.ПараметрыШаблона();
			
			ТаблицаПараметрыШаблона = Новый ТаблицаЗначений;
			ТаблицаПараметрыШаблона.Колонки.Добавить("Имя"                , Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));
			ТаблицаПараметрыШаблона.Колонки.Добавить("Тип"                , Новый ОписаниеТипов("ОписаниеТипов"));
			ТаблицаПараметрыШаблона.Колонки.Добавить("Представление"      , Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
			
			Для каждого ПараметрШаблона Из ПараметрыШаблона Цикл
				ОписаниеТипа = ПараметрШаблона.ОписаниеТипа.Типы();
				Если ОписаниеТипа.Количество() > 0 Тогда
					Если ОписаниеТипа[0] <> ТипЗнч(Предмет) Тогда
						НовыйПараметр = ТаблицаПараметрыШаблона.Добавить();
						НовыйПараметр.Имя = ПараметрШаблона.ИмяПараметра;
						НовыйПараметр.Представление = ПараметрШаблона.ПредставлениеПараметра;
						НовыйПараметр.Тип = ПараметрШаблона.ОписаниеТипа;
						ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ПараметрШаблона.ИмяПараметра, ПараметрШаблона.ОписаниеТипа,, ПараметрШаблона.ПредставлениеПараметра));
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШаблоныСообщенийПараметры.Ссылка,
		|	ШаблоныСообщенийПараметры.ИмяПараметра КАК Имя,
		|	ШаблоныСообщенийПараметры.ТипПараметра КАК Тип,
		|	ШаблоныСообщенийПараметры.ПредставлениеПараметра КАК Представление
		|ИЗ
		|	Справочник.ШаблоныСообщений.Параметры КАК ШаблоныСообщенийПараметры
		|ГДЕ
		|	ШаблоныСообщенийПараметры.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Шаблон);
		
		ТаблицаПараметрыШаблона = Запрос.Выполнить().Выгрузить();
		
		Для каждого Реквизит Из ТаблицаПараметрыШаблона Цикл
			
			ОписаниеТипаПараметра = ОбщегоНазначения.ОписаниеТипаСтрока(250);
			Если ТипЗнч(Реквизит.Тип) = Тип("ХранилищеЗначения") Тогда
				ТипПараметраЗначение = Реквизит.Тип.Получить();
				Если ТипЗнч(ТипПараметраЗначение) = Тип("ОписаниеТипов") Тогда
					ОписаниеТипаПараметра = ТипПараметраЗначение;
				КонецЕсли;
			КонецЕсли;
			
			ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(Реквизит.Имя, ОписаниеТипаПараметра,, Реквизит.Представление));
		КонецЦикла;
	КонецЕсли;
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Для Каждого ПараметрШаблона Из ТаблицаПараметрыШаблона Цикл
		Элемент = Элементы.Добавить(ПараметрШаблона.Имя, Тип("ПолеФормы"), Элементы.ПараметрыШаблона);
		Элемент.Вид                        = ВидПоляФормы.ПолеВвода;
		Элемент.ПоложениеЗаголовка         = ПоложениеЗаголовкаЭлементаФормы.Лево;
		Элемент.Заголовок                  = ПараметрШаблона.Представление;
		Элемент.ПутьКДанным                = ПараметрШаблона.Имя;
		Элемент.РастягиватьПоГоризонтали   = Ложь;
		Элемент.Ширина = 50;
		СписокРеквизитов.Добавить(ПараметрШаблона.Имя);
	КонецЦикла;
	
	ЭтотОбъект.Высота = 3 + ТаблицаПараметрыШаблона.Количество() * 2;
	
КонецПроцедуры

#КонецОбласти

