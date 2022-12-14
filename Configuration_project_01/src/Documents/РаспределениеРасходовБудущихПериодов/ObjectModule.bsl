#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВЫБОР
			|		КОГДА СтатьиРасходов.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов)
			|			ТОГДА ЕСТЬNULL(СтатьиРасходов.ПравилоРаспределенияРасходовРегл.НачалоПериода, """")
			|		КОГДА СтатьиРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов)
			|			ТОГДА ЕСТЬNULL(СтатьиРасходов.ПравилоРаспределенияРасходовУпр.НачалоПериода, """")
			|		ИНАЧЕ """"
			|	КОНЕЦ КАК НачалоПериода,
			|	ВЫБОР
			|		КОГДА СтатьиРасходов.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов)
			|			ТОГДА ЕСТЬNULL(СтатьиРасходов.ПравилоРаспределенияРасходовРегл.БазаРаспределенияРБП, НЕОПРЕДЕЛЕНО)
			|		КОГДА СтатьиРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов)
			|			ТОГДА ЕСТЬNULL(СтатьиРасходов.ПравилоРаспределенияРасходовУпр.БазаРаспределенияРБП, НЕОПРЕДЕЛЕНО)
			|		ИНАЧЕ НЕОПРЕДЕЛЕНО
			|	КОНЕЦ КАК БазаРаспределения,
			|	ВЫБОР
			|		КОГДА СтатьиРасходов.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов)
			|			ТОГДА ЕСТЬNULL(СтатьиРасходов.ПравилоРаспределенияРасходовРегл.КоличествоМесяцев, 0)
			|		КОГДА СтатьиРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов)
			|			ТОГДА ЕСТЬNULL(СтатьиРасходов.ПравилоРаспределенияРасходовУпр.КоличествоМесяцев, 0)
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК Количество
			|ИЗ
			|	ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
			|ГДЕ
			|	СтатьиРасходов.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", СтатьяРасходов);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
		
			Если Выборка.НачалоПериода = "СДатыВозникновения" Тогда
				Если ЗначениеЗаполнено(ДанныеЗаполнения.Период) Тогда
					НачалоПериода = ДанныеЗаполнения.Период;
				Иначе
					НачалоПериода = ТекущаяДатаСеанса();
				КонецЕсли;
			ИначеЕсли Выборка.НачалоПериода = "СНачалаМесяца" Тогда
				Если ЗначениеЗаполнено(ДанныеЗаполнения.Дата) Тогда
					НачалоПериода = КонецМесяца(ДанныеЗаполнения.Дата) + 1;
				Иначе
					НачалоПериода = КонецМесяца(ТекущаяДатаСеанса()) + 1;
				КонецЕсли;
			КонецЕсли;
			
			КоличествоМесяцев = Выборка.Количество;
			ПравилоРаспределения = Выборка.БазаРаспределения;
			
		КонецЕсли;
		
		Если СуммаДокумента <> 0 ИЛИ СуммаДокументаУпр <> 0 Тогда
			ВариантУказанияСуммыУпр = Перечисления.ВариантыУказанияСуммыРБП.УказываетсяВручную;
		КонецЕсли;
		Если СуммаДокументаРегл <> 0 ИЛИ СуммаДокументаПР <> 0 ИЛИ СуммаДокументаВР <> 0 Тогда
			ВариантУказанияСуммыРегл = Перечисления.ВариантыУказанияСуммыРБП.УказываетсяВручную;
		КонецЕсли;
		
	КонецЕсли;
		
	ИнициализироватьДокумент(ДанныеЗаполнения);
	РаспределениеРасходовБудущихПериодовЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	РаспределениеРасходов.Очистить();
	
	РаспределениеРасходовБудущихПериодовЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверим соответствие сумм документа и табличной части.
	Если СуммаДокумента <> РаспределениеРасходов.Итог("Сумма")
	 ИЛИ СуммаДокументаРегл <> РаспределениеРасходов.Итог("СуммаРегл")
	 ИЛИ СуммаДокументаПР <> РаспределениеРасходов.Итог("ПостояннаяРазница")
	 ИЛИ СуммаДокументаВР <> РаспределениеРасходов.Итог("ВременнаяРазница") Тогда
		Текст = НСтр("ru = 'Сумма по строкам в табличной части должна равняться соответствующим суммам документа'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"РаспределениеРасходов[0].Дата",
			,
			Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	РеквизитыПроверкиАналитик = Новый Массив;
	РеквизитыПроверкиАналитик.Добавить("СтатьяРасходов, АналитикаРасходов");
	РеквизитыПроверкиАналитик.Добавить(Новый Структура("РаспределениеРасходов"));
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, РеквизитыПроверкиАналитик, МассивНепроверяемыхРеквизитов, Отказ);
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	РаспределениеРасходовБудущихПериодовЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ДатыЗапретаИзмененияУТ.ВключитьПроверкуДатыЗапретаИзменения(ЭтотОбъект);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОчиститьСуммыУпр = Ложь;
		ОчиститьСуммырегл = Ложь;
		Если ВариантУказанияСуммыУпр = Перечисления.ВариантыУказанияСуммыРБП.ОпределяетсяАвтоматически Тогда
			Если СуммаДокумента <> 0 ИЛИ СуммаДокументаУпр <> 0 Тогда
				СуммаДокумента = 0;
				СуммаДокументаУпр = 0;
			КонецЕсли;
			Если РаспределениеРасходов.Итог("Сумма") <> 0 ИЛИ РаспределениеРасходов.Итог("СуммаУпр") <> 0 Тогда
				ОчиститьСуммыУпр = Истина;
			КонецЕсли;
		КонецЕсли;
		Если ВариантУказанияСуммыРегл = Перечисления.ВариантыУказанияСуммыРБП.ОпределяетсяАвтоматически Тогда
			Если СуммаДокументаРегл <> 0 ИЛИ СуммаДокументаПР <> 0 ИЛИ СуммаДокументаВР <> 0 Тогда
				СуммаДокументаРегл = 0;
				СуммаДокументаПР = 0;
				СуммаДокументаВР = 0;
			КонецЕсли;
			Если РаспределениеРасходов.Итог("СуммаРегл") <> 0
			 ИЛИ РаспределениеРасходов.Итог("ПостояннаяРазница") <> 0
			 ИЛИ РаспределениеРасходов.Итог("ВременнаяРазница") <> 0 Тогда
				ОчиститьСуммыРегл = Истина;
			КонецЕсли;
		КонецЕсли;
		Если ОчиститьСуммыУпр ИЛИ ОчиститьСуммыРегл Тогда
			Для Каждого Строка Из РаспределениеРасходов Цикл
				Если ОчиститьСуммыУпр Тогда
					Строка.Сумма = 0;
					Строка.СуммаУпр = 0;
				КонецЕсли;
				Если ОчиститьСуммыРегл Тогда
					Строка.СуммаРегл = 0;
					Строка.ПостояннаяРазница = 0;
					Строка.ВременнаяРазница = 0;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	РаспределениеРасходовБудущихПериодовЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.РаспределениеРасходовБудущихПериодов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Регистрация задания к расчету себестоимости.
	ИменаРеквизитов = "ВариантРаспределенияРасходовУпр, ВариантРаспределенияРасходовРегл";
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтатьяРасходов, ИменаРеквизитов);
	
	Если (ВариантУказанияСуммыУпр = Перечисления.ВариантыУказанияСуммыРБП.ОпределяетсяАвтоматически
	 И Реквизиты.ВариантРаспределенияРасходовУпр = Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов)
	ИЛИ (ВариантУказанияСуммыРегл = Перечисления.ВариантыУказанияСуммыРБП.ОпределяетсяАвтоматически
	 И Реквизиты.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаРасходыБудущихПериодов) Тогда
		ШаблонЗапретаДанных = ДатыЗапретаИзменения.ШаблонДанныхДляПроверки();
		СтрокаШаблона = ШаблонЗапретаДанных.Добавить();
		СтрокаШаблона.Раздел = "РегламентныеОперации";
		СтрокаШаблона.Дата = НачалоМесяца(Дата);
		ЕстьЗапретИзмененияПоДатеДокумента = ДатыЗапретаИзменения.НайденЗапретИзмененияДанных(ШаблонЗапретаДанных);
		Если Не ЕстьЗапретИзмененияПоДатеДокумента Тогда
			РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(Дата, Ссылка, Организация);
		КонецЕсли;
		
	КонецЕсли;
	
	// Движения по прочим расходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДоходыРасходыПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	// Запись наборов записей
	РаспределениеРасходовБудущихПериодовЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	РаспределениеРасходовБудущихПериодовЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		
		Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация", "");
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
