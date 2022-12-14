///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаголовокОшибки = НСтр("ru = 'Ошибка при настройке динамического списка присоединенных файлов.'");
	ОкончаниеОшибки = НСтр("ru = 'В этом случае настройка динамического списка невозможна.'");
	
	ИмяСправочникаХранилищаВерсийФайлов = РаботаСФайламиСлужебный.ИмяСправочникаХраненияВерсийФайлов(
		Параметры.Файл.ВладелецФайла, "", ЗаголовокОшибки, ОкончаниеОшибки);
		
	Если Не ПустаяСтрока(ИмяСправочникаХранилищаВерсийФайлов) Тогда
		НастроитьДинамическийСписок(ИмяСправочникаХранилищаВерсийФайлов);
	КонецЕсли;
	
	ВидимостьКомандыСравнить = 
		Не ОбщегоНазначения.ЭтоLinuxКлиент() И Не ОбщегоНазначения.ЭтоВебКлиент();
	Элементы.ФормаСравнить.Видимость = ВидимостьКомандыСравнить;
	Элементы.КонтекстноеМенюСписокСравнить.Видимость = ВидимостьКомандыСравнить;
	
	УникальныйИдентификаторКарточкиФайла = Параметры.УникальныйИдентификаторКарточкиФайла;
	
	Список.Параметры.УстановитьЗначениеПараметра("Владелец", Параметры.Файл);
	ВладелецВерсии = Параметры.Файл;
	
	РаботаСФайламиСлужебный.УстановитьОтборПоПометкеУдаления(Список.Отбор);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		Элементы.ФормаОткрытьВерсию.Картинка = БиблиотекаКартинок.Лупа;
		Элементы.ФормаОткрытьВерсию.Отображение = ОтображениеКнопки.Картинка;
		Элементы.СписокКомментарий.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СделатьАктивнойВыполнить()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоваяАктивнаяВерсия = ТекущиеДанные.Ссылка;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(ТекущиеДанные.Владелец, ТекущиеДанные.Ссылка);
	
	Если ЗначениеЗаполнено(ДанныеФайла.Редактирует) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Смена активной версии разрешена только для незанятых файлов.'"));
	ИначеЕсли ДанныеФайла.ПодписанЭП Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Смена активной версии разрешена только для неподписанных файлов.'"));
	Иначе
		СменитьАктивнуюВерсиюФайла(НоваяАктивнаяВерсия);
		Оповестить("Запись_Файл", Новый Структура("Событие", "АктивнаяВерсияИзменена"), Параметры.Файл);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл"
		И Параметр.Свойство("Событие")
		И (Параметр.Событие = "ЗаконченоРедактирование"
		Или Параметр.Событие = "ВерсияСохранена") Тогда
		
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Владелец, ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВерсияПрисоединенногоФайла", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ИзменитьДоступностьКоманд();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВерсияПрисоединенногоФайла", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Сравнить 2 выбранные версии. 
&НаКлиенте
Процедура Сравнить(Команда)
	
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	Если ЧислоВыделенныхСтрок <> 2 И ЧислоВыделенныхСтрок <> 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для просмотра отличий необходимо выбрать две версии файла.'"));
		Возврат;
	КонецЕсли;
		
	Если ЧислоВыделенныхСтрок = 2 Тогда
		ПервыйФайл = Элементы.Список.ВыделенныеСтроки[0];
		ВторойФайл = Элементы.Список.ВыделенныеСтроки[1];
	ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
		ПервыйФайл = Элементы.Список.ТекущиеДанные.Ссылка;
		ВторойФайл = Элементы.Список.ТекущиеДанные.РодительскаяВерсия;
	КонецЕсли;
	
	Расширение = НРег(Элементы.Список.ТекущиеДанные.Расширение);
	РаботаСФайламиСлужебныйКлиент.СравнитьФайлы(УникальныйИдентификатор, ПервыйФайл, ВторойФайл, Расширение, ВладелецВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсию(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Владелец, ТекущиеДанные.Ссылка ,УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(ТекущиеДанные.Владелец, ТекущиеДанные.Ссылка , УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.УдалитьДанные(
		Новый ОписаниеОповещения("ПослеУдаленияДанных", ЭтотОбъект),
		Элементы.Список.ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПомеченныеФайлы(Команда)
	
	РаботаСФайламиСлужебныйКлиент.ИзменитьОтборПоПометкеУдаления(Список.Отбор, Элементы.ПоказыватьПомеченныеФайлы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьДоступностьКоманд()
	
	АвторТекущийПользователь =
		Элементы.Список.ТекущиеДанные.Автор = ПользователиКлиент.АвторизованныйПользователь();
	
	Элементы.ФормаУдалить.Доступность = АвторТекущийПользователь;
	Элементы.СписокКонтекстноеМенюУдалить.Доступность = АвторТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура СменитьАктивнуюВерсиюФайла(Версия)
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировкиДанных = Блокировка.Добавить(Метаданные.НайтиПоТипу(ТипЗнч(Версия.Владелец)).ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Версия.Владелец);
		
		ЭлементБлокировкиДанных = Блокировка.Добавить(Метаданные.НайтиПоТипу(ТипЗнч(Версия)).ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Версия);
		
		Блокировка.Заблокировать();
		
		ЗаблокироватьДанныеДляРедактирования(Версия.Владелец, , УникальныйИдентификаторКарточкиФайла);
		ЗаблокироватьДанныеДляРедактирования(Версия, , УникальныйИдентификаторКарточкиФайла);
		
		ФайлОбъект = Версия.Владелец.ПолучитьОбъект();
		Если ФайлОбъект.ПодписанЭП Тогда
			ВызватьИсключение НСтр("ru = 'У подписанного файла нельзя изменять активную версию.'");
		КонецЕсли;
		ФайлОбъект.ТекущаяВерсия = Версия;
		ФайлОбъект.ТекстХранилище = Версия.ТекстХранилище;
		ФайлОбъект.Записать();
		
		ВерсияОбъект = Версия.ПолучитьОбъект();
		ВерсияОбъект.Записать();
		
		РазблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, УникальныйИдентификаторКарточкиФайла);
		РазблокироватьДанныеДляРедактирования(Версия, УникальныйИдентификаторКарточкиФайла);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДинамическийСписок(ИмяСправочникаХранилищаВерсийФайлов)
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВерсииФайлов.Код КАК Код,
		|	ВерсииФайлов.Размер КАК Размер,
		|	ВерсииФайлов.Комментарий КАК Комментарий,
		|	ВерсииФайлов.Автор КАК Автор,
		|	ВерсииФайлов.ДатаСоздания КАК ДатаСоздания,
		|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
		|	ВерсииФайлов.РодительскаяВерсия КАК РодительскаяВерсия,
		|	ВЫБОР
		|		КОГДА ВерсииФайлов.ПометкаУдаления
		|			ТОГДА ВерсииФайлов.ИндексКартинки + 1
		|		ИНАЧЕ ВерсииФайлов.ИндексКартинки
		|	КОНЕЦ КАК ИндексКартинки,
		|	ВерсииФайлов.ПометкаУдаления КАК ПометкаУдаления,
		|	ВерсииФайлов.Владелец КАК Владелец,
		|	ВерсииФайлов.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ВерсииФайлов.Владелец.ТекущаяВерсия = ВерсииФайлов.Ссылка
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЭтоТекущая,
		|	ВерсииФайлов.Расширение КАК Расширение,
		|	ВерсииФайлов.НомерВерсии КАК НомерВерсии
		|ИЗ
		|	Справочник." + ИмяСправочникаХранилищаВерсийФайлов + " КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.Владелец = &Владелец";
	
	ПолноеИмяСправочника = "Справочник." + ИмяСправочникаХранилищаВерсийФайлов;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника", ПолноеИмяСправочника);
	
	СвойстваСписка.ОсновнаяТаблица  = ПолноеИмяСправочника;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

#КонецОбласти
