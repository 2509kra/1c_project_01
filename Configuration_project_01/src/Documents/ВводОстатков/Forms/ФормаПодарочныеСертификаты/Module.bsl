
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьВидимостьЭлементов();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	Элементы.ГруппаВводОстатковПо.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
	УстановитьЗаголовок();
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПодарочногоСертификатаПриИзменении(Элемент)
	
	ВидПодарочногоСертификатаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВОперативномУчетеПриИзменении(Элемент)
	ИзменитьВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБУиНУПриИзменении(Элемент)
	ИзменитьВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВУУПриИзменении(Элемент)
	ИзменитьВидимостьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодарочныеСертификаты

&НаКлиенте
Процедура ПодарочныеСертификатыПодарочныйСертификатПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПодарочныеСертификаты.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ПодарочныйСертификат) Тогда
		Возврат;
	КонецЕсли;
	
	Данные = ПодарочныеСертификатыВызовСервера.ПолучитьДанныеПодарочногоСертификата(ТекущиеДанные.ПодарочныйСертификат);
	ТекущиеДанные.МагнитныйКод = Данные.МагнитныйКод;
	ТекущиеДанные.Штрихкод = Данные.Штрихкод;
	ТекущиеДанные.СерийныйНомер = Данные.СерийныйНомер;
	
	ЗаполнитьСуммы(
		ТекущиеДанные.СуммаВВалютеСертификата,
		ТекущиеДанные.СуммаРегл,
		ТекущиеДанные.СуммаУпр,
		Объект.ВидПодарочногоСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодарочныеСертификатыСуммаВВалютеСертификатаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПодарочныеСертификаты.ТекущиеДанные;
	
	ЗаполнитьСуммы(
		ТекущиеДанные.СуммаВВалютеСертификата,
		ТекущиеДанные.СуммаРегл,
		ТекущиеДанные.СуммаУпр,
		Объект.ВидПодарочногоСертификата);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ПодарочныеСертификатыСерийныйНомер"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ПодарочныеСертификатыШтрихкод"].Имя);
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы["ПодарочныеСертификатыМагнитныйКод"].Имя);

	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Элемент.Отбор, "Объект.ПодарочныеСертификаты.ПодарочныйСертификат", Неопределено, ВидСравненияКомпоновкиДанных.Заполнено);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
																						  Объект.Номер,
																						  Объект.Дата,
																						  Объект.ТипОперации);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьЭлементов()
	ВестиУУНаПланеСчетовХозрасчетный = Ложь;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидПодарочногоСертификата, "ТипКарты");
	Если ЗначенияРеквизитов.ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
		Элементы.ПодарочныеСертификатыМагнитныйКод.Видимость = Истина;
		Элементы.ПодарочныеСертификатыШтрихкод.Видимость     = Ложь;
	ИначеЕсли ЗначенияРеквизитов.ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
		Элементы.ПодарочныеСертификатыМагнитныйКод.Видимость = Ложь;
		Элементы.ПодарочныеСертификатыШтрихкод.Видимость     = Истина;
	Иначе
		Элементы.ПодарочныеСертификатыМагнитныйКод.Видимость = Истина;
		Элементы.ПодарочныеСертификатыШтрихкод.Видимость     = Истина;
	КонецЕсли;
	
	Элементы.ПодарочныеСертификатыСуммаРегл.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВБУиНУ;
	Элементы.ПодарочныеСертификатыСуммаУпр.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВУУ;
	Элементы.ОтражатьВУУ.Видимость = ВестиУУНаПланеСчетовХозрасчетный;
	
КонецПроцедуры

&НаСервере
Процедура ВидПодарочногоСертификатаПриИзмененииНаСервере()
	
	ИзменитьВидимостьЭлементов();
	
	Для Каждого СтрокаТЧ Из Объект.ПодарочныеСертификаты Цикл
		СтрокаТЧ.ПодарочныйСертификат = Неопределено;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСуммы(Сумма, СуммаРегл, СуммаУпр, ВидПодарочногоСертификата)
	
	ДатаДокумента = Объект.Дата;
	
	Если ЗначениеЗаполнено(ВидПодарочногоСертификата) Тогда
		
		Валюта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидПодарочногоСертификата, "Валюта");
		
		Если Валюта = ВалютаРегламентированногоУчета Тогда
			СуммаРегл = Сумма;
		Иначе
			КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаРегламентированногоУчета, ДатаДокумента);
			СуммаРегл = Окр(Сумма * КоэффициентПересчета, 2, 1);
		КонецЕсли;
		
		Если Валюта = ВалютаУправленческогоУчета Тогда
			СуммаУпр = Сумма;
		Иначе
			КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаУправленческогоУчета, ДатаДокумента);
			СуммаУпр = Окр(Сумма * КоэффициентПересчета, 2, 1);
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
