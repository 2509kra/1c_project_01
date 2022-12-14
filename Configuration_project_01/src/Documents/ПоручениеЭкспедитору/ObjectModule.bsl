#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Массив") Тогда
		Для Каждого Основание Из ДанныеЗаполнения Цикл
			Если ОбщегоНазначения.ЭтоДокумент(Основание.Метаданные()) Тогда
				НоваяСтрока = Основания.Добавить();
				НоваяСтрока.Основание = Основание;
			КонецЕсли;
		КонецЦикла;
		
		Если Основания.Количество() > 0 Тогда
			
			ДанныеОснований = Документы.ПоручениеЭкспедитору.ДанныеОснований(Основания.ВыгрузитьКолонку("Основание"));
			
			Если ДанныеОснований.Пункты.Количество() > 0 Тогда
				Пункт = ДанныеОснований.Пункты[0];
			КонецЕсли;
			Если ДанныеОснований.Склады.Количество() > 0 Тогда
				Склад = ДанныеОснований.Склады[0];
			Иначе
				Склад = Справочники.Склады.СкладПоУмолчанию();
			КонецЕсли;
			Если ДанныеОснований.Контакты.Количество() > 0 Тогда
				КонтактноеЛицо = ДанныеОснований.Контакты[0];
			КонецЕсли;
			Если ДанныеОснований.СпособыДоставки.Количество() = 1 Тогда
				СпособДоставки = ДанныеОснований.СпособыДоставки[0];
			КонецЕсли;
			
			Возврат;
		ИначеЕсли ДанныеЗаполнения.Количество() = 1 Тогда
			ДанныеЗаполнения = ДанныеЗаполнения[0];
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Склады") Тогда
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ЭтоГруппа") Тогда
			ВызватьИсключение НСтр("ru = 'Не предусмотрен ввод поручения экспедитору на основании группы складов.'");
		Иначе
			Пункт = ДанныеЗаполнения;
			Склад = ДанныеЗаполнения;
			СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуВПункте;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		Пункт = ДанныеЗаполнения;
		СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуВПункте;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Пункт)
		И Не ЗначениеЗаполнено(КонтактноеЛицо)
		И ТипЗнч(Пункт) = Тип("СправочникСсылка.Партнеры") Тогда
		ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Пункт, КонтактноеЛицо);
	КонецЕсли;		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверямыхРеквизитов = Новый Массив;
	Если СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуВПункте Тогда
		МассивНепроверямыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверямыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ, Истина);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуВПункте Тогда
		Склад = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаВыполнения) Тогда
		ДатаВыполнения = Дата;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли