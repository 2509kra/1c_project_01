
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает признак необходимости открыть форму миграции приложения.
//
// Возвращаемое значение:
//   Булево - Истина если нужно открыть форму.
//
Функция НужноОткрытьФорму() Экспорт
	
	Если Не РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных()
		Или Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Состояния = Новый Массив;
	Состояния.Добавить(Перечисления.СостоянияМиграцииПриложения.Выполняется);
	Состояния.Добавить(Перечисления.СостоянияМиграцииПриложения.ОжиданиеЗагрузки);
	Состояния.Добавить(Перечисления.СостоянияМиграцииПриложения.ЗавершенаУспешно);
	Состояния.Добавить(Перечисления.СостоянияМиграцииПриложения.ЗавершенаСОшибкой);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Инициатор", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("Состояния", Состояния);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК Проверка
	|ИЗ
	|	РегистрСведений.МиграцияПриложенийСостояниеВыгрузки КАК МиграцияПриложенийСостояниеВыгрузки
	|ГДЕ
	|	МиграцияПриложенийСостояниеВыгрузки.Инициатор = &Инициатор
	|	И МиграцияПриложенийСостояниеВыгрузки.Состояние В(&Состояния)";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти
