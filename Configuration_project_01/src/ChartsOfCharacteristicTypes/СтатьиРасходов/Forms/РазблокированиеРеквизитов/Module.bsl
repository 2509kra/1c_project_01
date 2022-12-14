
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РазрешитьРедактированиеВидаДетятельностиИВариантаРаспределенияРасходов = Истина;
	РазрешитьРедактированиеАналитикаРасходов = Истина;
	РазрешитьРедактированиеВариантРаздельногоУчетаНДС = Истина;
	РазрешитьРедактированиеНастроекРегламентированногоУчета = Истина;
	
	Если Параметры.ВидДеятельностиРасходов = Перечисления.ВидыДеятельностиРасходов.ПрочаяДеятельность
		И Параметры.СтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.КурсовыеРазницы Тогда
		ЗапретРазблокировкиВидаДеятельностиРасходов = Истина;
		Элементы.ОписаниеВариантРаспределенияРасходов.Заголовок = 
			НСтр("ru = 'Вариант распределения расходов не рекомендуется изменять, если есть проведенные документы отражения расходов, в которых указана данная статья.'");
		Элементы.РазрешитьРедактированиеВидаДеятельностиИВариантаРаспределенияРасходов.Заголовок = 
			НСтр("ru = 'Разрешить редактирование типа расходов и варианта распределения расходов'");
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Результат = РедактируемыеРеквизиты();
	Закрыть(Результат);

КонецПроцедуры

&НаСервере
Функция РедактируемыеРеквизиты()
	
	Результат = Новый Массив;
	Если РазрешитьРедактированиеВидаДеятельностиИВариантаРаспределенияРасходов Тогда
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ТипРасходов.Имя);
		Если НЕ ЗапретРазблокировкиВидаДеятельностиРасходов Тогда
			Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВидДеятельностиРасходов.Имя);
		КонецЕсли;
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВариантРаспределенияРасходовРегл.Имя);
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВариантРаспределенияРасходовУпр.Имя);
	КонецЕсли;
	Если РазрешитьРедактированиеАналитикаРасходов Тогда
		Результат.Добавить("ТипЗначения");
	КонецЕсли;
	Если РазрешитьРедактированиеВариантРаздельногоУчетаНДС Тогда
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВариантРаздельногоУчетаНДС.Имя);
	КонецЕсли;
	Если РазрешитьРедактированиеНастроекРегламентированногоУчета Тогда
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВидАктива.Имя);
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ПринятиеКНалоговомуУчету.Имя);
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВидРасходов.Имя);
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВидПрочихДоходовИРасходов.Имя);
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.КосвенныеЗатратыНУ.Имя);
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВидРБП.Имя);
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ПризнаватьРасходамиПриУСН.Имя);
		Результат.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Реквизиты.ВидДеятельностиДляНалоговогоУчетаЗатрат.Имя);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

#КонецОбласти
