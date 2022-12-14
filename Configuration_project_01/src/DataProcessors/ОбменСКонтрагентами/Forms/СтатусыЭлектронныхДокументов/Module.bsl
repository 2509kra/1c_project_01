
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыОбъектовУчета = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ПараметрыОбъектовУчета");
	Если Не ЗначениеЗаполнено(ПараметрыОбъектовУчета) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	АдресДанных = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "АдресДанных", "");
	
	ЗаполнитьСтатусыВнутреннихДокументов(АдресДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		
		Если ТипЗнч(Параметр) = Тип("Структура")
			И Параметр.Свойство("ДокументыУчета")
			И ТипЗнч(Параметр.ДокументыУчета) = Тип("Массив")
			И Параметр.ДокументыУчета.Количество() > 0 Тогда
			
			ОбновитьСписок = Ложь;
			
			Для Каждого ПараметрыОбъектаУчета Из ПараметрыОбъектовУчета Цикл
				Если Параметр.ДокументыУчета.Найти(ПараметрыОбъектаУчета.Ссылка) <> Неопределено Тогда
					ОбновитьСписок = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ОбновитьСписок Тогда
				ОбновитьСтатусыВнутреннихДокументов();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСтатусыДокументов

&НаКлиенте
Процедура СтатусыДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СтатусыДокументовОжидаемоеДействие Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.ОжидаемоеДействие) Тогда
			ВыполнитьДействиеПоДокументам(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли Поле = Элементы.СтатусыДокументовПредставлениеДокумента Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.ЭлектронныйДокумент) Тогда
			ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ТекущиеДанные.ЭлектронныйДокумент);
		Иначе
			ОткрытьВнутреннийДокументОбъектаУчета(ТекущиеДанные);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСтатусыДокументов(Команда)
	
	ОбновитьСтатусыВнутреннихДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УсловноеОформление

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ОформлениеСтрокиСтатусыДокументов();
	
	ОформлениеПоляОжидаемоеДействие();
	
	ОформлениеПоляПредставлениеСостояния();
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеСтрокиСтатусыДокументов()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СтатусыДокументов");
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СтатусыДокументов.ЭтоГруппа");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеПоляОжидаемоеДействие()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусыДокументовОжидаемоеДействие.Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СтатусыДокументов.ОжидаемоеДействие");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеПоляПредставлениеСостояния()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусыДокументовПредставлениеСостояния.Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СтатусыДокументов.ОжидаемоеДействие");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьСтатусыВнутреннихДокументов(АдресДанных = "")
	
	СтатусыДокументов.ПолучитьЭлементы().Очистить();
	
	Если ЗначениеЗаполнено(АдресДанных) Тогда
		ТаблицаДокументов = ПолучитьИзВременногоХранилища(АдресДанных);
		УдалитьИзВременногоХранилища(АдресДанных);
	Иначе
		ТаблицаДокументов = ОбменСКонтрагентамиСлужебный.СтатусыЭлектронныхДокументовОбъектаУчета(ПараметрыОбъектовУчета);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТаблицаДокументов) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДокументов.Сортировать("ОжидаемоеДействие Убыв, ПредставлениеДокумента Возр");
	
	КоллекцииГрупп = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		ДобавитьЭлементДереваСтатусовДокументов(КоллекцииГрупп, СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементДереваСтатусовДокументов(КоллекцииГрупп, СтрокаТаблицы)
	ГруппаДействий = ГруппаСтатусовДокументов(КоллекцииГрупп, СтрокаТаблицы.ОжидаемоеДействие);
	Элемент = ГруппаДействий.ПолучитьЭлементы().Добавить();
	ЗаполнитьЗначенияСвойств(Элемент, СтрокаТаблицы);
КонецПроцедуры

&НаСервере
Функция ГруппаСтатусовДокументов(КоллекцииГрупп, ОжидаемоеДействие)
	
	ГруппаДействий = КоллекцииГрупп[ОжидаемоеДействие];
	Если ГруппаДействий <> Неопределено Тогда
		Возврат ГруппаДействий;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОжидаемоеДействие) Тогда
		ПредставлениеГруппы = НСтр("ru = 'Действий не требуется'");
	ИначеЕсли ОжидаемоеДействие = Перечисления.ОжидаемоеДействиеЭД.Сформировать Тогда
		ПредставлениеГруппы = НСтр("ru = 'Отправить на подпись'");
	ИначеЕсли ОжидаемоеДействие = Перечисления.ОжидаемоеДействиеЭД.Подписать Тогда
		ПредставлениеГруппы = НСтр("ru = 'Требуется подписание'");
	Иначе
		ПредставлениеГруппы = Строка(ОжидаемоеДействие);
	КонецЕсли;
	
	ГруппаДействий = СтатусыДокументов.ПолучитьЭлементы().Добавить();
	ГруппаДействий.ПредставлениеДокумента = ПредставлениеГруппы;
	ГруппаДействий.ОжидаемоеДействие = ОжидаемоеДействие;
	ГруппаДействий.ЭтоГруппа = Истина;
	
	КоллекцииГрупп.Вставить(ОжидаемоеДействие, ГруппаДействий);
	
	Возврат ГруппаДействий;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСтатусыВнутреннихДокументов()
	
	ТекущиеДанные = Элементы.СтатусыДокументов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		КлючТекущегоЭлемента = Неопределено;
	Иначе
		КлючТекущегоЭлемента = Новый Структура("ЭтоГруппа, ОжидаемоеДействие, ВидВнутреннегоДокумента");
		ЗаполнитьЗначенияСвойств(КлючТекущегоЭлемента, ТекущиеДанные);
	КонецЕсли;
	
	Результат = ОбновитьСтатусыВнутреннихДокументовНаСервере(КлючТекущегоЭлемента);
	
	Для Каждого ИдентификаторГруппы Из Результат.ДобавленныеГруппы Цикл
		Элементы.СтатусыДокументов.Развернуть(ИдентификаторГруппы);
	КонецЦикла;
	
	Элементы.СтатусыДокументов.ТекущаяСтрока = Результат.ИдентификаторСтроки;
	
КонецПроцедуры

&НаСервере
Функция ОбновитьСтатусыВнутреннихДокументовНаСервере(Знач КлючТекущегоЭлемента)
	
	Результат = Новый Структура;
	Результат.Вставить("ДобавленныеГруппы", Новый Массив);
	Результат.Вставить("ИдентификаторСтроки", 0);
	
	ЗаполнитьСтатусыВнутреннихДокументов();
	
	Для Каждого Элемент Из СтатусыДокументов.ПолучитьЭлементы() Цикл
		Результат.ДобавленныеГруппы.Добавить(Элемент.ПолучитьИдентификатор());
	КонецЦикла;
	
	Если ЗначениеЗаполнено(КлючТекущегоЭлемента) Тогда
		Результат.ИдентификаторСтроки = ИдентификаторТекущейСтроки(СтатусыДокументов, КлючТекущегоЭлемента);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Функция ИдентификаторТекущейСтроки(КоллекцияЭлементов, КлючТекущегоЭлемента)
	
	Для Каждого Элемент Из КоллекцияЭлементов.ПолучитьЭлементы() Цикл
		
		Если ЭтоТекущийЭлемент(Элемент, КлючТекущегоЭлемента) Тогда
			Возврат Элемент.ПолучитьИдентификатор();
		КонецЕсли;
		
		Если Элемент.ЭтоГруппа Тогда
			
			Результат = ИдентификаторТекущейСтроки(Элемент, КлючТекущегоЭлемента);
			
			Если ЗначениеЗаполнено(Результат) Тогда
				Возврат Результат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ЭтоТекущийЭлемент(Элемент, КлючТекущегоЭлемента)
	Для Каждого КлючЗначение Из КлючТекущегоЭлемента Цикл
		Если Элемент[КлючЗначение.Ключ] <> КлючЗначение.Значение Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ВыполнитьДействиеПоДокументам(ТекущиеДанные)
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьДействиеПоДокументамЗавершение", ЭтотОбъект);
	
	Если ТекущиеДанные.ОжидаемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.Сформировать") Тогда
		
		СформироватьДокументы(ТекущиеДанные, Оповещение);
		
	ИначеЕсли ТекущиеДанные.ОжидаемоеДействие = ПредопределенноеЗначение("Перечисление.ОжидаемоеДействиеЭД.Подписать") Тогда
		
		ПодписатьДокументы(ТекущиеДанные, Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеПоДокументамЗавершение(Результат, Контекст) Экспорт
	
	ОбновитьСтатусыВнутреннихДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументы(ТекущиеДанные, ОповещениеОЗавершении)
	
	Действие = "Сформировать";
	
	МассивОбъектов = Новый Массив;
	КлючиНастроекОбъектов = Новый Соответствие;
	
	Если ТекущиеДанные.ЭтоГруппа Тогда
		
		Для Каждого Элемент Из ТекущиеДанные.ПолучитьЭлементы() Цикл
			
			МассивКлючейНастроек = КлючиНастроекОбъектов[Элемент.ОбъектУчета];
			Если МассивКлючейНастроек = Неопределено Тогда
				МассивОбъектов.Добавить(Элемент.ОбъектУчета);
				КлючиНастроекОбъектов.Вставить(Элемент.ОбъектУчета,
					ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(КлючНастройкиВнутреннегоЭДО(Элемент)));
			Иначе
				МассивКлючейНастроек.Добавить(КлючНастройкиВнутреннегоЭДО(Элемент));
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		МассивОбъектов.Добавить(ТекущиеДанные.ОбъектУчета);
		КлючиНастроекОбъектов.Вставить(ТекущиеДанные.ОбъектУчета,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(КлючНастройкиВнутреннегоЭДО(ТекущиеДанные)));
	КонецЕсли;
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("КлючиНастроекОбъектов", КлючиНастроекОбъектов);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОбработатьЭД(МассивОбъектов, Действие, ДопПараметры, , ОповещениеОЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьДокументы(ТекущиеДанные, ОповещениеОЗавершении)
	
	Действие = "Подписать";
	
	МассивОбъектов = Новый Массив;
	
	МассивФайловЭлектронныхДокументов = Новый Массив;
	Если ТекущиеДанные.ЭтоГруппа Тогда
		Для Каждого Элемент Из ТекущиеДанные.ПолучитьЭлементы() Цикл
			МассивФайловЭлектронныхДокументов.Добавить(Элемент.ФайлЭлектронногоДокумента);
		КонецЦикла;
	Иначе
		МассивФайловЭлектронныхДокументов.Добавить(ТекущиеДанные.ФайлЭлектронногоДокумента);
	КонецЕсли;
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОбработатьЭД(МассивОбъектов, Действие, ,
		МассивФайловЭлектронныхДокументов, ОповещениеОЗавершении);
	
КонецПроцедуры

&НаКлиенте
Функция КлючНастройкиВнутреннегоЭДО(ТекущиеДанные)
	
	КлючНастройки = Новый Структура;
	КлючНастройки.Вставить("Организация");
	КлючНастройки.Вставить("ВидВнутреннегоДокумента");
	ЗаполнитьЗначенияСвойств(КлючНастройки, ТекущиеДанные);
	Возврат КлючНастройки;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьВнутреннийДокументОбъектаУчета(ТекущиеДанные);
	
	ЭлектронныйДокумент = ВнутреннийДокументОбъектаУчета(
		ТекущиеДанные.ОбъектУчета, ТекущиеДанные.ВидВнутреннегоДокумента);
	
	Если ЗначениеЗаполнено(ЭлектронныйДокумент) Тогда 
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ЭлектронныйДокумент);
		Возврат;
	КонецЕсли;
	
	КлючНастройки = КлючНастройкиВнутреннегоЭДО(ТекущиеДанные);
	
	КлючиНастроекОбъектов = Новый Соответствие;
	КлючиНастроекОбъектов.Вставить(ТекущиеДанные.ОбъектУчета,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(КлючНастройки));
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("КлючиНастроекОбъектов", КлючиНастроекОбъектов);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОткрытьАктуальныйЭДЗавершить",
		ОбменСКонтрагентамиСлужебныйКлиент, ПараметрыОткрытия);
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ПараметрКоманды",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.ОбъектУчета));
	ПараметрыПроверки.Вставить("Обработчик", ОбработчикОповещения);
	ПараметрыПроверки.Вставить("Источник"  , Неопределено);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ВыполнитьПроверкуПроведенияДокументов(ПараметрыПроверки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВнутреннийДокументОбъектаУчета(Знач ОбъектУчета, Знач ВидВнутреннегоДокумента)
	
	Возврат ОбменСКонтрагентамиСлужебный.ВнутреннийДокументОбъектаУчета(ОбъектУчета, ВидВнутреннегоДокумента);
	
КонецФункции

#КонецОбласти