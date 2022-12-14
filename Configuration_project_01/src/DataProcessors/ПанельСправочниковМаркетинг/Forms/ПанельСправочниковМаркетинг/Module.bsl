
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УправлениеЭлементами();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		// Изменены настройки программы в панелях администрирования
		УправлениеЭлементами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбщиеСправочники

&НаКлиенте
Процедура ОткрытьВидыЦен(Команда)
	
	ОткрытьФорму("Справочник.ВидыЦен.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыКартЛояльности(Команда)
	
	ОткрытьФорму("Справочник.ВидыКартЛояльности.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЦенПрайсЛист(Команда)
	
	ПоказатьЗначение(,ВидЦеныПрайсЛист());
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФорматыМагазинов(Команда)
	
	ОткрытьФорму("РегистрСведений.ИсторияИзмененияФорматовМагазинов.Форма.ФормаРедактирования",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТоварныеКатегории(Команда)
	
	ОткрытьФорму("Справочник.ТоварныеКатегории.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМарки(Команда)
	
	ОткрытьФорму("Справочник.Марки.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКвотыАссортимента(Команда)
	
	ОткрытьФорму("Документ.УстановкаКвотАссортимента.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКоллекции(Команда)
	
	ОткрытьФорму("Справочник.КоллекцииНоменклатуры.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБонусныеПрограммыЛояльности(Команда)
	
	ОткрытьФорму("Справочник.БонусныеПрограммыЛояльности.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУсловияПредоставленияСкидокНаценок(Команда)
	
	ОткрытьФорму("Справочник.УсловияПредоставленияСкидокНаценок.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область РассылкиИОповещенияКлиентам

&НаКлиенте
Процедура ОткрытьШаблоныСообщений(Команда)
	
	ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГруппыРассылокИОповещений(Команда)
	
	ОткрытьФорму("Справочник.ГруппыРассылокИОповещений.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыОповещений(Команда)
	
	ОткрытьФорму("Справочник.ВидыОповещенийКлиентам.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Анкетирование

&НаКлиенте
Процедура ОткрытьВопросыДляАнкетирования(Команда)
	
	ОткрытьФорму("ПланВидовХарактеристик.ВопросыДляАнкетирования.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьШаблоныАнкет(Команда)
	
	ОткрытьФорму("Справочник.ШаблоныАнкет.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Сделки

&НаКлиенте
Процедура ОткрытьСправочникСостоянияПроцессов(Команда)
	
	ОткрытьФорму("Справочник.СостоянияПроцессов.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникВидыСделок(Команда)
	
	ОткрытьФорму("Справочник.ВидыСделокСКлиентами.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникПричиныПроигрышаСделок(Команда)
	
	ОткрытьФорму("Справочник.ПричиныПроигрышаСделок.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникПричиныНеудовлетворенияПервичногоСпроса(Команда)
	
	ОткрытьФорму("Справочник.ПричиныНеудовлетворенияПервичногоСпроса.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникРолиПартнеровВСделкахИПроектах(Команда)
	
	ОткрытьФорму("Справочник.РолиПартнеровВСделкахИПроектах.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникРолиКонтактныхЛицВСделкахИПроектах(Команда)
	
	ОткрытьФорму("Справочник.РолиКонтактныхЛицВСделкахИПроектах.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ПартнерыКонтактныеЛица

&НаКлиенте
Процедура ОткрытьСправочникБизнесРегионы(Команда)
	
	ОткрытьФорму("Справочник.БизнесРегионы.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникРолиКонтактныхЛиц(Команда)
	
	ОткрытьФорму("Справочник.РолиКонтактныхЛицПартнеров.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыКонтактнойИнформации(Команда)
	
	ОткрытьФорму("Справочник.ВидыКонтактнойИнформации.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникВидыСвязейПартнеров(Команда)
	
	ОткрытьФорму("Справочник.ВидыСвязейМеждуПартнерами.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникГруппыДоступаПартнеров(Команда)
	
	ОткрытьФорму("Справочник.ГруппыДоступаПартнеров.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Претензии

&НаКлиенте
Процедура ОткрытьСправочникПричиныВозникновенияПретензий(Команда)
	
	ОткрытьФорму("Справочник.ПричиныВозникновенияПретензий.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементами()

	ФиксироватьПретензииКлиентов      = ПолучитьФункциональнуюОпцию("ФиксироватьПретензииКлиентов");
	ИспользоватьНесколькоВидовЦен     = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен");
	ИспользоватьАвтоматическиеСкидкиВПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	ИспользоватьЦеновыеГруппы 				  = ПолучитьФункциональнуюОпцию("ИспользоватьЦеновыеГруппы");
	ИспользоватьКартыЛояльности               = ПолучитьФункциональнуюОпцию("ИспользоватьКартыЛояльности");
	ИспользоватьБонусныеПрограммыЛояльности   = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммыЛояльности");
	
	ИспользоватьПатнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	ИспользоватьСделки                  = ПолучитьФункциональнуюОпцию("ИспользоватьСделкиСКлиентами");
	ИспользоватьУправлениеСделками      = ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеСделками");
	
	ИспользоватьГруппыДоступаПартнеров     = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаПартнеров");
	ИспользоватьРолиКонтактныхЛицПартнеров = ПолучитьФункциональнуюОпцию("ИспользоватьРолиКонтактныхЛицПартнеров");
	ИспользоватьБизнесРегионы              = ПолучитьФункциональнуюОпцию("ИспользоватьБизнесРегионы");
	ИспользоватьВидыСвязейПартнеров        = ПолучитьФункциональнуюОпцию("ИспользоватьВидыСвязейПартнеров");
	ИспользоватьПартнеровКакКонтрагентов   = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	
	ИспользоватьПочтовыйКлиент 	 = ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент");
	ИспользоватьАнкетирование  	 = ПолучитьФункциональнуюОпцию("ИспользоватьАнкетирование");
	ИспользоватьШаблоныСообщений = ПолучитьФункциональнуюОпцию("ИспользоватьШаблоныСообщений");
	
	ПравоДоступаВидыЦен                     = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыЦен);
	ПравоДоступаЦеновыеГруппы 				= ПравоДоступа("Просмотр", Метаданные.Справочники.ЦеновыеГруппы);
	ПравоДоступаВидыКартЛояльности          = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыКартЛояльности);
	ПравоДоступаУсловияПредоставления       = ПравоДоступа("Просмотр", Метаданные.Справочники.УсловияПредоставленияСкидокНаценок);
	ПравоДоступаБонусныеПрограммыЛояльности = ПравоДоступа("Просмотр", Метаданные.Справочники.БонусныеПрограммыЛояльности);
	ПравоДоступаАссортимент                     = ПравоДоступа("Просмотр", Метаданные.Справочники.ТоварныеКатегории);

	ПравоДоступаКлассификация               = ПравоДоступа("Использование", Метаданные.Обработки.Классификация);
	
	ПравоДоступаГруппыРассылокИОповещений = ПравоДоступа("Просмотр", Метаданные.Справочники.ГруппыРассылокИОповещений);
	ПравоДоступаВидыОповещений            = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыОповещенийКлиентам);
	ПравоДоступаШаблоныСообщений          = ПравоДоступа("Просмотр", Метаданные.Справочники.ШаблоныСообщений);
	
	ПравоДоступаВопросыДляАнкетирования = ПравоДоступа("Просмотр", Метаданные.ПланыВидовХарактеристик.ВопросыДляАнкетирования);
	ПравоДоступаШаблоныАнкет            = ПравоДоступа("Просмотр", Метаданные.Справочники.ШаблоныАнкет);
	
	ПравоДоступаВидыСделокСКлиентами   = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыСделокСКлиентами);
	ПравоДоступаПричиныПроигрышаСделок = ПравоДоступа("Просмотр", Метаданные.Справочники.ПричиныПроигрышаСделок);
	ПравоДоступаСостоянияПроцессов     = ПравоДоступа("Просмотр", Метаданные.Справочники.СостоянияПроцессов);
	
	ПравоДоступаРолиПартнеровВСделкахИПроектах = ПравоДоступа(
		"Просмотр",
		Метаданные.Справочники.РолиПартнеровВСделкахИПроектах);
		
	ПравоДоступаРолиКонтактныхЛицВСделкахИПроектах = ПравоДоступа(
		"Просмотр",
		Метаданные.Справочники.РолиКонтактныхЛицВСделкахИПроектах);
		
	ПравоДоступаПричиныНеудовлетворенияПервичногоСпроса = ПравоДоступа(
		"Просмотр",
		Метаданные.Справочники.ПричиныНеудовлетворенияПервичногоСпроса);
	
	ПравоДоступаПричиныВозникновенияПретензий = ПравоДоступа(
		"Просмотр",
		Метаданные.Справочники.ПричиныВозникновенияПретензий);
		
	ПравоДоступаГруппыДоступаПартнеров      = ПравоДоступа("Просмотр", Метаданные.Справочники.ГруппыДоступаПартнеров);
	ПравоДоступаРолиКонтактныхЛицПартнеров  = ПравоДоступа("Просмотр", Метаданные.Справочники.РолиКонтактныхЛицПартнеров);
	ПравоДоступаБизнесРегионы               = ПравоДоступа("Просмотр", Метаданные.Справочники.БизнесРегионы);
	ПравоДоступаВидыСвязейМеждуПартнерами   = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыСвязейМеждуПартнерами);
	
	ПравоДоступаВидыКонтактнойИнформации = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыКонтактнойИнформации);
	
	Элементы.ГруппаНастроекВидовЦен.Видимость            		 = ПравоДоступаВидыЦен;
	Элементы.ОткрытьЦеновыеГруппы.Видимость 					 = ПравоДоступаЦеновыеГруппы И ИспользоватьЦеновыеГруппы;
	Элементы.ГруппаНастроекВидовКартЛояльности.Видимость 		 = ПравоДоступаВидыКартЛояльности И ИспользоватьКартыЛояльности;
	Элементы.ГруппаУсловияПредоставленияСкидокНаценок.Видимость  = ПравоДоступаУсловияПредоставления И ИспользоватьАвтоматическиеСкидкиВПродажах;
	Элементы.ГруппаНастроекБонусныхПрограммЛояльности.Видимость  = ПравоДоступаБонусныеПрограммыЛояльности И ИспользоватьБонусныеПрограммыЛояльности;
	
	Элементы.ГруппаНастроекВидовЦен.Видимость   = ПравоДоступаВидыЦен И ИспользоватьНесколькоВидовЦен;
	Элементы.ГруппаНастроекОдинВидЦен.Видимость = ПравоДоступаВидыЦен И Не ИспользоватьНесколькоВидовЦен;
	
	// Номенклатура, продаваемая совместно
	ИспользоватьНоменклатуруПродаваемуюСовместно            = ПолучитьФункциональнуюОпцию("ИспользоватьНоменклатуруПродаваемуюСовместно");
	ПравоДоступаНоменклатураПродаваемаяСовместно            = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.НоменклатураПродаваемаяСовместно);
	ПравоДоступаНоменклатураПродаваемаяСовместноИзменение   = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НоменклатураПродаваемаяСовместно);
	Элементы.ОткрытьНастройкаПоискаАссоциаций.Видимость = ИспользоватьНоменклатуруПродаваемуюСовместно
		И ПравоДоступаНоменклатураПродаваемаяСовместноИзменение;
	Элементы.ОткрытьНоменклатураПродаваемаяСовместно.Видимость = ИспользоватьНоменклатуруПродаваемуюСовместно
		И ПравоДоступаНоменклатураПродаваемаяСовместно;
	
	#Область Ассортимент
	
	Элементы.ОткрытьФорматыМагазинов.Видимость  = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ИсторияИзмененияФорматовМагазинов);
	элементы.ОткрытьТоварныеКатегории.Видимость = ПравоДоступа("Просмотр", Метаданные.Справочники.ТоварныеКатегории);
	Элементы.ОткрытьМарки.Видимость             = ПравоДоступа("Просмотр", Метаданные.Справочники.Марки);
	Элементы.ОткрытьКвотыАссортимента.Видимость = ПравоДоступа("Просмотр", Метаданные.Документы.УстановкаКвотАссортимента);
	Элементы.ОткрытьКоллекции.Видимость         = ПравоДоступа("Просмотр", Метаданные.Справочники.КоллекцииНоменклатуры);
	
	Элементы.ГруппаКлассификацияНоменклатуры.Видимость = ПравоДоступаКлассификация;
	
	#КонецОбласти
	
	#Область РассылкиИОповещенияКлиентам
	
	Элементы.ОткрытьГруппыРассылокИОповещений.Видимость  = ПравоДоступаГруппыРассылокИОповещений И ИспользоватьПочтовыйКлиент И ИспользоватьШаблоныСообщений;
	Элементы.ОткрытьВидыОповещений.Видимость             = ПравоДоступаВидыОповещений И ИспользоватьПочтовыйКлиент И ИспользоватьШаблоныСообщений;
	Элементы.ОткрытьСправочникШаблоныСообщений.Видимость = ПравоДоступаШаблоныСообщений И ИспользоватьШаблоныСообщений;
	
	#КонецОбласти
	
	#Область Анкетирование
	
	Элементы.ОткрытьВопросыДляАнкетирования.Видимость = ПравоДоступаВопросыДляАнкетирования И ИспользоватьАнкетирование;
	Элементы.ОткрытьШаблоныАнкет.Видимость            = ПравоДоступаШаблоныАнкет И ИспользоватьАнкетирование;
	
	#КонецОбласти
	
	#Область Сделки
	
	Элементы.ОткрытьСправочникВидыСделок.Видимость = ПравоДоступаВидыСделокСКлиентами;
	Элементы.ОткрытьСправочникСостоянияПроцессов.Видимость = ПравоДоступаСостоянияПроцессов;
	Элементы.ОткрытьСправочникПричиныПроигрышаСделок.Видимость = ПравоДоступаПричиныПроигрышаСделок;
	Элементы.ОткрытьСправочникПричиныНеудовлетворенияПервичногоСпроса.Видимость = ПравоДоступаПричиныНеудовлетворенияПервичногоСпроса;
	Элементы.ОткрытьСправочникРолиПартнеровВСделкахИПроектах.Видимость 	= ПравоДоступаРолиПартнеровВСделкахИПроектах;
	Элементы.ОткрытьСправочникРолиКонтактныхЛицВСделкахИПроектах.Видимость = ПравоДоступаРолиКонтактныхЛицВСделкахИПроектах;

	Если НЕ ИспользоватьСделки Тогда
		
		Элементы.ГруппаНастроекСделки.Заголовок = НСтр("ru = 'Проекты'");
		
	КонецЕсли;
	
	Если ИспользоватьПатнеровКакКонтрагентов Тогда
		КомандаРолиПартнеровВСделкахИПроектах = Команды.Найти("ОткрытьСправочникРолиПартнеровВСделкахИПроектах");
		Если КомандаРолиПартнеровВСделкахИПроектах <> Неопределено Тогда
			КомандаРолиПартнеровВСделкахИПроектах.Заголовок = НСтр("ru = 'Роли контрагентов в сделках и проектах'");
			КомандаРолиПартнеровВСделкахИПроектах.Подсказка = 
			       НСтр("ru = 'Классификатор, используемый для понимания, какую роль выполняют косвенно или непосредственно участвующие в сделке или проекте контрагенты.'");
		КонецЕсли;
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ПартнерыИКонтактныеЛица
	
	Элементы.ГруппаГруппыДоступаПартнеров.Видимость = ИспользоватьГруппыДоступаПартнеров
		И ПравоДоступаГруппыДоступаПартнеров;
	Элементы.ГруппаРолиКонтактныхЛиц.Видимость = ИспользоватьРолиКонтактныхЛицПартнеров
		И ПравоДоступаРолиКонтактныхЛицПартнеров;
	Элементы.ГруппаБизнесРегионы.Видимость = ИспользоватьБизнесРегионы
		И ПравоДоступаБизнесРегионы;
	Элементы.ГруппаВидыСвязейПартнеров.Видимость = ИспользоватьВидыСвязейПартнеров
		И ПравоДоступаВидыСвязейМеждуПартнерами;
		
	Если Не Элементы.ГруппаРолиКонтактныхЛиц.Видимость Тогда
		Если ИспользоватьПартнеровКакКонтрагентов Тогда
			Элементы.ГруппаПартнерыКонтактныеЛица.Заголовок = НСтр("ru = 'Контрагенты'");
		Иначе
			Элементы.ГруппаПартнерыКонтактныеЛица.Заголовок = НСтр("ru = 'Партнеры'");
		КонецЕсли;
	Иначе
		Если ИспользоватьПартнеровКакКонтрагентов Тогда
			Элементы.ГруппаПартнерыКонтактныеЛица.Заголовок = НСтр("ru = 'Контрагенты и контактные лица'");
		КонецЕсли;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	           ЭтотОбъект, "ДекорацияСправочникРолиКонтактныхЛиц",
	           НСтр("ru = 'Виды ролей контактных лиц, описывающих деятельность контактного лица на предприятии контрагента. Например, директор, руководитель отдела, менеджер.'"),
	           ИспользоватьПартнеровКакКонтрагентов);
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	           ЭтотОбъект, "СправочникГруппыДоступаПартнеров",
	           НСтр("ru = 'Группы доступа контрагентов.'"),
	           ИспользоватьПартнеровКакКонтрагентов,
	           НСтр("ru = 'Классификатор деления контрагентов на группы, по которым можно ограничивать доступ на просмотр, добавление (изменение) партнеров и доступ к документам по партнерам.'"));
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	           ЭтотОбъект, "СправочникГруппыДоступаПартнеров",
	           НСтр("ru = 'Группы доступа контрагентов.'"),
	           ИспользоватьПартнеровКакКонтрагентов);
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	           ЭтотОбъект, "ДекорацияСправочникГруппыДоступаПартнеров",
	           НСтр("ru = 'Классификатор деления контрагентав на группы, по которым можно ограничивать доступ на просмотр, добавление (изменение) контрагентов и доступ к документам по контрагентам.'"),
	           ИспользоватьПартнеровКакКонтрагентов);
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	           ЭтотОбъект, "СправочникВидыСвязейПартнеров",
	           НСтр("ru = 'Виды связей контрагентов.'"),
	           ИспользоватьПартнеровКакКонтрагентов);
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	           ЭтотОбъект, "ДекорацияВидыСвязейПартнеров",
	           НСтр("ru = 'Классификатор видов деловых связей , которые могут быть настроены между контрагентами торгового предприятия.'"),
	           ИспользоватьПартнеровКакКонтрагентов);
	
	Элементы.ОткрытьВидыКонтактнойИнформации.Видимость = ПравоДоступаВидыКонтактнойИнформации;
	
	#КонецОбласти
	
	#Область Претензии
	
	Элементы.ГруппаПретензии.Видимость = ФиксироватьПретензииКлиентов И ПравоДоступаПричиныВозникновенияПретензий;
	
	#КонецОбласти
	
КонецПроцедуры

#Область Прочее

&НаСервереБезКонтекста
Функция ВидЦеныПрайсЛист()
	
	Возврат Ценообразование.ВидЦеныПрайсЛист();
	
КонецФункции

&НаКлиенте
Процедура ОткрытьЦеновыеГруппы(Команда)

	ОткрытьФорму("Справочник.ЦеновыеГруппы.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРейтингиПродажНоменклатуры(Команда)
	
	ОткрытьФорму("Справочник.РейтингиПродажНоменклатуры.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкаПоискаАссоциаций(Команда)
	
	ОткрытьФорму("РегистрСведений.НоменклатураПродаваемаяСовместно.Форма.НастройкаПоискаАссоциаций", Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНоменклатураПродаваемаяСовместно(Команда)
	
	ОткрытьФорму("РегистрСведений.НоменклатураПродаваемаяСовместно.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
