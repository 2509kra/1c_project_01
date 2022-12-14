#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем ТекстСообщения;
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("Контрагент");
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Заполнение",
			?(ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры,
				НСтр("ru = 'Покупатель'"),
				НСтр("ru = 'Поставщик'")),
			, , ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Контрагент", "Отчет", Отказ);
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли