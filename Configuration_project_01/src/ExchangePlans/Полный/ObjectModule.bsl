#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ГлПоставщикиЗаданийПартионногоУчета;
Перем ГлПоставщикиЗаданийВзаиморасчетовСКлиентами;
Перем ГлПоставщикиЗаданийВзаиморасчетовСПоставщиками;
Перем ГлЗаказыДляОтражения;
Перем ГлДанныеДляСозданияПерерасчетаСебестоимости;
Перем ГлДанныеДляСозданияЗаданийВзаиморасчетовСКлиентами;
Перем ГлДанныеДляСозданияЗаданийВзаиморасчетовСПоставщиками;

Перем ГлКонтактыВзаимодействия;
Перем ГлПредметыВзаимодействия;
Перем ГлПапкиВзаимодействия;

Перем ГлДанныеДляФормированияЗаписейКнигиПокупокПродаж;
Перем ГлПоставщикиЗаданийКФормированиюЗаписейКнигиПокупокПродаж;

Перем ГлДокументыКОтражениюВРеестре;
Перем ГлДокументыКУдалениюИзРеестра;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриПолученииДанныхОтПодчиненного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад)
	
	Если ТипЗнч(ЭлементДанных) <> Тип("УдалениеОбъекта") Тогда
		
		МетаДанныеЭлементаДанных = ЭлементДанных.Метаданные();
		
		Если ГлПоставщикиЗаданийПартионногоУчета[МетаДанныеЭлементаДанных] <> Неопределено Тогда
			ГлДанныеДляСозданияПерерасчетаСебестоимости.Добавить(ЭлементДанных);
		КонецЕсли;
		
		СтруктураМВТ = Новый Структура(); 
		СтруктураМВТ.Вставить("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц);
		
		СтруктураВТ = Новый Структура();
		СтруктураВТ.Вставить("СтруктураВременныеТаблицы", СтруктураМВТ);
		
		Если ГлПоставщикиЗаданийВзаиморасчетовСКлиентами.Найти(ТипЗнч(ЭлементДанных)) <> Неопределено
			Или ГлПоставщикиЗаданийВзаиморасчетовСПоставщиками.Найти(ТипЗнч(ЭлементДанных)) <> Неопределено Тогда
			
			ЭлементДанных.ДополнительныеСвойства.Вставить("ДляПроведения",    СтруктураВТ);
			ЭлементДанных.ДополнительныеСвойства.Вставить("ДатаРегистратора", КонецДня(ТекущаяДатаСеанса()));
			ЭлементДанных.ДополнительныеСвойства.Вставить("РежимЗаписи",      РежимЗаписиДокумента.Запись);
			
			Если ГлПоставщикиЗаданийВзаиморасчетовСКлиентами.Найти(ТипЗнч(ЭлементДанных)) <> Неопределено Тогда
				ГлДанныеДляСозданияЗаданийВзаиморасчетовСКлиентами.Добавить(ЭлементДанных);
			Иначе
				ГлДанныеДляСозданияЗаданийВзаиморасчетовСПоставщиками.Добавить(ЭлементДанных);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ГлПоставщикиЗаданийКФормированиюЗаписейКнигиПокупокПродаж.Найти(МетаДанныеЭлементаДанных) <> Неопределено Тогда
			Если ОбщегоНазначения.ЭтоРегистр(МетаДанныеЭлементаДанных) Тогда
				ЭлементДанных.ДополнительныеСвойства.Вставить("ДляПроведения", СтруктураВТ);
			ИначеЕсли ОбщегоНазначения.ЭтоДокумент(МетаДанныеЭлементаДанных) Тогда
				ГлДанныеДляФормированияЗаписейКнигиПокупокПродаж.Добавить(ЭлементДанных);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ПриПолученииДанныхФайла(ЭлементДанных);
	
КонецПроцедуры

Процедура ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад)
	
	Если ТипЗнч(ЭлементДанных) <> Тип("УдалениеОбъекта") Тогда
		
		СтруктураМВТ = Новый Структура(); 
		СтруктураМВТ.Вставить("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц);
		
		СтруктураВТ = Новый Структура();
		СтруктураВТ.Вставить("СтруктураВременныеТаблицы", СтруктураМВТ);
		
		Если ГлПоставщикиЗаданийВзаиморасчетовСКлиентами.Найти(ТипЗнч(ЭлементДанных)) <> Неопределено
			Или ГлПоставщикиЗаданийВзаиморасчетовСПоставщиками.Найти(ТипЗнч(ЭлементДанных)) <> Неопределено Тогда
			
			ЭлементДанных.ДополнительныеСвойства.Вставить("ДляПроведения",    СтруктураВТ);
			ЭлементДанных.ДополнительныеСвойства.Вставить("ДатаРегистратора", КонецДня(ТекущаяДатаСеанса()));
			ЭлементДанных.ДополнительныеСвойства.Вставить("РежимЗаписи",      РежимЗаписиДокумента.Запись);
			
			Если ГлПоставщикиЗаданийВзаиморасчетовСКлиентами.Найти(ТипЗнч(ЭлементДанных)) <> Неопределено Тогда
				ГлДанныеДляСозданияЗаданийВзаиморасчетовСКлиентами.Добавить(ЭлементДанных);
			Иначе
				ГлДанныеДляСозданияЗаданийВзаиморасчетовСПоставщиками.Добавить(ЭлементДанных);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПриПолученииДанныхФайла(ЭлементДанных);
	
КонецПроцедуры

Процедура ПриОтправкеДанныхГлавному(ЭлементДанных, ОтправкаЭлемента)
	
	Если ОтправкаЭлемента <> ОтправкаЭлементаДанных.Удалить 
		И ТипЗнч(ЭлементДанных) <> Тип("УдалениеОбъекта")
		И ТипЗнч(ЭлементДанных) = Тип("РегистрНакопленияНаборЗаписей.ПартииТоваровОрганизаций") Тогда
		
		ПереопределитьНаборЗаписей(ЭлементДанных, Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиСервер.НадоВыполнитьОбработчикПослеЗагрузкиДанных(ЭтотОбъект, Ссылка) Тогда
		
		ПослеЗагрузкиДанных();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Переопределяет стандартное поведение при загрузке данных;
//
Процедура ПриПолученииДанныхФайла(ЭлементДанных)
	
	ТипПолучаемогоОбъекта = ТипЗнч(ЭлементДанных);
	
	Если ТипЗнч(ЭлементДанных) = Тип("УдалениеОбъекта") Тогда
		ТипЭлементаДанных = ТипЗнч(ЭлементДанных.Ссылка);
		Если ГлДокументыКУдалениюИзРеестра.Найти(ТипЭлементаДанных) = Неопределено
			И РегистрыСведений.РеестрДокументов.ОбъектВключенВСоставДанныхРеестра(ЭлементДанных.Ссылка) Тогда
			ГлДокументыКУдалениюИзРеестра.Добавить(ТипЭлементаДанных);
		КонецЕсли;
	Иначе
		МетаДанныеЭлементаДанных = ЭлементДанных.Метаданные();
		Если ГлДокументыКОтражениюВРеестре.Получить(МетаДанныеЭлементаДанных) = Неопределено
			И РегистрыСведений.РеестрДокументов.ОбъектВключенВСоставДанныхРеестра(ЭлементДанных) Тогда
			ГлДокументыКОтражениюВРеестре.Вставить(МетаДанныеЭлементаДанных);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипПолучаемогоОбъекта = Тип("СправочникОбъект.СегментыНоменклатуры")
		Или ТипПолучаемогоОбъекта = Тип("СправочникОбъект.СегментыПартнеров")
		Или ТипПолучаемогоОбъекта = Тип("СправочникОбъект.ПравилаНачисленияИСписанияБонусныхБаллов")
		Или ТипПолучаемогоОбъекта = Тип("СправочникОбъект.ПроверкиСостоянияСистемы")
		Или ТипПолучаемогоОбъекта = Тип("СправочникОбъект.ВидыОповещенийКлиентам") Тогда
		
		Если Не ЭлементДанных.ЭтоГруппа Тогда
			Если ТипПолучаемогоОбъекта = Тип("СправочникОбъект.ПроверкиСостоянияСистемы") Тогда
				ИмяРеквизита = "РегламентноеЗаданиеGUID";
			Иначе
				ИмяРеквизита = "РегламентноеЗадание";
			КонецЕсли;
			ЭлементДанных[ИмяРеквизита] = ПолучитьРеглЗаданияЭтойИБ(ЭлементДанных, ИмяРеквизита);
		КонецЕсли;
		
	ИначеЕсли ТипПолучаемогоОбъекта = Тип("СправочникОбъект.ДополнительныеОтчетыИОбработки") Тогда
		
		Если ОбщегоНазначения.СсылкаСуществует(ЭлементДанных.Ссылка) И Не ЭлементДанных.ЭтоГруппа Тогда
			Запрос = Новый Запрос;
			Запрос.Текст =
				"ВЫБРАТЬ
				|	ДополнительныеОтчетыИОбработкиКоманды.РегламентноеЗаданиеGUID КАК РегламентноеЗадание
				|ИЗ
				|	Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
				|ГДЕ
				|	ДополнительныеОтчетыИОбработкиКоманды.Ссылка = &Ссылка";
			
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				СтрокаИдентификатора = ЭлементДанных.Команды.Найти(Выборка.РегламентноеЗадание, "РегламентноеЗаданиеGUID");
				Если СтрокаИдентификатора <> Неопределено Тогда
					СтрокаИдентификатора.РегламентноеЗаданиеGUID =
						ИдентификаторСуществующегоРегламентногоЗадания(Выборка.РегламентноеЗадание);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ТипПолучаемогоОбъекта = Тип("РегистрСведенийНаборЗаписей.НастройкиАдресныхСкладов") Тогда
		
		Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	НастройкиАдресныхСкладовНовая.Склад,
			|	НастройкиАдресныхСкладовНовая.Помещение,
			|	НастройкиАдресныхСкладовНовая.ГлубинаАнализа,
			|	НастройкиАдресныхСкладовНовая.МинимальнаяВероятностьОтгрузки,
			|	НастройкиАдресныхСкладовНовая.УровеньОбслуживанияУпаковокКлассаX,
			|	НастройкиАдресныхСкладовНовая.УровеньОбслуживанияУпаковокКлассаY,
			|	НастройкиАдресныхСкладовНовая.УровеньОбслуживанияУпаковокКлассаZ,
			|	НастройкиАдресныхСкладовНовая.ИспользоватьАдресноеХранение,
			|	НастройкиАдресныхСкладовНовая.ИспользоватьАдресноеХранениеСправочно,
			|	НастройкиАдресныхСкладовНовая.ИспользоватьРабочиеУчастки,
			|	НастройкиАдресныхСкладовНовая.НастройкаФормированияПоРабочимУчасткамОтбор,
			|	НастройкиАдресныхСкладовНовая.ОграничиватьПоВесуОтбор,
			|	НастройкиАдресныхСкладовНовая.ОграничиватьПоОбъемуОтбор,
			|	НастройкиАдресныхСкладовНовая.ОграничениеПоОбъемуОтбор,
			|	НастройкиАдресныхСкладовНовая.ОграничениеПоВесуОтбор,
			|	НастройкиАдресныхСкладовНовая.РабочийУчастокОтбор
			|ПОМЕСТИТЬ ВТ_НовыйНаборЗаписей
			|ИЗ
			|	&ТаблицаНабораЗаписей КАК НастройкиАдресныхСкладовНовая
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТ_НовыйНаборЗаписей.Склад КАК Склад,
			|	ВТ_НовыйНаборЗаписей.Помещение КАК Помещение,
			|	ВТ_НовыйНаборЗаписей.ГлубинаАнализа,
			|	ВТ_НовыйНаборЗаписей.МинимальнаяВероятностьОтгрузки,
			|	ВТ_НовыйНаборЗаписей.УровеньОбслуживанияУпаковокКлассаX,
			|	ВТ_НовыйНаборЗаписей.УровеньОбслуживанияУпаковокКлассаY,
			|	ВТ_НовыйНаборЗаписей.УровеньОбслуживанияУпаковокКлассаZ,
			|	ВТ_НовыйНаборЗаписей.ИспользоватьАдресноеХранение,
			|	ВТ_НовыйНаборЗаписей.ИспользоватьАдресноеХранениеСправочно,
			|	ВТ_НовыйНаборЗаписей.ИспользоватьРабочиеУчастки,
			|	ВТ_НовыйНаборЗаписей.НастройкаФормированияПоРабочимУчасткамОтбор,
			|	ВТ_НовыйНаборЗаписей.ОграничиватьПоВесуОтбор,
			|	ВТ_НовыйНаборЗаписей.ОграничиватьПоОбъемуОтбор,
			|	ВТ_НовыйНаборЗаписей.ОграничениеПоОбъемуОтбор,
			|	ВТ_НовыйНаборЗаписей.ОграничениеПоВесуОтбор,
			|	ВТ_НовыйНаборЗаписей.РабочийУчастокОтбор,
			|	ЕСТЬNULL(НастройкиАдресныхСкладов.РегламентноеЗаданиеРасчетаПоказателейПрогноза, &ПустойИдентификатор) КАК РегламентноеЗаданиеРасчетаПоказателейПрогноза,
			|	ЕСТЬNULL(НастройкиАдресныхСкладов.РегламентноеЗаданиеСозданиеЗаданийНаОтбор, &ПустойИдентификатор) КАК РегламентноеЗаданиеСозданиеЗаданийНаОтбор,
			|	ЕСТЬNULL(НастройкиАдресныхСкладов.РегламентныеЗаданияСозданияЗаданийНаПересчетТоваров, """") КАК РегламентныеЗаданияСозданияЗаданийНаПересчетТоваров,
			|	ВЫБОР
			|		КОГДА НастройкиАдресныхСкладов.РегламентноеЗаданиеСозданиеЗаданийНаОтбор ЕСТЬ NULL 
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ НастройкиАдресныхСкладов.ИспользоватьРегламентноеЗаданиеСозданияЗаданийНаОтбор
			|	КОНЕЦ КАК ИспользоватьРегламентноеЗаданиеСозданияЗаданийНаОтбор
			|ИЗ
			|	ВТ_НовыйНаборЗаписей КАК ВТ_НовыйНаборЗаписей
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
			|		ПО ВТ_НовыйНаборЗаписей.Склад = НастройкиАдресныхСкладов.Склад
			|			И ВТ_НовыйНаборЗаписей.Помещение = НастройкиАдресныхСкладов.Помещение");
			
		Запрос.УстановитьПараметр("ТаблицаНабораЗаписей", ЭлементДанных.Выгрузить());
		Запрос.УстановитьПараметр("ПустойИдентификатор",  Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
		
		Результат = Запрос.Выполнить().Выгрузить();
		ЭлементДанных.Загрузить(Результат);
	
	ИначеЕсли ТипПолучаемогоОбъекта = Тип("РегистрСведенийНаборЗаписей.КонтактыВзаимодействий") Тогда
		
		КонтактВзаимодействия = ЭлементДанных.Отбор.Контакт.Значение;
		
		Если ГлКонтактыВзаимодействия.Найти(КонтактВзаимодействия) = Неопределено Тогда
			ГлКонтактыВзаимодействия.Добавить(КонтактВзаимодействия);
		КонецЕсли;
		
	ИначеЕсли ТипПолучаемогоОбъекта = Тип("РегистрСведенийНаборЗаписей.ПредметыПапкиВзаимодействий") Тогда
		
		ГлПредметыВзаимодействия = ОбменДаннымиУТУП.ОбъединитьМассивы(ГлПредметыВзаимодействия,ЭлементДанных.ВыгрузитьКолонку("Предмет"));
		ГлПапкиВзаимодействия    = ОбменДаннымиУТУП.ОбъединитьМассивы(ГлПапкиВзаимодействия,   ЭлементДанных.ВыгрузитьКолонку("ПапкаЭлектронногоПисьма"));
		
	ИначеЕсли ТипЗнч(ЭлементДанных) = Тип("ДокументОбъект.ЗаказКлиента")
		Или ТипЗнч(ЭлементДанных) = Тип("ДокументОбъект.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		
		ГлЗаказыДляОтражения.Добавить(ЭлементДанных.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗагрузкиДанных()
	
	Справочники.КлючиАналитикиУчетаНоменклатуры.ЗаменитьДублиКлючейАналитики();
	Справочники.КлючиАналитикиУчетаПоПартнерам.ЗаменитьДублиКлючейАналитики();
	Справочники.КлючиАналитикиУчетаПартий.ЗаменитьДублиКлючейАналитики();
	Справочники.ВидыЗапасов.ЗаменитьДублиВидовЗапасов();
	Справочники.КлючиАналитикиУчетаНаборов.ЗаменитьДублиКлючейАналитики();
	РегистрыСведений.УстаревшиеВидыЗапасовСОстатками.ОбновитьЗаписи();
	
	Если ГлЗаказыДляОтражения.Количество() > 0 Тогда
		РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ГлЗаказыДляОтражения, Ложь, Ложь);
	КонецЕсли;
	
	Если ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() И ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Обработки.ИсправлениеРеестраДокументов.ОчиститьНесуществующиеСсылкиВРеестреДокументов();
	ИначеЕсли ГлДокументыКУдалениюИзРеестра.Количество() > 0 Тогда
		Обработки.ИсправлениеРеестраДокументов.ОчиститьНесуществующиеСсылкиВРеестреДокументов(ГлДокументыКУдалениюИзРеестра);
	КонецЕсли;
	
	Если ГлДокументыКОтражениюВРеестре.Количество() > 0 Тогда
		РегистрыСведений.РеестрДокументов.ОтразитьДанныеДокументовВРеестре(ГлДокументыКОтражениюВРеестре);
	КонецЕсли;
	
	Для Каждого ДанныеДляПерерасчета Из ГлДанныеДляСозданияПерерасчетаСебестоимости Цикл
		ОбменДаннымиУТ.СоздатьЗаданиеКРасчетуСебестоимостиПриОбменеДанными(ДанныеДляПерерасчета);
	КонецЦикла;
	
	Для Каждого ДанныеНабора Из ГлДанныеДляСозданияЗаданийВзаиморасчетовСКлиентами Цикл
		ВзаиморасчетыСервер.ОтразитьЗаданияКРаспределениюРасчетовСКлиентами(ДанныеНабора.Отбор.Регистратор, ДанныеНабора.ДополнительныеСвойства);
	КонецЦикла;
	
	Для Каждого ДанныеНабора Из ГлДанныеДляСозданияЗаданийВзаиморасчетовСПоставщиками Цикл
		ВзаиморасчетыСервер.ОтразитьЗаданияКРаспределениюРасчетовСПоставщиками(ДанныеНабора.Отбор.Регистратор, ДанныеНабора.ДополнительныеСвойства);
	КонецЦикла;
	
	ОперативныеВзаиморасчетыСервер.ВыполнитьОтложенноеРаспределение();
	
	// Расчет состояния контактов и очистка от дублей справочника СтроковыеКонтактыВзаимодействия.
	Если ГлКонтактыВзаимодействия.Количество() > 0 Тогда
		
		Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	ОсновнойОбход.Ссылка КАК Ссылка,
			|	ПовторнаяВыборка.Ссылка КАК Дубль,
			|	ПовторнаяВыборка.ПометкаУдаления КАК ПометкаУдаления
			|ИЗ
			|	Справочник.СтроковыеКонтактыВзаимодействий КАК ОсновнойОбход
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтроковыеКонтактыВзаимодействий КАК ПовторнаяВыборка
			|		ПО ОсновнойОбход.Наименование = ПовторнаяВыборка.Наименование
			|			И (ОсновнойОбход.Ссылка <> ПовторнаяВыборка.Ссылка)
			|ГДЕ
			|	НЕ ПовторнаяВыборка.Ссылка ЕСТЬ NULL 
			|	И ОсновнойОбход.Ссылка В(&МассивПолученных)
			|		И НЕ ОсновнойОбход.ПометкаУдаления
			|
			|СГРУППИРОВАТЬ ПО
			|	ОсновнойОбход.Ссылка,
			|	ПовторнаяВыборка.Ссылка");

		Запрос.УстановитьПараметр("МассивПолученных", ГлКонтактыВзаимодействия);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			// Сформируем соответствие ссылок и дублей.
			СоответствиеЗначений = Новый Соответствие;
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Пока Выборка.Следующий() Цикл
			
				СоответствиеЗначений.Вставить(Выборка.Дубль, Выборка.Ссылка);
				
				Если Не Выборка.ПометкаУдаления Тогда
					СправочникОбъект = Выборка.Дубль.ПолучитьОбъект();
					Попытка
						СправочникОбъект.УстановитьПометкуУдаления(Истина, Ложь);
					Исключение
						ИмяСобытияЖурналРегистрации = НСтр("ru = 'Получение данных в РИБ.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
						Сообщение = НСтр("ru = 'При попытке пометить на удаление дубли элементов справочника СтроковыеКонтактыВзаимодействия произошла ошибка.
											|%1'");
						Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение,
							ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						ЗаписьЖурналаРегистрации(ИмяСобытияЖурналРегистрации, УровеньЖурналаРегистрации.Информация, , , Сообщение);
					КонецПопытки;
				КонецЕсли;
				
			КонецЦикла;
		
			ОбщегоНазначенияУТ.ЗаменитьСсылки(СоответствиеЗначений);

		КонецЕсли;
		
		// Расчет состояния контактов
		Взаимодействия.РассчитатьРассмотреноПоКонтактам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ГлКонтактыВзаимодействия, "Контакт"));
		
	КонецЕсли;
	
	// Расчет состояние предметов взаимодействия
	Если ГлПредметыВзаимодействия.Количество() > 0 Тогда
		Взаимодействия.РассчитатьРассмотреноПоПредметам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ГлПредметыВзаимодействия, "Предмет"));
	КонецЕсли;
	
	// Расчет состояния папок взаимодействия
	Если ГлПапкиВзаимодействия.Количество() > 0 Тогда
		Взаимодействия.РассчитатьРассмотреноПоПапкам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ГлПапкиВзаимодействия, "Папка"));
	КонецЕсли;
	
	Если ГлДанныеДляФормированияЗаписейКнигиПокупокПродаж.Количество() > 0 Тогда
		УчетНДСУП.СформироватьЗаданияПоДокументам(ГлДанныеДляФормированияЗаписейКнигиПокупокПродаж);
	КонецЕсли;
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		РегистрыСведений.ЗаданияКЗакрытиюМесяца.УдалитьЗаписиВПодчиненномУзлеРИБ();
	КонецЕсли;
	
КонецПроцедуры // ПослеЗагрузкиДанных()

Функция ПолучитьРеглЗаданияЭтойИБ(ЭлементДанных, ИмяРеквизита) 
	
	Если Не ОбщегоНазначения.СсылкаСуществует(ЭлементДанных.Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РеглЗаданияЭтойИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		ЭлементДанных.Ссылка, ИмяРеквизита);
		
	
	Возврат ИдентификаторСуществующегоРегламентногоЗадания(РеглЗаданияЭтойИБ);
	
КонецФункции

// Функция проверяет существование регламентного задания по переданному идентификатору.
//
// Параметры:
//   Идентификатор - строка - идентификатор регламентного задания.
//
// Возвращаемое значение:
//   Идентификатор - если регламентное задание найдено,
//   Неопределено  - если регламентное задание не найдено.
//
Функция ИдентификаторСуществующегоРегламентногоЗадания(Идентификатор)
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отбор = Новый Структура("Идентификатор", Идентификатор);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	// Проверяем, что задание найдено.
	Если Задания.Количество() <> 1 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции

Процедура ПереопределитьНаборЗаписей(ЭлементДанных, УзелПланаОбмена)
	
	Для Каждого ЗаписьНабора Из ЭлементДанных Цикл
		
		Если ПланыОбмена.ГлавныйУзел() <> Неопределено И Не ЗаписьНабора.Первичное Тогда
			ЭлементДанных.Удалить(ЗаписьНабора);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
#КонецОбласти

#Область Инициализация

ГлПоставщикиЗаданийПартионногоУчета                   = РасчетСебестоимости.ВходящиеДанныеМеханизма(, Истина);
ГлПоставщикиЗаданийВзаиморасчетовСКлиентами           = ОбменДаннымиУТУП.РегистрыДляСозданияЗаданийКРасчетуВзаиморасчетовСКлиентами();
ГлПоставщикиЗаданийВзаиморасчетовСПоставщиками        = ОбменДаннымиУТУП.РегистрыДляСозданияЗаданийКРасчетуВзаиморасчетовСПоставщиками();
ГлЗаказыДляОтражения                                  = Новый Массив;
ГлДанныеДляСозданияПерерасчетаСебестоимости           = Новый Массив;
ГлДанныеДляСозданияЗаданийВзаиморасчетовСКлиентами    = Новый Массив;
ГлДанныеДляСозданияЗаданийВзаиморасчетовСПоставщиками = Новый Массив;

ГлКонтактыВзаимодействия  = Новый Массив;
ГлПредметыВзаимодействия = Новый Массив;
ГлПапкиВзаимодействия     = Новый Массив;

ГлПоставщикиЗаданийКФормированиюЗаписейКнигиПокупокПродаж = РегистрыСведений.ЗаданияКФормированиюДвиженийПоНДС.ВходящиеДанныеМеханизма();
ГлДанныеДляФормированияЗаписейКнигиПокупокПродаж          = Новый Массив;

ГлДокументыКОтражениюВРеестре = Новый Соответствие;
ГлДокументыКУдалениюИзРеестра = Новый Массив;

#КонецОбласти

#КонецЕсли