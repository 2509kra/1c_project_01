#Область СлужебныйПрограммныйИнтерфейс

// Получает текущие параметры логирования.
// 
// Возвращаемое значение:
// 	см. НовыеПараметрыЛогированияЗапросов.
Функция ПараметрыЛогированияЗапросов() Экспорт
	
	Возврат ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыСеанса.ПараметрыЛогированияЗапросовИСМП, Ложь);
	
КонецФункции

// Создает новую структуру данных для передачи в метод см. Вывести.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * HTTPЗапросОтвет   - Неопределено, HTTPЗапрос, HTTPОтвет - Запрос или ответ.
// * ПараметрыОтправки - Неопределено, Структура             - Параметры отправки запроса.
// * HTTPМетод         - Строка, Неопределено                - HTTP-метод отправки запроса.
// * ТекстОшибки       - Строка, Неопределено                - Текст ошибки отправки запроса.
Функция НоваяСтруктураДанныхЗаписи() Экспорт
	
	ПараметрыЗаписиЛога = Новый Структура();
	ПараметрыЗаписиЛога.Вставить("HTTPЗапросОтвет",   Неопределено);
	ПараметрыЗаписиЛога.Вставить("ПараметрыОтправки", Неопределено);
	ПараметрыЗаписиЛога.Вставить("HTTPМетод",         Неопределено);
	ПараметрыЗаписиЛога.Вставить("ТекстОшибки",       Неопределено);
	
	Возврат ПараметрыЗаписиЛога;
	
КонецФункции

// Включает логирование запросов в текущем сейнсе на время ЗаписыватьСекунд.
// 
// Параметры:
// 	ЗаписыватьСекунд - Неопределено, Число - Количество секунд, после которых прекратится запись логов запросов.
// 	НовыйЛог         - Булево              - Добавляет новый слой логирования, который обязательно должен завершаться
// 	                                         методом см. ЗавершитьЛогированиеЗапросовПоИдентификатору. 
// 	                                         Возвращаются параметры логирования с текущим значением идентификатора логов.
// Возвращаемое значение:
// 	см. НовыеПараметрыЛогированияЗапросов.
Функция ВключитьЛогированиеЗапросов(ЗаписыватьСекунд = Неопределено, НовыйЛог = Ложь) Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	
	Если Не ЗначениеЗаполнено(ПараметрыЛогирования.ТекущийИдентификатор) Тогда
		УстановитьНовыйЛог(ПараметрыЛогирования);
	КонецЕсли;
	
	Если НовыйЛог Тогда
		ПараметрыСтека                      = НовыеПараметрыЛогированияЗапросов();
		ПараметрыСтека.ТекущийИдентификатор = ПараметрыЛогирования.ТекущийИдентификатор;
		ПараметрыСтека.Включено             = ПараметрыЛогирования.Включено;
		ПараметрыСтека.ОкончаниеЗаписи      = ПараметрыЛогирования.ОкончаниеЗаписи;
		ПараметрыЛогирования.СтекПараметров.Добавить(ПараметрыСтека);
		УстановитьНовыйЛог(ПараметрыЛогирования);
	КонецЕсли;
	
	ПараметрыЛогирования.Включено = Истина;
	
	Если ЗаписыватьСекунд <> Неопределено Тогда
		Если ЗаписыватьСекунд > 0 Тогда
			ПараметрыЛогирования.ОкончаниеЗаписи = ТекущаяУниверсальнаяДатаВМиллисекундах() + (ЗаписыватьСекунд * 1000);
		Иначе
			ПараметрыЛогирования.ОкончаниеЗаписи = 0
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
	Возврат ПараметрыЛогирования;
	
КонецФункции

// Отключает режим записи логов.
// 
Процедура ОтключитьЛогированиеЗапросов() Экспорт
	
	ПараметрыЛогирования                 = ПараметрыЛогированияЗапросов();
	ПараметрыЛогирования.Включено        = Ложь;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

// Очищает файл лога основного слоя.
// 
Процедура ОчиститьЛогЗапросов() Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	ИмяФайлаЛога         = ПараметрыЛогирования.ФайлыЛогирования.Получить(ПараметрыЛогирования.ТекущийИдентификатор);
	
	Если ИмяФайлаЛога <> Неопределено Тогда
		Файл = Новый Файл(ИмяФайлаЛога);
		Если Файл.Существует() Тогда
			УдалитьФайлы(ИмяФайлаЛога);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПараметрыЛогирования.Включено Тогда
		ПараметрыЛогирования.ОкончаниеЗаписи = Неопределено;
	КонецЕсли;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

// Завершает уровень логирования, установленный методом см. ВключитьЛогированиеЗапросов с признаком НовыйЛог.
// 
// Параметры:
// 	ИдентификаторЗаписи - Строка - Идентификатор уровня логирования.
// Возвращаемое значение:
// 	Неопределено, Строка - Результат записи логов запросов.
Функция ЗавершитьЛогированиеЗапросовПоИдентификатору(ИдентификаторЗаписи) Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	СодержаниеЛога       = СодержаниеЛогаЗапросов(ИдентификаторЗаписи);
	
	Если СодержаниеЛога <> Неопределено Тогда
		УдалитьФайлЛога(ИдентификаторЗаписи, ПараметрыЛогирования);
	КонецЕсли;
	
	Если ПараметрыЛогирования.ТекущийИдентификатор = ИдентификаторЗаписи Тогда
		
		Если ПараметрыЛогирования.СтекПараметров.Количество() = 0 Тогда
			ОтключитьЛогированиеЗапросов();
		Иначе
			ИндексСтека                               = ПараметрыЛогирования.СтекПараметров.ВГраница();
			ПараметрыСтрека                           = ПараметрыЛогирования.СтекПараметров.Получить(ИндексСтека);
			ПараметрыЛогирования.ТекущийИдентификатор = ПараметрыСтрека.ТекущийИдентификатор;
			ПараметрыЛогирования.Включено             = ПараметрыСтрека.Включено;
			ПараметрыЛогирования.ОкончаниеЗаписи      = ПараметрыСтрека.ОкончаниеЗаписи;
			ПараметрыЛогирования.СтекПараметров.Удалить(ИндексСтека);
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
	Возврат СодержаниеЛога;
	
КонецФункции

// Получает содержимое лога запроса по идентификатору уровня лога или содержание осноного уровня
// 
// Параметры:
// 	ИдентификаторЗаписи - Неопределено, Строка - Идентификатор уровня логирования.
// Возвращаемое значение:
// 	Неопределено, Строка - Записанные данные запросовю.
Функция СодержаниеЛогаЗапросов(ИдентификаторЗаписи = Неопределено) Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	
	Если ЗначениеЗаполнено(ИдентификаторЗаписи) Тогда
		ИмяФайлаЛога = ПараметрыЛогирования.ФайлыЛогирования.Получить(ИдентификаторЗаписи);
	Иначе
		ИмяФайлаЛога = ПараметрыЛогирования.ФайлыЛогирования.Получить(ПараметрыЛогирования.ТекущийИдентификатор);
	КонецЕсли;
	
	Если ИмяФайлаЛога = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Файл = Новый Файл(ИмяФайлаЛога);
	Если Не Файл.Существует() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайлаЛога, КодировкаТекста.UTF8);
	Данные = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Возврат Данные;
	
КонецФункции

// Проверят необходимость записи логов запросов по флагу и времени записи.
// 
// Параметры:
// 	ПараметрыЛогирования см. НовыеПараметрыЛогированияЗапросов.
// Возвращаемое значение:
// 	Булево - Призак записи логов запросов.
Функция ВыполняетсяЛогированиеЗапросов(ПараметрыЛогирования) Экспорт
	
	Если Не ПараметрыЛогирования.Включено
		Или (ЗначениеЗаполнено(ПараметрыЛогирования.ОкончаниеЗаписи)
		И ПараметрыЛогирования.ОкончаниеЗаписи <= ТекущаяУниверсальнаяДатаВМиллисекундах()) Тогда
		Возврат Ложь;
	Иначе 
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Выполняет запись HTTP запроса / ответа в файл логирования, если запись лога включена.
// 
// Параметры:
// 	ДанныеЗаписи - см. НоваяСтруктураДанныхЗаписи.
Процедура Вывести(ДанныеЗаписи) Экспорт
	
	HTTPЗапросОтвет   = ДанныеЗаписи.HTTPЗапросОтвет;
	ПараметрыОтправки = ДанныеЗаписи.ПараметрыОтправки;
	HTTPМетод         = ДанныеЗаписи.HTTPМетод;
	ТекстОшибки       = ДанныеЗаписи.ТекстОшибки;
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	Если Не ВыполняетсяЛогированиеЗапросов(ПараметрыЛогирования) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайла = ПараметрыЛогирования.ФайлыЛогирования.Получить(ПараметрыЛогирования.ТекущийИдентификатор);
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8,, Истина);
	
	Если HTTPЗапросОтвет <> Неопределено Тогда
		
		Если ТипЗнч(HTTPЗапросОтвет) = Тип("HTTPЗапрос") Тогда
			ЗаписьТекста.ЗаписатьСтроку("");
			URLЗапроса = ИнтеграцияИСМП.URLЗапроса(HTTPЗапросОтвет, ПараметрыОтправки, HTTPМетод);
			ЗаписьТекста.ЗаписатьСтроку(URLЗапроса);
		ИначеЕсли ТипЗнч(HTTPЗапросОтвет) = Тип("HTTPОтвет") Тогда
			ЗаписьТекста.ЗаписатьСтроку("");
			ЗаписьТекста.ЗаписатьСтроку(СтрШаблон("Код состояния: %1", HTTPЗапросОтвет.КодСостояния));
		ИначеЕсли ТипЗнч(HTTPЗапросОтвет) = Тип("Структура") Тогда
			ЗаписьТекста.ЗаписатьСтроку("");
			ЗаписьТекста.ЗаписатьСтроку(НСтр("ru = 'Запрос проксирован через сервис интернет-поддержки'"));
		КонецЕсли;
		
		Для Каждого КлючИЗначение Из HTTPЗапросОтвет.Заголовки Цикл
			
			ЗначениеЗаголовка = КлючИЗначение.Значение;
			ЗаписьТекста.ЗаписатьСтроку(СтрШаблон("%1: %2", КлючИЗначение.Ключ, ЗначениеЗаголовка));
			
		КонецЦикла;
		
		Если ТипЗнч(HTTPЗапросОтвет) = Тип("Структура") Тогда
			Тело = HTTPЗапросОтвет.Тело;
		Иначе
			Тело = HTTPЗапросОтвет.ПолучитьТелоКакСтроку();
		КонецЕсли;
		
		Если Не ПустаяСтрока(Тело) Тогда
			ЗаписьТекста.ЗаписатьСтроку(Тело);
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ТекстОшибки) Тогда
		
		ЗаписьТекста.ЗаписатьСтроку(ТекстОшибки);
		
	КонецЕсли;
	
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

// Выполняет установку параметров сеанса. Вызывается из модуля сеанса.
//
// Параметры:
//  ИмяПараметра			 - Строка - имя параметра сеанса.
//  УстановленныеПараметры	 - Массив - все установленные параметры сеанса.
//
Процедура УстановитьПараметрыСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
	
	Если ИмяПараметра = "ПараметрыЛогированияЗапросовИСМП" Тогда
		ПараметрыЛогированияЗапросов                     = НовыеПараметрыЛогированияЗапросов();
		ПараметрыСеанса.ПараметрыЛогированияЗапросовИСМП = ОбщегоНазначения.ФиксированныеДанные(ПараметрыЛогированияЗапросов);
		Если ТипЗнч(УстановленныеПараметры) = Тип("Массив") Тогда
			УстановленныеПараметры.Добавить(ИмяПараметра);
		ИначеЕсли ТипЗнч(УстановленныеПараметры) = Тип("Структура") Тогда
			УстановленныеПараметры.Вставить(ИмяПараметра);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Сохраняет параметры логирования в параметр сеанса.
// 
// Параметры:
// 	ПараметрыЛогирования - см. НовыеПараметрыЛогированияЗапросов.
Процедура УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования) Экспорт
	
	ПараметрыСеанса.ПараметрыЛогированияЗапросовИСМП = ОбщегоНазначения.ФиксированныеДанные(ПараметрыЛогирования);
	
КонецПроцедуры

// Включает уровень логирования запросов при исполнение в фоновом задании на сервере в клиент-серверном варианте.
// 
Процедура НастроитьПараметрыЛогированияВФоновомЗадании() Экспорт
	
	Если ИнтеграцияИСМПКлиентСерверПовтИсп.ЭтоФоновоеЗаданиеНаСервере() Тогда
		ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
		Если ВыполняетсяЛогированиеЗапросов(ПараметрыЛогирования) Тогда
			ЛогированиеЗапросовИСМП.ВключитьЛогированиеЗапросов(, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Дополняет возвращаемые данные (данные, которые помещаются во временное хранилище при завершении длительной операции)
// данными логирования запросов.
// Параметры:
// 	ДанныеДокумента - Структура - Возвращаемые из фонового задания данные.
Процедура ЗаполнитьВозвращаемыеДанныеФоновогоЗадания(ДанныеДокумента) Экспорт
	
	Если ИнтеграцияИСМПКлиентСерверПовтИсп.ЭтоФоновоеЗаданиеНаСервере()
		И ТипЗнч(ДанныеДокумента) = Тип("Структура") Тогда
		
		ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
		
		Если ПараметрыЛогирования.Включено Тогда
			
			ДанныеЛогаЗапросов   = ЗавершитьЛогированиеЗапросовПоИдентификатору(ПараметрыЛогирования.ТекущийИдентификатор);
			
			Если ДанныеЛогаЗапросов <> Неопределено Тогда
				ДанныеДокумента.Вставить("ДанныеЛогаЗапросов", ДанныеЛогаЗапросов);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Дописывает полученные данные лога запросов в текущий уровень логирования.
// 
// Параметры:
// 	ДанныеДокумента - Структура:
// 	* ДанныеЛогаЗапросов - Строка - Данные для записи в лог запросовю
Процедура ДописатьВТекущийЛогДанныеИзФоновогоЗадания(ДанныеДокумента) Экспорт
	
	ДанныеЛогаЗапросов = Неопределено;
	
	Если ТипЗнч(ДанныеДокумента) <> Тип("Структура")
		Или Не ДанныеДокумента.Свойство("ДанныеЛогаЗапросов", ДанныеЛогаЗапросов)
		Или ТипЗнч(ДанныеЛогаЗапросов) <> Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	ИмяФайла             = ПараметрыЛогирования.ФайлыЛогирования.Получить(ПараметрыЛогирования.ТекущийИдентификатор);
	
	Если ИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8,, Истина);
	ЗаписьТекста.ЗаписатьСтроку(ДанныеЛогаЗапросов);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

// Настраивает данные по штрихкодам для логирования.
// 
// Параметры:
// 	ДанныеПоШтрихкодам    - см. ШтрихкодированиеИС.ИнициализацияДанныхПоШтрихкодам.
// 	ПараметрыСканирования - см. ШтрихкодированиеИС.ПараметрыСканирования.
// 	Включить              - Булево - Флан начала логирования.
// 	ФормаУникальныйИдентификатор - ФормаКлиентскогоПриложения, УникальныйИдентификатор, Неопределено - Идентификатор для результата.
Процедура НастроитьДанныеПоШтрихкодам(ДанныеПоШтрихкодам, ПараметрыСканирования, Включить = Ложь, ФормаУникальныйИдентификатор = Неопределено) Экспорт
	
	Если Не ПараметрыСканирования.ЗаписыватьЛогЗапросовИСМП Тогда
		Возврат;
	КонецЕсли;
	
	Если Включить Тогда
		
		Если Не ДанныеПоШтрихкодам.ЛогированиеЗапросов.Используется Тогда
			
			ДанныеПоШтрихкодам.ЛогированиеЗапросов.Используется = Истина;
			ПараметрыЛогирования = ВключитьЛогированиеЗапросов(, Истина);
			
			ДанныеПоШтрихкодам.ЛогированиеЗапросов.ИдентификаторЛога = ПараметрыЛогирования.ТекущийИдентификатор;
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеПоШтрихкодам.ЛогированиеЗапросов.Используется Тогда
			
			ДанныеПоШтрихкодам.ЛогированиеЗапросов.Используется = Ложь;
			
			ЛогЗапросов = ЗавершитьЛогированиеЗапросовПоИдентификатору(
				ДанныеПоШтрихкодам.ЛогированиеЗапросов.ИдентификаторЛога);
			
			Если ТипЗнч(ФормаУникальныйИдентификатор) = Тип("УникальныйИдентификатор") Тогда
				АдресПомещения = ФормаУникальныйИдентификатор;
			ИначеЕсли ТипЗнч(ФормаУникальныйИдентификатор) = Тип("ФормаКлиентскогоПриложения") Тогда
				АдресПомещения = ФормаУникальныйИдентификатор.УникальныйИдентификатор;
			Иначе
				АдресПомещения = Новый УникальныйИдентификатор();
			КонецЕсли;
			
			АдресЛогаЗапросов = ПоместитьВоВременноеХранилище(ЛогЗапросов, АдресПомещения);
			ДанныеПоШтрихкодам.ЛогированиеЗапросов.АдресЛогаЗапросов = АдресЛогаЗапросов;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текствое описание текущего окружения и параметров.
// 
// Возвращаемое значение:
// 	Строка - Текстовое описание текущего окружения.
Функция ИнформацияОбОкружении() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеОкружения = Новый Массив();
	
	ИнформацияОСистеме = Новый СистемнаяИнформация();
	
	ДанныеОкружения.Добавить(
		СтрШаблон(
			НСтр("ru = 'Конфигурация: %1 (%2)'"),
			Метаданные.Синоним,
			Метаданные.Версия));
	ДанныеОкружения.Добавить(
		СтрШаблон(
			НСтр("ru = 'Версия платформы: %1 (%2)'"),
			ИнформацияОСистеме.ВерсияПриложения,
			ИнформацияОСистеме.ТипПлатформы));
	
	Для Каждого ОписаниеПодсистемы Из ОбщегоНазначения.ОписанияПодсистем() Цикл
		Если НРег(ОписаниеПодсистемы.Имя) = НРег("БиблиотекаИнтеграцииГосИС") Тогда
			ДанныеОкружения.Добавить(
				СтрШаблон(
					НСтр("ru = 'Версия библиотеки ГосИС: %1'"),
					ОписаниеПодсистемы.Версия));
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	СинонимыНастроекСканирования = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПредставленияПараметровСканирования();
	НастройкиСканирования        = ИнтеграцияИСМПВызовСервера.НастройкиСканированияКодовМаркировки();
	
	ДанныеОкружения.Добавить(
		СтрШаблон(
			"%1: %2",
			Метаданные.Константы.ЗапрашиватьДанныеСервисаИСМП.Синоним,
			НастройкиСканирования.ЗапрашиватьДанныеСервисаИСМП));
	
	ПараметрыКонтроля = НастройкаПараметровСканированияСлужебныйКлиентСерверПовтИсп.ПараметрыКонтроля();
	
	Для Каждого КлючИЗначение Из ПараметрыКонтроля Цикл
		
		ГруппаНастроек = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
			НастройкиСканирования,
			КлючИЗначение.Ключ);
		
		ПредставленияИсключения = НастройкаПараметровСканированияСлужебныйКлиентСервер.ПредставленияИсключения(
			ГруппаНастроек);
		
		ЗначениеИсключения = "";
		
		Если ГруппаНастроек.Включено
			И ЗначениеЗаполнено(ПредставленияИсключения.ПолноеВОднуСтроку) Тогда
			ЗначениеИсключения = СтрШаблон(", %1", ПредставленияИсключения.ПолноеВОднуСтроку);
		КонецЕсли;
		
		ДанныеОкружения.Добавить(
			СтрШаблон(
				"%1: %2%3",
				СинонимыНастроекСканирования.Получить(КлючИЗначение.Ключ),
				Формат(ГруппаНастроек.Включено, "ДФ=dd.MM.yyyy; БЛ=Нет; БИ=Да;"),
				ЗначениеИсключения));
		
	КонецЦикла;
	
	ОтключенаТабачнаяПродукция = Не (ИнтеграцияИСМПВызовСервера.ВестиУчетМаркируемойПродукции(
		Перечисления.ВидыПродукцииИС.Табак)
		Или ИнтеграцияИСМПВызовСервера.ВестиУчетМаркируемойПродукции(
		Перечисления.ВидыПродукцииИС.АльтернативныйТабак));
	
	ГруппаНастроек = НастройкаПараметровСканированияСлужебныйКлиентСервер.ЗначениеГруппыНастроек(
			НастройкиСканирования,
			КлючИЗначение.Ключ);
	
	ОтключенныеНастройки = Новый Соответствие();
	ОтключенныеНастройки.Вставить("ЗапрашиватьДанныеСервисаИСМП",    Истина);
	ОтключенныеНастройки.Вставить("ПараметрыКонтроляСтатусов",       Истина);
	ОтключенныеНастройки.Вставить("ПараметрыКонтроляВладельцев",     Истина);
	ОтключенныеНастройки.Вставить("ПараметрыКонтроляСредствамиККТ",  Истина);
	ОтключенныеНастройки.Вставить("РежимКонтроляСредствамиККТ",      (Не ГруппаНастроек.Включено));
	ОтключенныеНастройки.Вставить("ПропускатьПроверкуСредствамиККТ", (Не ГруппаНастроек.Включено));
	ОтключенныеНастройки.Вставить("УчитыватьМРЦ",                                              ОтключенаТабачнаяПродукция);
	ОтключенныеНастройки.Вставить("ПроверятьПотребительскиеУпаковкиНаВхождениеВСеруюЗонуМОТП", ОтключенаТабачнаяПродукция);
	ОтключенныеНастройки.Вставить("ДатаПроизводстваНачалаКонтроляСтатусовКодовМаркировкиМОТП", ОтключенаТабачнаяПродукция);
	ОтключенныеНастройки.Вставить("ПроверятьЛогистическиеИГрупповыеУпаковкиНаСодержаниеСерыхКодовМОТП", ОтключенаТабачнаяПродукция);
	
	Для Каждого КлючИЗначение Из НастройкиСканирования Цикл
		ИмяНастройки = КлючИЗначение.Ключ;
		Если ОтключенныеНастройки.Получить(ИмяНастройки) <> Неопределено
			И ОтключенныеНастройки.Получить(ИмяНастройки) Тогда
			Продолжить;
		КонецЕсли;
		Заголовок = СинонимыНастроекСканирования.Получить(ИмяНастройки);
		Если Не ЗначениеЗаполнено(Заголовок) Тогда
			Заголовок = ИмяНастройки;
		КонецЕсли;
		Значение = СинонимыНастроекСканирования.Получить(КлючИЗначение.Значение);
		Если Значение = Неопределено Тогда
			Значение = КлючИЗначение.Значение;
		КонецЕсли;
		ДанныеОкружения.Добавить(
			СтрШаблон(
				"%1: %2",
				Заголовок,
				Формат(Значение, "ДФ=dd.MM.yyyy; БЛ=Нет; БИ=Да;")));
	КонецЦикла;
	
	ДанныеОкружения.Добавить(
		СтрШаблон(
			"%1: %2",
			Метаданные.Константы.РежимРаботыСТестовымКонтуромИСМП.Синоним,
			ИнтеграцияИСМПКлиентСерверПовтИсп.РежимРаботыСТестовымКонтуромИСМП()));
	
	УстановленныеРасширения = Новый Массив();
	
	Если СтрНайти(Метаданные.РежимСовместимости, "Версия8_2") = 0 Тогда
		Для Каждого Расширение Из РасширенияКонфигурации.Получить() Цикл
			Если Не Расширение.Активно Тогда
				Продолжить;
			КонецЕсли;
			УстановленныеРасширения.Добавить(
				СокрЛП(
					СтрШаблон(
						НСтр("ru = '%1 %2'"),
						Расширение.Имя,
						Расширение.Версия)));
		КонецЦикла;
	КонецЕсли;
	
	Если УстановленныеРасширения.Количество() Тогда
		ДанныеОкружения.Добавить(
			СтрШаблон(
				НСтр("ru = 'Активные расширения конфигурации: %1'"),
				СтрСоединить(УстановленныеРасширения, ", ")));
	КонецЕсли;
	
	УчитываемыеВидыПродукции = ИнтеграцияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции();
	ДанныеОкружения.Добавить(
			СтрШаблон(
				НСтр("ru = 'Ведется учет: %1'"),
				СтрСоединить(УчитываемыеВидыПродукции, ", ")));
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		РежимЭксплуатации = НСтр("ru = 'Файловая информационная база'");
	Иначе
		РежимЭксплуатации = НСтр("ru = 'Клиент-серверный режим'");
	КонецЕсли;
	
	ДанныеОкружения.Добавить(
		СтрШаблон(
			НСтр("ru = 'Режим эксплуатации: %1'"),
			РежимЭксплуатации));
	
	Возврат СтрСоединить(ДанныеОкружения, Символы.ПС);
	
КонецФункции

#Область ЛогированиеПротоколОбмена

// Включает логирование запросов для протокола обмена в текущем сейнсе на время ЗаписыватьСекунд.
// 
// Возвращаемое значение:
// 	см. НовыеПараметрыЛогированияЗапросов.
Функция ВключитьЛогированиеЗапросовДляПротоколаОбмена() Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	
	Если Не ЗначениеЗаполнено(ПараметрыЛогирования.ТекущийИдентификаторПротоколОбмена) Тогда
		УстановитьНовыйЛогПротоколаОбмена(ПараметрыЛогирования);
	КонецЕсли;
	
	ПараметрыЛогирования.ВключеноПротоколОбмена = Истина;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
	Возврат ПараметрыЛогирования;
	
КонецФункции

// Отключает режим записи логов для протокола обмена.
// 
Процедура ОтключитьЛогированиеЗапросовДляПротоколаОбмена() Экспорт
	
	ПараметрыЛогирования                        = ПараметрыЛогированияЗапросов();
	ПараметрыЛогирования.ВключеноПротоколОбмена = Ложь;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

// Завершает уровень логирования для протокола обмена, установленный методом см. ВключитьЛогированиеЗапросовДляПротоколаОбмена.
// 
// Параметры:
// 	ИдентификаторЗаписи - Строка - Идентификатор уровня логирования.
// Возвращаемое значение:
// 	Неопределено, Строка - Результат записи логов запросов.
Функция ЗавершитьЛогированиеЗапросовПоИдентификаторуПротоколаОбмена(ИдентификаторЗаписи) Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	СодержаниеЛога       = СодержаниеЛогаЗапросовПротоколОбмена(ИдентификаторЗаписи);
	
	Если СодержаниеЛога <> Неопределено Тогда
		УдалитьФайлыЛогаПротоколОбмена(ИдентификаторЗаписи, ПараметрыЛогирования);
	КонецЕсли;
	
	ПараметрыЛогирования.ВключеноПротоколОбмена = Ложь;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
	Возврат СодержаниеЛога;
	
КонецФункции

// Получает содержимое лога запросов для протокола обмена  по идентификатору уровня лога или содержание осноного уровня
// 
// Параметры:
//  ИдентификаторЗаписи - Неопределено, Строка - Идентификатор логирования протокола обмена.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Записанные данные запросов. (См. ИнтеграцияИСМПСлужебный.ИнициализироватьТаблицуПротоколОбмена).
Функция СодержаниеЛогаЗапросовПротоколОбмена(ИдентификаторЗаписи = Неопределено) Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	ПротоколОбмена = ИнтеграцияИСМПСлужебный.ИнициализироватьТаблицуПротоколОбмена(Истина);
	Если ЗначениеЗаполнено(ИдентификаторЗаписи) Тогда
		ФайлыПротоколаОбмена = ПараметрыЛогирования.ФайлыЛогированияПротоколОбмена.Получить(ИдентификаторЗаписи);
	Иначе
		ФайлыПротоколаОбмена = ПараметрыЛогирования.ФайлыЛогированияПротоколОбмена.Получить(ПараметрыЛогирования.ТекущийИдентификаторПротоколОбмена);
	КонецЕсли;
	
	Если ФайлыПротоколаОбмена = Неопределено Тогда
		Возврат ПротоколОбмена;
	КонецЕсли;
	
	Для Каждого ИмяФайла Из ФайлыПротоколаОбмена Цикл
		Файл = Новый Файл(ИмяФайла);
		Если Не Файл.Существует() Тогда
			Продолжить;
		КонецЕсли;
		ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
		ТекстСообщенияXML = ЧтениеТекста.Прочитать();
		ДанныеПротокола = ОбщегоНазначения.ЗначениеИзСтрокиXML(ТекстСообщенияXML);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеПротокола.ПротоколОбмена, ПротоколОбмена);
		
	КонецЦикла;
	
	Если ЧтениеТекста <> Неопределено Тогда
		ЧтениеТекста.Закрыть();
	КонецЕсли;
		
	Возврат ПротоколОбмена;
	
КонецФункции

// Проверят необходимость записи логов запросов протокола обмена по флагу.
// 
// Параметры:
// 	ПараметрыЛогирования см. НовыеПараметрыЛогированияЗапросов.
// Возвращаемое значение:
// 	Булево - Призак записи логов запросов.
Функция ВыполняетсяЛогированиеЗапросовДляПротоколаОбмена(ПараметрыЛогирования) Экспорт
	
	Если Не ПараметрыЛогирования.ВключеноПротоколОбмена Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Выполняет запись HTTP запроса / ответа в файл логирования в формат протокола обмена, если запись лога включена.
// 
// Параметры:
// 	ДанныеЗаписи - см. НоваяСтруктураДанныхЗаписи.
Процедура ВывестиДанныеДляПротоколаОбмена(РезультатЗапроса) Экспорт
	
	ПараметрыЛогирования = ПараметрыЛогированияЗапросов();
	Если Не ВыполняетсяЛогированиеЗапросовДляПротоколаОбмена(ПараметрыЛогирования) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПротоколОбмена", Неопределено);
	
	ПротоколОбмена = ИнтеграцияИСМПСлужебный.ИнициализироватьТаблицуПротоколОбмена(Истина);
	Результат.ПротоколОбмена = ПротоколОбмена;
	
	ПараметрыОтправкиHTTPЗапросов = РезультатЗапроса.ПараметрыОтправкиHTTPЗапросов;
	HTTPМетод                     = РезультатЗапроса.HTTPМетод;
	HTTPЗапрос                    = РезультатЗапроса.HTTPЗапрос;
	HTTPОтвет                     = РезультатЗапроса.HTTPОтвет;
	
	ЗапросЗаголовки = Новый Массив;
	Для Каждого КлючИЗначение Из HTTPЗапрос.Заголовки Цикл
		ЗапросЗаголовки.Добавить(
			СтрШаблон("%1: %2", КлючИЗначение.Ключ, КлючИЗначение.Значение));
	КонецЦикла;
	
	ЗаписьПротокола = ПротоколОбмена.Добавить();
	ЗаписьПротокола.ДатаУниверсальная = ТекущаяУниверсальнаяДата();
	ЗаписьПротокола.Запрос            = ИнтеграцияИСМП.URLЗапроса(HTTPЗапрос, ПараметрыОтправкиHTTPЗапросов, HTTPМетод);
	ЗаписьПротокола.ЗапросЗаголовки   = СтрСоединить(ЗапросЗаголовки, Символы.ПС);
	ЗаписьПротокола.ЗапросТело        = HTTPЗапрос.ПолучитьТелоКакСтроку();
	
	Если HTTPОтвет <> Неопределено Тогда
		
		ЗаписьПротокола.ОтветЗаголовки = ИнтеграцияИСМПСлужебный.ЗаголовкиИзHTTPОтвета(HTTPОтвет);
		
		Если ТипЗнч(HTTPОтвет) = Тип("Структура") Тогда
			ЗаписьПротокола.ОтветТело = HTTPОтвет.Тело;
		Иначе
			ЗаписьПротокола.ОтветТело = HTTPОтвет.ПолучитьТелоКакСтроку();
		КонецЕсли;
		
		ЗаписьПротокола.КодСостояния = Строка(HTTPОтвет.КодСостояния);
		
		Если РезультатЗапроса.Свойство("ТекстОшибки")
			И Не ЗначениеЗаполнено(ЗаписьПротокола.ОтветТело) Тогда
			ЗаписьПротокола.ОтветТело = РезультатЗапроса.ТекстОшибки;
		КонецЕсли;
		
	Иначе
		ЗаписьПротокола.ОтветТело = РезультатЗапроса.ТекстОшибки;
	КонецЕсли;
	
	ТекущийИдентификатор = ПараметрыЛогирования.ТекущийИдентификаторПротоколОбмена;
	ФайлыПротокола = ПараметрыЛогирования.ФайлыЛогированияПротоколОбмена.Получить(ТекущийИдентификатор);
	Если ФайлыПротокола = Неопределено Тогда
		ФайлыПротокола = Новый Массив;
	КонецЕсли;
	ИмяФайла = ПолучитьИмяВременногоФайла(".log");
	ФайлыПротокола.Добавить(ИмяФайла);
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8,, Ложь);
	ЗаписьТекста.ЗаписатьСтроку(ОбщегоНазначения.ЗначениеВСтрокуXML(Результат));
	ЗаписьТекста.Закрыть();
	
	ПараметрыЛогирования.ФайлыЛогированияПротоколОбмена[ТекущийИдентификатор] = ФайлыПротокола;
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

#КонецОбласти

	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Удаляет файл, в который ранее писался лог запросов по идентификатору.
// 
// Параметры:
// 	ИдентификаторЗаписи - Строка - Идентификатор лога запросов.
// 	ПараметрыЛогирования - см. НовыеПараметрыЛогированияЗапросов.
Процедура УдалитьФайлЛога(ИдентификаторЗаписи, ПараметрыЛогирования)
	
	ИмяФайла = ПараметрыЛогирования.ФайлыЛогирования.Получить(ИдентификаторЗаписи);
	Если ИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Файл = Новый Файл(ИмяФайла);
	Если Файл.Существует() Тогда
		УдалитьФайлы(Файл.ПолноеИмя);
	КонецЕсли;

КонецПроцедуры

// Удаляет файл, в который ранее писался лог запросов по идентификатору.
// 
// Параметры:
// 	ИдентификаторЗаписи - Строка - Идентификатор лога запросов.
// 	ПараметрыЛогирования - см. НовыеПараметрыЛогированияЗапросов.
Процедура УдалитьФайлыЛогаПротоколОбмена(ИдентификаторЗаписи, ПараметрыЛогирования)
	
	ФайлыПротоколаОбмена = ПараметрыЛогирования.ФайлыЛогированияПротоколОбмена.Получить(ИдентификаторЗаписи);
	Если ФайлыПротоколаОбмена = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ИмяФайла Из ФайлыПротоколаОбмена Цикл
		Файл = Новый Файл(ИмяФайла);
		Если Файл.Существует() Тогда
			УдалитьФайлы(Файл.ПолноеИмя);
		КонецЕсли;
		
	КонецЦикла;
	
	ФайлыПротоколаОбмена.Очистить();
	
КонецПроцедуры

// Устанавливает в параметры логирования значения для нового уровня логирования.
// 
// Параметры:
// 	ПараметрыЛогирования - см. НовыеПараметрыЛогированияЗапросов.
Процедура УстановитьНовыйЛог(ПараметрыЛогирования)

	ПараметрыЛогирования.ТекущийИдентификатор = Строка(Новый УникальныйИдентификатор());
	ПараметрыЛогирования.ФайлыЛогирования.Вставить(
		ПараметрыЛогирования.ТекущийИдентификатор,
		ПолучитьИмяВременногоФайла(".log"));
	
КонецПроцедуры

// Устанавливает в параметры логирования значения для нового уровня логирования.
// 
// Параметры:
// 	ПараметрыЛогирования - см. НовыеПараметрыЛогированияЗапросов.
Процедура УстановитьНовыйЛогПротоколаОбмена(ПараметрыЛогирования)

	ПараметрыЛогирования.ТекущийИдентификаторПротоколОбмена = Строка(Новый УникальныйИдентификатор());
	ПараметрыЛогирования.ФайлыЛогированияПротоколОбмена.Вставить(
		ПараметрыЛогирования.ТекущийИдентификаторПротоколОбмена,
		Новый Массив);
	
КонецПроцедуры
	
// Параметры логирования запросов.
// Возвращаемое значение:
// 	Структура - Описание:
// * ФайлыЛогирования - Соответствие:
// 	Ключ     - Строка - Идентификатор лога.
// 	Значение - Строка - Имя файла логирования.
// * ОкончаниеЗаписи      - Число            - Универстальная дата окончания записи лога в милисекундах.
// * Включено             - Булево           - Признак записи лога.
// * ТекущийИдентификатор - Строка           - Текущий идентификатор логирования.
// * СтекПараметров       - Массив из Строка - Стек параметров записи лога.
Функция НовыеПараметрыЛогированияЗапросов()
	
	ПараметрыЛогирования = Новый Структура();
	ПараметрыЛогирования.Вставить("Включено",             Ложь);
	ПараметрыЛогирования.Вставить("ОкончаниеЗаписи",      Неопределено);
	ПараметрыЛогирования.Вставить("ФайлыЛогирования",     Новый Соответствие());
	ПараметрыЛогирования.Вставить("ТекущийИдентификатор", Неопределено);
	ПараметрыЛогирования.Вставить("СтекПараметров",       Новый Массив());
	
	ПараметрыЛогирования.Вставить("ТекущийИдентификаторПротоколОбмена", Неопределено);
	ПараметрыЛогирования.Вставить("ВключеноПротоколОбмена",             Ложь);
	ПараметрыЛогирования.Вставить("ФайлыЛогированияПротоколОбмена",     Новый Соответствие());

	Возврат ПараметрыЛогирования;
	
КонецФункции

#КонецОбласти