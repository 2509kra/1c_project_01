#Область ПрограммныйИнтерфейс

// Регистрирует тарифицируемые услуги конфигурации из Структуры.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//  ПоставщикиУслуг - Массив из Структура - описывает поставщика услуги:
// 	 * Идентификатор - Строка - идентификатор поставщика услуги (тип Строка - Строка(50)),
// 	 * Наименование - Строка - наименование поставщика услуги (тип Строка - Строка(150)),
// 	 * Услуги - Массив из Структура - услуги поставщика с обязательными ключами:
// 	   ** Идентификатор - Строка - идентификатор услуги  (тип Строка - Строка(50))
// 	   ** Наименование - Строка - наименование услуги  (тип Строка - Строка(150))
// 	   ** ТипУслуги - ПеречислениеСсылка.ТипыУслуг - тип услуги.
//
Процедура ПриФормированииСпискаУслуг(ПоставщикиУслуг) Экспорт
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	// Конец ЭлектронноеВзаимодействие
	
КонецПроцедуры

// Событие, которое вызывается при изменении активации лицензии.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
// 	ДанныеОЛицензии - Структура - данные о лицензии:
// 	 * Услуга - СправочникСсылка.УслугиСервиса - услуга.
// 	 * ИмяЛицензии - Строка - имя лицензии.
// 	 * КонтекстЛицензии - Строка - контекст лицензии.
// 	ЛицензияАктивирована - Булево - активирована лицензия или деактивирована.
//
Процедура ПриИзмененииСостоянияАктивацииЛицензии(ДанныеОЛицензии, ЛицензияАктивирована) Экспорт
КонецПроцедуры

// Событие, которое вызывается при обновлении доступных лицензий.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//	ПараметрыЛицензии - Структура - соответствует составу реквизитов, измерений и ресурсов РС "ДоступныеЛицензии":
// 	 * ИдентификаторПодписки - УникальныйИдентификатор - внутренний идентификатор подписки.
// 	 * Услуга - СправочникСсылка.УслугиСервиса - услуга.
// 	 * ДатаНачалаДействия - Дата - дата начала действия подписки.
// 	 * ДатаОкончанияДействия - Дата - дата окончания действия подписки.
// 	 * КоличествоЛицензий - Число - количество лицензий.
// 	 * НомерПодписки - Строка - номер подписки.
// 	 * ДатаИзменения - Дата - дата изменения.
//
Процедура ПриОбновленииДоступныхЛицензий(ПараметрыЛицензии) Экспорт
КонецПроцедуры

// Событие, которое вызывается при удалении доступных лицензий.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//	ПараметрыЛицензии - см. ПриОбновленииДоступныхЛицензий.ПараметрыЛицензии
//
Процедура ПриУдаленииДоступныхЛицензий(ПараметрыЛицензии) Экспорт
КонецПроцедуры

// Вызывается при определении представления валюты оплаты сервиса.
// @skip-warning ПустойМетод - переопределяемый метод.
// 
// Параметры:
//  ПредставлениеВалютыОплаты - Строка - представление валюты оплаты.
//
Процедура ПриУстановкеПредставленияВалютыОплаты(ПредставлениеВалютыОплаты) Экспорт
КонецПроцедуры

// Вызывается при получении имени формы обработки ответа на запрос счета на оплату.
// @skip-warning ПустойМетод - переопределяемый метод.
// 
// Параметры:
//  ИмяФормыОбработкиОтвета - Строка - имя формы обработки ответа.
//
Процедура ПриПолученииИмениФормыОбработкиОтвета(ИмяФормыОбработкиОтвета) Экспорт
КонецПроцедуры

#КонецОбласти
