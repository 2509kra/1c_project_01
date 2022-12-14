
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.ОснованиеПлатежа) Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОснованиеПлатежа = Параметры.ОснованиеПлатежа;
	
	// Получаем настройки подключения к Яндекс.Кассе по данным основания платежа
	
	НастройкаЯндексКассы = ИнтеграцияСЯндексКассойСлужебный.НастройкаЯндексКассыОснованияПлатежа(ОснованиеПлатежа);
	
	Если НастройкаЯндексКассы = Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не обнаружены настройки подключения к ЮKassa'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Заполняем контактную информация для отправки чеков
	
	Если НастройкаЯндексКассы.ОтправкаЧековЧерезЯндекс Тогда
		ЗаполнитьСпискиКонтактнойИнформации();
	КонецЕсли; 
		
	ТребуетсяОбновлениеДанныхВСервисе = Ложь;
	ТребуетсяОбновлениеКонтактнойИнформацииВСервисе = Ложь;
	ДанныеОснованияПлатежаВСервисеОбработаны = Ложь;
	
	ВариантОтправки = "ЭлектроннаяПочта";
	
	НастройкиШаблонов = ИнтеграцияСЯндексКассойСлужебный.НастройкиШаблоновСообщений();
	
	КлючПоложенияОкна = "";
	УправлениеЭлементамиФормыПоПодсистемам(КлючПоложенияОкна);
	УправлениеЭлементамиФормыПоНастройкам(КлючПоложенияОкна);
	УправлениеЭлементамиФормыПоДанным(КлючПоложенияОкна);
	
	КлючСохраненияПоложенияОкна = СтрШаблон("ЯндексКасса.%1.%2", 
		ЭтотОбъект.Заголовок,
		КлючПоложенияОкна);
		
	ВосстановитьШаблоныПоУмолчанию();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьДанныеОснованияПлатежаВСервисе();
	
	ТипПлатформыКлиента = ОбщегоНазначенияКлиент.ТипПлатформыКлиента();
	
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#Иначе
		ЭтоВебКлиент = Ложь;
	#КонецЕсли
		
	ОтображатьКнопкуКопироватьВБуфер = (ТипПлатформыКлиента = ТипПлатформы.Windows_x86 
		ИЛИ ТипПлатформыКлиента = ТипПлатформы.Windows_x86_64)
		И Не ЭтоВебКлиент;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"КопироватьВБуфер",
		"Видимость",
		ОтображатьКнопкуКопироватьВБуфер);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкиШаблонов.Используется 
		И ЗначениеЗаполнено(ОснованиеПлатежа) Тогда
		
		СохранитьШаблоныПоУмолчанию(ОснованиеПлатежа, 
			ШаблонСообщенияЭлектроннаяПочта, ШаблонСообщенияТелефон);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ДоставкаЧека

&НаКлиенте
Процедура ВариантДоставкиЧекаЭлектроннаяПочтаПриИзменении(Элемент)
	
	ТребуетсяОбновлениеКонтактнойИнформацииВСервисе = Истина;
	
	УправлениеЭлементамиФормыПоДанным();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантДоставкиЧекаТелефонПриИзменении(Элемент)
	
	ТребуетсяОбновлениеКонтактнойИнформацииВСервисе = Истина;
	
	УправлениеЭлементамиФормыПоДанным();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоставкаЧекаЭлектроннаяПочтаПриИзменении(Элемент)
	
	ВариантДоставкиЧека = "ЭлектроннаяПочта";
	
	ТребуетсяОбновлениеКонтактнойИнформацииВСервисе = Истина;
	
	УправлениеЭлементамиФормыПоДанным();
		
КонецПроцедуры

&НаКлиенте
Процедура ДоставкаЧекаТелефонПриИзменении(Элемент)
	
	ВариантДоставкиЧека = "Телефон";
	
	ТребуетсяОбновлениеКонтактнойИнформацииВСервисе = Истина;
	
	УправлениеЭлементамиФормыПоДанным();
	
КонецПроцедуры

#КонецОбласти

#Область ОтправкаСсылки

&НаКлиенте
Процедура ШаблонСообщенияЭлектроннаяПочтаПриИзменении(Элемент)
	
	ВариантОтправки = "ЭлектроннаяПочта";
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонСообщенияТелефонПриИзменении(Элемент)
	
	ВариантОтправки = "Телефон";
	
КонецПроцедуры

#КонецОбласти

#Область ПодсказкаФормы

&НаКлиенте
Процедура ДекорацияПояснениеКФормеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьНастройку" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьНастройкуЯндексКассы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьСсылку(Команда)
	
	НачатьФормированиеПлатежнойСсылки();
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьВБуфер(Команда)
	
	// Копирование происходит с предварительной очисткой через обработчик, для обхода поведения платформы
	// при повторном копировании - при определенных условиях копирование не происходит.
	
	ЭтотОбъект.БуферОбмена = "";
		
	ПодключитьОбработчикОжидания("КопироватьСсылкуВБуфер", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСсылку(Команда)
	
	Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда
		
		Закрыть();
		ОтправитьПлатежнуюСсылку();
	
	Иначе
		
		ОбработкаОтправки = Новый ОписаниеОповещения("ОтправитьСсылкуПослеФормирования", ЭтотОбъект);
		НачатьФормированиеПлатежнойСсылки(ОбработкаОтправки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОтправкаСсылки

&НаКлиенте
Процедура ОтправитьПлатежнуюСсылку()
	
	ШаблоныИспользуются = НастройкиШаблонов.Используется;
	
	Если ВариантОтправки = "ЭлектроннаяПочта" Тогда
		
		Если ШаблоныИспользуются И ЗначениеЗаполнено(ШаблонСообщенияЭлектроннаяПочта) Тогда
			СформироватьСообщениеДляОтправки(КонструкторПараметровОтправки(ШаблонСообщенияЭлектроннаяПочта, "Письмо"));
		Иначе
			РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(КонструкторПараметровОтправкиБезШаблона());
		КонецЕсли;
	
	ИначеЕсли ВариантОтправки = "Телефон" Тогда
		
		Если ШаблоныИспользуются И ЗначениеЗаполнено(ШаблонСообщенияТелефон) Тогда
			СформироватьСообщениеДляОтправки(КонструкторПараметровОтправки(ШаблонСообщенияТелефон, "СообщениеSMS"));
		Иначе
			ПоказатьФормуСообщения(Новый Структура("Текст, Получатель, ДополнительныеПараметры", 
				ПлатежнаяСсылка, СписокПолучателей()), "СообщениеSMS", ОснованиеПлатежа);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСсылкуПослеФормирования(Результат, ДопПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда
		
		Закрыть();
		ОтправитьПлатежнуюСсылку();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КонструкторПараметровОтправки(Шаблон, ВидСообщения)
	
	ПараметрыОтправки = Новый Структура();
	ПараметрыОтправки.Вставить("Шаблон", Шаблон);
	ПараметрыОтправки.Вставить("Предмет", ОснованиеПлатежа);
	ПараметрыОтправки.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтправки.Вставить("ДополнительныеПараметры", Новый Структура);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПреобразовыватьHTMLДляФорматированногоДокумента", Истина);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ВидСообщения", ВидСообщения);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПроизвольныеПараметры", Новый Соответствие);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ОтправитьСразу", Ложь);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПлатежнаяСсылка", ПлатежнаяСсылка);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("КонтактныеДанныеЧека", КонтактныеДанныеЧека());
	
	Возврат ПараметрыОтправки;
	
КонецФункции

&НаКлиенте
Функция КонструкторПараметровОтправкиБезШаблона()
	
	ПараметрыСообщения = Новый Структура;
	
	ПараметрыСообщения.Вставить("Получатель", СписокПолучателей());
	ПараметрыСообщения.Вставить("Предмет", ОснованиеПлатежа);
	ПараметрыСообщения.Вставить("ПлатежнаяСсылка", ПлатежнаяСсылка);
	ПараметрыСообщения.Вставить("Тема", НСтр("ru = 'Ссылка для оплаты'"));
	
	Если ОтправлятьПисьмаВФорматеHTML() Тогда
		ПараметрыСообщения.Вставить("Текст", Новый Структура("ТекстHTML, СтруктураВложений",
			СтрШаблон(ТекстПисьмаБезШаблонаHTML(), ПлатежнаяСсылка), Новый Структура()));
	Иначе
		ПараметрыСообщения.Вставить("Текст", СтрШаблон(ТекстПисьмаБезШаблонаТекст(), ПлатежнаяСсылка));
	КонецЕсли;
	
	ИнтеграцияСЯндексКассойКлиентПереопределяемый.ЗаполнитьПараметрыСообщенияБезШаблона(ПараметрыСообщения);
	
	Возврат ПараметрыСообщения;
	
КонецФункции

&НаКлиенте
Процедура СформироватьСообщениеДляОтправки(ПараметрыОтправки)
	
	Результат = СформироватьСообщениеНаСервере(ПараметрыОтправки);
	
	ПоказатьФормуСообщения(Результат, ПараметрыОтправки.ДополнительныеПараметры.ВидСообщения, ПараметрыОтправки.Предмет);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьСообщениеНаСервере(ПараметрыОтправки)
	
	МодульШаблоныСообщенийСлужебный = ОбщегоНазначения.ОбщийМодуль("ШаблоныСообщений");
	
	Результат = МодульШаблоныСообщенийСлужебный.
		СформироватьСообщение(
			ПараметрыОтправки.Шаблон, 
			ПараметрыОтправки.Предмет, 
			ПараметрыОтправки.УникальныйИдентификатор, 
			ПараметрыОтправки.ДополнительныеПараметры);

	Вложения = Новый Массив;
	
	Для каждого ЭлементКоллекции Из Результат.Вложения Цикл
		
		ТекущееВложение = Новый Структура;
		
		ТекущееВложение.Вставить("Представление");
		ТекущееВложение.Вставить("АдресВоВременномХранилище");
		ТекущееВложение.Вставить("Кодировка");
		ТекущееВложение.Вставить("Идентификатор");
		
		ЗаполнитьЗначенияСвойств(ТекущееВложение, ЭлементКоллекции);
		
		Вложения.Добавить(ТекущееВложение);
		
	КонецЦикла;		
	
	Результат.Вложения = Вложения;
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьФормуСообщения(Сообщение, ВидСообщения, Предмет)
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда 
			
			ДополнительныеПараметры = Новый Структура("ИсточникКонтактнойИнформации, ПеревестиВТранслит");
			
			Если Сообщение.ДополнительныеПараметры <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, Сообщение.ДополнительныеПараметры);
			КонецЕсли;
			
			ДополнительныеПараметры.ИсточникКонтактнойИнформации = Предмет;
			Текст  = ?(Сообщение.Свойство("Текст"), Сообщение.Текст, "");
			
			Получатели = Новый Массив;
			
			ЗаполнитьПолучателейИзСообщения(Получатели, Сообщение);
			
			МодульОтправкаSMSКлиент= ОбщегоНазначенияКлиент.ОбщийМодуль("ОтправкаSMSКлиент");
			
			МодульОтправкаSMSКлиент.ОтправитьSMS(Получатели, Текст, ДополнительныеПараметры);
			
		Иначе
			КопироватьСсылкуВБуфер();
		КонецЕсли;
	Иначе
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(Сообщение);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПолучателейИзСообщения(Получатели, Сообщение)
	
	Если Не Сообщение.Свойство("Получатель") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Сообщение.Получатель) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЭлементКоллекции Из Сообщение.Получатель Цикл
		
		КонтактныеДанные = Новый Структура;
		
		КонтактныеДанные.Вставить("Телефон",                      ЭлементКоллекции.Значение);
		КонтактныеДанные.Вставить("Представление",                ЭлементКоллекции.Представление);
		КонтактныеДанные.Вставить("ИсточникКонтактнойИнформации", Неопределено);
		
		Получатели.Добавить(КонтактныеДанные);

	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтправлятьПисьмаВФорматеHTML()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		Возврат ПолучитьФункциональнуюОпцию("ОтправлятьПисьмаВФорматеHTML");
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции


&НаКлиенте
Функция ТекстПисьмаБезШаблонаHTML()
	
	HTMLСтрока = 
	
	"<html>
	|<head>
	|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
	|<meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"" />
	|<meta name=""format-detection"" content=""telephone=no"" />
	|</head>
	|<body>
	|<p>Ссылка для оплаты: <a href=""%1"">%1</a></p>
	|
	|</body>
	|</html>";
	
	Возврат СтрШаблон(НСтр("ru = '%1'"), HTMLСтрока);
		
КонецФункции

&НаКлиенте
Функция ТекстПисьмаБезШаблонаТекст()
	
	Возврат НСтр("ru = 'Ссылка для оплаты: %1'");
		
КонецФункции

&НаСервере
Функция СписокПолучателей()
	
	СписокПолучателей = Новый СписокЗначений;
	
	ИнтеграцияСЯндексКассойПереопределяемый.ПриФормированииСпискаПолучателейСообщения(ОснованиеПлатежа, ВариантОтправки, СписокПолучателей);
	
	Возврат СписокПолучателей;
	
КонецФункции

#КонецОбласти

#Область РаботаССервисом

&НаКлиенте
Процедура ЗаполнитьДанныеОснованияПлатежаВСервисе()
	
	ИмяМетода = "ДанныеОснованияПлатежаВСервисе";
	
	ВходящиеПараметры = Новый Структура;
	ВходящиеПараметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	ВходящиеПараметры.Вставить("НастройкаЯндексКассы", НастройкаЯндексКассы);
	
	ДлительнаяОперация = ВыполнитьМетодСервисаВФоне(ИмяМетода, ВходящиеПараметры, УникальныйИдентификатор);
	
	ОжидатьЗавершенияМетодаСервиса(ИмяМетода, ДлительнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеОснованияПлатежаВСервисе() 
	
	Если ДанныеОснованияПлатежаВСервисе = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОснованияПлатежаВСервисеОбработаны = Истина;
	
	Если ДанныеОснованияПлатежаВСервисе.Статус <> "Новый" Тогда
		
		ПлатежнаяСсылка = ДанныеОснованияПлатежаВСервисе.ПлатежнаяСсылка;
		
		КонтактныеДанныеЭлектронногоЧека = ДанныеОснованияПлатежаВСервисе.КонтактныеДанныеЭлектронногоЧека;
		УстановитьВариантДоставкиЧека(КонтактныеДанныеЭлектронногоЧека);
		
		Если ДанныеОснованияПлатежаВСервисе.Статус = "НеОплачен" Тогда
			Если ОснованиеПлатежаИзменено(ОснованиеПлатежа, ДанныеОснованияПлатежаВСервисе) Тогда
				ТребуетсяОбновлениеДанныхВСервисе = Истина;
			КонецЕсли; 
		КонецЕсли; 
		
	КонецЕсли;
	
	УправлениеЭлементамиФормыПоДанным();
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьФормированиеПлатежнойСсылки(Знач ОписаниеОповещения = Неопределено)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьВозможностьФормированияПлатежнойСсылки() Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = "ПлатежнаяСсылка";
	
	ВходящиеПараметры = Новый Структура;
	ВходящиеПараметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	ВходящиеПараметры.Вставить("НастройкаЯндексКассы", НастройкаЯндексКассы);
	ВходящиеПараметры.Вставить("КонтактныеДанныеЧека", КонтактныеДанныеЧека());
	
	ДлительнаяОперация = ВыполнитьМетодСервисаВФоне(ИмяМетода, ВходящиеПараметры, УникальныйИдентификатор);
	
	ОжидатьЗавершенияМетодаСервиса(ИмяМетода, ДлительнаяОперация, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСсылкуВБуфер()
		
	ЭтотОбъект.БуферОбмена = СтрШаблон(
	
	"<!DOCTYPE html>
	|<html>
	|	<body onload='copy()'>
	|		<input id='input' type='text'/>
	|		<script>
	|			function copy() {
	|				var text = '%1';
	|				var ua = navigator.userAgent;
	|				if (ua.search(/MSIE/) > 0 || ua.search(/Trident/) > 0) {
	|					window.clipboardData.setData('Text', text);
	|				} else {
	|					var copyText = document.getElementById('input');
	|					copyText.value = text;
	|					copyText.select();
	|					document.execCommand('copy');
	|				}
	|			}
	|		</script>
	|	</body>
	|</html>", ПлатежнаяСсылка);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Ссылка получена'"),, 
		НСтр("ru = 'Ссылка для оплаты через ЮKassa скопирована в буфер обмена'"));
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОснованиеПлатежаИзменено(Знач ОснованиеПлатежа, Знач ДанныеОснованияПлатежаВСервисе)
	
	ВходящиеПараметры = Новый Структура;
	ВходящиеПараметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	ВходящиеПараметры.Вставить("ДанныеОснованияПлатежаВСервисе", ДанныеОснованияПлатежаВСервисе);
	
	Возврат ИнтеграцияСЯндексКассойСлужебный.ОснованиеПлатежаИзменено(ВходящиеПараметры);
	
КонецФункции

&НаКлиенте
Функция ПроверитьВозможностьФормированияПлатежнойСсылки(Знач ВыводитьСообщение = Истина) 

	Проверено = Истина;
	СообщенияОбОшибках = Новый Массив;
	
	КонтактныеДанныеЧека = КонтактныеДанныеЧека();
	
	Если НастройкаЯндексКассы.ОтправкаЧековЧерезЯндекс Тогда
		
		Если ЗначениеЗаполнено(КонтактныеДанныеЧека) Тогда
			
			Если ВариантДоставкиЧека = "ЭлектроннаяПочта"
				И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(КонтактныеДанныеЧека) Тогда
				
				Проверено = Ложь;
				СообщенияОбОшибках.Добавить(НСтр("ru = 'Некорректный адрес доставки электронного чека'"));
				
			КонецЕсли;
			
		Иначе
		
			Проверено = Ложь;
			
			Если ВариантДоставкиЧека = "ЭлектроннаяПочта" Тогда
				СообщенияОбОшибках.Добавить(НСтр("ru = 'Не указан адрес доставки электронного чека'"));
			ИначеЕсли ВариантДоставкиЧека = "Телефон" Тогда	
				СообщенияОбОшибках.Добавить(НСтр("ru = 'Не указан номер телефона для доставки электронного чека'"));	
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Проверено И ВыводитьСообщение Тогда
		Для каждого Сообщение Из СообщенияОбОшибках Цикл
			ОбщегоНазначенияКлиент.СообщитьПользователю(Сообщение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Проверено;

КонецФункции

#КонецОбласти

#Область РаботаССервисомВФоне

&НаСервереБезКонтекста
Функция ВыполнитьМетодСервисаВФоне(Знач ИмяМетода, Знач ВходящиеПараметры, Знач ИдентификаторФормы)
	
	ДлительнаяОперация = ИнтеграцияСЯндексКассойСлужебный.ВыполнитьМетодСервисаВФоне(ИмяМетода, ВходящиеПараметры, ИдентификаторФормы);
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаКлиенте
Процедура ОжидатьЗавершенияМетодаСервиса(Знач ИмяМетода, Знач ДлительнаяОперация, Знач ОписаниеОповещения = Неопределено) 
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ИмяМетода", ИмяМетода);
	ДопПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения("МетодСервисаЗавершение", ЭтотОбъект, ДопПараметры);
	
	Элементы.ДекорацияДлительнаяОперация.Видимость = Истина;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ДлительнаяОперацияЗавершение, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура МетодСервисаЗавершение(Знач Результат, Знач ДопПараметры) Экспорт
	
	Элементы.ДекорацияДлительнаяОперация.Видимость = Ложь;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
		Возврат;
	КонецЕсли;
	
	РезультатМетода = РезультатФоновогоЗаданияИзВременногоХранилища(Результат.АдресРезультата);
	
	Если ДопПараметры.ИмяМетода = "ПлатежнаяСсылка" Тогда
		
		ПлатежнаяСсылка = РезультатМетода.ПлатежнаяСсылка;
		МагазинПодключен = Не РезультатМетода.ОтсутствуетДоступ;
		
		Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда
			ТребуетсяОбновлениеДанныхВСервисе = Ложь;
			ТребуетсяОбновлениеКонтактнойИнформацииВСервисе = Ложь;
		КонецЕсли;
		
		УправлениеЭлементамиФормыПоДанным();
		
	ИначеЕсли ДопПараметры.ИмяМетода = "ДанныеОснованияПлатежаВСервисе" Тогда
		
		ДанныеОснованияПлатежаВСервисе = РезультатМетода;
		МагазинПодключен = Не РезультатМетода.ОтсутствуетДоступ;
		
		ОбработатьДанныеОснованияПлатежаВСервисе();
		
	КонецЕсли;
	
	Для каждого Сообщение Из Результат.Сообщения Цикл
		Сообщение.Сообщить();
	КонецЦикла;
	
	Если ДопПараметры.Свойство("ОписаниеОповещения") Тогда
		Если ДопПараметры.ОписаниеОповещения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДопПараметры.ОписаниеОповещения, РезультатМетода);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РезультатФоновогоЗаданияИзВременногоХранилища(Адрес)
	
	Результат = ПолучитьИзВременногоХранилища(Адрес);
	УдалитьИзВременногоХранилища(Адрес);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область КонтактнаяИнформация

&НаСервере
Процедура УстановитьВариантДоставкиЧека(КонтактныеДанныеЭлектронногоЧека)
	
	ЭтоАдресЭлектроннойПочты = ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(КонтактныеДанныеЭлектронногоЧека);
	
	Если ЭтоАдресЭлектроннойПочты Тогда
		
		ДоставкаЧекаЭлектроннаяПочта = КонтактныеДанныеЭлектронногоЧека;
		ВариантДоставкиЧека = "ЭлектроннаяПочта";
			
	Иначе
		
		ДоставкаЧекаТелефон = ТелефонВСтрокуВнутр(КонтактныеДанныеЭлектронногоЧека);
		ВариантДоставкиЧека = "Телефон";
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиКонтактнойИнформации()
	
	КонтактнаяИнформация = ИнтеграцияСЯндексКассойСлужебный.КонтактнаяИнформацияОснованияПлатежа(ОснованиеПлатежа);
	
	Для Каждого Телефон Из КонтактнаяИнформация.Телефоны Цикл
		
		Элементы.ДоставкаЧекаТелефон.СписокВыбора.Добавить(ТелефонВСтрокуВнутр(Телефон), Телефон);
		
	КонецЦикла;
	
	Для Каждого ЭлектроннаяПочта Из КонтактнаяИнформация.ЭлектроннаяПочта Цикл
		
		Элементы.ДоставкаЧекаЭлектроннаяПочта.СписокВыбора.Добавить(ЭлектроннаяПочта);
		
	КонецЦикла;
	
	ВариантДоставкиЧека = "ЭлектроннаяПочта";
	
	Если Элементы.ДоставкаЧекаТелефон.СписокВыбора.Количество() > 0 Тогда
		
		ДоставкаЧекаТелефон = Элементы.ДоставкаЧекаТелефон.СписокВыбора[0].Значение;
		Элементы.ДоставкаЧекаТелефон.КнопкаВыпадающегоСписка = Истина;
		ВариантДоставкиЧека = "Телефон";
		
	КонецЕсли;
	
	Если Элементы.ДоставкаЧекаЭлектроннаяПочта.СписокВыбора.Количество() > 0 Тогда
		
		ДоставкаЧекаЭлектроннаяПочта = Элементы.ДоставкаЧекаЭлектроннаяПочта.СписокВыбора[0].Значение;
		Элементы.ДоставкаЧекаЭлектроннаяПочта.КнопкаВыпадающегоСписка = Истина;
		ВариантДоставкиЧека = "ЭлектроннаяПочта";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КонтактныеДанныеЧека()
	
	КонтактныеДанныеЧека = "";
	
	Если НастройкаЯндексКассы.ОтправкаЧековЧерезЯндекс Тогда
		
		Если ВариантДоставкиЧека = "ЭлектроннаяПочта" 
			И ЗначениеЗаполнено(ДоставкаЧекаЭлектроннаяПочта) Тогда
			
			КонтактныеДанныеЧека = ДоставкаЧекаЭлектроннаяПочта;
			
		КонецЕсли; 
		
		Если ВариантДоставкиЧека = "Телефон" 
			И ЗначениеЗаполнено(ДоставкаЧекаТелефон) Тогда
			
			КонтактныеДанныеЧека = "+7" + ТелефонВСтрокуВнутр(ДоставкаЧекаТелефон);
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	Возврат КонтактныеДанныеЧека;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Функция ТелефонВСтрокуВнутр(Знач Телефон)
	
	СтрокаТелефона = "";
	Числа = "0123456789";
	
	ДлинаПредставленияТелефона = СтрДлина(Телефон);
	Для Индекс = 1 По ДлинаПредставленияТелефона Цикл
		
		Символ = Сред(Телефон, Индекс, 1);
		Если СтрНайти(Числа, Символ) > 0 Тогда
			СтрокаТелефона = СтрокаТелефона + Символ;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Прав(СтрокаТелефона, 10);
	
КонецФункции

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормыПоПодсистемам(КлючПоложенияОкна = "")
	
	ЕстьЭлектроннаяПочта = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями");
	ЕстьОтправкаSMS = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS");
	ИспользуютсяШаблоны = НастройкиШаблонов.Используется;
	
	ЕстьВыборВариантаОтправки = ЕстьЭлектроннаяПочта И ЕстьОтправкаSMS;
	
	Элементы.ГруппаВариантОтправкиЭлектроннаяПочта.Видимость = ЕстьЭлектроннаяПочта;
	Элементы.НадписьВариантОтправкиЭлектроннаяПочта.Видимость = Не ЕстьВыборВариантаОтправки;
	Элементы.ВариантОтправкиЭлектроннаяПочта.Видимость = ЕстьВыборВариантаОтправки;
	
	Элементы.ГруппаВариантОтправкиТелефон.Видимость = ЕстьОтправкаSMS;
	Элементы.НадписьВариантОтправкиТелефон.Видимость = Не ЕстьВыборВариантаОтправки;
	Элементы.ВариантОтправкиТелефон.Видимость = ЕстьВыборВариантаОтправки;
	
	Если Не (ЕстьВыборВариантаОтправки ИЛИ ИспользуютсяШаблоны) Тогда
		
		Элементы.ГруппаВариантОтправки.Видимость = Ложь;
		Элементы.Переместить(Элементы.ОтправитьСсылку, Элементы.ГруппаСформироватьСсылку);
		Элементы.ОтправитьСсылку.Заголовок = НСтр("ru = 'Отправить покупателю'");
		
	КонецЕсли;
	
	Если Не ИспользуютсяШаблоны Тогда
		Элементы.ГруппаВариантОтправки.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ГруппаВариантОтправкиПереключатели.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ШаблонСообщенияЭлектроннаяПочта.Видимость = Ложь;
		Элементы.ШаблонСообщенияТелефон.Видимость = Ложь;
		Элементы.ДекорацияКонвертОтправка.Видимость = Ложь;
		Элементы.ДекорацияСообщенияОтправка.Видимость = Ложь;
	КонецЕсли;
	
	КлючПоложенияОкна = КлючПоложенияОкна 
		+ Строка(Элементы.ГруппаВариантОтправки.Видимость)
		+ Строка(Элементы.ГруппаВариантОтправки.Группировка)
		+ Строка(Элементы.ГруппаВариантОтправкиЭлектроннаяПочта.Видимость)
		+ Строка(Элементы.ГруппаВариантОтправкиТелефон.Видимость);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормыПоНастройкам(КлючПоложенияОкна = "")
	
	Элементы.ГруппаВариантДоставкиЧека.Видимость = НастройкаЯндексКассы.ОтправкаЧековЧерезЯндекс;
	
	КлючПоложенияОкна = КлючПоложенияОкна + Строка(Элементы.ГруппаВариантДоставкиЧека.Видимость);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормыПоДанным(КлючПоложенияОкна = "")
	
	Если Не ДанныеОснованияПлатежаВСервисеОбработаны Тогда
		
		Элементы.СформироватьСсылку.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
		Элементы.СформироватьСсылку.Заголовок = НСтр("ru = 'Ожидание ответа...'");
		
		Элементы.ДекорацияПояснениеКФорме.Заголовок = НСтр("ru = 'Ожидание ответа сервиса о текущем состоянии счета.'");
		Элементы.ДекорацияПояснениеКФорме.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
		
		Элементы.Страницы.ТолькоПросмотр = Истина;
		Элементы.СформироватьСсылку.Доступность = Ложь;
		Элементы.ОтправитьСсылку.Доступность = Ложь;
		
		Возврат;
		
	КонецЕсли;
	
	Если НастройкаЯндексКассы.СДоговором Тогда
		
		НастроитьФормуПослеПроверкиДоступа();
		
		Если Не МагазинПодключен Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Страницы.ТолькоПросмотр = Ложь;
	Элементы.СформироватьСсылку.Доступность = Истина;
	Элементы.ОтправитьСсылку.Доступность = Истина;
	
	// Управление кнопкой "Сформировать ссылку"
	
	Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда
		
		Если ТребуетсяОбновлениеДанныхВСервисе ИЛИ ТребуетсяОбновлениеКонтактнойИнформацииВСервисе Тогда
			Элементы.СформироватьСсылку.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
			Элементы.СформироватьСсылку.Доступность = Истина;
		Иначе 
			Элементы.СформироватьСсылку.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
			Элементы.СформироватьСсылку.Доступность = Ложь;
		КонецЕсли; 
		
		Элементы.СформироватьСсылку.Заголовок = НСтр("ru = 'Обновить данные'");
	Иначе
		
		Элементы.СформироватьСсылку.Доступность = Истина;
		Элементы.СформироватьСсылку.Заголовок = НСтр("ru = 'Сформировать ссылку'");
		
	КонецЕсли;
	
	// Управление заголовком формы
	
	Если ТребуетсяОбновлениеДанныхВСервисе Тогда
		Элементы.ДекорацияПояснениеКФорме.Заголовок = 
			НСтр("ru = 'Внимание! Счет был изменен после формирования ссылки для его оплаты. Требуется обновление данных.'");
		
		Элементы.ДекорацияПояснениеКФорме.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
 	
	Иначе 
		
		Если ДанныеОснованияПлатежаВСервисе.Статус = "Оплачен" Тогда
			Элементы.ДекорацияПояснениеКФорме.Заголовок = 
				НСтр("ru = 'Ссылка для оплаты счета была сформирована и отправлена покупателю. Счет оплачен.'");
		ИначеЕсли ДанныеОснованияПлатежаВСервисе.Статус = "ОплаченОжиданиеЧека" Тогда		
			Элементы.ДекорацияПояснениеКФорме.Заголовок = 
				НСтр("ru = 'Ссылка для оплаты счета была сформирована и отправлена покупателю. Счет оплачен. Ожидается доставка чека.'");
		Иначе 
			Если ЗначениеЗаполнено(ПлатежнаяСсылка) Тогда // Ссылка сформирована
				Элементы.ДекорацияПояснениеКФорме.Заголовок = 
					НСтр("ru = 'Ссылка для оплаты счета сформирована и готова к отправке покупателю.'");
			Иначе 
				Если НЕ НастройкаЯндексКассы.ОтправкаЧековЧерезЯндекс Тогда
					Элементы.ДекорацияПояснениеКФорме.Заголовок = 
						НСтр("ru = 'Сформируйте ссылку для оплаты счета и отправьте ее покупателю.'");
				Иначе 
					Элементы.ДекорацияПояснениеКФорме.Заголовок = 
						НСтр("ru = 'Выберите способ доставки электронного чека, сформируйте ссылку для оплаты счета и отправьте ее покупателю.'");
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
		
		Элементы.ДекорацияПояснениеКФорме.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
		
	КонецЕсли;
	
	Если ДанныеОснованияПлатежаВСервисе.Статус = "Оплачен"
		ИЛИ ДанныеОснованияПлатежаВСервисе.Статус = "ОплаченОжиданиеЧека" Тогда
		
		Элементы.Страницы.ТолькоПросмотр = Истина;
		Элементы.СформироватьСсылку.Доступность = Ложь;
		Элементы.ОтправитьСсылку.Доступность = Ложь;
		
		Элементы.ДекорацияПояснениеКФорме.ЦветФона = ЦветаСтиля.ЦветФонаПодсказки;
		Элементы.ДекорацияПояснениеКФорме.ЦветТекста = Новый Цвет;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиФормы

&НаСервереБезКонтекста
Процедура СохранитьШаблоныПоУмолчанию(ОснованиеПлатежа, ШаблонСообщенияЭлектроннаяПочта, ШаблонСообщенияТелефон)
				
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОснованиеПлатежа)) Тогда
		ПредставлениеОснования = ОснованиеПлатежа.Метаданные().ПолноеИмя();	
	Иначе
		ПредставлениеОснования = ОснованиеПлатежа;
	КонецЕсли;
	
	// Шаблоны электронной почты
	
	КлючНастроек = "ШаблоныСообщенийЭлектроннойПочты";
	
	Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ФормаПодготовкиПлатежнойСсылки", КлючНастроек);
	
	Если Настройки = Неопределено Тогда
		ШаблоныПоУмолчанию = Новый Соответствие();
	Иначе
		ШаблоныПоУмолчанию = Настройки;
	КонецЕсли;
	
	ШаблоныПоУмолчанию.Вставить(ПредставлениеОснования, ШаблонСообщенияЭлектроннаяПочта);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ФормаПодготовкиПлатежнойСсылки", КлючНастроек, ШаблоныПоУмолчанию);
	
	// Шаблоны SMS сообщений
	
	КлючНастроек = "ШаблоныСообщенийSMS";
	
	Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ФормаПодготовкиПлатежнойСсылки", КлючНастроек);
	
	Если Настройки = Неопределено Тогда
		ШаблоныПоУмолчанию = Новый Соответствие();
	Иначе
		ШаблоныПоУмолчанию = Настройки;
	КонецЕсли;
	
	ШаблоныПоУмолчанию.Вставить(ПредставлениеОснования, ШаблонСообщенияТелефон);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ФормаПодготовкиПлатежнойСсылки", КлючНастроек, ШаблоныПоУмолчанию);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьШаблоныПоУмолчанию()
	
	Если НастройкиШаблонов.Используется 	
		И ЗначениеЗаполнено(ОснованиеПлатежа) Тогда
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОснованиеПлатежа)) Тогда
			ПредставлениеОснования = ОснованиеПлатежа.Метаданные().ПолноеИмя();	
		Иначе
			ПредставлениеОснования = ОснованиеПлатежа;
		КонецЕсли;
		
		// Шаблоны электронной почты
		
		Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ФормаПодготовкиПлатежнойСсылки", "ШаблоныСообщенийЭлектроннойПочты");
		
		Если Настройки <> Неопределено
			И ТипЗнч(Настройки) = Тип("Соответствие")
			И Настройки[ПредставлениеОснования] <> Неопределено Тогда
			
			ШаблонСообщенияЭлектроннаяПочта = Настройки[ПредставлениеОснования];
			
		КонецЕсли;
		
		// Шаблоны SMS сообщений
		
		Настройки = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ФормаПодготовкиПлатежнойСсылки", "ШаблоныСообщенийSMS");
		
		Если Настройки <> Неопределено
			И ТипЗнч(Настройки) = Тип("Соответствие")
			И Настройки[ПредставлениеОснования] <> Неопределено Тогда
			
			ШаблонСообщенияТелефон = Настройки[ПредставлениеОснования];
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура НастроитьФормуПослеПроверкиДоступа()
	
	Если Не МагазинПодключен Тогда
		
		Если ИнтеграцияСЯндексКассойСлужебный.ЕстьПравоИзмененияНастроек() Тогда
			Элементы.ДекорацияПояснениеКФорме.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
				НСтр("ru = 'Истек период доступа к ЮKassa. Необходимо повторно <a href = ""ОткрытьНастройку"">предоставить доступ</a>'"));
		Иначе
			Элементы.ДекорацияПояснениеКФорме.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
				НСтр("ru = 'Истек период доступа к ЮKassa. Необходимо повторно предоставить доступ. Обратитесь к администратору'"));
		КонецЕсли;
		
		Элементы.ДекорацияПояснениеКФорме.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
		
	КонецЕсли;
	
	Элементы.КартинкаПредупреждение.Видимость      = Не МагазинПодключен;
	Элементы.ГруппаВариантДоставкиЧека.Доступность = МагазинПодключен;
	Элементы.ГруппаПлатежнаяСсылка.Доступность     = МагазинПодключен;
	Элементы.ГруппаВариантОтправки.Доступность     = МагазинПодключен;
	Элементы.Справка.Видимость                     = МагазинПодключен;
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуЯндексКассы()
	
	ПараметрыФормы = ИнтеграцияСЯндексКассойСлужебныйКлиент.ОписаниеПараметровФормыНастройкиЯндексКассы();
	
	ПараметрыФормы.Ключ = НастройкаЯндексКассы.Ссылка;
	ПараметрыФормы.ОткрытьСтраницуПодключенияКассы = Истина;
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияФормыНастроек", ЭтотОбъект);
	
	ИнтеграцияСЯндексКассойСлужебныйКлиент.ОткрытьФормуНастроекЯндексКассы(ПараметрыФормы, ЭтотОбъект, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыНастроек(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	МагазинПодключен = Результат.МагазинПодключен;
	
	УправлениеЭлементамиФормыПоДанным();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

