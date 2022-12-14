
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	
	Если Параметры.Свойство("Организация") Тогда
		
		ПоВсемОрганизациям = Параметры.Организация = Справочники.Организации.ПустаяСсылка();
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Организация",
			Параметры.Организация,
			?(ПоВсемОрганизациям,ВидСравненияКомпоновкиДанных.НеРавно, ВидСравненияКомпоновкиДанных.Равно),
			,
			Истина);
		
		Список.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.КомпоновщикНастроек.Настройки.Отбор, "Дата",
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
			НачалоМесяца(Параметры.ПериодРегистрации),
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			"НачалоПериода");
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.КомпоновщикНастроек.Настройки.Отбор, "Дата",
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			КонецМесяца(Параметры.ПериодРегистрации),
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			"КонецПериода");
			
		Список.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
