///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает признак использования внешних пользователей в программе
// (значение функциональной опции ИспользоватьВнешнихПользователей).
//
// Возвращаемое значение:
//  Булево - если Истина, внешние пользователи включены.
//
Функция ИспользоватьВнешнихПользователей() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");
	
КонецФункции

// Возвращает текущего внешнего пользователя.
//  Рекомендуется использовать в коде, который поддерживает только внешних пользователей.
//
//  Если вход в сеанс выполнил не внешний пользователь, тогда будет вызвано исключение.
//
// Возвращаемое значение:
//  СправочникСсылка.ВнешниеПользователи - внешний пользователь.
//
Функция ТекущийВнешнийПользователь() Экспорт
	
	Возврат ПользователиСлужебныйКлиентСервер.ТекущийВнешнийПользователь(
		Пользователи.АвторизованныйПользователь());
	
КонецФункции

// Возвращает ссылку на объект авторизации внешнего пользователя, полученный из информационной базы.
// Объект авторизации - это ссылка на объект информационной базы, используемый
// для связи с внешним пользователем, например: контрагент, физическое лицо и т.д.
//
// Параметры:
//  ВнешнийПользователь - Неопределено - используется текущий внешний пользователь.
//                      - СправочникСсылка.ВнешниеПользователи - указанный внешний пользователь.
//
// Возвращаемое значение:
//  Ссылка - объект авторизации одного из типов, указанных в описании типов в свойстве
//           "Метаданные.Справочники.ВнешниеПользователи.Реквизиты.ОбъектыАвторизации.Тип".
//
Функция ПолучитьОбъектАвторизацииВнешнегоПользователя(ВнешнийПользователь = Неопределено) Экспорт
	
	Если ВнешнийПользователь = Неопределено Тогда
		ВнешнийПользователь = ТекущийВнешнийПользователь();
	КонецЕсли;
	
	ОбъектАвторизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВнешнийПользователь, "ОбъектАвторизации").ОбъектАвторизации;
	
	Если ЗначениеЗаполнено(ОбъектАвторизации) Тогда
		Если ПользователиСлужебный.ОбъектАвторизацииИспользуется(ОбъектАвторизации, ВнешнийПользователь) Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Объект авторизации ""%1"" (%2)
					|установлен для нескольких внешних пользователей.'"),
				ОбъектАвторизации,
				ТипЗнч(ОбъектАвторизации));
		КонецЕсли;
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для внешнего пользователя ""%1"" не задан объект авторизации.'"),
			ВнешнийПользователь);
	КонецЕсли;
	
	Возврат ОбъектАвторизации;
	
КонецФункции

// Используется для настройки отображения наличия внешних пользователей в списках справочников (партнеры, респонденты и др.), 
// являющихся объектом авторизации в справочнике ВнешниеПользователи.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - вызывающий объект.
//
Процедура НастроитьОтображениеСпискаВнешнихПользователей(Форма) Экспорт
	
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Возврат;
	КонецЕсли;
	
	// Удаление отображения недоступных сведений.
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(Форма.Список.ТекстЗапроса);
	Источники = СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Источники; // ИсточникиСхемыЗапроса
	Для Индекс = 0 По Источники.Количество() - 1 Цикл
		Если Источники[Индекс].Источник.ИмяТаблицы = "Справочник.ВнешниеПользователи" Тогда
			Источники.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	Форма.Список.ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
КонецПроцедуры

#КонецОбласти
