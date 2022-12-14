
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Валюта = Параметры.Валюта;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Сумма) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не введена сумма выемки'"),,,"Сумма");
		Возврат;
	КонецЕсли;
	
	//А.М.А агентская инкасация
	//Закрыть(Сумма);
	Результат = Новый Структура;
	Результат.Вставить("Сумма", Сумма);
	Результат.Вставить("АгентскийПлатеж", АгентскийПлатеж);
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
