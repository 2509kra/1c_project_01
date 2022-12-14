
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ЗаблокироватьОткрытиеФормыНаМобильномКлиенте(Отказ);
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
	
	ТолькоПросмотр = НЕ (ОбменСКонтрагентамиСлужебный.ЭтоПрямойОбмен(Объект.СпособОбменаЭД)
		И (Объект.СостояниеЭДО = Перечисления.СостоянияВерсийЭД.НаУтверждении
			ИЛИ Объект.СостояниеЭДО = Перечисления.СостоянияВерсийЭД.НаПодписи));
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ТипЭлементаВерсииЭД.Видимость = Объект.ВидЭД <> Перечисления.ВидыЭД.ПроизвольныйЭД;
	Элементы.ТипДокумента.Видимость = Объект.ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД;
	
	ИспользуютсяДоговорыКонтрагентов = ОбменСКонтрагентамиПовтИсп.ИспользуютсяДоговорыКонтрагентов();
	Элементы.ДоговорКонтрагента.Видимость = ИспользуютсяДоговорыКонтрагентов;
	
	Элементы.ОбратныйАдрес.Видимость = ЗначениеЗаполнено(Объект.СпособОбменаЭД)
		И ОбменСКонтрагентамиСлужебный.ЭтоПрямойОбмен(Объект.СпособОбменаЭД);
	
КонецПроцедуры


#КонецОбласти

