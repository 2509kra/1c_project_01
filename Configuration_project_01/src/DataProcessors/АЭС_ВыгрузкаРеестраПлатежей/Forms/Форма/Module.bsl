
&НаСервере
Процедура ВыгрузитьНаСервере(БД, НаборДанных)	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
				   |" + НаборДанных + " 
	               |ИЗ
	               |	Документ.АЭС_Платежи.СторонниеУслуги КАК Источник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЧекККМВозврат КАК ЧекККМВозврат
	               |		ПО Источник.ДокументПродажи = ЧекККМВозврат.ЧекККМ
         		   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АЭС_ДанныеКонтрагентов.СрезПоследних(&КонПериода, ) КАК ДанныеКонтрагента
              	   |		ПО Источник.Ссылка.Контрагент = ДанныеКонтрагента.Контрагент
            	   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АЭС_КомиссияНоменклатуры.СрезПоследних КАК Комиссия
       		       |		ПО Источник.Ссылка.Партнер = Комиссия.Партнер
               	   |			И Источник.Ссылка.Организация = Комиссия.Организация
               	   |			И Источник.Номенклатура = Комиссия.Номенклатура
	               |ГДЕ
	               |	Источник.Ссылка.Статус = ЗНАЧЕНИЕ(перечисление.СтатусыЧековККМ.Пробит)
	               |	И Источник.Ссылка.Дата МЕЖДУ &НачПериода И &КонПериода
	               |	И Источник.Ссылка.Организация = &Организация
	               |	И Источник.Ссылка.Возврат = ЛОЖЬ
	               |	И Источник.Ссылка.Проведен = ИСТИНА
	               |	И Источник.Ссылка.Партнер = &Партнер
	               |	И (НЕ ЧекККМВозврат.Статус = ЗНАЧЕНИЕ(перечисление.СтатусыЧековККМ.Пробит)
	               |			ИЛИ ЧекККМВозврат.Ссылка ЕСТЬ NULL)
				   |	#ДопУсловие# ";
	
	
	Запрос.УстановитьПараметр("НачПериода", НачалоДня(Объект.Дата));
	Запрос.УстановитьПараметр("КонПериода", КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Партнер", Объект.Партнер);
	ДопУсловие = "";
	Если ЗначениеЗаполнено(Объект.Номенклатура) тогда
		ДопУсловие = ДопУсловие+" И Источник.Номенклатура = &Номенклатура";
		Запрос.УстановитьПараметр("Номенклатура", Объект.Номенклатура);
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		ДопУсловие =  ДопУсловие+" И Источник.Приимечание = &Приимечание";
		Запрос.УстановитьПараметр("Приимечание", ВидДокумента);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.КассаККМ) Тогда 
		ДопУсловие = ДопУсловие+" И Источник.Ссылка.КассаККМ = &КассаККМ";
		Запрос.УстановитьПараметр("КассаККМ", Объект.КассаККМ);
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ДопУсловие#", ДопУсловие);	
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СТЗ Из Результат Цикл
		Данные = Новый Структура;
		Для Каждого СТЧ Из Объект.ДанныеПоПартнеру Цикл
			Если Не ЗначениеЗаполнено(СТЧ.ПолеПриемник) Тогда
				Продолжить;
			КонецЕсли;
			Если ЗначениеЗаполнено(СТЧ.Обработать) Тогда  

				Попытка
					Данные.Вставить(СТЧ.ПолеПриемник, Вычислить(СТЧ.Обработать));
				Исключение
					Сообщить("При выгрузке произошла ошибка. Обратитесь к системному администратору");
				КонецПопытки;
			Иначе
				Данные.Вставить(СТЧ.ПолеПриемник, СТЗ[СТЧ.ПолеПриемник]);
			КонецЕсли;
		КонецЦикла;
		БД.Добавить(Данные);
	КонецЦикла;
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Функция ПолучитьКД(Контрагент, Тип)
	РезультатыЧтения = Новый Структура;	
	ЗначенияПолей = Контрагент.КонтактнаяИнформация[0].ЗначенияПолей;
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВJSON(ЗначенияПолей) Тогда
		ДанныеАдреса = УправлениеКонтактнойИнформациейСлужебный.СтрокаJSONВСтруктуру(ЗначенияПолей);
		НаселенныйПунктДетально = РаботаСАдресами.ПодготовитьАдресДляВвода(ДанныеАдреса);
	Иначе
		XDTOКонтактная = ИзвлечьСтарыйФорматАдреса(ЗначенияПолей, Перечисления.ТипыКонтактнойИнформации.Адрес);
		ДанныеАдреса = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияВСтруктуруJSON(XDTOКонтактная, Перечисления.ТипыКонтактнойИнформации.Адрес);
		НаселенныйПунктДетально = РаботаСАдресами.ПодготовитьАдресДляВвода(ДанныеАдреса);
		//XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(ЗначенияПолей, Перечисления.ТипыКонтактнойИнформации.Адрес, РезультатыЧтения);
	КонецЕсли;
	
	Если Тип = "Индекс" Тогда
		Возврат НаселенныйПунктДетально.ZIPcode;
	ИначеЕсли  Тип = "Область" Тогда
		Область = НаселенныйПунктДетально.area + " " + НаселенныйПунктДетально.areaType;
		Возврат Область;
	ИначеЕсли Тип = "Район" Тогда
		Район = НаселенныйПунктДетально.district + " " + НаселенныйПунктДетально.districtType;
		Возврат Район;
	ИначеЕсли Тип = "ПаселенныйПункт" Тогда
		Если ЗначениеЗаполнено(НаселенныйПунктДетально.city) Тогда
			ПаселенныйПункт = НаселенныйПунктДетально.cityType + " " + НаселенныйПунктДетально.city; 
		Иначе
			ПаселенныйПункт = НаселенныйПунктДетально.localityType + " " + НаселенныйПунктДетально.locality; 
		КонецЕсли;
		Возврат ПаселенныйПункт; 
	ИначеЕсли Тип = "Улица" Тогда 
		Улица = НаселенныйПунктДетально.streetType + " " + НаселенныйПунктДетально.street;
		Возврат Улица;
	ИначеЕсли Тип = "Дом" Тогда
		Дом =  НаселенныйПунктДетально.housenumber;
		Для Каждого СТРМ Из НаселенныйПунктДетально.buildings Цикл 
			Дом = Дом + " " + СТРМ.type + " " + СТРМ.number;	
		КонецЦикла;
		Возврат Дом;
	ИначеЕсли Тип = "Квартира" Тогда
		Квартира = НаселенныйПунктДетально.apartments[0].number;
		Возврат Квартира;
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура Выгрузить(Команда)
	Если Объект.ДанныеПоПартнеру.Количество()=0 Тогда
		ПартнерПриИзмененииНаСервере();
	КонецЕсли;
	НаборДанных = "";
	БД = Новый XBase;
	Для Каждого СТЧ Из Объект.ДанныеПоПартнеру Цикл 
		Если ЗначениеЗаполнено(СТЧ.ПолеПриемник) Тогда 
			БД.Поля.Добавить(СТЧ.ПолеПриемник,		СТЧ.ТипПоля, Цел(СТЧ.ДлинаПоля), Число(Прав(СТЧ.ДлинаПоля-Цел(СТЧ.ДлинаПоля),1)));
			Если Объект.ДанныеПоПартнеру.Количество() = СТЧ.НомерСтроки Тогда  
				НаборДанных = НаборДанных + СТЧ.ПолеИсточник + " КАК " +СТЧ.ПолеПриемник; 
			Иначе
				НаборДанных = НаборДанных + СТЧ.ПолеИсточник+ " КАК " +СТЧ.ПолеПриемник+"," + Символы.ПС; 
			КонецЕсли;
		Иначе
			Если Объект.ДанныеПоПартнеру.Количество() = СТЧ.НомерСтроки Тогда  
				НаборДанных = НаборДанных + СТЧ.ПолеИсточник; 
			Иначе
				НаборДанных = НаборДанных + СТЧ.ПолеИсточник+"," + Символы.ПС; 
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
	ИмяФайла = ПолучитьИмяФайла(); 
	Если ИмяФайла = Неопределено Тогда
		ИмяФайла = "AES"+"_"+Формат(Объект.Дата, "ДФ=ддММ");
	Иначе
		ИмяФайла = Вычислить(ИмяФайла);
	КонецЕсли;
	
	БД.АвтоСохранение = Истина;
	БД.СоздатьФайл(?(Прав(Объект.ПутьКФайлу,1)="\",Объект.ПутьКФайлу+ИмяФайла,Объект.ПутьКФайлу+"\"+ИмяФайла));
	БД.Кодировка=КодировкаXBase.OEM;
	
	МассивДанных =Новый Массив;
	ВыгрузитьНаСервере(МассивДанных, НаборДанных);
	
	Для Каждого СТР из МассивДанных Цикл
		БД.Добавить();
		ЗаполнитьЗначенияСвойств(БД,СТР);
		
		//Если СТР.Свойство("NOM_PP") Тогда
		//	БД.NOM_PP = НомерПП;
		//КонецЕсли;
	КонецЦикла;
	БД.ЗакрытьФайл();
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Заголовок = "Выберите файл";

	ДиалогВыбора.ПолноеИмяФайла = "";
    Текст = "ru = ""Текст""; en = ""Text""";
    Фильтр = "ДБФ (*.dbf)|*.dbf";
    ДиалогВыбора.Фильтр = Фильтр;
    ДиалогВыбора.МножественныйВыбор = Ложь;

	Если ДиалогВыбора.Выбрать() Тогда
		Объект.ПутьКФайлу = ДиалогВыбора.Каталог;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПартнерПриИзмененииНаСервере()
	Если Объект.ДанныеПоПартнеру.Количество()>0 Тогда
		Объект.ДанныеПоПартнеру.Очистить();
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	АЭС_НастройкаВыгрузкиПлатежей.ПолеИсточник,
	               |	АЭС_НастройкаВыгрузкиПлатежей.ПолеПриемник,
	               |	АЭС_НастройкаВыгрузкиПлатежей.ТипПоля,
	               |	АЭС_НастройкаВыгрузкиПлатежей.ДлинаПоля,
	               |	АЭС_НастройкаВыгрузкиПлатежей.Обработать
	               |ИЗ
	               |	РегистрСведений.АЭС_НастройкаВыгрузкиПлатежей КАК АЭС_НастройкаВыгрузкиПлатежей
	               |ГДЕ
	               |	АЭС_НастройкаВыгрузкиПлатежей.Партнер = &Партнер
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	АЭС_НастройкаВыгрузкиПлатежей.Порядок";
	
	Запрос.УстановитьПараметр("Партнер",Объект.Партнер);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.ДанныеПоПартнеру.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	// Вставить содержимое обработчика.
КонецФункции

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	ПартнерПриИзмененииНаСервере();
КонецПроцедуры

Процедура П()
Запрос = Новый Запрос;
Запрос.Текст = "ВЫБРАТЬ
               |	Источник.Ссылка КАК Ссылка,
               |	ГОД(Источник.ПериодПлатежа) - 2000 КАК Поле1,
               |	ВЫБОР
               |		КОГДА Комиссия.УдержаниеИзСуммыПеричисления
               |			ТОГДА ВЫБОР
               |					КОГДА Комиссия.СпособРасчетаКомиссии = ЗНАЧЕНИЕ(Перечисление.АЭС_СпособоРасчетаКомиссии.ФиксированнаяСумма)
               |						ТОГДА Источник.Сумма - Комиссия.Мин
               |					ИНАЧЕ ВЫБОР
               |							КОГДА Источник.Сумма - (ВЫРАЗИТЬ(Источник.Сумма / 100 * Комиссия.ПроцентКомиссии КАК ЧИСЛО)) < Комиссия.Мин и Комиссия.Мин<>0
               |								ТОГДА Комиссия.Мин
               |							КОГДА Источник.Сумма - (ВЫРАЗИТЬ(Источник.Сумма / 100 * Комиссия.ПроцентКомиссии КАК ЧИСЛО)) > Комиссия.Макс и Комиссия.Макс<>0

               |								ТОГДА Комиссия.Макс
               |							ИНАЧЕ Источник.Сумма - (ВЫРАЗИТЬ(Источник.Сумма / 100 * Комиссия.ПроцентКомиссии КАК ЧИСЛО))
               |						КОНЕЦ
               |				КОНЕЦ
               |	КОНЕЦ КАК Сумма
               |ИЗ
               |	Документ.АЭС_Платежи.СторонниеУслуги КАК Источник
               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЧекККМВозврат КАК ЧекККМВозврат
               |		ПО Источник.ДокументПродажи = ЧекККМВозврат.ЧекККМ
               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АЭС_ДанныеКонтрагентов.СрезПоследних(&КонПериода, ) КАК ДанныеКонтрагента
               |		ПО Источник.Ссылка.Контрагент = ДанныеКонтрагента.Контрагент
               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АЭС_КомиссияНоменклатуры.СрезПоследних КАК Комиссия
               |		ПО Источник.Ссылка.Партнер = Комиссия.Партнер
               |			И Источник.Ссылка.Организация = Комиссия.Организация
               |			И Источник.Ссылка.КассаККМ = Комиссия.Номенклатура
               |ГДЕ
               |	Источник.Ссылка.Статус = ЗНАЧЕНИЕ(перечисление.СтатусыЧековККМ.Пробит)
               |	И Источник.Ссылка.Дата МЕЖДУ &НачПериода И &КонПериода
               |	И Источник.Ссылка.Организация = &Организация
               |	И Источник.Ссылка.Возврат = ЛОЖЬ
               |	И Источник.Ссылка.Проведен = ИСТИНА
               |	И Источник.Ссылка.Партнер = &Партнер
               |	И (НЕ ЧекККМВозврат.Статус = ЗНАЧЕНИЕ(перечисление.СтатусыЧековККМ.Пробит)
               |			ИЛИ ЧекККМВозврат.Ссылка ЕСТЬ NULL)
               |	И Источник.Номенклатура = &Номенклатура
               |	И Источник.Приимечание = &Приимечание";

Результат = Запрос.Выполнить();
Выборка = Результат.Выбрать();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Объект.Дата = ТекущаяДата();
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОбновитьСписокПартнеров();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокПартнеров()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДоговорыКонтрагентов.Партнер
	               |ИЗ
	               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	               |ГДЕ
	               |	ДоговорыКонтрагентов.Организация = &Организация
	               |	И ДоговорыКонтрагентов.Контрагент = &Контрагент
	               |	И ДоговорыКонтрагентов.ДатаНачалаДействия <= &ДатаНачалаДействия
	               |	И ДоговорыКонтрагентов.ДатаОкончанияДействия >= &ДатаОкончанияДействия";

	Запрос.УстановитьПараметр("Организация", Объект.Организация );
	Запрос.УстановитьПараметр("Контрагент", Справочники.Контрагенты.РозничныйПокупатель);
	Запрос.УстановитьПараметр("ДатаНачалаДействия", ТекущаяДата());
	Запрос.УстановитьПараметр("ДатаОкончанияДействия", ТекущаяДата());

	Результат = Запрос.Выполнить().Выгрузить();
	РезМассив = Результат.ВыгрузитьКолонку("Партнер");
	Возврат РезМассив;
КонецФункции

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбновитьСписокПартнеров();	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПартнеров()
	СписокПартнеров = ПолучитьСписокПартнеров();
	Элементы.Партнер.СписокВыбора.ЗагрузитьЗначения(СписокПартнеров);
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяФайла()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПартнерыДополнительныеРеквизиты.Значение
	               |ИЗ
	               |	Справочник.Партнеры.ДополнительныеРеквизиты КАК ПартнерыДополнительныеРеквизиты
	               |ГДЕ
	               |	ПартнерыДополнительныеРеквизиты.Ссылка = &Партнер
	               |	И ПартнерыДополнительныеРеквизиты.Свойство.Заголовок = ""ИмяФайла""";
	
	Запрос.УстановитьПараметр("Партнер", Объект.Партнер);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если  Выборка.Следующий() Тогда
		Возврат Выборка.Значение;
	Иначе			
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

&НаСервере
Функция ИзвлечьСтарыйФорматАдреса(Знач ЗначенияПолей, Знач ТипКонтактнойИнформации) Экспорт
	
	Перем XDTOКонтактная, РезультатыЧтения;
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(ЗначенияПолей)
		И ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		РезультатыЧтения = Новый Структура;
		XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(ЗначенияПолей, ТипКонтактнойИнформации, РезультатыЧтения);
		Если РезультатыЧтения.Свойство("ТекстОшибки") Тогда
			// Распознали с ошибками, сообщим при открытии.
			ТекстПредупрежденияПриОткрытии = РезультатыЧтения.ТекстОшибки;
			XDTOКонтактная.Представление   = Параметры.Представление;
			XDTOКонтактная.Состав.Страна   = Строка(Справочники.СтраныМира.Россия);
		КонецЕсли;
	Иначе
		XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.АдресXMLВXDTO(ЗначенияПолей, Параметры.Представление, );
		Если Параметры.Свойство("Страна") И ЗначениеЗаполнено(Параметры.Страна) Тогда
			Если ТипЗнч(Параметры.Страна) = ТипЗнч(Справочники.СтраныМира.ПустаяСсылка()) Тогда
				XDTOКонтактная.Состав.Страна = Параметры.Страна.Наименование;
			Иначе
				XDTOКонтактная.Состав.Страна = Строка(Параметры.Страна);
			КонецЕсли;
		Иначе
			XDTOКонтактная.Состав.Страна = Справочники.СтраныМира.Россия.Наименование;
		КонецЕсли;
	КонецЕсли;
	Возврат XDTOКонтактная;

КонецФункции

