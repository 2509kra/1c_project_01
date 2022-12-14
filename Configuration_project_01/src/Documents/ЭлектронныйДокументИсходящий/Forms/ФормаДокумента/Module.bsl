
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТолькоПросмотр = Истина;
	
	УправлениеФормой(ЭтотОбъект);
	
	Если Объект.ВидЭД = Перечисления.ВидыЭД.Внутренний Тогда
		Элементы.Контрагент.Видимость = Ложь;
		Элементы.ДоговорКонтрагента.Видимость = Ложь;
		Элементы.ИдентификаторОрганизации.Видимость = Ложь;
		Элементы.ИдентификаторКонтрагента.Видимость = Ложь;
		Элементы.ТребуетсяИзвещение.Видимость = Ложь;
		Элементы.СуммаДокумента.Видимость = Ложь;
		Элементы.ТребуетсяПодтверждение.Видимость = Ложь;
		Элементы.СодержитДанныеОМаркируемыхТоварах.Видимость = Ложь;
		Элементы.ВыгружатьДополнительныеСведения.Видимость = Ложь;
		Элементы.ДатаОтправки.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Элементы.ВидВнутреннегоДокумента.Видимость = Ложь;
	
	ВидДокументаБезТитула = ОбменСКонтрагентамиСлужебный.ЭтоВидЭДБезТитула(Объект.ВидЭД);
	Если Не ВидДокументаБезТитула
		И Объект.ОбменБезПодписи Тогда
		Элементы.ТребуетсяПодтверждение.Заголовок = НСтр("ru = 'Ожидается подтверждение получателем'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.ТипЭлементаВерсииЭД.Видимость = Объект.ВидЭД <> ПредопределенноеЗначение("Перечисление.ВидыЭД.ПроизвольныйЭД");
	Элементы.ТипДокумента.Видимость = Объект.ВидЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.ПроизвольныйЭД");
	
	ИспользуютсяДоговорыКонтрагентов = ОбменСКонтрагентамиПовтИсп.ИспользуютсяДоговорыКонтрагентов();
	Элементы.ДоговорКонтрагента.Видимость = ИспользуютсяДоговорыКонтрагентов;
	
КонецПроцедуры

#КонецОбласти


