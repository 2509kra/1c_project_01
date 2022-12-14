#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТекстЗаполнить = НСтр("ru = 'Заполнить'");

	Режим = Параметры.Режим;

	Если Режим = "МинимальныйОстаток" Тогда

		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОстаток;
		Заголовок = НСтр("ru = 'Заполнение минимального остатка'");
		Элементы.ПереключательОстаток.СписокВыбора.Добавить(0, НСтр("ru = 'Минимальный остаток:'"));
		Элементы.Команда.Заголовок = ТекстЗаполнить;
		Переключить(0);

	ИначеЕсли Режим = "МаксимальныйОстаток" Тогда

		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОстаток;
		Заголовок = НСтр("ru = 'Заполнение максимального остатка'");
		Элементы.ПереключательОстаток.СписокВыбора.Добавить(0, НСтр("ru = 'Максимальный остаток:'"));
		Элементы.Команда.Заголовок = ТекстЗаполнить;
		Элементы.Подсказка.Заголовок = СтрЗаменить(Элементы.Подсказка.Заголовок,
			НСтр("ru = 'Минимальный'"), НСтр("ru = 'Максимальный'"));
		Переключить(0);

	ИначеЕсли Режим = "ПериодПродаж" Тогда

		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПериодПродаж;
		Заголовок = НСтр("ru = 'Установка периода расчета продаж'");

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПереключательПриИзменении(Элемент)

	Переключить(0);

КонецПроцедуры

&НаКлиенте
Процедура Переключатель1ПриИзменении(Элемент)

	Переключить(1);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Переключить(Индекс)

	Переключатель = Индекс;
	Элементы.Остаток.Доступность        = Переключатель = 0;

	Если Не Элементы.Остаток.Доступность Тогда
		Остаток = 0;
	Иначе
		КоличествоДней = 0;
	КонецЕсли;

	Элементы.КоличествоДней.Доступность = Переключатель = 1;
	Элементы.Подсказка.Доступность     = Переключатель = 1;
	Элементы.Команда.Заголовок = ?(Переключатель = 0, НСтр("ru = 'Заполнить'"), НСтр("ru = 'Рассчитать и заполнить'"));

КонецПроцедуры

&НаКлиенте
Процедура Команда(Команда)

	Результат = Новый Структура("Режим", Параметры.Режим);

	Если Параметры.Режим = "МинимальныйОстаток" Или Параметры.Режим = "МаксимальныйОстаток" Тогда

		Результат.Вставить("Рассчитывать", Переключатель = 1);
		Результат.Вставить("Значение",     ?(Переключатель = 0, Остаток, КоличествоДней));

	ИначеЕсли Параметры.Режим = "ПериодПродаж" Тогда

	КонецЕсли;

	ОповеститьОВыборе(Результат);

КонецПроцедуры

#КонецОбласти
