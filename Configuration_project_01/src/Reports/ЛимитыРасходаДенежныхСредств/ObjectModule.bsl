#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Документ", Параметры.ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить("КлючТекущегоВарианта", ЭтаФорма.КлючТекущегоВарианта);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрДокумент = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.Настройки, "Документ");
	
	Если ЗначениеЗаполнено(ПараметрДокумент.Значение) Тогда
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрДокумент.Значение, 
			"Дата, ДатаПлатежа, ЖелательнаяДатаПлатежа, Организация, Подразделение, ХозяйственнаяОперация");
			
		Если ЗначениеЗаполнено(РеквизитыДокумента.ДатаПлатежа) Тогда
			ПериодЛимита = РеквизитыДокумента.ДатаПлатежа;
		ИначеЕсли ЗначениеЗаполнено(РеквизитыДокумента.ЖелательнаяДатаПлатежа) Тогда
			ПериодЛимита = РеквизитыДокумента.ЖелательнаяДатаПлатежа;
		Иначе
			ПериодЛимита = РеквизитыДокумента.Дата;
		КонецЕсли;
		
		ПараметрПериод = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.Настройки, "Период");
		ПараметрПериод.Значение = Новый СтандартныйПериод(НачалоМесяца(ПериодЛимита), КонецМесяца(ПериодЛимита));
		ПараметрПериод.Использование = Истина;
		
		ПараметрХозяйственнаяОперация = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.Настройки, "ХозяйственнаяОперация");
		ПараметрХозяйственнаяОперация.Значение = РеквизитыДокумента.ХозяйственнаяОперация;
		ПараметрХозяйственнаяОперация.Использование = Истина;
		
		СтатьиДвиженияДенежныхСредств = СтатьиДвиженияДенежныхСредствДокумента(ПараметрДокумент.Значение);
		Для каждого ГруппировкаСтатьяДвиженияДенежныхСредств Из КомпоновщикНастроек.Настройки.Структура Цикл
			УстановитьОтборКомпоновщикаНастроек(
				ГруппировкаСтатьяДвиженияДенежныхСредств.Отбор, 
				"СтатьяДвиженияДенежныхСредств", 
				СтатьиДвиженияДенежныхСредств);
		КонецЦикла;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям") Тогда
			УстановитьОтборКомпоновщикаНастроек(
				КомпоновщикНастроек.Настройки.Отбор, 
				"Организация", 
				РеквизитыДокумента.Организация);
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям") Тогда
			УстановитьОтборКомпоновщикаНастроек(
				КомпоновщикНастроек.Настройки.Отбор, 
				"Подразделение", 
				РеквизитыДокумента.Подразделение);
		КонецЕсли;
		
	Иначе
		
		ПараметрХозяйственнаяОперация = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.Настройки, "ХозяйственнаяОперация");
		ПараметрХозяйственнаяОперация.Значение = Перечисления.ХозяйственныеОперации.ПустаяСсылка();
		ПараметрХозяйственнаяОперация.Использование = Истина;
		
	КонецЕсли;
	
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Валюта"));
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Константы.ВалютаУправленческогоУчета.Получить();
		Параметр.Использование = Истина;
	КонецЕсли;
	
	КомпоновкаДанныхСервер.НастроитьДинамическийПериод(СхемаКомпоновкиДанных, КомпоновщикНастроек);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОтборКомпоновщикаНастроек(Отбор, ИмяПоля, Значение)
	
	ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Отбор, ИмяПоля);
	Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		ЭлементОтбора.ПравоеЗначение = Значение;
		ЭлементОтбора.Использование = Истина;
	КонецЦикла;
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	ВспомогательныеПараметры = Новый Массив;
	
	КлючТекущегоВарианта = "";
	Если КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта", КлючТекущегоВарианта) Тогда
		Если КлючТекущегоВарианта = "ЛимитыРасходаДенежныхСредствКонтекст" Тогда
			ВспомогательныеПараметры.Добавить("Периодичность");
			ВспомогательныеПараметры.Добавить("Период");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВспомогательныеПараметры;
КонецФункции

Функция СтатьиДвиженияДенежныхСредствДокумента(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеДенежныхСредств.СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкаНаРасходованиеДенежныхСредств
	|ГДЕ
	|	ЗаявкаНаРасходованиеДенежныхСредств.Ссылка = &ДокументСсылка
	|	И ЗаявкаНаРасходованиеДенежныхСредств.ХозяйственнаяОперация В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КонвертацияВалюты),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств)
	|	)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа
	|ГДЕ
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка = &ДокументСсылка
	|	И ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.ХозяйственнаяОперация НЕ В (
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КонвертацияВалюты),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств))
	|";
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	СтатьиДвиженияДенежныхСредств = Новый СписокЗначений;
	СтатьиДвиженияДенежныхСредств.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СтатьяДвиженияДенежныхСредств"));
	
	Возврат СтатьиДвиженияДенежныхСредств;
	
КонецФункции

#КонецОбласти

#КонецЕсли