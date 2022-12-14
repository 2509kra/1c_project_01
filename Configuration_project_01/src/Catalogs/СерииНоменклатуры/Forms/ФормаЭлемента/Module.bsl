
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик механизма "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	УправлениеСвойствамиУТ.УстановитьОтметкуНезаполненныхСвойств(ЭтаФорма, Объект);
	
	Если Не ЗначениеЗаполнено(Объект.ВидНоменклатуры) Тогда
		Элементы.ВидНоменклатуры.ТолькоПросмотр = Ложь;
		Возврат;
	КонецЕсли;
	
	Элементы.ВидНоменклатуры.ТолькоПросмотр = Истина;
	УстановитьНастройкиПоШаблону();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СтруктураОповещения = Новый Структура;
	СтруктураОповещения.Вставить("Номер", Объект.Номер);
	СтруктураОповещения.Вставить("ГоденДо", Объект.ГоденДо);
	СтруктураОповещения.Вставить("НомерКиЗГИСМ", Объект.НомерКиЗГИСМ);
	СтруктураОповещения.Вставить("RFIDTID", Объект.RFIDTID);
	СтруктураОповещения.Вставить("RFIDUser", Объект.RFIDUser);
	СтруктураОповещения.Вставить("RFIDEPC", Объект.RFIDEPC);
	СтруктураОповещения.Вставить("EPCGTIN", Объект.EPCGTIN);
	СтруктураОповещения.Вставить("RFIDМеткаНеЧитаемая", Объект.RFIDМеткаНеЧитаемая);
	СтруктураОповещения.Вставить("ПроизводительЕГАИС", Объект.ПроизводительЕГАИС);
	СтруктураОповещения.Вставить("Справка2ЕГАИС", Объект.Справка2ЕГАИС);
	СтруктураОповещения.Вставить("ПроизводительВЕТИС", Объект.ПроизводительВЕТИС);
	СтруктураОповещения.Вставить("ЗаписьСкладскогоЖурналаВЕТИС", Объект.ЗаписьСкладскогоЖурналаВЕТИС);
	СтруктураОповещения.Вставить("ИдентификаторПартииВЕТИС", Объект.ИдентификаторПартииВЕТИС);
	СтруктураОповещения.Вставить("МаксимальнаяРозничнаяЦенаМОТП", Объект.МаксимальнаяРозничнаяЦенаМОТП);
	
	Оповестить("Запись_СерииНоменклатуры", СтруктураОповещения, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обработчик механизма "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	УстановитьНастройкиПоШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПроизводстваПриИзменении(Элемент)
	
	НоменклатураКлиентСервер.ПересчитатьДатуСерии(Объект.ДатаПроизводства);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПроизводстваНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НоменклатураКлиент.ДатаПроизводстваНачалоВыбора(Объект, Неопределено, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГоденДоПриИзменении(Элемент)
	
	НоменклатураКлиентСервер.ПересчитатьДатуСерии(Объект.ГоденДо);
	
КонецПроцедуры

&НаКлиенте
Процедура ГоденДоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИменаПараметров = "ГоденДо, ДатаПроизводства, ФорматДаты, ИспользоватьДатуПроизводства, ЕдиницаИзмеренияСрокаГодности";
	ПараметрыФормы = Новый Структура(ИменаПараметров);
	
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, Объект);
	
	ПараметрыФормы.ФорматДаты                    = ПараметрыПолитики.ФорматнаяСтрокаСрокаГодности;
	ПараметрыФормы.ИспользоватьДатуПроизводства  = ПараметрыПолитики.ИспользоватьДатуПроизводстваСерии;
	ПараметрыФормы.ЕдиницаИзмеренияСрокаГодности = ПараметрыПолитики.ЕдиницаИзмеренияСрокаГодности;
	
	НоменклатураКлиент.ДатаИстеченияСрокаГодностиНачалоВыбора(Объект, ПараметрыФормы, Неопределено,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область Прочее

&НаСервере
Процедура УстановитьНастройкиПоШаблону()
	
	РежимОтладки = ОбщегоНазначенияУТ.РежимОтладки();
	
	ПараметрыПолитики = Новый ФиксированнаяСтруктура(
		ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(Объект.ВидНоменклатуры));
	
	Элементы.ГоденДо.Видимость          = ПараметрыПолитики.ИспользоватьСрокГодностиСерии;
	Элементы.ДатаПроизводства.Видимость = ПараметрыПолитики.ИспользоватьДатуПроизводстваСерии;
	
	Если ПараметрыПолитики.ИспользоватьСрокГодностиСерии Тогда
		Элементы.ГоденДо.Формат               = ПараметрыПолитики.ФорматнаяСтрокаСрокаГодности;
		Элементы.ГоденДо.ФорматРедактирования = ПараметрыПолитики.ФорматнаяСтрокаСрокаГодности;
	КонецЕсли;
	
	Если ПараметрыПолитики.ИспользоватьДатуПроизводстваСерии Тогда
		Элементы.ДатаПроизводства.Формат               = ПараметрыПолитики.ФорматнаяСтрокаСрокаГодности;
		Элементы.ДатаПроизводства.ФорматРедактирования = ПараметрыПолитики.ФорматнаяСтрокаСрокаГодности;
	КонецЕсли;
		
	Элементы.Номер.Видимость   = ПараметрыПолитики.ИспользоватьНомерСерии;
	
	МожноМенятьНомер = РежимОтладки
						Или Не ПараметрыПолитики.ИспользоватьRFIDМеткиСерии
						Или Не ((ЗначениеЗаполнено(Объект.RFIDTID)
									Или ЗначениеЗаполнено(Объект.RFIDEPC))
								И Не Объект.RFIDМеткаНеЧитаемая);
	
	Элементы.Номер.ТолькоПросмотр = Не МожноМенятьНомер;
	
	Элементы.НомерКИЗГИСМ.Видимость = ПараметрыПолитики.ИспользоватьНомерКИЗГИСМСерии;
	
	Элементы.RFIDTID.Видимость  = ПараметрыПолитики.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDUser.Видимость = ПараметрыПолитики.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDEPC.Видимость  = ПараметрыПолитики.ИспользоватьRFIDМеткиСерии;
	Элементы.EPCGTIN.Видимость  = ПараметрыПолитики.ИспользоватьRFIDМеткиСерии;
	Элементы.RFIDМеткаНеЧитаемая.Видимость  = ПараметрыПолитики.ИспользоватьRFIDМеткиСерии;
	
	Элементы.RFIDTID.ТолькоПросмотр = Не РежимОтладки;
	Элементы.RFIDUser.ТолькоПросмотр = Не РежимОтладки;
	Элементы.RFIDEPC.ТолькоПросмотр = Не РежимОтладки;
	Элементы.RFIDМеткаНеЧитаемая.ТолькоПросмотр = Не РежимОтладки;
	
	Элементы.ПроизводительЕГАИС.Видимость = ПараметрыПолитики.ИспользоватьПроизводителяЕГАИССерии;
	Элементы.Справка2ЕГАИС.Видимость      = ПараметрыПолитики.ИспользоватьСправку2ЕГАИССерии;
	
	Элементы.ПроизводительВЕТИС.Видимость           = ПараметрыПолитики.ИспользоватьПроизводителяВЕТИССерии;
	Элементы.ЗаписьСкладскогоЖурналаВЕТИС.Видимость = ПараметрыПолитики.ИспользоватьЗаписьСкладскогоЖурналаВЕТИССерии;
	Элементы.ИдентификаторПартииВЕТИС.Видимость     = ПараметрыПолитики.ИспользоватьИдентификаторПартииВЕТИССерии;
	
	Элементы.МаксимальнаяРозничнаяЦенаМОТП.Видимость = ПараметрыПолитики.ИспользоватьМРЦМОТПСерии;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
