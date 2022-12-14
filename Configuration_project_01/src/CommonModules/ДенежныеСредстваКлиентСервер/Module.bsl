
#Область ПрограммныйИнтерфейс

// Преобразует строку в значение типа Дата. При неудаче возвращает пустую дату.
//
// Параметры:
//    Источник - Строка - Преобразуемое значение.
//
// Возвращаемое значение:
//    Дата - Полученная дата
//
Функция ПолучитьДатуИзСтроки(Знач Источник) Экспорт
	
	Приемник = '00010101';
	
	Если ПустаяСтрока(Источник) Тогда
		Возврат Приемник;
	КонецЕсли;
	
	Попытка
		
		Приемник = Дата(Источник);
		
	Исключение
	
		Буфер = Источник;
		
		ПозицияТочки = СтрНайти(Буфер, ".");
		
		Если ПозицияТочки = 0 Тогда
			Возврат Приемник;
		КонецЕсли;
		
		ЧислоДаты = Лев(Буфер, ПозицияТочки - 1);
		Буфер = Сред(Буфер, ПозицияТочки + 1);
		
		ПозицияТочки = СтрНайти(Буфер, ".");
		
		Если ПозицияТочки = 0 Тогда
			Возврат Приемник;
		КонецЕсли;
		
		МесяцДаты = Лев(Буфер, ПозицияТочки - 1);
		ГодДаты = Сред(Буфер, ПозицияТочки + 1);
		
		Попытка
			
			Если СтрДлина(ГодДаты) = 2 Тогда
			
				Если Число(ГодДаты) < 50 Тогда
					ГодДаты = "20" + ГодДаты;
				Иначе
					ГодДаты = "19" + ГодДаты;
				КонецЕсли;
			
			КонецЕсли;
			
		Исключение
			Возврат Приемник;
		КонецПопытки;
		
		Попытка
			
			Приемник = Дата(Число(ГодДаты), Число(МесяцДаты), Число(ЧислоДаты));
			
		Исключение
			
			Возврат Приемник;
			
		КонецПопытки;
	КонецПопытки;
	
	Возврат Приемник;
	
КонецФункции

// Преобразует строку в значение числового типа. При неудаче возвращает Неопределено.
//
// Параметры:
//    Источник - Строка - Преобразуемое значение.
//
// Возвращаемое значение:
//    Число - Полученное число
//
Функция ПреобразоватьВЧисло(Знач Буфер) Экспорт
	
	Если ТипЗнч(Буфер) = Тип("Число") Тогда
		Возврат Буфер;
	КонецЕсли;
	
	Буфер = СокрЛП(СтрЗаменить(Буфер, " ", ""));
	Если Не ПустаяСтрока(Буфер)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрЗаменить(СтрЗаменить(СтрЗаменить(Буфер, ".", ""), "-", ""), ",", "")) Тогда
		Результат = Число(Буфер);
		Если Результат < 0 Тогда
			Результат = - Результат;
		КонецЕсли;
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные файла выписки
//
// Параметры :
//    СтрокиВыписки - Массив - Массив строк файла выписки
//    ЧитатьДокументы - Булево - Признак чтения всей выписки, включая документы.
//
// Возвращаемое значение:
//    Структура - Данные выписки
//
Функция РазобратьФайлВыписки(СтрокиВыписки, ЧитатьДокументы = Истина) Экспорт
	
	Если ТипЗнч(СтрокиВыписки) <> Тип("Массив") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура("Заголовок, СписокСчетов, РасчетныеСчета, ДокументыВыписки, ОшибкиРазбора");
	ЗаголовокВыписки        = Неопределено;
	СписокСчетовВыписки     = Новый Массив;
	РасчетныеСчетаВыписки   = Новый Массив;
	ДокументыВыписки        = Новый Массив;
	ОшибкиРазбора           = Новый Массив;
	
	Попытка
	
	КоличествоСтрок = СтрокиВыписки.Количество();
	ТекущаяСтрока = 1;
	Пока ТекущаяСтрока < КоличествоСтрок Цикл
		
		Стр = ПолучитьСтрокуИмпорта(ТекущаяСтрока, КоличествоСтрок, СтрокиВыписки);
		
		Значение = "";
		Тег = "";
		РазобратьТеговуюСтроку(Стр, Тег, Значение);
		
		Если Лев(Врег(СокрЛП(Стр)), 14) = "СЕКЦИЯДОКУМЕНТ" Тогда
			
			Если Не ЧитатьДокументы Тогда
				Прервать;
			КонецЕсли;
			
			ТегиСтрокиДокумента = ТегиСтрокиДокумента();
			ТегиСтрокиДокумента.Операция = Значение;
			
			ЗагрузитьСекциюДокумента(ТегиСтрокиДокумента, ТекущаяСтрока, КоличествоСтрок, СтрокиВыписки);
			
			ДокументыВыписки.Добавить(ТегиСтрокиДокумента);
			
		ИначеЕсли Лев(Врег(СокрЛП(Стр)), 14) = "СЕКЦИЯРАСЧСЧЕТ" Тогда
			
			СтруктураРССчет = ЗагрузитьСекциюРасчСчета(ТекущаяСтрока, КоличествоСтрок, СтрокиВыписки);
			Если СтруктураРССчет <> Неопределено Тогда
				РасчетныеСчетаВыписки.Добавить(СтруктураРССчет);
			КонецЕсли;
			
		ИначеЕсли Лев(Врег(СокрЛП(Стр)), 8) = "РАСЧСЧЕТ" Тогда
			
			Значение = "";
			Тег      = "";
			РазобратьТеговуюСтроку(Стр, Тег, Значение);
			Если Тег = "РАСЧСЧЕТ" Тогда
				Если СписокСчетовВыписки.Найти(Значение) = Неопределено Тогда
					СписокСчетовВыписки.Добавить(Значение);
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли Лев(Врег(СокрЛП(Стр)), 10) = "КОНЕЦФАЙЛА" Тогда
			Прервать;
			
		ИначеЕсли Лев(Врег(СокрЛП(Стр)), 20) = "1CCLIENTBANKEXCHANGE" Тогда
			Продолжить;
			
		Иначе
			ЗагрузитьСтрокуЗаголовка(Стр, ТекущаяСтрока, ЗаголовокВыписки);
			
		КонецЕсли;
	КонецЦикла;
	
	Результат.Заголовок        = ЗаголовокВыписки;
	Результат.СписокСчетов     = СписокСчетовВыписки;
	Результат.РасчетныеСчета   = РасчетныеСчетаВыписки;
	Результат.ОшибкиРазбора    = ОшибкиРазбора;
	Результат.ДокументыВыписки = ДокументыВыписки;
	
	Исключение
		
		ОшибкиРазбора.Добавить(НСтр("ru = 'Структура файла не соответствует поддерживаемому формату.'"));
		
		Результат.Заголовок        = ЗаголовокВыписки;
		Результат.СписокСчетов     = СписокСчетовВыписки;
		Результат.РасчетныеСчета   = РасчетныеСчетаВыписки;
		Результат.ОшибкиРазбора    = ОшибкиРазбора;
		Результат.ДокументыВыписки = ДокументыВыписки;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Проверка корректности банковского счета
//
// Параметры:
//  Номер        - Строка - Номер банковского счета.
//  ВалютныйСчет - Булево - Признак, является ли счет валютным.
//  ТекстОшибки  - Строка - Текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево
//  Истина - контрольный ключ верен
//  Ложь - контрольный ключ не верен.
//
Функция ПроверитьКорректностьНомераСчета(Знач Номер, ВалютныйСчет = Ложь, ТекстОшибки = "") Экспорт
	
	Результат = Истина;
	Номер = СокрЛП(Номер);
	Если ПустаяСтрока(Номер) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ТекстОшибки = "";
	ДлинаНомера = СтрДлина(Номер);
	Если Не ВалютныйСчет И Не (ДлинаНомера = 20 Или ДлинаНомера = 11) Тогда
		ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", " ") +
			СтрШаблон(НСтр("ru = 'Номер счета должен состоять из 20 или 11 цифр. Введено %1 цифр'"), ДлинаНомера);
		Результат = Ложь;
	ИначеЕсли ДлинаНомера = 20 И Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Номер) Тогда
		ТекстОшибки = ТекстОшибки + ?(ПустаяСтрока(ТекстОшибки), "", " ") +
			НСтр("ru = 'В номере банковского счета присутствуют не только цифры.
				|Возможно, номер указан неверно.'");
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеИнтерфейснымиЭлементамиФормы

Процедура НастроитьЭлементыФормы(Форма, ИзмененныйРеквизит = "", ДополнительныеРеквизиты = Неопределено) Экспорт
	
	СвойстваЭлементовФормы = СвойстваЭлементовФормы(Форма.Объект, Форма.НастройкиПолей, Форма.ЗависимостиПолей, ИзмененныйРеквизит, ДополнительныеРеквизиты);
	
	Для каждого СвойстваЭлемента Из СвойстваЭлементовФормы Цикл
		
		Если Не ЗначениеЗаполнено(СвойстваЭлемента.ИмяЭлемента) Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяЭлемента = СтрЗаменить(СвойстваЭлемента.ИмяЭлемента, ".", "");
		
		Если СвойстваЭлемента.Свойство = "ТолькоПросмотрБезОтметкиНезаполненного" Тогда
			Форма.Элементы[ИмяЭлемента].ТолькоПросмотр = СвойстваЭлемента.Значение;
			Форма.Элементы[ИмяЭлемента].АвтоОтметкаНезаполненного = Не СвойстваЭлемента.Значение;
		ИначеЕсли СвойстваЭлемента.Свойство = "ТолькоПросмотрБезОчистки" Тогда
			Форма.Элементы[ИмяЭлемента].ТолькоПросмотр = СвойстваЭлемента.Значение;
		ИначеЕсли СвойстваЭлемента.Свойство = "ВидимостьЭлемента" Тогда
			Форма.Элементы[ИмяЭлемента].Видимость = СвойстваЭлемента.Значение;
		Иначе
			Форма.Элементы[ИмяЭлемента][СвойстваЭлемента.Свойство] = СвойстваЭлемента.Значение;
		КонецЕсли;
		Если СвойстваЭлемента.Свойство = "АвтоОтметкаНезаполненного" И СвойстваЭлемента.Значение = Ложь
			Или СвойстваЭлемента.Свойство = "ТолькоПросмотрБезОтметкиНезаполненного" И СвойстваЭлемента.Значение = Истина Тогда
			Форма.Элементы[ИмяЭлемента].ОтметкаНезаполненного = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция СвойстваЭлементовФормы(Объект, НастройкиПолей, ЗависимостиПолей = Неопределено, ИзмененныйРеквизит = "", ДополнительныеРеквизиты = Неопределено) Экспорт
	
	СвойстваЭлементовФормы = Новый Массив;
	
	Если Не ЗначениеЗаполнено(ИзмененныйРеквизит) Или Не ЗначениеЗаполнено(ЗависимостиПолей) Тогда
		
		Для каждого ЭлементНастройки Из НастройкиПолей Цикл
			
			ЗначениеУсловия = Неопределено;
			
			Для каждого Поле Из ЭлементНастройки.Поля Цикл
				
				Если ЗначениеУсловия = Неопределено Тогда
					ЗначениеУсловия = ЗначениеУсловия(ЭлементНастройки.Условие.Элементы, Объект,, ДополнительныеРеквизиты);
				КонецЕсли;
				
				Для каждого Свойство Из ЭлементНастройки.Свойства Цикл
					
					Если Свойство.Значение = Неопределено
						Или ТипЗнч(Свойство.Значение) = Тип("Булево") Тогда
						
						Если Свойство.Значение = Неопределено Тогда
							ЗначениеСвойства = ЗначениеУсловия;
						ИначеЕсли Свойство.Значение Тогда
							ЗначениеСвойства = ЗначениеУсловия;
						Иначе
							ЗначениеСвойства = Не ЗначениеУсловия;
						КонецЕсли;
						
						ДобавитьСвойствоПоляФормы(Поле, Свойство.Ключ, ЗначениеСвойства, СвойстваЭлементовФормы);
					Иначе
						Если Не ЗначениеЗаполнено(ЗначениеУсловия) Или ЗначениеУсловия Тогда
							ДобавитьСвойствоПоляФормы(Поле, Свойство.Ключ, Свойство.Значение, СвойстваЭлементовФормы);
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
	Иначе
		
		ЗависимыеПоля = Неопределено;
		
		ИзмененныеРеквизиты = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИзмененныйРеквизит,,, Истина);
		
		Для каждого ЗначениеРеквизита Из ИзмененныеРеквизиты Цикл
			
			НайденныеСтроки = ЗависимостиПолей.НайтиСтроки(Новый Структура("ИмяРеквизита", ЗначениеРеквизита));
			Если НайденныеСтроки.Количество() Тогда
				ЗависимыеПоля = НайденныеСтроки[0].ЗависимыеПоля;
			КонецЕсли;
			
			Если ЗависимыеПоля <> Неопределено Тогда
				
				Для каждого ЭлементНастройки Из НастройкиПолей Цикл
					
					ЗначениеУсловия = Неопределено;
					
					Для каждого Поле Из ЭлементНастройки.Поля Цикл
						
						Если ЗависимыеПоля.Найти(Поле) = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						Если ЗначениеУсловия = Неопределено Тогда
							ЗначениеУсловия = ЗначениеУсловия(ЭлементНастройки.Условие.Элементы, Объект,, ДополнительныеРеквизиты);
						КонецЕсли;
						
						Для каждого Свойство Из ЭлементНастройки.Свойства Цикл
							
							Если Свойство.Значение = Неопределено
								Или ТипЗнч(Свойство.Значение) = Тип("Булево") Тогда
								
								Если Свойство.Значение = Неопределено Тогда
									ЗначениеСвойства = ЗначениеУсловия;
								ИначеЕсли Свойство.Значение Тогда
									ЗначениеСвойства = ЗначениеУсловия;
								Иначе
									ЗначениеСвойства = Не ЗначениеУсловия;
								КонецЕсли;
								
								ДобавитьСвойствоПоляФормы(Поле, Свойство.Ключ, ЗначениеСвойства, СвойстваЭлементовФормы);
							Иначе
								Если Не ЗначениеЗаполнено(ЗначениеУсловия) Или ЗначениеУсловия Тогда
									ДобавитьСвойствоПоляФормы(Поле, Свойство.Ключ, Свойство.Значение, СвойстваЭлементовФормы);
								КонецЕсли;
							КонецЕсли;
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат СвойстваЭлементовФормы;
	
КонецФункции

Процедура ДобавитьСвойствоПоляФормы(ИмяЭлемента, Свойство, Значение, СвойстваПолейФормы)
	
	НовоеСвойство = Новый Структура;
	НовоеСвойство.Вставить("ИмяЭлемента", ИмяЭлемента);
	НовоеСвойство.Вставить("Свойство", Свойство);
	НовоеСвойство.Вставить("Значение", Значение);
	
	СвойстваПолейФормы.Добавить(НовоеСвойство);
	
КонецПроцедуры

Функция ЗначениеУсловия(ЭлементыУсловия, Объект, ТипГруппы = Неопределено, ДополнительныеРеквизиты = Неопределено)
	
	Если ТипГруппы = Неопределено Тогда
		ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	КонецЕсли;
	
	Значение = Неопределено;
	
	Для каждого ЭлементУсловия Из ЭлементыУсловия Цикл
		Если ТипЗнч(ЭлементУсловия) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Если ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ Тогда
				
				Если Значение = Неопределено Тогда
					Значение = Истина;
				КонецЕсли;
				Значение = Значение И ЗначениеУсловия(ЭлементУсловия.Элементы, Объект, ЭлементУсловия.ТипГруппы, ДополнительныеРеквизиты);
				
			ИначеЕсли ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли Тогда
				
				Если Значение = Неопределено Тогда
					Значение = Ложь;
				КонецЕсли;
				Значение = Значение Или ЗначениеУсловия(ЭлементУсловия.Элементы, Объект, ЭлементУсловия.ТипГруппы, ДополнительныеРеквизиты);
				
			ИначеЕсли ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
				
				Значение = Не ЗначениеУсловия(ЭлементУсловия.Элементы, Объект, ЭлементУсловия.ТипГруппы, ДополнительныеРеквизиты);
				
			КонецЕсли;
		Иначе
			Если ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ Тогда
				
				Если Значение = Неопределено Тогда
					Значение = Истина;
				КонецЕсли;
				Значение = Значение И ЗначениеВыраженияУсловия(ЭлементУсловия, Объект, ДополнительныеРеквизиты);
				
			ИначеЕсли ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли Тогда
				
				Если Значение = Неопределено Тогда
					Значение = Ложь;
				КонецЕсли;
				Значение = Значение Или ЗначениеВыраженияУсловия(ЭлементУсловия, Объект, ДополнительныеРеквизиты);
				
			ИначеЕсли ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
				
				Значение = Не ЗначениеВыраженияУсловия(ЭлементУсловия, Объект, ДополнительныеРеквизиты);
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Значение;
	
КонецФункции

Функция ЗначениеВыраженияУсловия(ЭлементУсловия, Объект, ДополнительныеРеквизиты)
	
	Значение = Ложь;
	
	ЛевоеЗначение = Неопределено;
	
	ИмяРеквизита = Строка(ЭлементУсловия.ЛевоеЗначение);
	
	Если ТипЗнч(ДополнительныеРеквизиты) = Тип("Структура") Тогда
		ПозицияТочки = СтрНайти(ИмяРеквизита, ".");
		Если ПозицияТочки <> 0 Тогда
			ДополнительныеРеквизиты.Свойство(Сред(ИмяРеквизита, ПозицияТочки + 1), ЛевоеЗначение);
		Иначе
			ЛевоеЗначение = Объект[ИмяРеквизита];
		КонецЕсли;
	Иначе
		ЛевоеЗначение = Объект[ИмяРеквизита];
	КонецЕсли;
	
	Если ЛевоеЗначение <> Неопределено Тогда
		Если ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			Значение = (ЛевоеЗначение = ЭлементУсловия.ПравоеЗначение);
		ИначеЕсли ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
			Значение = (ЛевоеЗначение <> ЭлементУсловия.ПравоеЗначение);
		ИначеЕсли ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено Тогда
			Значение = ЗначениеЗаполнено(ЛевоеЗначение);
		ИначеЕсли ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке И ТипЗнч(ЭлементУсловия.ПравоеЗначение) = Тип("Массив") Тогда
			Значение = (Не ЭлементУсловия.ПравоеЗначение.Найти(ЛевоеЗначение) = Неопределено);
		ИначеЕсли ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке И ТипЗнч(ЭлементУсловия.ПравоеЗначение) = Тип("СписокЗначений") Тогда
			Значение = (Не ЭлементУсловия.ПравоеЗначение.НайтиПоЗначению(ЛевоеЗначение) = Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти

#Область ПлатежныйКалендарь

Процедура ПересчитатьПодчиненныеСтрокиДерева(СтрокаДерева, ДнейПланирования) Экспорт
	
	Если СтрокаДерева.ВидСтроки = 0 Тогда // Остаток в валюте ДС, либо в валюте платежа
		
		НачальныйОстаток = СтрокаДерева.Остаток;
		Для Инд = 0 По ДнейПланирования Цикл
			СтрокаДерева["День" + Инд] = НачальныйОстаток + СтрокаДерева["День" + Инд + "ВВалюте"];
			НачальныйОстаток = СтрокаДерева["День" + Инд];
		КонецЦикла;
		
	ИначеЕсли СтрокаДерева.ВидСтроки = 2 Тогда // Остаток в одной валюте
		
		СтрокаДерева.Остаток = СтрокаДерева.ОстатокВОднойВалюте;
		НачальныйОстаток = СтрокаДерева.ОстатокВОднойВалюте;
		Для Инд = 0 По ДнейПланирования Цикл
			СтрокаДерева["День" + Инд] = НачальныйОстаток + СтрокаДерева["День" + Инд + "ВОднойВалюте"];
			НачальныйОстаток = СтрокаДерева["День" + Инд];
		КонецЦикла;
		
	ИначеЕсли СтрокаДерева.ВидСтроки = 1 Тогда // Оборот в валюте ДС, либо в валюте платежа
		
		Для Инд = 0 По ДнейПланирования Цикл
			СтрокаДерева["День" + Инд] = СтрокаДерева["День" + Инд + "ВВалюте"];
		КонецЦикла;
		
	ИначеЕсли СтрокаДерева.ВидСтроки = 3 Тогда // Оборот в одной валюте
		
		Для Инд = 0 По ДнейПланирования Цикл
			СтрокаДерева["День" + Инд] = СтрокаДерева["День" + Инд + "ВОднойВалюте"];
		КонецЦикла;
	КонецЕсли;
	
	Если ТипЗнч(СтрокаДерева) = Тип("ДанныеФормыЭлементДерева") Тогда
		Строки = СтрокаДерева.ПолучитьЭлементы();
	Иначе
		Строки = СтрокаДерева.Строки;
	КонецЕсли;
		
	Для каждого СтрокаДерева Из Строки Цикл
		ПересчитатьПодчиненныеСтрокиДерева(СтрокаДерева, ДнейПланирования);
	КонецЦикла;
	
КонецПроцедуры

Функция ДатаПлатежа(ПланироватьСДаты, День) Экспорт
	
	Возврат ПланироватьСДаты + 86400 * (День - 1);
	
КонецФункции

Функция ДеньПлатежа(ПланироватьСДаты, ДатаПлатежа) Экспорт
	
	Если ПланироватьСДаты > ДатаПлатежа Тогда
		Возврат 0;
	Иначе
		Возврат (ДатаПлатежа - ПланироватьСДаты)/86400 + 1;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область РазборВыписки

Процедура ЗагрузитьСтрокуЗаголовка(ТекстСтрокиЗаголовка, ТекущаяСтрока, ЗаголовокВыписки)
	
	Если ТипЗнч(ЗаголовокВыписки) = Тип("Неопределено") Тогда
		ЗаголовокВыписки = Новый Структура(
			ВРЕГ("ВерсияФормата, Кодировка, Отправитель, Получатель, ДатаСоздания, ВремяСоздания, ДатаНачала, ДатаКонца"));
	КонецЕсли;
	
	Значение = ""; Тег = "";
	
	Если РазобратьТеговуюСтроку(ТекстСтрокиЗаголовка, Тег, Значение) Тогда
		Если ЗаголовокВыписки.Свойство(Тег) Тогда
			
			ЗаголовокВыписки[Тег] = Значение;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗагрузитьСекциюРасчСчета(ТекущаяСтрока, КоличествоСтрок, МассивСтрок)
	
	ТегиРасчетногоСчета = ТегиРасчетногоСчета();
	
	СтрокаРазбора = ПолучитьСтрокуИмпорта(ТекущаяСтрока, КоличествоСтрок, МассивСтрок);
	
	Значение = ""; Тег = "";
	
	Пока РазобратьТеговуюСтроку(СтрокаРазбора, Тег, Значение) Цикл
		
		Если ТегиРасчетногоСчета.Свойство(Тег) Тогда
			
			ТегиРасчетногоСчета[Тег] = Значение;
			
		КонецЕсли;
		
		СтрокаРазбора = ПолучитьСтрокуИмпорта(ТекущаяСтрока, КоличествоСтрок, МассивСтрок);
		
		Значение = ""; Тег = "";
		
	КонецЦикла;
	
	Если ВРЕГ(Лев(СокрЛП(СтрокаРазбора), 13)) = "КОНЕЦРАСЧСЧЕТ" Тогда
		Возврат ТегиРасчетногоСчета;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ЗагрузитьСекциюДокумента(СтрокаДокумента, ТекущаяСтрока, КоличествоСтрок, МассивСтрок)
	
	СекцияДокумента = "СЕКЦИЯДОКУМЕНТ=" + СтрокаДокумента.Операция + Символы.ПС;
	
	СтрокаРазбора = ПолучитьСтрокуИмпорта(ТекущаяСтрока, КоличествоСтрок, МассивСтрок);
	
	Пока Лев(Врег(СокрЛП(СтрокаРазбора)), 14) <> "КОНЕЦДОКУМЕНТА" Цикл
		Тег      = "";
		Значение = "";
		
		Если РазобратьТеговуюСтроку(СтрокаРазбора, Тег, Значение) Тогда
			
			СекцияДокумента = СекцияДокумента + СтрокаРазбора + Символы.ПС;
			
			Если СтрокаДокумента.Свойство(Тег) Тогда
				
				Если ЗначениеЗаполнено(Значение) И НЕ ЗначениеЗаполнено(СтрокаДокумента[Тег]) Тогда
					СтрокаДокумента[Тег] = Значение;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		СтрокаРазбора = ПолучитьСтрокуИмпорта(ТекущаяСтрока, КоличествоСтрок, МассивСтрок);
		
	КонецЦикла;
	
	СтрокаДокумента.ДанныеВыписки = СекцияДокумента + "КОНЕЦДОКУМЕНТА";
	
КонецПроцедуры

Функция ПолучитьСтрокуИмпорта(ТекущаяСтрока, КоличествоСтрок, МассивСтрок)
	
	Буфер = "";
	
	Пока ПустаяСтрока(Буфер) ИЛИ Лев(Буфер, 2) = "//" Цикл
		
		Если ТекущаяСтрока > КоличествоСтрок Тогда
			Возврат "";
		КонецЕсли;
		
		Буфер = МассивСтрок[ТекущаяСтрока - 1];
		ТекущаяСтрока = ТекущаяСтрока + 1;
		
	КонецЦикла;
	
	Возврат Буфер;
	
КонецФункции

Функция РазобратьТеговуюСтроку(СтрокаРазбора, Тег, Значение)
	
	ПозицияПрисваивания = СтрНайти(СтрокаРазбора, "=");
	
	Если ПозицияПрисваивания = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Тег = ВРЕГ(СокрЛП(Лев(СтрокаРазбора, ПозицияПрисваивания - 1)));
	
	Значение = СокрЛП(Сред(СтрокаРазбора, ПозицияПрисваивания + 1));
	
	Возврат НЕ ПустаяСтрока(Тег);
	
КонецФункции

Функция ТегиРасчетногоСчета()
	
	Возврат Новый Структура("ДатаНачала, ДатаКонца, РасчСчет, НачальныйОстаток, ВсегоПоступило, ВсегоСписано, КонечныйОстаток");
	
КонецФункции

Функция ТегиСтрокиДокумента()
	
	Возврат Новый Структура(
		"Номер, Дата, Сумма,
		|ВидПлатежа, ВидОплаты, Операция,
		|КвитанцияДата, КвитанцияВремя, КвитанцияСодержание,
		|ДатаСписано, ДатаПоступило,
		|ПлательщикСчет, Плательщик, ПлательщикИНН, Плательщик1, ПлательщикНаименованиеМеждународное, ПлательщикСтрана,
		|ПлательщикРасчСчет, ПлательщикБанк1, ПлательщикБанк2, ПлательщикБИК, ПлательщикКорсчет,
		|ПлательщикБанк3, ПлательщикБанк4, ПлательщикБанк5, ПлательщикСВИФТ,
		|Плательщик2, Плательщик3, Плательщик4,
		|ПолучательСчет, Получатель, ПолучательИНН, Получатель1, ПолучательНаименованиеМеждународное, ПолучательСтрана,
		|ПолучательРасчСчет, ПолучательБанк1, ПолучательБанк2, ПолучательБИК, ПолучательКорсчет,
		|ПолучательБанк3, ПолучательБанк4, ПолучательБанк5, ПолучательСВИФТ,
		|Получатель2, Получатель3, Получатель4,
		|СтатусСоставителя, ПлательщикКПП, ПолучательКПП, ПоказательКБК, ОКАТО, ОКТМО,
		|ПоказательОснования, ПоказательПериода, ПоказательНомера, ПоказательДаты, ПоказательТипа,
		|Код,
		|КодНазПлатежа,
		|НазначениеПлатежа, НазначениеПлатежа1, НазначениеПлатежа2, НазначениеПлатежа3, НазначениеПлатежа4, НазначениеПлатежа5, НазначениеПлатежа6,
		|СрокПлатежа, Очередность,
		|УсловиеОплаты1, УсловиеОплаты2, УсловиеОплаты3,
		|СрокАкцепта, ВидАккредитива, ПлатежПоПредст, ДополнУсловия, НомерСчетаПоставщика, ДатаОтсылкиДок,
		|ДанныеВыписки
		|");
	
КонецФункции

#КонецОбласти

#КонецОбласти