#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru='Интерактивное создание запрещено.'");
	КонецЕсли;
	
	ПоОбщемуРасписанию = ?(Объект.ПоОтдельномуРасписанию, 1, 0);
	
	ОписаниеДопПараметров = Объект.Ссылка.ПолучитьОбъект().ОписаниеДополнительныхПараметров.Получить();
	
	ДопПараметрыАвтопроверки = Объект.Ссылка.ПолучитьОбъект().ДополнительныеПараметрыАвтопроверки.Получить();
	
	Если НЕ ТипЗнч(ДопПараметрыАвтопроверки) = Тип("Структура") Тогда
		ДопПараметрыАвтопроверки = Новый Структура;
	КонецЕсли;
	
	Если ТипЗнч(ОписаниеДопПараметров) = Тип("ТаблицаЗначений") Тогда
		
		ДобавляемыеРеквизиты = Новый Массив;
		
		Для Каждого ДопПараметр Из ОписаниеДопПараметров Цикл
			
			НовыйРеквизит = Новый РеквизитФормы(ДопПараметр.ИмяПараметра, Новый ОписаниеТипов(ДопПараметр.ТипПараметра),, ДопПараметр.Заголовок);
			
			ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
			
			Если ДопПараметрыПроверки.НайтиПоЗначению(ДопПараметр.ИмяПараметра) = Неопределено Тогда
				ДопПараметрыПроверки.Добавить(ДопПараметр.ИмяПараметра);
			КонецЕсли;
			
			Если ДопПараметр.ИспользуетсяДляАвтопроверки Тогда
				
				НовыйРеквизит = Новый РеквизитФормы("Автопроверка" + ДопПараметр.ИмяПараметра, Новый ОписаниеТипов(ДопПараметр.ТипПараметра),, ДопПараметр.Заголовок);
				
				ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		Для Каждого ДопПараметр Из ОписаниеДопПараметров Цикл
			
			НовыйЭлемент = Элементы.Добавить(ДопПараметр.ИмяПараметра, Тип("ПолеФормы"), Элементы.ГруппаДополнительныеПараметры);
			
			НовыйЭлемент.ПутьКДанным = ДопПараметр.ИмяПараметра;
			
			Если ДопПараметр.ТипПараметра = "Булево" Тогда
				НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
			Иначе
				НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
				НовыйЭлемент.АвтоОтметкаНезаполненного = ДопПараметр.Обязательный;
			КонецЕсли;
			
			ЭтотОбъект[ДопПараметр.ИмяПараметра] = ДопПараметр.ЗначениеПоУмолчанию;
			
			Если ДопПараметр.ИспользуетсяДляАвтопроверки Тогда
				
				НовыйЭлемент = Элементы.Добавить("Автопроверка" + ДопПараметр.ИмяПараметра, Тип("ПолеФормы"), Элементы.ГруппаДополнительныеПараметрыАвтопроверки);
			
				НовыйЭлемент.ПутьКДанным = "Автопроверка" + ДопПараметр.ИмяПараметра;
			
				Если ДопПараметр.ТипПараметра = "Булево" Тогда
					НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
				Иначе
					НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
					НовыйЭлемент.АвтоОтметкаНезаполненного = ДопПараметр.Обязательный;
				КонецЕсли;
				
				Если ДопПараметрыАвтопроверки.Свойство(ДопПараметр.ИмяПараметра) И ЗначениеЗаполнено(ДопПараметрыАвтопроверки[ДопПараметр.ИмяПараметра]) Тогда
					ЭтотОбъект["Автопроверка" + ДопПараметр.ИмяПараметра] = ДопПараметрыАвтопроверки[ДопПараметр.ИмяПараметра];
				Иначе
					ЭтотОбъект["Автопроверка" + ДопПараметр.ИмяПараметра] = ДопПараметр.ЗначениеПоУмолчанию;
					ДопПараметрыАвтопроверки.Вставить(ДопПараметр.ИмяПараметра);
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЦикла;
		
		Для Каждого КлючЗначение Из ДопПараметрыАвтопроверки Цикл
			СтрокаДопПоиск = Новый Структура("ИмяПараметра, ИспользуетсяДляАвтопроверки", КлючЗначение.Ключ, Истина);
			Если ОписаниеДопПараметров.НайтиСтроки(СтрокаДопПоиск).Количество() = 0 Тогда
				ДопПараметрыАвтопроверки.Удалить(КлючЗначение.Ключ);
			КонецЕсли;
		КонецЦикла
	
	КонецЕсли;
	
	Элементы.Важность.ТолькоПросмотр				 = НЕ Объект.ВозможноИзменениеВажности;
	
	Элементы.ГруппаВыполнение.Доступность 			 = НЕ Объект.ПометкаУдаления;
	
	Элементы.ГруппаДополнительныеПараметры.Видимость = НЕ Объект.ВыполняетсяТолькоВКонтексте;
	Элементы.ГруппаВыполнение.Видимость 			 = НЕ Объект.ВыполняетсяТолькоВКонтексте;
	Элементы.ФормаВыполнитьПроверку.Видимость 		 = ТипЗнч(Объект.КонтекстВыполнения) <> Тип("ПеречислениеСсылка.ОперацииЗакрытияМесяца");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РежимРаботы = Новый Структура;
	РежимРаботы.Вставить("ВозможнаНастройкаРасписания",  НЕ ОбщегоНазначения.РазделениеВключено());
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	РегламентноеЗадание = Справочники.ПроверкиСостоянияСистемы.РегламентноеЗаданиеПоУникальномуНомеру(ТекущийОбъект.РегламентноеЗаданиеGUID);
	
	Если НЕ РегламентноеЗадание = Неопределено Тогда
		РасписаниеИндивидуальногоЗадания = РегламентноеЗадание.Расписание;
	КонецЕсли;
	
	ОбщееРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ПроверкаСостоянияСистемы);
	РасписаниеОбщегоЗадания  = ОбщееРегламентноеЗадание.Расписание;
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Код) Тогда
		ТекущийОбъект.УстановитьНовыйКод();
	КонецЕсли;
	
	Если РасписаниеИндивидуальногоЗадания <> Неопределено Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("РасписаниеВыполнения", РасписаниеИндивидуальногоЗадания);
	КонецЕсли;
	
	Если ТипЗнч(ДопПараметрыАвтопроверки) = Тип("Структура") И ДопПараметрыАвтопроверки.Количество() > 0 Тогда
		Для Каждого КлючЗначение Из ДопПараметрыАвтопроверки Цикл
			ДопПараметрыАвтопроверки.Вставить(КлючЗначение.Ключ, ЭтотОбъект["Автопроверка" + КлючЗначение.Ключ]);
		КонецЦикла;
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ДопПараметрыАвтопроверки", ДопПараметрыАвтопроверки);
	КонецЕсли;
	
	ТаблицаДополнительныхПараметровПроверки = ТекущийОбъект.ОписаниеДополнительныхПараметров.Получить();
	
	Если ЗначениеЗаполнено(ТаблицаДополнительныхПараметровПроверки) Тогда
		
		Для Каждого ЭлементСписка Из ДопПараметрыПроверки Цикл
			НайденнаяСтрока = ТаблицаДополнительныхПараметровПроверки.Найти(ЭлементСписка.Значение,"ИмяПараметра");
			Если НайденнаяСтрока <> Неопределено Тогда
				НайденнаяСтрока.ЗначениеПоУмолчанию = ЭтотОбъект[ЭлементСписка.Значение];
			КонецЕсли;
		КонецЦикла;
		
		ТекущийОбъект.ОписаниеДополнительныхПараметров = Новый ХранилищеЗначения(ТаблицаДополнительныхПараметровПроверки);
		
	КонецЕсли;
	
	Если НЕ ТекущийОбъект.ПоОтдельномуРасписанию Тогда
		
		ОбщееРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ПроверкаСостоянияСистемы);
		ОбщееРегламентноеЗаданиеИдентификатор = РегламентныеЗаданияСервер.УникальныйИдентификатор(ОбщееРегламентноеЗадание);
		
		Изменения = Новый Структура("Расписание", РасписаниеОбщегоЗадания);
		РегламентныеЗаданияСервер.ИзменитьЗадание(ОбщееРегламентноеЗаданиеИдентификатор, Изменения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если НЕ Объект.ПоОтдельномуРасписанию Тогда
		Оповестить("ИзмененоРасписаниеПроверкаСостоянияСистемы", РасписаниеОбщегоЗадания, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПредставлениеОбщегоРасписанияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	                                                                                                
	Если РасписаниеОбщегоЗадания = Неопределено Тогда
		РасписаниеОбщегоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеОбщегоЗадания);
	Оповещение = Новый ОписаниеОповещения("ПредставлениеОбщегоРасписанияНажатиеЗавершение", ЭтотОбъект);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеИндивидуальногоРасписанияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	                                                                                                
	Если РасписаниеИндивидуальногоЗадания = Неопределено Тогда
		РасписаниеИндивидуальногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеИндивидуальногоЗадания);
	Оповещение = Новый ОписаниеОповещения("ПредставлениеИндивидуальногоРасписанияНажатиеЗавершение", ЭтотОбъект);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяПриИзменении(Элемент)
	
	УстановитьДоступностьНастройкиРасписания(ЭтотОбъект, Объект.Используется);
	УстановитьВидимостьДоступностьРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоОбщемуРасписаниюПриИзменении(Элемент)
	
	Объект.ПоОтдельномуРасписанию = ПоОбщемуРасписанию = 1;
	УстановитьВидимостьДоступностьРасписания();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить(Объект.Ссылка);
	
	ЗначенияДопПараметров = Новый Структура;
	Для Каждого ЭлементСписка Из ДопПараметрыПроверки Цикл
		ЗначенияДопПараметров.Вставить(ЭлементСписка.Значение, ЭтотОбъект[ЭлементСписка.Значение]);
	КонецЦикла;
	
	Результат = РезультатПроверкиВДлительнойОперации(МассивЭлементов, ЗначенияДопПараметров);
	
	АудитСостоянияСистемыКлиент.ПодключитьДлительнуюОперацию(ЭтаФорма, Результат, ПараметрыОбработчикаОжидания, ФормаДлительнойОперации);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ОбновитьФорму(ЭтотОбъект, Объект.Используется, Объект.ПоОтдельномуРасписанию, Объект.РегламентноеЗаданиеGUID);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФорму(Форма, Используется, ПоОтдельномуРасписанию, УникальныйИдентификаторЗадания)
	
	УстановитьДоступностьНастройкиРасписания(Форма, Используется);
	
	УстановитьВидимостьДоступностьРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОбщегоРасписанияНажатиеЗавершение(Расписание, ДополнительныеПараметры) Экспорт 
	
	Если Расписание = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РасписаниеОбщегоЗадания = Расписание;
	
	ОбновитьПредставлениеРасписания(ЭтаФорма);	
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеИндивидуальногоРасписанияНажатиеЗавершение(Расписание, ДополнительныеПараметры) Экспорт 
	
	Если Расписание = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РасписаниеИндивидуальногоЗадания = Расписание;
	
	ОбновитьПредставлениеРасписания(ЭтаФорма);	
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция РезультатПроверкиВДлительнойОперации(Знач МассивПроверок, Знач ЗначенияДопПараметров)
	
	Возврат АудитСостоянияСистемы.РезультатПроверкиВДлительнойОперации(ЭтаФорма, МассивПроверок, ЗначенияДопПараметров);
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания) Экспорт
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	АудитСостоянияСистемыКлиент.ПроверитьВыполнениеЗадания(ЭтаФорма, ПараметрыОбработчикаОжидания, ФормаДлительнойОперации);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьНастройкиРасписания(Форма, Используется)
	
	Форма.Элементы.ГруппаПараметрыАвтоматическойПроверки.Доступность = Используется;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьРасписания()
	
	Элементы.ПредставлениеОбщегоРасписания.Доступность 			= Объект.Используется И РежимРаботы.ВозможнаНастройкаРасписания;
	Элементы.ПредставлениеИндивидуальногоРасписания.Доступность = Объект.Используется И РежимРаботы.ВозможнаНастройкаРасписания;
	
	ОбновитьПредставлениеРасписания(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеРасписания(Форма)
	
	Если НЕ Форма.Объект.Используется Тогда
		Форма.ПредставлениеОбщегоРасписания = "";
		Форма.ПредставлениеИндивидуальногоРасписания = "";
	ИначеЕсли Форма.Объект.ПоОтдельномуРасписанию Тогда
		Форма.ПредставлениеОбщегоРасписания = "";
		Форма.ПредставлениеИндивидуальногоРасписания = АудитСостоянияСистемыКлиентСервер.ПредставлениеРасписания(Форма.РасписаниеИндивидуальногоЗадания);
	Иначе
		Форма.ПредставлениеОбщегоРасписания = АудитСостоянияСистемыКлиентСервер.ПредставлениеРасписания(Форма.РасписаниеОбщегоЗадания);
		Форма.ПредставлениеИндивидуальногоРасписания = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
