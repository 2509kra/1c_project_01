#Область ПрограммныйИнтерфейс

// Возможность определить настройки интеграции с EDI
//
// Параметры:
//  НастройкиУчета - Структура - см. НастройкиEDI.НастройкиУчета
//
Процедура ПриОпределенииНастроекУчета(НастройкиУчета) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ПриОпределенииНастроекУчета(НастройкиУчета);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Позволяет определить доступность виджета EDI по правам доступа пользователя.
//
// Параметры:
//  Раздел   - ПеречислениеСсылка.РазделыВиджетовEDI - раздел текущих дел EDI для которого определяется доступность.
//  Доступен - Булево - по умолчанию Ложь.
//
Процедура ПриОпределенииДоступностиРазделаВиджетаПоПравам(Раздел, Доступен) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ПриОпределенииДоступностиРазделаВиджетаПоПравам(Раздел, Доступен);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Заполняются данными прикладного документа, для определения возможности его отправки через EDI
//
// Параметры:
//  СсылкаНаДокумент            - ДокументСсылка - раздел текущих дел EDI для которого определяется доступность.
//  ДанныеПрикладногоОбъектаEDI - Структура - требуемые данные заполнения - см. ПараметрыПрикладногоДокументаДляОпределенияВозможностиОтправки.
//  ЗаполнениеНеВыполнялось     - Булево - требуется установить в Ложь, если заполнение выполнено.
//
Процедура ЗаполнитьДанныеПрикладногоДокумента(СсылкаНаДокумент, ДанныеПрикладногоОбъектаEDI, ЗаполнениеНеВыполнялось) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ЗаполнитьДанныеПрикладногоДокумента(СсылкаНаДокумент, ДанныеПрикладногоОбъектаEDI, ЗаполнениеНеВыполнялось);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возможность переопределить поведение при загрузке данных из настроек в форме списка прикладных документов
//
// Параметры:
//  Форма                 - ФормаКлиентскогоПриложения - форма, в которой выполняется событие.
//  Настройки             - Структура                  - загружаемые настройки.
//  СтандартнаяОбработка  - Булево                     - признак стандартной обработки события.
//
Процедура ПриЗагрузкеДанныхИзНастроекНаСервереФормаСпискаПрикладногоДокумента(Форма, Настройки, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ПриЗагрузкеДанныхИзНастроекНаСервереФормаСпискаПрикладногоДокумента(Форма, Настройки, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Требуется определить какие реквизиты формы документа, будут заблокированы в зависимости от доступности реквизитов документа EDI
//
// Параметры:
//  ТаблицаПараметров      - ТаблицаЗначений - состоит из следующих колонок:
//   * ИмяРеквизита        - Строка - имя реквизита документа EDI, которое не должно быть изменено.
//   * БлокируемыеЭлементы - СписокЗначений - список имен элементов формы прикладного документа, которые должны быть заблокированы, так как они могут изменить документ EDI.
//  ТипДокумента           - ПеречислениеСсылка.ТипыДокументовEDI - тип документа, для которого выполняется настройка блокировки реквизитов.
//
Процедура ЗаполнитьПараметрыЗапретаРедактированияРеквизитовEDI(ТаблицаПараметров, ТипДокумента) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ЗаполнитьПараметрыЗапретаРедактированияРеквизитовEDI(ТаблицаПараметров, ТипДокумента);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возможность выполнить действия при получении нового состояния EDI по данным сервиса.
//
// Параметры:
//  ПараметрыЗаписи      - Структура - см. РегистрСведений.СостоянияДокументовEDI.ПараметрыЗаписиВРегистр.
//
Процедура ПриОбновленииЗаписиСостоянияДокументовПоДаннымСервиса(ПараметрыЗаписи) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ПриОбновленииЗаписиСостоянияДокументовПоДаннымСервиса(ПараметрыЗаписи);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Определяет значение склада прикладного объекта по набору признаков, с которыми он может кореллировать.
// 
// Параметры:
//  Склад - ОпределяемыйТип.СкладEDI - значение реквизита, которое нужно заполнить.
//  ТипПрикладногоДокумента - Тип - тип прикладного объекта, для которого определяется значение реквизита.
//  КритерииПоиска - Структура - критерии отбора прикладных объектов для получения.
//    * Организация - ОпределяемыйТип.Организация - организация заказа.
//    * Контрагент - ОпределяемыйТип.КонтрагентБЭД - контрагент заказа.
//
Процедура ПриАвтоматическомОпределенииСкладаПрикладногоДокумента(Склад, 
	Знач ТипПрикладногоДокумента, Знач КритерииПоиска) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ПриАвтоматическомОпределенииСкладаПрикладногоДокумента(Склад,ТипПрикладногоДокумента ,КритерииПоиска);
	//-- НЕ ГОСИС
	
КонецПроцедуры


// Определяет склад по умолчанию
// 
// Параметры:
// 	Склад - ОпределяемыйТип.СкладEDI - значение склада, которое нужно заполнить.
//
Процедура УстановитьСкладПоУмолчанию(Склад) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.УстановитьСкладПоУмолчанию(Склад);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#Область ПриОпределенииВозможностиВыполненияКомандСервиса

// Возможность определить доступность команды EDI.
//
// Параметры:
//  ПрикладнойОбъект - ДокументСсылка - документ, для которого определяется доступность команды.
//  КатегорииКоманд  - ТаблицаЗначений - см. ДокументыEDIИнтеграция.НовыйТаблицаДоступныхКатегорийКомандПриВыводеДоступныхДействий.
//
Процедура ПриОпределенииДоступностиКомандПриОтображении(ПрикладнойОбъект, КатегорииКоманд) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ПриОпределенииДоступностиКомандПриОтображении(ПрикладнойОбъект, КатегорииКоманд);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Возможность проверить возможно ли выполнение команды EDI после того как пользователь уже начал ее выполнять.
//
// Параметры:
//  ПараметрыВыполнения - Структура - см. ДокументыEDIИнтеграция.НовыйВозможностьДействияСервисаПриВыполнении.
//
Процедура ПередВыполнениемКомандыСервиса(ПараметрыВыполнения) Экспорт
	
	//++ НЕ ГОСИС
	СервисEDIУТ.ПередВыполнениемКомандыСервиса(ПараметрыВыполнения);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

