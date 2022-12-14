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
	
	ЭлектроннаяПодписьСлужебный.УстановитьУсловноеОформлениеСпискаСертификатов(Список);
	
	Параметры.Отбор.Свойство("Организация", Организация);
	
	ЗакрыватьПриВыборе = Ложь;
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		
		ТекстЗапроса = Список.ТекстЗапроса;
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ДополнитьЗапросСпискаСертификатов(
			ТекстЗапроса);
	Иначе
		ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "&ДополнительноеУсловие", "ИСТИНА");
	КонецЕсли;
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	ГруппаПользователейПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования")
	   И Параметр.Свойство("ЭтоНовый") Тогда
		
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Источник;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаПользователейИспользованиеПриИзменении(Элемент)
	
	ГруппаПользователейПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПользователейПриИзменении(Элемент)
	
	ГруппаПользователейПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Не Копирование Тогда
		ПараметрыСоздания = Новый Структура;
		ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
		ПараметрыСоздания.Вставить("Организация",   Организация);
		
		ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификатПослеВыбораНазначения(
			"ТолькоДляШифрования", ПараметрыСоздания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)
	
	Элементы.Список.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзФайла(Команда)
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
	ПараметрыСоздания.Вставить("Организация",   Организация);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификатТолькоДляШифрованияИзФайла(ПараметрыСоздания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ГруппаПользователейПриИзмененииНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ГруппаПользователей", ГруппаПользователей, ГруппаПользователейИспользование);
	
КонецПроцедуры

#КонецОбласти
