
#Область СлужебныйПрограммныйИнтерфейс

#Область РазборКодаМаркировки

Функция ЭлементКодаМаркировкиСоответствуетОписанию(Значение, ОписаниеЭлементаКМ, СоставКодаМаркировки, ПараметрыОписанияКодаМаркировки) Экспорт
	
	Если ОписаниеЭлементаКМ.Имя = "GTIN" Тогда
		
		Если Не РазборКодаМаркировкиИССлужебныйКлиентСерверПовтИсп.ЭтоGTIN(Значение) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ЗначениеEAN = РазборКодаМаркировкиИССлужебныйКлиентСерверПовтИсп.ШтрихкодEANИзGTIN(Значение);
		
		РазборКодаМаркировкиИССлужебныйКлиентСервер.ЗаполнитьСоставКодаМаркировки(
			СоставКодаМаркировки, Новый Структура("Имя", "EAN"), ЗначениеEAN);
		
	ИначеЕсли ОписаниеЭлементаКМ.Имя = "SSCC" Тогда
		
		КонтрольноеЧисло = ШтрихкодыУпаковокКлиентСервер.КонтрольноеЧислоSSCC(Лев(Значение, ОписаниеЭлементаКМ.Длина - 1));
		
		Возврат КонтрольноеЧисло =  Число(Прав(Значение, 1));
		
	ИначеЕсли ОписаниеЭлементаКМ.Имя = "МРЦСтрокой" Тогда
		
		РезультатПроверки = РазборКодаМаркировкиИССлужебныйКлиентСерверПовтИсп.МРЦПоВидуУпаковки(Значение, ПараметрыОписанияКодаМаркировки.ВидУпаковки);
		
		Если Не РезультатПроверки.ЭтоМРЦ Тогда
			Возврат Ложь;
		КонецЕсли;
		
		РазборКодаМаркировкиИССлужебныйКлиентСервер.ЗаполнитьСоставКодаМаркировки(
			СоставКодаМаркировки, Новый Структура("Имя", "МРЦ"), РезультатПроверки.ЗначениеМРЦ);
		
		РазборКодаМаркировкиИССлужебныйКлиентСервер.ЗаполнитьСоставКодаМаркировки(
			СоставКодаМаркировки, Новый Структура("Имя", "ВключаетМРЦ"), Истина);
	
	ИначеЕсли ОписаниеЭлементаКМ.Имя = "КодПроверки" Или ОписаниеЭлементаКМ.Имя = "КлючПроверки" Тогда
		
		РазборКодаМаркировкиИССлужебныйКлиентСервер.ЗаполнитьСоставКодаМаркировки(
			СоставКодаМаркировки, Новый Структура("Имя", "ВключаетКриптоХвост"), Истина);
		
	ИначеЕсли ОписаниеЭлементаКМ.Имя = "ДатаФормированияАТК" Тогда
		
		// дата формирования оператором агрегированного таможенного кода (ДДММГГ)
		
		Год   = Прав(Значение, 2);
		Месяц = Сред(Значение, 3, 2);
		День  = Лев(Значение, 2);
		
		ДатаСтрокой = СтрШаблон("20%1%2%3", Год, Месяц, День);
		
		КвалификаторыДаты = Новый КвалификаторыДаты(ЧастиДаты.Дата);
		ОписаниеТипа      = Новый ОписаниеТипов("Дата",,, КвалификаторыДаты);
		
		ДатаФормированияАТК = ОписаниеТипа.ПривестиЗначение(ДатаСтрокой);
		
		Возврат ДатаФормированияАТК <> '00010101';
		
	ИначеЕсли ОписаниеЭлементаКМ.Имя = "ИНН" Тогда
		
		ТекстСообщения = "";
		
		Если СтрНачинаетсяС(Значение, "00") Тогда
			ИНН = Прав(Значение, 10);
			Если РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ИНН, Истина, ТекстСообщения) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
		
		Возврат РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Значение, Ложь, ТекстСообщения);
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПреобразоватьЗначениеДляЗаполненияСоставаКодаМаркировки(ПараметрыОписанияКодаМаркировки, СоставКодаМаркировки, ОписаниеЭлементаКМ, Значение) Экспорт
	
	Если СоставКодаМаркировки = Неопределено Или Не СоставКодаМаркировки.Свойство(ОписаниеЭлементаКМ.Имя) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОписаниеЭлементаКМ.Имя = "ГоденДо" Тогда
		
		Если ОписаниеЭлементаКМ.Код = "17" Тогда
			// Дата окончания срока годности продукции (срок хранения более 72 часов).
			// Формат: YYMMDD
			КвалификаторыДаты = Новый КвалификаторыДаты(ЧастиДаты.Дата);
		Иначе
			// Дата окончания срока годности продукции (срок хранения менее 72 часов)
			// Формат: YYMMDDHHMM
			КвалификаторыДаты = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
		КонецЕсли;
		
		ОписаниеТипа = Новый ОписаниеТипов("Дата",,, КвалификаторыДаты);
		Значение = ОписаниеТипа.ПривестиЗначение("20" + Значение);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоНеФормализованныйКодМаркировки(ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата, РезультатБезФильтра) Экспорт
	
	Если ПрисутствуетТабачнаяПродукция(Настройки.ДоступныеВидыПродукции) Тогда
		
		Если ЭтоНеФормализованныйКодМаркировкиГрупповойУпаковкиТабака(
				ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата, РезультатБезФильтра) Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоНеФормализованныйКодМаркировкиЛогистическойУпаковкиGS1128(
			ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата, РезультатБезФильтра) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область НастройкиРазбораКодаМаркировки

Функция НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки) Экспорт
	
	СоставКодаМаркировки = Новый Структура;
	СоставКодаМаркировки.Вставить("ВключаетИдентификаторыПрименения", Ложь);
	
	Если ТипШтрихкодаИВидУпаковки.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Потребительская")
		Или ТипШтрихкодаИВидУпаковки.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая") Тогда
		
		СоставКодаМаркировки.Вставить("GTIN",          "");
		СоставКодаМаркировки.Вставить("EAN",           "");
		СоставКодаМаркировки.Вставить("СерийныйНомер", "");
		
	ИначеЕсли ТипШтрихкодаИВидУпаковки.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Логистическая")
		И ТипШтрихкодаИВидУпаковки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.SSCC") Тогда
		
		СоставКодаМаркировки.Вставить("SSCC", "");
		
	ИначеЕсли ТипШтрихкодаИВидУпаковки.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Логистическая")
		И ТипШтрихкодаИВидУпаковки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128") Тогда
		
		СоставКодаМаркировки.Вставить("GTIN", "");
		СоставКодаМаркировки.Вставить("EAN",  "");
		СоставКодаМаркировки.Вставить("КоличествоВложенныхЕдиниц",                 Неопределено);
		СоставКодаМаркировки.Вставить("ВозможныВариантыКоличестваВложенныхЕдиниц", Ложь);
		
	ИначеЕсли ТипШтрихкодаИВидУпаковки.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.АгрегированныйТаможенныйКод") Тогда
		
		СоставКодаМаркировки.Вставить("ИНН",                 "");
		СоставКодаМаркировки.Вставить("ДатаФормирования",    "");
		СоставКодаМаркировки.Вставить("ПризнакУникальности", "");
		
	КонецЕсли;
	
	Возврат СоставКодаМаркировки;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазборКодаМаркировки

Функция ЭтоНеФормализованныйКодМаркировкиГрупповойУпаковкиТабака(ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата, РезультатБезФильтра)
	
	// После идентификатора 93 для блоков и только для них может быть произвольное количество идентификаторов применения
	// 010460620310255621!MmNZo2800514900093Ij5E240FA075486.00
	
	ШаблоныКодаМаркировкиСХвостом = Настройки.ДополнительныеПараметры.ИСМП.Табак.ШаблоныКодаМаркировкиСХвостом;
	
	Если ШаблоныКодаМаркировкиСХвостом.Количество() = 0 Тогда
		Возврат Ложь; // Учет табачной продукции не ведется
	КонецЕсли;
	
	ИсходныйКодМаркировки       = ПараметрыРазбораКодаМаркировки.КодМаркировки;
	ИсходнаяДлинаКодаМаркировки = ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки;
	ДанныеРезультата            = Неопределено;
	
	Для Каждого ШаблонКодаМаркировки Из ШаблоныКодаМаркировкиСХвостом Цикл
		
		Если ПараметрыРазбораКодаМаркировки.НачинаетсяСоСкобки Или ПараметрыРазбораКодаМаркировки.СодержитРазделительGS Тогда
			ДлинаКодаМаркировкиИзШаблона = ШаблонКодаМаркировки.ДлинаСоСкобкой;
		Иначе
			ДлинаКодаМаркировкиИзШаблона = ШаблонКодаМаркировки.Длина;
		КонецЕсли;
		
		Если ИсходнаяДлинаКодаМаркировки <= ДлинаКодаМаркировкиИзШаблона Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки = ДлинаКодаМаркировкиИзШаблона;
		
		ПараметрыРазбораКодаМаркировки.КодМаркировки = Лев(ИсходныйКодМаркировки, ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки);
		
		ДанныеРезультата = РазборКодаМаркировкиИССлужебныйКлиентСервер.КодМаркировкиСоответствуетШаблону(ПараметрыРазбораКодаМаркировки, Настройки, ШаблонКодаМаркировки);
		
		Если ДанныеРезультата = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеРезультата.КодМаркировки = ИсходныйКодМаркировки;
		ДанныеРезультата.ВидУпаковки   = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая");
		
		Если ПараметрыРазбораКодаМаркировки.РасширеннаяДетализация Тогда
			ДанныеРезультата.Детализация.ЭтоНеФормализованныйКодМаркировки = Истина;
		КонецЕсли;
		
		ПараметрыРазбораКодаМаркировки.КодМаркировки       = ИсходныйКодМаркировки;
		ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки = ИсходнаяДлинаКодаМаркировки;
		
		Возврат Истина;
		
	КонецЦикла;
	
	ПараметрыРазбораКодаМаркировки.КодМаркировки       = ИсходныйКодМаркировки;
	ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки = ИсходнаяДлинаКодаМаркировки;
	
	Возврат Ложь;
	
КонецФункции

Функция ЭтоНеФормализованныйКодМаркировкиЛогистическойУпаковкиGS1128(ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата, РезультатБезФильтра)
	
	Если РезультатБезФильтра.Количество() > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Ограничение согласно документации СУЗ
	МинимальнаяДлинаКодаТранспортнойУпаковки    = 18; // В ЦРПТ логистическая упаковка не может быть меньше 18 символов
	МинимальнаяДлинаКодаТранспортнойУпаковкиАТП = 34;
	МаксимальнаяДлинаКодаТранспортнойУпаковки   = 74;
	
	Если ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки < МинимальнаяДлинаКодаТранспортнойУпаковки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ФильтрПоВидуПродукции = ПараметрыРазбораКодаМаркировки.ФильтрПоВидуПродукции;
	Если Не ФильтрПоВидуПродукции.Использовать Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВидыПродукции = Новый Массив;
	Для Каждого ВидПродукции Из ФильтрПоВидуПродукции.ВидыПродукции Цикл
		Если Не ИнтеграцияИСКлиентСервер.ЭтоПродукцияИСМП(ВидПродукции, Истина) Тогда
			Возврат Ложь;
		КонецЕсли;
		Если Настройки.ДоступныеВидыПродукции.Найти(ВидПродукции) <> Неопределено Тогда
			ВидыПродукции.Добавить(ВидПродукции);
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки < МинимальнаяДлинаКодаТранспортнойУпаковкиАТП Тогда
		ИндексАТП = ВидыПродукции.Найти(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак"));
		Если ИндексАТП <> Неопределено Тогда
			ВидыПродукции.Удалить(ИндексАТП);
		КонецЕсли;
	КонецЕсли;
	
	Если ВидыПродукции.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КодМаркировки = ПараметрыРазбораКодаМаркировки.КодМаркировки;
	
	ЗначениеИдентификатораGTIN = Неопределено;
	
	ПрисутствуетИдентификатор02               = Ложь;
	ЗначениеИдентификатора37                  = Неопределено;
	ВозможныВариантыКоличестваВложенныхЕдиниц = Ложь;
	
	ДлинаКодаМаркировкиБезРазделителей = 0;
	
	Если ПараметрыРазбораКодаМаркировки.НачинаетсяСоСкобки Тогда
		
		РезультатРазбора = МенеджерОборудованияМаркировкаКлиентСервер.РазобратьСтрокуШтрихкодаGS1(КодМаркировки);
		Если РезультатРазбора.Разобран Тогда
			
			ЭлементКМ = РезультатРазбора.ДанныеШтрихкода["01"];
			Если ЭлементКМ = Неопределено Тогда
				ЭлементКМ = РезультатРазбора.ДанныеШтрихкода["02"];
				Если ЭлементКМ <> Неопределено Тогда
					ЗначениеИдентификатораGTIN = ЭлементКМ.Значение;
					Если РезультатРазбора.ДанныеШтрихкода["37"] <> Неопределено Тогда
						ЗначениеИдентификатора37    = СтрокаВЧисло(РезультатРазбора.ДанныеШтрихкода["37"].Значение);
						ПрисутствуетИдентификатор02 = (ЗначениеИдентификатора37 > 0);
					КонецЕсли;
				КонецЕсли;
			Иначе
				ЗначениеИдентификатораGTIN = ЭлементКМ.Значение;
			КонецЕсли;
			
			Для Каждого КлючЗначение Из РезультатРазбора.ДанныеШтрихкода Цикл
				Идентификатор          = КлючЗначение.Ключ;
				ЗначениеИдентификатора = КлючЗначение.Значение.Значение;
				ДлинаКодаМаркировкиБезРазделителей = ДлинаКодаМаркировкиБезРазделителей + СтрДлина(Идентификатор) + СтрДлина(ЗначениеИдентификатора);
			КонецЦикла;
			
		Иначе
			
			ИдентификаторGTIN = Лев(КодМаркировки, 4);
			Если ИдентификаторGTIN = "(01)" Тогда
				ЗначениеИдентификатораGTIN = Сред(КодМаркировки, 5, 14);
			ИначеЕсли ИдентификаторGTIN = "(02)" Тогда
				ПараметрыРазбораКодаМаркировки.МодульКонтекста.МодульОбщегоНазначения().СообщитьПользователю(РезультатРазбора.ОписаниеОшибки);
			КонецЕсли;
			
			Если Не РазборКодаМаркировкиИССлужебныйКлиентСерверПовтИсп.ЭтоGTIN(ЗначениеИдентификатораGTIN) Тогда
				Возврат Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ПараметрыРазбораКодаМаркировки.СодержитРазделительGS Тогда
		
		РезультатРазбора = ПараметрыРазбораКодаМаркировки.РезультатРазбора;
		
		ЭлементКМ = РезультатРазбора.ДанныеШтрихкода["01"];
		Если ЭлементКМ = Неопределено Тогда
			ЭлементКМ = РезультатРазбора.ДанныеШтрихкода["02"];
			Если ЭлементКМ <> Неопределено Тогда
				ЗначениеИдентификатораGTIN = ЭлементКМ.Значение;
				Если РезультатРазбора.ДанныеШтрихкода["37"] <> Неопределено Тогда
					ЗначениеИдентификатора37    = СтрокаВЧисло(РезультатРазбора.ДанныеШтрихкода["37"].Значение);
					ПрисутствуетИдентификатор02 = (ЗначениеИдентификатора37 > 0);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ЗначениеИдентификатораGTIN = ЭлементКМ.Значение;
		КонецЕсли;
		
		Для Каждого КлючЗначение Из РезультатРазбора.ДанныеШтрихкода Цикл
			Идентификатор          = КлючЗначение.Ключ;
			ЗначениеИдентификатора = КлючЗначение.Значение.Значение;
			ДлинаКодаМаркировкиБезРазделителей = ДлинаКодаМаркировкиБезРазделителей + СтрДлина(Идентификатор) + СтрДлина(ЗначениеИдентификатора);
		КонецЦикла;
		
		ДлинаКодаМаркировкиДляПроверки = ДлинаКодаМаркировкиБезРазделителей + РезультатРазбора.ДанныеШтрихкода.Количество() * 2;
		Если ДлинаКодаМаркировкиДляПроверки <> СтрДлина(КодМаркировки) Тогда
			Возврат Ложь; // код маркировки предположительно содержит дубрирующие идентификаторы
		КонецЕсли;
		
	Иначе
		
		Если Не ШтрихкодированиеИСКлиентСервер.КодСоответствуетАлфавиту(КодМаркировки, Настройки.Алфавит.БуквыЦифрыЗнаки) Тогда
			Возврат Ложь;
		КонецЕсли;
		Если МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(КодМаркировки) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ДлинаКодаМаркировкиБезРазделителей = ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки;
		
		ВариантыРазбораШтрихкодаGS1 = РазборКодаМаркировкиИССлужебныйКлиентСервер.ВариантыРазбораШтрихкодаGS1БезРазделителей(КодМаркировки);
		Если ВариантыРазбораШтрихкодаGS1 = Неопределено Тогда
			
			Если Настройки.ВалидироватьШтрихкодаGS1БезРазделителей Тогда
				Возврат Ложь;
			КонецЕсли;
			
		Иначе
			
			ПроверитьНаличиеВложенныхЕдиниц = Ложь;
			
			ИдентификаторGTIN = Лев(КодМаркировки, 2);
			Если ИдентификаторGTIN = "01" Или ИдентификаторGTIN = "02" Тогда
				ЗначениеИдентификатораGTIN = Сред(КодМаркировки, 3, 14);
				Если РазборКодаМаркировкиИССлужебныйКлиентСерверПовтИсп.ЭтоGTIN(ЗначениеИдентификатораGTIN) Тогда
					ПроверитьНаличиеВложенныхЕдиниц = (ИдентификаторGTIN = "02");
				Иначе
					ЗначениеИдентификатораGTIN = Неопределено;
				КонецЕсли;
			КонецЕсли;
			
			ВариантыКоличестваВложенныхЕдиниц = Новый СписокЗначений;
			
			Если ПроверитьНаличиеВложенныхЕдиниц Тогда
				
				Для Каждого ВариантРазбора Из ВариантыРазбораШтрихкодаGS1 Цикл
					
					Если ВариантРазбора.РезультатРазбора.ДанныеШтрихкода["02"] <> Неопределено Тогда
						
						Если ЗначениеИдентификатораGTIN <> ВариантРазбора.РезультатРазбора.ДанныеШтрихкода["02"].Значение Тогда
							Продолжить;
						ИначеЕсли ВариантРазбора.РезультатРазбора.ДанныеШтрихкода["37"] = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						ЗначениеИдентификатора37 = СтрокаВЧисло(ВариантРазбора.РезультатРазбора.ДанныеШтрихкода["37"].Значение);
						
						Если ЗначениеИдентификатора37 > 0 Тогда
							ВариантыКоличестваВложенныхЕдиниц.Добавить(ЗначениеИдентификатора37);
						КонецЕсли;
						
						ЗначениеИдентификатора37 = Неопределено;
						
					КонецЕсли;
					
				КонецЦикла;
				
				ВариантыКоличестваВложенныхЕдиниц.СортироватьПоЗначению(НаправлениеСортировки.Возр);
				ВариантыКоличестваВложенныхЕдиниц = ВариантыКоличестваВложенныхЕдиниц.ВыгрузитьЗначения();
				Если ВариантыКоличестваВложенныхЕдиниц.Количество() > 1 Тогда
					ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВариантыКоличестваВложенныхЕдиниц);
				КонецЕсли;
				
				Если ВариантыКоличестваВложенныхЕдиниц.Количество() = 0 Тогда
					
					ЗначениеИдентификатораGTIN = Неопределено;
					
				ИначеЕсли ВариантыКоличестваВложенныхЕдиниц.Количество() = 1 Тогда
					
					ЗначениеИдентификатора37 = ВариантыКоличестваВложенныхЕдиниц[0];
					
				Иначе
					
					КоличествоПредполагаемыхКоличеств = 0;
					Для Каждого ВариантКоличестваВложенныхЕдиниц Из ВариантыКоличестваВложенныхЕдиниц Цикл
						Если    ВариантКоличестваВложенныхЕдиниц % 2 = 0
							Или ВариантКоличестваВложенныхЕдиниц % 3 = 0
							Или ВариантКоличестваВложенныхЕдиниц % 5 = 0 Тогда
							
							КоличествоПредполагаемыхКоличеств = КоличествоПредполагаемыхКоличеств + 1;
							
							Если ЗначениеИдентификатора37 = Неопределено Тогда
								ЗначениеИдентификатора37 = ВариантКоличестваВложенныхЕдиниц;
							КонецЕсли;
							
						КонецЕсли;
					КонецЦикла;
					
					Если ЗначениеИдентификатора37 = Неопределено Тогда
						ЗначениеИдентификатораGTIN = Неопределено;
					КонецЕсли;
					
					ВозможныВариантыКоличестваВложенныхЕдиниц = (КоличествоПредполагаемыхКоличеств > 1);
					
				КонецЕсли;
				
				ПрисутствуетИдентификатор02 = ЗначениеЗаполнено(ЗначениеИдентификатораGTIN) И ЗначениеЗаполнено(ЗначениеИдентификатора37);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	GTIN = "";
	Если ЗначениеЗаполнено(ЗначениеИдентификатораGTIN)
		И ТипЗнч(ЗначениеИдентификатораGTIN) = Тип("Строка")
		И СтрДлина(ЗначениеИдентификатораGTIN) = 14
		И РазборКодаМаркировкиИССлужебныйКлиентСерверПовтИсп.ЭтоGTIN(ЗначениеИдентификатораGTIN) Тогда
		
		GTIN = ЗначениеИдентификатораGTIN;
		
	КонецЕсли;
	
	КоличествоВложенныхЕдиниц = Неопределено;
	
	Если ПрисутствуетИдентификатор02 Тогда
		
		Если ЗначениеЗаполнено(GTIN) Тогда
			КоличествоВложенныхЕдиниц = ЗначениеИдентификатора37;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДлинаКодаМаркировкиБезРазделителей > 0 Тогда
		Если ДлинаКодаМаркировкиБезРазделителей > МаксимальнаяДлинаКодаТранспортнойУпаковки Тогда
			Возврат Ложь;
		КонецЕсли;
		Если ДлинаКодаМаркировкиБезРазделителей < МинимальнаяДлинаКодаТранспортнойУпаковкиАТП Тогда
			ИндексАТП = ВидыПродукции.Найти(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак"));
			Если ИндексАТП <> Неопределено Тогда
				Если ВидыПродукции.Количество() = 1 Тогда
					Возврат Ложь;
				КонецЕсли;
				ВидыПродукции.Удалить(ИндексАТП);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ТипШтрихкодаИВидУпаковки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ТипШтрихкодаИВидУпаковки();
	ТипШтрихкодаИВидУпаковки.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128");
	ТипШтрихкодаИВидУпаковки.ВидУпаковки  = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Логистическая");
	
	СоставКодаМаркировки = НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки);
	СоставКодаМаркировки.GTIN = GTIN;
	
	Если ЗначениеЗаполнено(СоставКодаМаркировки.GTIN) Тогда
		СоставКодаМаркировки.EAN = РазборКодаМаркировкиИССлужебныйКлиентСерверПовтИсп.ШтрихкодEANИзGTIN(СоставКодаМаркировки.GTIN);
		СоставКодаМаркировки.ВключаетИдентификаторыПрименения = Истина;
	КонецЕсли;
	
	СоставКодаМаркировки.КоличествоВложенныхЕдиниц                 = КоличествоВложенныхЕдиниц;
	СоставКодаМаркировки.ВозможныВариантыКоличестваВложенныхЕдиниц = ВозможныВариантыКоличестваВложенныхЕдиниц;
	
	ДанныеРезультата = РазборКодаМаркировкиИССлужебныйКлиентСервер.НовыйРезультатРазбораКодаМаркировки(ПараметрыРазбораКодаМаркировки.РасширеннаяДетализация);
	ДанныеРезультата.КодМаркировки        = КодМаркировки;
	ДанныеРезультата.ТипШтрихкода         = ТипШтрихкодаИВидУпаковки.ТипШтрихкода;
	ДанныеРезультата.ВидУпаковки          = ТипШтрихкодаИВидУпаковки.ВидУпаковки;
	ДанныеРезультата.ВидыПродукции        = ВидыПродукции;
	ДанныеРезультата.СоставКодаМаркировки = СоставКодаМаркировки;
	
	Если ПараметрыРазбораКодаМаркировки.РасширеннаяДетализация Тогда
		ДанныеРезультата.Детализация.НачинаетсяСоСкобки                = ПараметрыРазбораКодаМаркировки.НачинаетсяСоСкобки;
		ДанныеРезультата.Детализация.СодержитРазделительGS             = ПараметрыРазбораКодаМаркировки.СодержитРазделительGS;
		ДанныеРезультата.Детализация.ЭтоНеФормализованныйКодМаркировки = Истина;
	КонецЕсли;
	
	Для Каждого ВидПродукции Из ВидыПродукции Цикл
		ДанныеРезультата.ВидыУпаковокПоВидамПродукции[ВидПродукции] =
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипШтрихкодаИВидУпаковки.ВидУпаковки);
	КонецЦикла;
	
	НормализованныйКодМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.НормализоватьКодМаркировки(
		ДанныеРезультата, ВидыПродукции[0]); // Тут вид продукции не имеет значения
	
	ДанныеРезультата.НормализованныйКодМаркировки = НормализованныйКодМаркировки;
	
	Возврат Истина;
	
КонецФункции

Функция СтрокаВЧисло(Строка)
	
	Число = 0;
	
	Если ТипЗнч(Строка) = Тип("Строка") Тогда
		
		КвалификаторЧисла = Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный);
		ОписаниеТипаЧисла = Новый ОписаниеТипов("Число",,, КвалификаторЧисла);
		Число = ОписаниеТипаЧисла.ПривестиЗначение(Строка);
		
	КонецЕсли;
	
	Возврат Число;
	
КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыИФункции

Функция ПрисутствуетТабачнаяПродукция(ВидыПродукции)
	
	Для Каждого ВидПродукции Из ВидыПродукции Цикл
		Если ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти