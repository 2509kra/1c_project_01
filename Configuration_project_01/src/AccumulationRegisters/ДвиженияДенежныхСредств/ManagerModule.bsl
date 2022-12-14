#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)
	|	И( ВЫБОР КОГДА ТипЗначения(ДенежныеСредства) = Тип(Справочник.Кассы) ТОГДА ЗначениеРазрешено(ДенежныеСредства)
	|	КОГДА ТипЗначения(ДенежныеСредства) = Тип(Справочник.КассыККМ) ТОГДА ЗначениеРазрешено(ДенежныеСредства)
	|	КОГДА ТипЗначения(ДенежныеСредства) = Тип(Справочник.ФизическиеЛица) ТОГДА ЗначениеРазрешено(ДенежныеСредства)
	|	ИНАЧЕ ИСТИНА КОНЕЦ) ";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли
