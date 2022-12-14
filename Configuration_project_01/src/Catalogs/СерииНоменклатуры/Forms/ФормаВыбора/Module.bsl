
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Параметры.ВидНоменклатуры) Тогда
		ВидНоменклатуры = Параметры.ВидНоменклатуры;
	ИначеЕсли ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		РеквизитыСерии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ТекущаяСтрока,
			Новый Структура("ВидНоменклатуры", "ВидНоменклатуры"));
		
		ВидНоменклатуры = РеквизитыСерии.ВидНоменклатуры;
	ИначеЕсли ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Номенклатура,
			Новый Структура("ВидНоменклатуры", "ВидНоменклатуры"));
		
		ВидНоменклатуры = РеквизитыНоменклатуры.ВидНоменклатуры;
	КонецЕсли;
	
	Элементы.ВидНоменклатуры.ТолькоПросмотр = ЗначениеЗаполнено(ВидНоменклатуры);
	
	ВидНоменклатурыПриИзмененииСервер();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			
			Номер = МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр).Штрихкод;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																					"Номер",
																					Номер,
																					ВидСравненияКомпоновкиДанных.Содержит,
																					,
																					ЗначениеЗаполнено(Номер));
			
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																			"Номер",
																			Номер,
																			ВидСравненияКомпоновкиДанных.Содержит,
																			,
																			ЗначениеЗаполнено(Номер));
	
КонецПроцедуры

&НаКлиенте
Процедура ГоденДоПриИзменении(Элемент)
	
	НоменклатураКлиентСервер.ПересчитатьДатуСерии(ГоденДо);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																			"ГоденДо",
																			ГоденДо,
																			ВидСравненияКомпоновкиДанных.Равно,
																			,
																			ЗначениеЗаполнено(ГоденДо));
	
КонецПроцедуры

&НаКлиенте
Процедура ГоденДоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИменаПараметров = "ГоденДо, ФорматДаты, ИспользоватьДатуПроизводства, ЕдиницаИзмеренияСрокаГодности";
	ПараметрыФормы = Новый Структура(ИменаПараметров);
	
	ПараметрыФормы.ГоденДо                       = ГоденДо;
	ПараметрыФормы.ФорматДаты                    = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
	ПараметрыФормы.ИспользоватьДатуПроизводства  = Ложь;
	ПараметрыФормы.ЕдиницаИзмеренияСрокаГодности = ПараметрыШаблона.ЕдиницаИзмеренияСрокаГодности;
	
	НоменклатураКлиент.ДатаИстеченияСрокаГодностиНачалоВыбора(ЭтаФорма, ПараметрыФормы, Неопределено,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ВидНоменклатурыПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование Тогда
		Отказ = Истина;
		
		Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
			ТекстПредупреждения = НСтр("ru = 'Перед добавлением серии необходимо указать вид номенклатуры.'");
			
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
			
			Возврат;
		ИначеЕсли ЗначениеЗаполнено(ПараметрыШаблона)
			И Не ПараметрыШаблона.ИспользоватьСерии Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Невозможно добавить новую серию, так как в настройках вида номенклатуры выключена возможность использования серий.'");
			
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
			
			Возврат;
			
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВидНоменклатуры", ВидНоменклатуры);
		ЗначенияЗаполнения.Вставить("Номер",           Номер);
		ЗначенияЗаполнения.Вставить("ГоденДо",         ГоденДо);
		
		ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта",
			Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), Элементы.Список);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ВидНоменклатурыПриИзмененииСервер()
	
	ПараметрыШаблона = Неопределено;
	ВладелецСерий    = Справочники.ВидыНоменклатуры.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		ПараметрыШаблона = Новый ФиксированнаяСтруктура(
									ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(ВидНоменклатуры));
		
		ВладелецСерий = ПараметрыШаблона.ВладелецСерий;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																			"ВидНоменклатуры",
																			ВладелецСерий,
																			ВидСравненияКомпоновкиДанных.Равно,
																			,
																			Истина);
	
	НастроитьПоШаблону();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПоШаблону()
	
	Если ПараметрыШаблона = Неопределено
		Или (ТипЗнч(ПараметрыШаблона) = Тип("ФиксированнаяСтруктура")
			И Не ПараметрыШаблона.ИспользоватьСерии) Тогда
		
		ВестиСведенияДляДекларацийАлкоВРознице = ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийАлкоВРознице");
		ВестиУчетПодконтрольныхТоваровВЕТИС    = ПолучитьФункциональнуюОпцию("ВестиУчетПодконтрольныхТоваровВЕТИС");
		
		Элементы.Номер.Видимость   = Ложь;
		Элементы.ГоденДо.Видимость = Ложь;
		
		Элементы.СписокНомер.Видимость = Истина;
		
		Элементы.СписокДатаПроизводства.Видимость = Истина;
		Элементы.СписокГоденДо.Видимость          = Истина;
		
		Элементы.СписокНомерКИЗГИСМ.Видимость = ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ");
		
		Элементы.СписокПроизводительЕГАИС.Видимость = ВестиСведенияДляДекларацийАлкоВРознице;
		Элементы.СписокСправка2ЕГАИС.Видимость      = ВестиСведенияДляДекларацийАлкоВРознице;
		
		Элементы.СписокПроизводительВЕТИС.Видимость           = ВестиУчетПодконтрольныхТоваровВЕТИС;
		Элементы.СписокЗаписьСкладскогоЖурналаВЕТИС.Видимость = ВестиУчетПодконтрольныхТоваровВЕТИС;
		
	Иначе
		
		Элементы.Номер.Видимость   = ПараметрыШаблона.ИспользоватьНомерСерии;
		Элементы.ГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		
		Если ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
			Элементы.ГоденДо.Формат               = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
			Элементы.ГоденДо.ФорматРедактирования = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
			
			Элементы.СписокГоденДо.Формат = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		КонецЕсли;
		
		Элементы.СписокНомер.Видимость = ПараметрыШаблона.ИспользоватьНомерСерии;
		
		Элементы.СписокДатаПроизводства.Видимость = ПараметрыШаблона.ИспользоватьДатуПроизводстваСерии;
		Элементы.СписокГоденДо.Видимость          = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		
		Если ПараметрыШаблона.ИспользоватьДатуПроизводстваСерии Тогда
			Элементы.СписокДатаПроизводства.Формат = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		КонецЕсли;
		
		Элементы.СписокНомерКИЗГИСМ.Видимость = ПараметрыШаблона.ИспользоватьНомерКИЗГИСМСерии;
		
		Элементы.СписокПроизводительЕГАИС.Видимость = ПараметрыШаблона.ИспользоватьПроизводителяЕГАИССерии;
		Элементы.СписокСправка2ЕГАИС.Видимость      = ПараметрыШаблона.ИспользоватьСправку2ЕГАИССерии;
		
		Элементы.СписокПроизводительВЕТИС.Видимость           = ПараметрыШаблона.ИспользоватьПроизводителяВЕТИССерии;
		Элементы.СписокЗаписьСкладскогоЖурналаВЕТИС.Видимость = ПараметрыШаблона.ИспользоватьЗаписьСкладскогоЖурналаВЕТИССерии;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
