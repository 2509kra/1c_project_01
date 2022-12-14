
&НаСервере
Процедура ПечатьНаСервере(ТабДок)
	Макет = РегистрыСведений.АЭС_СписокАнкет.ПолучитьМакет("Макет");
	ОбластьЛист1 = Макет.ПолучитьОбласть("Лист1");
	ОбластьЛист2 = Макет.ПолучитьОбласть("Лист2");
	ОбластьЛист1.Параметры.ФизЛицо						= Запись.ФизЛицо;
	ОбластьЛист1.Параметры.Гражданство					= Запись.Гражданство;
	ОбластьЛист1.Параметры.ДатаРождения 				= Формат(ДатаРождения,"ДФ=dd.MM.yyyy");
	ОбластьЛист1.Параметры.МестоРождения				= Запись.МестоРождения;
	ОбластьЛист1.Параметры.АдресРегистрации				= АдресРегистрации;
	ОбластьЛист1.Параметры.АдресФактическогоПроживания	= АдресФактическогоПроживания;
	ОбластьЛист1.Параметры.ПаспортныеДанные				= "" + ВидДокумента + " Серия:" + Серия + " Номер:" + Номер + " Дата выдачи:" + Формат(ДатаВыдачи,"ДФ=dd.MM.yyyy") + " Код подразделения:" + КодПодразделения + " Кем выдан:"+КемВыдан;
	ОбластьЛист1.Параметры.ДанныеМиграционнойКарты		= "" + ВидМиграционногоДокумента + ?(ЗначениеЗаполнено(СерияМиграционнойКарты), " Серия:" + СерияМиграционнойКарты, "") + ?(ЗначениеЗаполнено(НомерМиграционнойКарты), " Номер:" + НомерМиграционнойКарты,"") + ?(ЗначениеЗаполнено(ДатаНачала)," Начало срока:" + Формат(ДатаНачала,"ДФ=dd.MM.yyyy"),"") + ?(ЗначениеЗаполнено(ДатаОкончания)," Окончание срока:" + Формат(ДатаОкончания,"ДФ=dd.MM.yyyy"),"");
	ОбластьЛист1.Параметры.ДанныеДокументаПребывания    = Запись.ДанныеДокументаПребывания;
	ОбластьЛист1.Параметры.ИНН							= ИНН;
	ОбластьЛист1.Параметры.НомерПФР						= Запись.Сведения;
	ОбластьЛист1.Параметры.ГосДолжностьРФ				= Запись.ГосДолжностьРФ;
	ОбластьЛист1.Параметры.Телефон						= Телефон;
	ОбластьЛист1.Параметры.СведенияОПредставителе		= Запись.СведенияОПредставителе;
	ОбластьЛист1.Параметры.ИностранноеПубличноеЛицо 	= Запись.ИностранноеПубличноеЛицо;
	ОбластьЛист1.Параметры.Сведения1					= Запись.Сведения1;

	ТабДок.Вывести(ОбластьЛист1);
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	
	ОбластьЛист2.Параметры.НаличиеВПеречне				= "" + ?(ЗначениеЗаполнено(Запись.НомерПеречня),"Номер " + Запись.НомерПеречня,"Отсутствует")  + ?(ЗначениеЗаполнено(Запись.ДатаПеречня), " Дата " + Формат(Запись.ДатаПеречня,"ДФ=dd.MM.yyyy"),"");
	ОбластьЛист2.Параметры.НаличиеВСписке               = "" + ?(ЗначениеЗаполнено(Запись.НомерСписка),"Номер " + Запись.НомерСписка,"Отсутствует")  + ?(ЗначениеЗаполнено(Запись.ДатаСписка), " Дата " + Формат(Запись.ДатаСписка,"ДФ=dd.MM.yyyy"),"");
	ОбластьЛист2.Параметры.НаличиеВПеречне3				= "" + ?(ЗначениеЗаполнено(Запись.НомерПеречня3),"Номер " + Запись.НомерПеречня3,"Отсутствует")  + ?(ЗначениеЗаполнено(Запись.ДатаПеречня3), " Дата " + Формат(Запись.ДатаПеречня3,"ДФ=dd.MM.yyyy"),"");
	ОбластьЛист2.Параметры.ИностранноеПубличноеЛицо		= Запись.СведенияОбИнастранномПубличномЛице;
	ОбластьЛист2.Параметры.ГосударсвоНеФАТФ				= Запись.ГосударсвоНеФАТФ;
	ОбластьЛист2.Параметры.ДатаНачДоговора				= Запись.ДатаНачДоговора;
	ОбластьЛист2.Параметры.ДатаКонДоговора				= Запись.ДатаКонДоговора;
	ОбластьЛист2.Параметры.ПринятыеМеры					= Запись.ПринятыеМеры;
	ОбластьЛист2.Параметры.Сотрудник					= Запись.Сотрудник;
	ОбластьЛист2.Параметры.ДатаЗаполненияАнкеты			= Запись.ДатаЗаполненияАнкеты;
	ОбластьЛист2.Параметры.ДатаОбновленияАнкеты			= Запись.ДатаОбновленияАнкеты;
	ОбластьЛист2.Параметры.Отвественный					= Запись.Отвественный;
	ОбластьЛист2.Параметры.ИныеСведения					= Запись.ИныеСведения;
	ОбластьЛист2.Параметры.СтепеньРиска					= Запись.СтепеньРиска;
	ОбластьЛист2.Параметры.Сведения2					= Запись.Сведения2;
	ОбластьЛист2.Параметры.Сведения3					= Запись.Сведения3;
	ОбластьЛист2.Параметры.Сведения4					= Запись.Сведения4;
	ОбластьЛист2.Параметры.Сведения5					= Запись.Сведения5;

	ТабДок.Вывести(ОбластьЛист2);
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ТабДок = Новый ТабличныйДокумент;
	ПечатьНаСервере(ТабДок);
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("АнкетаПроверки");
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок; 
    КоллекцияПечатныхФорм[0].Экземпляров=1;
    КоллекцияПечатныхФорм[0].СинонимМакета = "Анкета проверки";
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Запись.ФизЛицо) Тогда
		ЗаполнитьДанныеПоФизЛицу();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Запись.Сотрудник) Тогда
		Запись.Сотрудник = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Запись.Отвественный) Тогда
		Запись.Отвественный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.ДатаЗаполненияАнкеты) Тогда
		Запись.ДатаЗаполненияАнкеты = ТекущаяДата();
	КонецЕсли;
	Если не ЗначениеЗаполнено(Запись.ДатаОбновленияАнкеты) Тогда
		Запись.ДатаОбновленияАнкеты = ТекущаяДата();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоФизЛицу()
	ФИО				= Запись.ФизЛицо.Наименование;
	ДатаРождения	= Запись.ФизЛицо.ДатаРождения;
	ИНН				= Запись.ФизЛицо.ИНН;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ФизическиеЛицаКонтактнаяИнформация.Представление КАК Представление,
	               |	ФизическиеЛицаКонтактнаяИнформация.Страна КАК Страна,
	               |	ФизическиеЛицаКонтактнаяИнформация.Тип КАК Тип,
	               |	ФизическиеЛицаКонтактнаяИнформация.Вид КАК Вид
	               |ИЗ
	               |	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	               |ГДЕ
	               |	ФизическиеЛицаКонтактнаяИнформация.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Запись.ФизЛицо);
		
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
			Если Выборка.Вид = Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица Тогда
				АдресРегистрации = Выборка.Представление;
			ИначеЕсли Выборка.Вид = Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица Тогда
				АдресФактическогоПроживания = Выборка.Представление;
			КонецЕсли;
		ИначеЕсли Выборка.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			Если Выборка.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица Тогда
				Телефон = Выборка.Представление;
			КонецЕсли;
		КонецЕсли;	
		Если Не ЗначениеЗаполнено(Запись.Гражданство) и ЗначениеЗаполнено(Выборка.Страна) Тогда
			Попытка
				Запись.Гражданство = Справочники.СтраныМира[Выборка.Страна];
			Исключение
				Запись.Гражданство = Справочники.СтраныМира.НайтиПоНаименованию(Выборка.Страна);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДокументыФизическихЛицСрезПоследних.ВидДокумента КАК ВидДокумента,
	               |	ДокументыФизическихЛицСрезПоследних.Серия КАК Серия,
	               |	ДокументыФизическихЛицСрезПоследних.Номер КАК Номер,
	               |	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи КАК ДатаВыдачи,
	               |	ДокументыФизическихЛицСрезПоследних.КемВыдан КАК КемВыдан,
	               |	ДокументыФизическихЛицСрезПоследних.КодПодразделения КАК КодПодразделения,
	               |	ДокументыФизическихЛицСрезПоследних.СрокДействия КАК СрокДействия,
	               |	ДокументыФизическихЛицСрезПоследних.ЯвляетсяДокументомУдостоверяющимЛичность КАК ДокументУдостоверяющимЛичность
	               |ИЗ
	               |	РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(&Дата, Физлицо = &Физлицо) КАК ДокументыФизическихЛицСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.УстановитьПараметр("Физлицо", Запись.ФизЛицо);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДокументУдостоверяющимЛичность Или ЗначениеЗаполнено(Выборка.КемВыдан) Или ЗначениеЗаполнено(Выборка.КодПодразделения) Тогда
		    ВидДокумента	= Выборка.ВидДокумента;
			Серия			= Выборка.Серия;
			Номер			= Выборка.Номер;
			ДатаВыдачи		= Выборка.ДатаВыдачи;
			КодПодразделения= Выборка.КодПодразделения;
			КемВыдан		= Выборка.КемВыдан;
		Иначе
			ВидМиграционногоДокумента	= Выборка.ВидДокумента;
			НомерМиграционнойКарты		= Выборка.Номер;
			СерияМиграционнойКарты		= Выборка.Серия;
			ДатаНачала					= Выборка.ДатаВыдачи;
			ДатаОкончания				= Выборка.СрокДействия;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	АЭС_СписокАнкет.ФизЛицо КАК ФизЛицо,
	               |	АЭС_СписокАнкет.ID КАК ID,
	               |	АЭС_СписокАнкет.НаличиеВПеречне КАК НаличиеВПеречне,
	               |	АЭС_СписокАнкет.НаличиеВСписке КАК НаличиеВСписке,
	               |	АЭС_СписокАнкет.Сотрудник КАК Сотрудник,
	               |	АЭС_СписокАнкет.Отвественный КАК Отвественный,
	               |	АЭС_СписокАнкет.Гражданство КАК Гражданство,
	               |	АЭС_СписокАнкет.МестоРождения КАК МестоРождения,
	               |	АЭС_СписокАнкет.ИностранноеПубличноеЛицо КАК ИностранноеПубличноеЛицо,
	               |	АЭС_СписокАнкет.ГосДолжностьРФ КАК ГосДолжностьРФ,
	               |	АЭС_СписокАнкет.СведенияОПредставителе КАК СведенияОПредставителе,
	               |	АЭС_СписокАнкет.ГосударсвоНеФАТФ КАК ГосударсвоНеФАТФ,
	               |	АЭС_СписокАнкет.ДатаНачДоговора КАК ДатаНачДоговора,
	               |	АЭС_СписокАнкет.ДатаКонДоговора КАК ДатаКонДоговора,
	               |	АЭС_СписокАнкет.ПринятыеМеры КАК ПринятыеМеры,
	               |	АЭС_СписокАнкет.ДатаЗаполненияАнкеты КАК ДатаЗаполненияАнкеты,
	               |	АЭС_СписокАнкет.ДатаОбновленияАнкеты КАК ДатаОбновленияАнкеты,
	               |	АЭС_СписокАнкет.ИныеСведения КАК ИныеСведения,
	               |	АЭС_СписокАнкет.СтепеньРиска КАК СтепеньРиска,
	               |	АЭС_СписокАнкет.НомерПеречня КАК НомерПеречня,
	               |	АЭС_СписокАнкет.ДатаПеречня КАК ДатаПеречня,
	               |	АЭС_СписокАнкет.НомерСписка КАК НомерСписка,
	               |	АЭС_СписокАнкет.ДатаСписка КАК ДатаСписка
	               |ИЗ
	               |	РегистрСведений.АЭС_СписокАнкет КАК АЭС_СписокАнкет
	               |ГДЕ
	               |	АЭС_СписокАнкет.ФизЛицо = &ФизЛицо";
	
	Запрос.УстановитьПараметр("ФизЛицо", Запись.ФизЛицо);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ПоискФизЛица()
	Заполнено = ЗаполненыВсеПоляПоиска();
	Если Заполнено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ДокументыФизическихЛицСрезПоследних.Физлицо КАК Физлицо
		|ИЗ
		|	РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
		|			&Дата,
		|			Физлицо.Наименование = &Наименование
		|				И ВидДокумента = &ВидДокумента
		|				И Серия = &Серия
		|				И Номер = &Номер
		|				И Физлицо.ДатаРождения = &ДатаРождения) КАК ДокументыФизическихЛицСрезПоследних";
		
		Запрос.УстановитьПараметр("Дата", ТекущаяДата());
		Запрос.УстановитьПараметр("Наименование", ФИО);
		Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
		Запрос.УстановитьПараметр("Серия", Серия);
		Запрос.УстановитьПараметр("Номер", Номер);
		Запрос.УстановитьПараметр("ДатаРождения", ДатаРождения);
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Запись.ФизЛицо = Выборка.Физлицо;	
			ЗаполнитьДанныеПоФизЛицу();
		ИначеЕсли Не ЗначениеЗаполнено(Запись.ФизЛицо) Тогда
			СоздатьФизЛицо();
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Запись.ФизЛицо) Тогда
		ЗаполнитьДанныеПоФизЛицу();		
	КонецЕсли;
	Если Заполнено Тогда
		ПоискВПеречне();
	Иначе
	    Запись.НаличиеВПеречне = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица");
	ВводКонтактнойИнформации(Вид, Элемент.ТекстРедактирования);

КонецПроцедуры

&НаКлиенте
Процедура ВводКонтактнойИнформации(Вид, ТекстРедактирования)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",Запись.ФизЛицо);
	ФормаФизЛица = ПолучитьФорму("Справочник.ФизическиеЛица.ФормаОбъекта",ПараметрыФормы,ЭтотОбъект);
	Отбор = Новый Структура;
	Отбор.Вставить("Вид",  Вид);
	ДанныеСтроки = ФормаФизЛица.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор)[0];
	
	мЭлемент = ФормаФизЛица.Элементы.Найти(ДанныеСтроки.ИмяРеквизита);
	
	ПараметрыКонтактнойИнформации = ФормаФизЛица.ПараметрыКонтактнойИнформации[ДанныеСтроки.ИмяЭлементаДляРазмещения];
	ДанныеЗаполнения = ФормаФизЛица;

	Результат = Новый Структура;
	Результат.Вставить("ИмяРеквизита", мЭлемент.Имя);
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ВидКонтактнойИнформации", ДанныеСтроки.Вид);
	ПараметрыОткрытияФормы.Вставить("ЗначенияПолей",  "");//ДанныеСтроки.ЗначенияПолей);
	ПараметрыОткрытияФормы.Вставить("Представление",  ТекстРедактирования);
	ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", Ложь);
	ПараметрыОткрытияФормы.Вставить("ТипПомещения",   ПараметрыКонтактнойИнформации.ПараметрыАдреса.ТипПомещения);
	ПараметрыОткрытияФормы.Вставить("Страна",         ПараметрыКонтактнойИнформации.ПараметрыАдреса.Страна);
	ПараметрыОткрытияФормы.Вставить("Индекс",         ПараметрыКонтактнойИнформации.ПараметрыАдреса.Индекс);
	ПараметрыОткрытияФормы.Вставить("КонтактнаяИнформацияОписаниеДополнительныхРеквизитов", ФормаФизЛица.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов);
	ПараметрыОткрытияФормы.Вставить("ОткрытаПоСценарию", Истина);
	
	Оповещение = Новый ОписаниеОповещения("ПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеЗаполнения",        ДанныеЗаполнения);
	Оповещение.ДополнительныеПараметры.Вставить("ЭтоТабличнаяЧасть",       Ложь);
	Оповещение.ДополнительныеПараметры.Вставить("ИмяЭлементаРазмещения",   ДанныеСтроки.ИмяЭлементаДляРазмещения);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеСтроки",            ДанныеСтроки);
	Оповещение.ДополнительныеПараметры.Вставить("Элемент",                 мЭлемент);
	Оповещение.ДополнительныеПараметры.Вставить("Результат",               Результат);
	Оповещение.ДополнительныеПараметры.Вставить("Форма",                   ФормаФизЛица);
	Оповещение.ДополнительныеПараметры.Вставить("ОбновитьКонтекстноеМеню", Ложь);
	
	ОткрытьФорму("Обработка.ВводКонтактнойИнформации.Форма", ПараметрыОткрытияФормы, Неопределено,,,, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеНачалоВыбораЗавершение(Знач РезультатЗакрытия, Знач ДополнительныеПараметры) Экспорт
	Если Не РезультатЗакрытия = Неопределено Тогда
		ОбновитьКонтактнуюИнформацию(РезультатЗакрытия);	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьКонтактнуюИнформацию(РезультатЗакрытия)
	ФизЛицоОбъект = Запись.ФизЛицо.ПолучитьОбъект();
	ДанныеСтроки = ФизЛицоОбъект.КонтактнаяИнформация.Найти(РезультатЗакрытия.Вид);
	Если ДанныеСтроки = Неопределено Тогда 
		ДанныеСтроки = ФизЛицоОбъект.КонтактнаяИнформация.Добавить();
		ДанныеСтроки.Вид = РезультатЗакрытия.Вид;
		ДанныеСтроки.Тип = РезультатЗакрытия.Тип;
		ДанныеСтроки.Страна = Запись.Гражданство;
	КонецЕсли;
	ДанныеСтроки.Представление = РезультатЗакрытия.Представление;
	ДанныеСтроки.ЗначенияПолей = РезультатЗакрытия.КонтактнаяИнформация;
	
	ФизЛицоОбъект.Записать();
	ЗаполнитьДанныеПоФизЛицу();
КонецПроцедуры

&НаСервере 
Функция ЗаполненыВсеПоляПоиска()
	Если ЗначениеЗаполнено(ВидДокумента) И
		ЗначениеЗаполнено(Серия) И
		ЗначениеЗаполнено(Номер) И 
		ЗначениеЗаполнено(ФИО) И
		ЗначениеЗаполнено(ДатаРождения)Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ДоступностьВводаАндреса()
	Зполнено = ЗаполненыВсеПоляПоиска();
	Если Зполнено Тогда
		Элементы.АдресРегистрации.ТолькоПросмотр = Ложь;
		Элементы.АдресФактическогоПроживания.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.АдресРегистрации.ТолькоПросмотр = Истина;
		Элементы.АдресФактическогоПроживания.ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДоступностьВводаАндреса();
	Если Запись.ИностранноеПубличноеЛицо Тогда
		Элементы.СведенияОбИнастранномПубличномЛице.Доступность = Истина;
	Иначе
		Элементы.СведенияОбИнастранномПубличномЛице.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	ДоступностьВводаАндреса();
	ПоискФизЛица();
	НаличиеВПеречнеПриИзменении(Неопределено);
	ВидМиграционногоДокументаПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СерияПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Серия) Тогда
		ТекстОшибки = "";
		Отказ = Не ДокументыФизическихЛицКлиентСервер.СерияДокументаУказанаПравильно(ВидДокумента, Серия, ТекстОшибки);
		Если Не ПустаяСтрока(ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Серия");
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	Если Не Отказ Тогда 
		ДоступностьВводаАндреса();
		ПоискФизЛица();
		НаличиеВПеречнеПриИзменении(Неопределено);
	Иначе
		Запись.НаличиеВПеречне = Ложь;		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Номер) Тогда
		ТекстОшибки = "";
		Отказ = Не ДокументыФизическихЛицКлиентСервер.НомерДокументаУказанПравильно(ВидДокумента, Номер, ТекстОшибки);
		Если Не ПустаяСтрока(ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Номер");
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	Если Не Отказ Тогда
		ДоступностьВводаАндреса();
		ПоискФизЛица();
		НаличиеВПеречнеПриИзменении(Неопределено);
	Иначе
		Запись.НаличиеВПеречне = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыдачиПриИзменении(Элемент)
	ДоступностьВводаАндреса();
КонецПроцедуры

&НаКлиенте
Процедура ФИОПриИзменении(Элемент)
	ПоискФизЛица();
	ДоступностьВводаАндреса();
	НаличиеВПеречнеПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ДатаРожденияПриИзменении(Элемент)
	ПоискФизЛица();
	ДоступностьВводаАндреса();
	НаличиеВПеречнеПриИзменении(Неопределено);
КонецПроцедуры

&НаСервере
Процедура СоздатьФизЛицо()
	ФизЛицоОбъект = Справочники.ФизическиеЛица.СоздатьЭлемент();
	ФизЛицоОбъект.Наименование 	= ФИО;
	ФизЛицоОбъект.ДатаРождения 	= ДатаРождения;
	ФизЛицоОбъект.ИНН 			= ИНН;
	ФизЛицоОбъект.Записать();
	Запись.ФизЛицо = ФизЛицоОбъект.Ссылка;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПаспортныеДанные()
	НаборЗаписей = РегистрыСведений.ДокументыФизическихЛиц.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ФизЛицо.Установить(Запись.ФизЛицо);
	НаборЗаписей.Отбор.ВидДокумента.Установить(ВидДокумента);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период 										= ТекущаяДата();
	НоваяЗапись.Физлицо										= Запись.ФизЛицо;
	НоваяЗапись.ВидДокумента								= ВидДокумента;
	НоваяЗапись.Серия										= Серия;
	НоваяЗапись.Номер										= Номер;
	НоваяЗапись.ДатаВыдачи									= ДатаВыдачи;
	НоваяЗапись.КодПодразделения							= КодПодразделения;
	НоваяЗапись.КемВыдан									= КемВыдан;
	НоваяЗапись.ЯвляетсяДокументомУдостоверяющимЛичность	= Истина;
	НаборЗаписей.Записать();
	
	Если ЗначениеЗаполнено(ВидМиграционногоДокумента) Тогда
		НаборЗаписей = РегистрыСведений.ДокументыФизическихЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ФизЛицо.Установить(Запись.ФизЛицо);
		НаборЗаписей.Отбор.ВидДокумента.Установить(ВидМиграционногоДокумента);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период = ТекущаяДата();
		НоваяЗапись.Физлицо			= Запись.ФизЛицо;
		НоваяЗапись.ВидДокумента	= ВидМиграционногоДокумента;
		НоваяЗапись.Серия			= СерияМиграционнойКарты;
		НоваяЗапись.Номер			= НомерМиграционнойКарты;
		НоваяЗапись.ДатаВыдачи		= ДатаНачала;
		НоваяЗапись.СрокДействия	= ДатаОкончания;
		НаборЗаписей.Записать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресФактическогоПроживанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица");
	ВводКонтактнойИнформации(Вид, Элемент.ТекстРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ТелефонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица");
	ВводКонтактнойИнформации(Вид, Элемент.ТекстРедактирования);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ЗаписатьПаспортныеДанные();
	ПовторнаяЗаписьДанныхФизЛица();
	Запись.Отвественный			= Пользователи.ТекущийПользователь();
	Запись.ДатаОбновленияАнкеты = ТекущаяДата();
КонецПроцедуры

&НаСервере 
Процедура ПовторнаяЗаписьДанныхФизЛица()
	ФизЛицоОбъект = Запись.ФизЛицо.ПолучитьОбъект();
	ФизЛицоОбъект.Наименование	= ФИО;
	ФизЛицоОбъект.ДатаРождения	= ДатаРождения;
	ФизЛицоОбъект.ИНН			= ИНН;
	ФизЛицоОбъект.Записать();
КонецПроцедуры

&НаСервере
Функция ПоискВПеречне()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	АЭС_СписокЭкстремистовСрезПоследних.ID КАК ID,
	               |	АЭС_СписокЭкстремистовСрезПоследних.Перечень КАК Перечень,
	               |	АЭС_СписокЭкстремистовСрезПоследних.НомерПеречня КАК НомерПеречня,
	               |	АЭС_СписокЭкстремистовСрезПоследних.ДатаПеречня КАК ДатаПеречня,
	               |	АЭС_СписокЭкстремистовСрезПоследних.Признак КАК Признак
	               |ИЗ
	               |	РегистрСведений.АЭС_СписокЭкстремистов.СрезПоследних(&Дата, ) КАК АЭС_СписокЭкстремистовСрезПоследних
	               |ГДЕ
	               |	(АЭС_СписокЭкстремистовСрезПоследних.Наименование ПОДОБНО &Наименование
	               |				И АЭС_СписокЭкстремистовСрезПоследних.ПаспортныеДанные ПОДОБНО &ПаспортныеДанные
	               |			ИЛИ АЭС_СписокЭкстремистовСрезПоследних.ПаспортныеДанные ПОДОБНО &ПаспортныеДанные)";
	
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.УстановитьПараметр("Наименование", ФИО);
	ПаспртныеДанные = "%"+СтрЗаменить(Серия," ","")+"%" + Номер + "%";
	Запрос.УстановитьПараметр("ПаспортныеДанные", ПаспртныеДанные);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда 
		Запись.ID				= Выборка.ID;
		Запись.Признак			= Выборка.Признак;
		Если Выборка.Перечень =1 Тогда
			Запись.НаличиеВПеречне	= Истина;
			Запись.НомерПеречня		= Выборка.НомерПеречня;
			Запись.ДатаПеречня		= Выборка.ДатаПеречня;
			Запись.НаличиеВСписке	= Ложь;
			Запись.НомерСписка		= "";
			Запись.ДатаСписка		= "00010101";
			Запись.НаличиеВПеречне3	= Ложь;
			Запись.НомерПеречня3	= "";
			Запись.ДатаПеречня3		= "00010101";
		ИначеЕсли Выборка.Перечень =2 Тогда
			Запись.НаличиеВПеречне	= Ложь;
			Запись.НомерПеречня		= "";
			Запись.ДатаПеречня		= "00010101";
			Запись.НаличиеВСписке	= Истина;
			Запись.НомерСписка		= Выборка.НомерПеречня;
			Запись.ДатаСписка		= Выборка.ДатаПеречня;
			Запись.НаличиеВПеречне3 = Ложь;
			Запись.НомерПеречня3	= "";
			Запись.ДатаПеречня3		= "00010101";
		Иначе
			Запись.НаличиеВПеречне	= Ложь;
			Запись.НомерПеречня		= "";
			Запись.ДатаПеречня		= "00010101";
			Запись.НаличиеВСписке	= Ложь;
			Запись.НомерСписка		= "";
			Запись.ДатаСписка		= "00010101";
			Запись.НаличиеВПеречне3 = Истина;
			Запись.НомерПеречня3	= Выборка.НомерПеречня;
			Запись.ДатаПеречня3		= Выборка.ДатаПеречня;
		КонецЕсли;
	Иначе 
		Запись.ID				= "";
		Запись.НаличиеВПеречне	= Ложь;
		Запись.НомерПеречня		= "";
		Запись.ДатаПеречня		= "00010101";
		Запись.НаличиеВСписке	= Ложь;
		Запись.НомерСписка		= "";
		Запись.ДатаСписка		= "00010101";
		Запись.НаличиеВПеречне3 = Ложь;
		Запись.НомерПеречня3	= "";
		Запись.ДатаПеречня3		= "00010101";
		Запись.ПринятыеМеры		= "Отсутствует"
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПредупреждениеЗавершение(Результат, ДополнительныеПараметры)Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура НаличиеВПеречнеПриИзменении(Элемент)
	Если Запись.НаличиеВПеречне ИЛИ Запись.НаличиеВСписке ИЛИ Запись.НаличиеВПеречне3 Тогда
		Оповещение = Новый ОписаниеОповещения("ПредупреждениеЗавершение", ЭтотОбъект);
		ТекстВопроса = "Информация о плательщике " + ФИО + " найдена в базе экстримистов"; 
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОК);  
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Попытка
		ЗаполнитьДанныеСпискаПродаж();
	Исключение
		Отказ = Истина;
	КонецПопытки;
	НаборЗаписей = РегистрыСведений.АЭС_СписокАнкет.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ФизЛицо.Установить(Запись.ФизЛицо);
	НаборЗаписей.Отбор.ID.Установить(Запись.ID);
	НаборЗаписей.Отбор.НаличиеВПеречне.Установить(Запись.НаличиеВПеречне);
	НаборЗаписей.Отбор.Сотрудник.Установить(Запись.Сотрудник);
	НаборЗаписей.Отбор.Отвественный.Установить(Запись.Отвественный);
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьДанныеСпискаПродаж()
	Если ЗначениеЗаполнено(ДокументПродажи) Тогда 
		НаборЗаписей = РегистрыНакопления.АЭС_СписокПлатежей_ФМ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ДокументПродажи);
		НаборЗаписей.Прочитать();
		Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
			ЗаписьНабора.ФизЛицо = Запись.ФизЛицо;
		КонецЦикла;
		НаборЗаписей.Записать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаличиеВСпискеПриИзменении(Элемент)
	Если Запись.НаличиеВСписке Тогда
		Оповещение = Новый ОписаниеОповещения("ПредупреждениеЗавершение", ЭтотОбъект);
		ТекстВопроса = "Информация о плательщике " + ФИО + " найдена в базе экстримистов"; 
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОК);  
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидМиграционногоДокументаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ВидДокумента) и ВидДокумента = ВидМиграционногоДокумента Тогда
		Оповещение = Новый ОписаниеОповещения("ПредупреждениеЗавершение", ЭтотОбъект);
		ТекстВопроса = "Вид миграционного документа совпадает с видом документа удостоверяющеголичность"; 
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОК);
		ВидМиграционногоДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИностранноеПубличноеЛицоПриИзменении(Элемент)
	Если Запись.ИностранноеПубличноеЛицо Тогда
		Элементы.СведенияОбИнастранномПубличномЛице.Доступность = Истина;
	Иначе
		Элементы.СведенияОбИнастранномПубличномЛице.Доступность = Ложь;
		Запись.СведенияОбИнастранномПубличномЛице = "";
	КонецЕсли;
КонецПроцедуры
