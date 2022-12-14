///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СтарыеЗначения; // Значения некоторых реквизитов и табличных частей группы доступа
                      // до ее изменения для использования в обработчике события ПриЗаписи.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	РегистрыСведений.ПраваРолей.ПроверитьДанныеРегистра();
	
	СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
		"Ссылка, Профиль, ПометкаУдаления, Пользователи, ВидыДоступа, ЗначенияДоступа");
	
	// Удаление пустых участников группы доступа.
	Индекс = Пользователи.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Если Не ЗначениеЗаполнено(Пользователи[Индекс].Пользователь) Тогда
			Пользователи.Удалить(Индекс);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Если Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		
		// Всегда предопределенный профиль Администратор.
		Профиль = Справочники.ПрофилиГруппДоступа.Администратор;
		
		// Не может быть персональной группой доступа.
		Пользователь = Неопределено;
		
		// Не может иметь обычного ответственного (только полноправные пользователи).
		Ответственный = Неопределено;
		
		// Изменение разрешено только полноправному пользователю.
		Если НЕ ПривилегированныйРежим()
		   И НЕ УправлениеДоступом.ЕстьРоль("ПолныеПрава") Тогда
			
			ВызватьИсключение
				НСтр("ru = 'Предопределенную группу доступа Администраторы
				           |можно изменять, либо в привилегированном режиме,
				           |либо при наличии роли ""Полные права"".'");
		КонецЕсли;
		
		// Проверка наличия только пользователей.
		Для каждого ТекущаяСтрока Из Пользователи Цикл
			Если ТипЗнч(ТекущаяСтрока.Пользователь) <> Тип("СправочникСсылка.Пользователи") Тогда
				ВызватьИсключение
					НСтр("ru = 'Предопределенная группа доступа Администраторы
					           |может содержать только пользователей.
					           |
					           |Группы пользователей, внешние пользователи и
					           |группы внешних пользователей недопустимы.'");
			КонецЕсли;
		КонецЦикла;
		
	// Нельзя устанавливать предопределенный профиль Администратор произвольной группе доступа.
	ИначеЕсли Профиль = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		ВызватьИсключение
			НСтр("ru = 'Предопределенный профиль Администратор может быть только
			           |у предопределенной группы доступа Администраторы.'");
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		// Автоматическая установка реквизитов для персональной группы доступа.
		Если ЗначениеЗаполнено(Пользователь) Тогда
			Родитель = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа();
		Иначе
			Пользователь = Неопределено;
			Если Родитель = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа(Истина) Тогда
				Родитель = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		// При снятии пометки удаления с группы доступа выполняется
		// снятие пометки удаления с профиля этой группы доступа.
		Если Не ПометкаУдаления И СтарыеЗначения.ПометкаУдаления = Истина Тогда
			НачатьТранзакцию();
			Попытка
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("Справочник.ПрофилиГруппДоступа");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Профиль);
				Блокировка.Заблокировать();
				
				ПометкаУдаленияПрофиля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Профиль, "ПометкаУдаления");
				ПометкаУдаленияПрофиля = ?(ПометкаУдаленияПрофиля = Неопределено, Ложь, ПометкаУдаленияПрофиля);
				Если ПометкаУдаленияПрофиля Тогда
					ЗаблокироватьДанныеДляРедактирования(Профиль);
					ПрофильОбъект = Профиль.ПолучитьОбъект();
					ПрофильОбъект.ПометкаУдаления = Ложь;
					ПрофильОбъект.Записать();
				КонецЕсли;
				
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обновляет:
// - роли добавленных, оставшихся и удаленных пользователей;
// - РегистрСведений.ТаблицыГруппДоступа;
// - РегистрСведений.ЗначенияГруппДоступа.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
		ОбновитьРолиПользователейПриИзмененииГруппыДоступа();
	КонецЕсли;
	
	НаличиеУчастников = Пользователи.Количество() <> 0;
	СтароеНаличиеУчастников = СтарыеЗначения.Ссылка = Ссылка И Не СтарыеЗначения.Пользователи.Пустой();
	
	Если Профиль           <> СтарыеЗначения.Профиль
	 Или ПометкаУдаления   <> СтарыеЗначения.ПометкаУдаления
	 Или НаличиеУчастников <> СтароеНаличиеУчастников Тогда
		
		РегистрыСведений.ТаблицыГруппДоступа.ОбновитьДанныеРегистра(Ссылка);
	КонецЕсли;
	
	Если Справочники.ГруппыДоступа.ИзменилисьВидыИлиЗначенияДоступа(СтарыеЗначения, ЭтотОбъект)
	 Или ПометкаУдаления   <> СтарыеЗначения.ПометкаУдаления
	 Или НаличиеУчастников <> СтароеНаличиеУчастников Тогда
		
		РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(Ссылка);
	КонецЕсли;
	
	Справочники.ПрофилиГруппДоступа.ОбновитьВспомогательныеДанныеПрофилейИзмененныхПриЗагрузке();
	Справочники.ГруппыДоступа.ОбновитьВспомогательныеДанныеГруппДоступаИзмененныхПриЗагрузке();
	Справочники.ГруппыДоступа.ОбновитьВспомогательныеДанныеГруппПользователейИзмененныхПриЗагрузке();
	Справочники.ГруппыДоступа.ОбновитьРолиПользователейИзмененныхПриЗагрузке();
	
	Если УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально() Тогда
		ТипыИзмененныхУчастников = ТипыИзмененныхУчастников(Пользователи, СтарыеЗначения.Пользователи);
		УправлениеДоступомСлужебный.ЗапланироватьОбновлениеНаборовГруппДоступа(
			"ГруппыДоступаПриИзмененииУчастников",
			ТипыИзмененныхУчастников.Пользователи,
			ТипыИзмененныхУчастников.ВнешниеПользователи);
		
		Если Не ПометкаУдаления Тогда
			УправлениеДоступомСлужебный.ЗапланироватьОбновлениеДоступаПриИзмененииУчастниковГруппыДоступа(Ссылка,
				ТипыИзмененныхУчастников);
		КонецЕсли;
		Если ПометкаУдаления <> СтарыеЗначения.ПометкаУдаления Тогда
			УправлениеДоступомСлужебный.ОбновитьГруппыДоступаРазрешенногоКлючаДоступа(Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
			ПроверяемыеРеквизиты, ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  НовыеУчастники - СправочникТабличнаяЧасть.ГруппыДоступа.Пользователи
//  СтарыеУчастники - РезультатЗапроса
// Возвращаемое значение:
//  Структура:
//    * ВнешниеПользователи - Булево
//    * Пользователи - Булево
//
Функция ТипыИзмененныхУчастников(НовыеУчастники, СтарыеУчастники)
	
	ТипыИзмененныхУчастников = Новый Структура;
	ТипыИзмененныхУчастников.Вставить("Пользователи", Ложь);
	ТипыИзмененныхУчастников.Вставить("ВнешниеПользователи", Ложь);
	
	ВсеУчастники = НовыеУчастники.Выгрузить(, "Пользователь");
	ВсеУчастники.Колонки.Добавить("ВидИзмененияСтроки", Новый ОписаниеТипов("Число"));
	ВсеУчастники.ЗаполнитьЗначения(1, "ВидИзмененияСтроки");
	Если СтарыеУчастники <> Неопределено Тогда
		Выборка = СтарыеУчастники.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ВсеУчастники.Добавить();
			НоваяСтрока.Пользователь = Выборка.Пользователь;
			НоваяСтрока.ВидИзмененияСтроки = -1;
		КонецЦикла;
	КонецЕсли;
	ВсеУчастники.Свернуть("Пользователь", "ВидИзмененияСтроки");
	Для Каждого Строка Из ВсеУчастники Цикл
		Если Строка.ВидИзмененияСтроки = 0 Тогда
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(Строка.Пользователь) = Тип("СправочникСсылка.Пользователи")
		 Или ТипЗнч(Строка.Пользователь) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
			ТипыИзмененныхУчастников.Пользователи = Истина;
		КонецЕсли;
		Если ТипЗнч(Строка.Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи")
		 Или ТипЗнч(Строка.Пользователь) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
			ТипыИзмененныхУчастников.ВнешниеПользователи = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТипыИзмененныхУчастников;
	
КонецФункции

Процедура ОбновитьРолиПользователейПриИзмененииГруппыДоступа()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СеансЗапущенБезРазделителей = МодульРаботаВМоделиСервиса.СеансЗапущенБезРазделителей();
	Иначе
		СеансЗапущенБезРазделителей = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено()
		И Ссылка = Справочники.ГруппыДоступа.Администраторы
		И Не СеансЗапущенБезРазделителей
		И ДополнительныеСвойства.Свойство("ПарольПользователяСервиса") Тогда
		
		ПарольПользователяСервиса = ДополнительныеСвойства.ПарольПользователяСервиса;
	Иначе
		ПарольПользователяСервиса = Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользователиДляОбновления =
		Справочники.ГруппыДоступа.ПользователиДляОбновленияРолей(СтарыеЗначения, ЭтотОбъект);
	
	Если Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		// Добавление пользователей, связанных с пользователямиИБ, имеющих роль ПолныеПрава.
		
		Для Каждого ПользовательИБ Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
			Если ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
				
				НайденныйПользователь = Справочники.Пользователи.НайтиПоРеквизиту(
					"ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
				
				Если НЕ ЗначениеЗаполнено(НайденныйПользователь) Тогда
					НайденныйПользователь = Справочники.ВнешниеПользователи.НайтиПоРеквизиту(
						"ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(НайденныйПользователь)
				   И ПользователиДляОбновления.Найти(НайденныйПользователь) = Неопределено Тогда
					
					ПользователиДляОбновления.Добавить(НайденныйПользователь);
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УправлениеДоступом.ОбновитьРолиПользователей(ПользователиДляОбновления, ПарольПользователяСервиса);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли