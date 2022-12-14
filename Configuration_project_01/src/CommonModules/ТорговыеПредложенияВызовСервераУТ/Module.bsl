
#Область СлужебныеПроцедурыИФункции

Процедура ВставитьСтрокиИзБуфераОбмена(Список) Экспорт
	
	// Вставка из буфера.
	СписокТоваров = ПолучитьСтрокиИзБуфераОбмена();
	
	Для Каждого СтрокаТовара Из СписокТоваров Цикл
		ТекущаяСтрока = Список.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
	КонецЦикла;	
	
КонецПроцедуры

// Получение строк таблицы из буфера обмена.
//
// Возвращаемое значение:
//   ТаблицаЗначений - строки, полученные из буфера обмена.
//
Функция ПолучитьСтрокиИзБуфераОбмена() 
	
	ТаблицаТоваров = КопированиеСтрокСервер.ПолучитьСтрокиИзБуфераОбмена();
	
	Если Не ЗначениеЗаполнено(ТаблицаТоваров) Или ТаблицаТоваров.Колонки.Найти("Номенклатура") = Неопределено Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Если ТаблицаТоваров.Колонки.Найти("Упаковка") = Неопределено Тогда
		ТаблицаТоваров.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
		МассивДляПолученияЕдиницИзмерения = ТаблицаТоваров.ВыгрузитьКолонку("Номенклатура");
	Иначе
		МассивДляПолученияЕдиницИзмерения = Новый Массив;
		Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
			Если Не ЗначениеЗаполнено(СтрокаТовара.Упаковка) Тогда
				МассивДляПолученияЕдиницИзмерения.Добавить(СтрокаТовара.Номенклатура);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивДляПолученияЕдиницИзмерения) Тогда
		ЕдиницыИзмеренияНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивДляПолученияЕдиницИзмерения,
			"ЕдиницаИзмерения");
		Для Каждого ЭлементСоответствия Из ЕдиницыИзмеренияНоменклатуры Цикл
			СтрокиТоваров = ТаблицаТоваров.НайтиСтроки(Новый Структура("Номенклатура, Упаковка",
				ЭлементСоответствия.Ключ, Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка()));
			Для Каждого СтрокаТоваров Из СтрокиТоваров Цикл
				СтрокаТоваров.Упаковка = ЭлементСоответствия.Значение;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТаблицаТоваров;
	
КонецФункции

// Настройки публикации.
//
// Параметры:
//  ТорговоеПредложение	 - Ссылка - ссылка на торговое предложение.
// 
// Возвращаемое значение:
//  Структура - значения дополнительных настроек.
//   * Организация - Ссылка - организация настройки.
//   * АдресЭлектроннойПочты - Строка - адрес электронной почты поставщика.
//   * Организация - Ссылка - организация настройки.
//   * УведомлятьОЗаказах - Булево - признак уведомления о получении заказов покупателей.
//   * ПубликоватьЦены - Булево - публиковать цены.
//   * ПубликоватьСрокиПоставки - Булево - публиковать сроки поставки.
//   * ПубликоватьОстатки - Булево - публиковать остатки.
//   * ДополнительноеОписание - Строка - дополнительное текстовое описание.
//   * ПоВсемТоварам - Булево - признак публикации все товаров из прайс-листа.
//
Функция НастройкиПубликации(ТорговоеПредложение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиПубликации = ТорговыеПредложения.НастройкиПубликации(ТорговоеПредложение);
	
	Если НастройкиПубликации = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат НастройкиПубликации;
	
КонецФункции

Функция ДанныеРедактированияПрайсЛиста(ПозицииТорговыхПредложений) Экспорт
	
	СписокНоменклатуры	= Новый СписокЗначений;
	СписокВидовЦен	= Новый Массив;
	Для Каждого ПозицияТорговогоПредложения Из ПозицииТорговыхПредложений Цикл
		СписокНоменклатуры.Добавить(ПозицияТорговогоПредложения.Номенклатура);
		СписокВидовЦен.Добавить(ПозицияТорговогоПредложения.ПрайсЛист.ВидЦен);
	КонецЦикла;
	
	ДанныеРедактированияПрайсЛиста = Новый Структура;
	ДанныеРедактированияПрайсЛиста.Вставить("СписокНоменклатуры" , СписокНоменклатуры);
	ДанныеРедактированияПрайсЛиста.Вставить("СписокВидовЦен"     , СписокВидовЦен);
	
	Возврат ДанныеРедактированияПрайсЛиста;
	
КонецФункции

Процедура НастройкиПрайсЛиста(ЭтотОбъект, МассивВидовЦенДляОтбора) Экспорт
	
	// Установка отборов
	ЭтотОбъект.КомпоновщикНастроекОтбор.Настройки.Отбор.Элементы.Очистить();
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ЭтотОбъект.КомпоновщикНастроекОтбор.Настройки.Отбор,
		"Номенклатура",
		ВидСравненияКомпоновкиДанных.ВСписке,
		МассивВидовЦенДляОтбора.СписокНоменклатуры,
		Неопределено,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	УстановкаЦенСервер.НастроитьЗаголовокОтбора(ЭтотОбъект);
	УстановкаЦенСервер.ИнициализироватьВыбранныеЦены(ЭтотОбъект, МассивВидовЦенДляОтбора.СписокВидовЦен);
	
	Для Каждого ВыбраннаяЦена Из ЭтотОбъект.ВыбранныеЦены Цикл
		 ВыбраннаяЦена.Выбрана = Истина;
	КонецЦикла;	
	
КонецПроцедуры

Функция ПолучитьМенеджера(Соглашение) Экспорт
	
	Если ЗначениеЗаполнено(Соглашение.Менеджер) Тогда
		Возврат Соглашение.Менеджер.ФизическоеЛицо
	Иначе
		Возврат Неопределено
	КонецЕсли;
	
КонецФункции

#КонецОбласти
