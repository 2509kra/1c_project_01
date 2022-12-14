#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
	
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиРМК.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НастройкиРМК КАК НастройкиРМК
		|ГДЕ
		|	НастройкиРМК.Ссылка <> &Ссылка
		|	И НастройкиРМК.РабочееМесто = &РабочееМесто");
		
		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
		
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для рабочего места %1 уже существует настройка РМК %2'"), РабочееМесто, Выборка.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				,
				,
				Отказ);
		
		КонецЕсли;
	
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из КассыККМ Цикл
		Если Не СтрокаТЧ.ИспользоватьБезПодключенияОборудования
			И Не ЗначениеЗаполнено(СтрокаТЧ.ПодключаемоеОборудование) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнено поле ""Оборудование""'");
			АдресОшибки = НСтр("ru='в строке %НомерСтроки% списка ""КассыККМ""'");
			АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", СтрокаТЧ.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + " " + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("КассыККМ", СтрокаТЧ.НомерСтроки, "ПодключаемоеОборудование"),
				,
				Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из ЭквайринговыеТерминалы Цикл
		Если Не СтрокаТЧ.ИспользоватьБезПодключенияОборудования
			И Не ЗначениеЗаполнено(СтрокаТЧ.ПодключаемоеОборудование) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнено поле ""Оборудование""'");
			АдресОшибки = НСтр("ru='в строке %НомерСтроки% списка ""Эквайринговые терминалы""'");
			АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", СтрокаТЧ.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + " " + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭквайринговыеТерминалы", СтрокаТЧ.НомерСтроки, "ПодключаемоеОборудование"),
				,
				Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
	КлючевыеРеквизитыТабличнойЧастиКассыККМ = Новый Массив;
	КлючевыеРеквизитыТабличнойЧастиКассыККМ.Добавить("КассаККМ");
	КлючевыеРеквизитыТабличнойЧастиКассыККМ.Добавить("ИспользоватьБезПодключенияОборудования");
	КлючевыеРеквизитыТабличнойЧастиКассыККМ.Добавить("ПодключаемоеОборудование");
	ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(
		ЭтотОбъект,
		"КассыККМ",
		КлючевыеРеквизитыТабличнойЧастиКассыККМ,
		Отказ,,
		Ложь);
		
	
	ОбщегоНазначенияУТКлиентСервер.ПроверитьНаличиеДублейЗначенийМассива(
		ЭтотОбъект["КассыККМ"].ВыгрузитьКолонку("ПодключаемоеОборудование"),
		Отказ,
		"Кассы ККМ",
		"Оборудование",
		Истина);
		
	
	КлючевыеРеквизитыТабличнойЧастиКассы = Новый Массив;
	КлючевыеРеквизитыТабличнойЧастиКассы.Добавить("Касса");
	ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(
		ЭтотОбъект,
		"Кассы",
		КлючевыеРеквизитыТабличнойЧастиКассы,
		Отказ,,
		Ложь);
		
	КлючевыеРеквизитыТабличнойЧастиКассы = Новый Массив;
	КлючевыеРеквизитыТабличнойЧастиКассы.Добавить("ПодключаемоеОборудование");
	ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(
		ЭтотОбъект,
		"Кассы",
		КлючевыеРеквизитыТабличнойЧастиКассы,
		Отказ,,
		Ложь);
	
	КлючевыеРеквизитыТабличнойЧастиЭквайринговыеТерминалы = Новый Массив;
	КлючевыеРеквизитыТабличнойЧастиЭквайринговыеТерминалы.Добавить("ЭквайринговыйТерминал");
	ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(
		ЭтотОбъект,
		"ЭквайринговыеТерминалы",
		КлючевыеРеквизитыТабличнойЧастиЭквайринговыеТерминалы,
		Отказ,,
		Ложь);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("КассыККМ.ПодключаемоеОборудование");
	МассивНепроверяемыхРеквизитов.Добавить("ЭквайринговыеТерминалы.ПодключаемоеОборудование");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Наименование = Строка(ЭтотОбъект.РабочееМесто);
КонецПроцедуры

#КонецОбласти

#КонецЕсли