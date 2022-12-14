#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаУзлаПриСозданииНаСервере(ЭтаФорма, Ложь);
		
	Если Объект.ВыгружатьИнформативныеОстатки = 2 Тогда
		РежимОтправкиСкладов = "ИнформативныеОстаткиПоВыбранным";
	ИначеЕсли Объект.ВыгружатьИнформативныеОстатки = 1 Тогда
		РежимОтправкиСкладов = "ИнформативныеОстаткиПоВсемСкладам";
	Иначе
		РежимОтправкиСкладов = "БезИнформативныхОстатков";
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	УстановитьВидимостьНаСервере();
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Объект.ИспользоватьОтборПоОрганизациям
		И Объект.Организации.Количество() > 0 Тогда
		Объект.Организации.Очистить();
	КонецЕсли;
	
	Объект.ИспользоватьОтборПоОрганизациям = Не Объект.Организации.Количество() = 0;;
	
	Если Не Объект.ИспользоватьОтборПоВидамЦен
		И Объект.ВидыЦен.Количество() > 0 Тогда
		Объект.ВидыЦен.Очистить();
	КонецЕсли;
	
	Объект.ИспользоватьОтборПоВидамЦен = Не Объект.ВидыЦен.Количество() = 0;
	
	Если РежимОтправкиСкладов = "ИнформативныеОстаткиПоВыбранным"
		И Объект.ИнформативныеОстаткиПоСкладам.Количество() > 0 Тогда
		Объект.ВыгружатьИнформативныеОстатки = 2;
	Иначе
		
		Объект.ИнформативныеОстаткиПоСкладам.Очистить();
		
		Если РежимОтправкиСкладов = "ИнформативныеОстаткиПоВсемСкладам" Тогда
			Объект.ВыгружатьИнформативныеОстатки = 1;
		Иначе
			Объект.ВыгружатьИнформативныеОстатки = 0;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоВидамЦенПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИнформОстаткиНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИнформОстаткиОтправлятьВсеПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИнформОстаткиВыбранныеСкладыПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПодразделения(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВыбираемыйСправочник",     "СтруктураПредприятия");
	ПараметрыФормы.Вставить("ТаблицаЗаполнения",        "Подразделения");
	ПараметрыФормы.Вставить("КолонкаЗаполнения",        "Подразделение");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",     НСтр("ru = 'Подразделения, по которым будет происходить фильтрация данных'"));
	ПараметрыФормы.Вставить("ТаблицаВыбранныхЗначений", СформироватьТаблицуВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("РежимУпорядочивания",      "ИЕРАРХИЯ");
	
	ОткрытьФорму("ПланОбмена.СОтборами.Форма.ФормаВыбораЗначений",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОрганизации(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВыбираемыйСправочник",     "Организации");
	ПараметрыФормы.Вставить("ТаблицаЗаполнения",        "Организации");
	ПараметрыФормы.Вставить("КолонкаЗаполнения",        "Организация");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",     НСтр("ru = 'Отправлять данные по организациям'"));
	ПараметрыФормы.Вставить("ТаблицаВыбранныхЗначений", СформироватьТаблицуВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("РежимУпорядочивания",      "");
	
	ОткрытьФорму("ПланОбмена.СОтборами.Форма.ФормаВыбораЗначений",
		ПараметрыФормы,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВидыЦен(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВыбираемыйСправочник",     "ВидыЦен");
	ПараметрыФормы.Вставить("ТаблицаЗаполнения",        "ВидыЦен");
	ПараметрыФормы.Вставить("КолонкаЗаполнения",        "ВидЦены");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",     НСтр("ru = 'Отправлять информацию о ценах по видам цен'"));
	ПараметрыФормы.Вставить("ТаблицаВыбранныхЗначений", СформироватьТаблицуВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("РежимУпорядочивания",      "");
	
	ОткрытьФорму("ПланОбмена.СОтборами.Форма.ФормаВыбораЗначений",
		ПараметрыФормы,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСклады(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВыбираемыйСправочник",     "Склады");
	ПараметрыФормы.Вставить("ТаблицаЗаполнения",        "ИнформативныеОстаткиПоСкладам");
	ПараметрыФормы.Вставить("КолонкаЗаполнения",        "Склад");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",     НСтр("ru = 'Отправлять информативные остатки по складам'"));
	ПараметрыФормы.Вставить("ТаблицаВыбранныхЗначений", СформироватьТаблицуВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("РежимУпорядочивания",      "ИЕРАРХИЯ");
	
	ОткрытьФорму("ПланОбмена.СОтборами.Форма.ФормаВыбораЗначений",
		ПараметрыФормы,
		ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОткрытьФорму("ПланОбмена.СОтборами.Форма.РазблокированиеРеквизитов",,,,,, 
		Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВыбратьОрганизации",
		"Доступность",
		Объект.ИспользоватьОтборПоОрганизациям);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВыбратьВидыЦен",
		"Доступность",
		Объект.ИспользоватьОтборПоВидамЦен);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВыбратьСклады",
		"Доступность",
		РежимОтправкиСкладов = "ИнформативныеОстаткиПоВыбранным");
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаОтборПоОрганизациям",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций"));
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаОтборПоВидамЦен",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен"));
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаОтборПоИнформативнымОстаткам",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов"));
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаФильтры",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") 
		Или ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов"));
		
	Элементы.ГруппаОтборы.ОтображатьЗаголовок = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаВсеОтборы",
		"Доступность",
		ПланыОбмена.ГлавныйУзел() = Неопределено);
		
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = Объект[ПараметрыФормы.ТаблицаЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(,ПараметрыФормы.КолонкаЗаполнения);
	Возврат ПоместитьВоВременноеХранилище(ТаблицаВыбранныхЗначений, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ТаблицаЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.КолонкаЗаполнения;
		Объект[СтруктураПараметров.ТаблицаЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	//Обновим заголовок выбранных подразделений
	Если Объект.Подразделения.Количество() > 0 Тогда
		
		ВыбранныеПодразделения = Объект.Подразделения.Выгрузить();
		ВыбранныеПодразделения.Колонки.Подразделение.Имя = "Ссылка";
		НовыйЗаголовокПодразделений = СформироватьТекстовоеПредставлениеКоллекции(ВыбранныеПодразделения);
		
	Иначе
		
		НовыйЗаголовокПодразделений = НСтр("ru = 'Выбрать подразделения'");
		
	КонецЕсли;
	
	Элементы.ВыбратьПодразделения.Заголовок = НовыйЗаголовокПодразделений;
	
	//Обновим заголовок выбранных организаций
	Если Объект.Организации.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = Объект.Организации.Выгрузить();
		ВыбранныеОрганизации.Колонки.Организация.Имя = "Ссылка";
		НовыйЗаголовокОрганизаций = СформироватьТекстовоеПредставлениеКоллекции(ВыбранныеОрганизации);
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ВыбратьОрганизации.Заголовок = НовыйЗаголовокОрганизаций;
	
	//Обновим заголовок выбранных видов цен
	Если Объект.ВидыЦен.Количество() > 0 Тогда
		
		ВыбранныеВидыЦен = Объект.ВидыЦен.Выгрузить();
		ВыбранныеВидыЦен.Колонки.ВидЦены.Имя = "Ссылка";
		НовыйЗаголовокВидовЦен = СформироватьТекстовоеПредставлениеКоллекции(ВыбранныеВидыЦен);
		
	Иначе
		
		НовыйЗаголовокВидовЦен = НСтр("ru = 'Выбрать виды цен'");
		
	КонецЕсли;
	
	Элементы.ВыбратьВидыЦен.Заголовок = НовыйЗаголовокВидовЦен;
	
	//Обновим заголовок выбранных складов
	Если Объект.ИнформативныеОстаткиПоСкладам.Количество() > 0 Тогда
		
		ВыбранныеСклады = Объект.ИнформативныеОстаткиПоСкладам.Выгрузить();
		ВыбранныеСклады.Колонки.Склад.Имя = "Ссылка";
		НовыйЗаголовокСкладов = СформироватьТекстовоеПредставлениеКоллекции(ВыбранныеСклады);
		
	Иначе
		
		НовыйЗаголовокСкладов = НСтр("ru = 'Выбрать склады'");
		
	КонецЕсли;
	
	Элементы.ВыбратьСклады.Заголовок = НовыйЗаголовокСкладов;
	
КонецПроцедуры

&НаСервере
Функция СформироватьТекстовоеПредставлениеКоллекции(Коллекция)
	
	СтрокаПредставления = "";
	
	КоличествоВыводимыхЭлементов = Коллекция.Количество();
	
	Если КоличествоВыводимыхЭлементов = 0 Тогда
		
		Возврат "";
		
	Иначе
		
		Запрос = Новый Запрос("ВЫБРАТЬ
			|	ТаблицаВыбранныхЗначений.Ссылка КАК СсылкаНаОбъект
			|ПОМЕСТИТЬ ТаблицаВыбранныхЗначений
			|ИЗ
			|	&ТаблицаВыбранныхЗначений КАК ТаблицаВыбранныхЗначений
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	СсылкаНаОбъект
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаВыбранныхЗначений.СсылкаНаОбъект,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПодчиненныеЭлементы.Ссылка) КАК ЕстьПодчиненные
			|ИЗ
			|	ТаблицаВыбранныхЗначений КАК ТаблицаВыбранныхЗначений
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК ПодчиненныеЭлементы
			|		ПО (ПодчиненныеЭлементы.Родитель = ТаблицаВыбранныхЗначений.СсылкаНаОбъект)
			|
			|СГРУППИРОВАТЬ ПО
			|	ТаблицаВыбранныхЗначений.СсылкаНаОбъект");

		Запрос.УстановитьПараметр("ТаблицаВыбранныхЗначений", Коллекция);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
		
			ОбъектКоллекции = Выборка.СсылкаНаОбъект;
			
			СтрокаПредставления = СтрокаПредставления 
				+ ОбъектКоллекции 
				+ ?(Выборка.ЕстьПодчиненные > 0, НСтр("ru = ' (Включая подчиненные)'"), "")
				+ ", ";
			
		КонецЦикла;
		
		СтрокаПредставления = Лев(СтрокаПредставления, СтрДлина(СтрокаПредставления) - 2);
		
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

#КонецОбласти

#КонецОбласти