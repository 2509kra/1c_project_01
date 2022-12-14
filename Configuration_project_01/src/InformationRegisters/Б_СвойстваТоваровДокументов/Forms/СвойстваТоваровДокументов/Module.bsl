
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВидДокумента = "Заказ"; 
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	ВидДокументаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВидДокументаПриИзмененииНаСервере()
	
	Если ВидДокумента = "Заказ" тогда
		
		СписокДокументов.ТекстЗапроса 		= ПолучитьЗапросСпискаДокументов("ЗаказКлиента");
		СписокДокументов.ОсновнаяТаблица 	= "Документ.ЗаказКлиента";
		
	ИначеЕсли ВидДокумента = "Отгрузка" тогда
		
		СписокДокументов.ТекстЗапроса 		= ПолучитьЗапросСпискаДокументов("РеализацияТоваровУслуг");
		СписокДокументов.ОсновнаяТаблица 	= "Документ.РеализацияТоваровУслуг";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	
	ВыбранныйДокумент = Элемент.ТекущаяСтрока;
	
	Если ЗначениеЗаполнено(ВыбранныйДокумент) тогда
		
		лНомер = ПолучитьНомерДокумента(ВыбранныйДокумент);
		
		Если НомерВыделенногоДокумента = "" ИЛИ НомерВыделенногоДокумента <> лНомер  тогда
			НомерВыделенногоДокумента = лНомер;
		Иначе
			НомерВыделенногоДокумента = "";
			Возврат;
		КонецЕсли;
		
		ПриАктивизацииСтрокиДокумента(); 
	Иначе
		ВыбранныйДокумент = Неопределено;      
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыДокументаПриАктивизацииСтроки(Элемент)
	
	лТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если лТекущиеДанные <> неопределено тогда
		
		ВыбраннаяНоменклатура   = лТекущиеДанные.Номенклатура;
		ВыбраннаяХарактеристика = лТекущиеДанные.Характеристика;
		ВыбранныйКодСтроки		= лТекущиеДанные.КодСтроки;
		ЗаполнениеСвойствВыбранногоТовара();
	Иначе
		ВыбраннаяНоменклатура   = Неопределено;
		ВыбраннаяХарактеристика = Неопределено;  
		ВыбранныйКодСтроки		= Неопределено;  
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвойстваТовараЗначениеПриИзменении(Элемент)
	ОбновитьИнформациюПоТовару();
КонецПроцедуры

&НаКлиенте
Процедура СвойстваТовараСвойствоПриИзменении(Элемент)
	ОбновитьИнформациюПоТовару();
КонецПроцедуры

&НаКлиенте
Процедура СвойстваТовараПослеУдаления(Элемент)
	ОбновитьИнформациюПоТовару();
КонецПроцедуры

#КонецОбласти


#Область ПроцедурыИФункцииСлужебные

&НаСервере
Функция ПолучитьЗапросСпискаДокументов(ТипДокумента)
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	Документ.Номер,
	|	Документ.Дата,
	|	Документ.Контрагент,
	|	Документ.Организация,
	|	Документ.СуммаДокумента
	|ИЗ
	|	Документ."+ТипДокумента+" КАК Документ";  	
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура ПриАктивизацииСтрокиДокумента()
	
	ТоварыДокумента.Очистить();
	
		Для Каждого ТекСтрока из ВыбранныйДокумент.Товары цикл
			НоваяПозиция 							= ТоварыДокумента.Добавить();	
			НоваяПозиция.Номенклатура 				= ТекСтрока.Номенклатура;
			НоваяПозиция.Характеристика 			= ТекСтрока.Характеристика;
			НоваяПозиция.Количество 				= ТекСтрока.Количество;
			НоваяПозиция.Цена 						= ТекСтрока.Цена;
			НоваяПозиция.КодСтроки 					= ТекСтрока.КодСтроки;
			
		КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеСвойствВыбранногоТовара()
	
	СвойстваТовара.Очистить();
	
	Если НЕ ЗначениеЗаполнено(ВыбранныйДокумент) тогда
		Возврат;	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыбраннаяНоменклатура) тогда
		Возврат;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Б_СвойстваТоваровДокументов.НаименованиеСвойства КАК Свойство,
	|	Б_СвойстваТоваровДокументов.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.Б_СвойстваТоваровДокументов КАК Б_СвойстваТоваровДокументов
	|ГДЕ
	|	Б_СвойстваТоваровДокументов.Документ = &Документ
	|	И Б_СвойстваТоваровДокументов.Номенклатура = &Номенклатура
	|	И Б_СвойстваТоваровДокументов.Характеристика = &Характеристика
	|	И Б_СвойстваТоваровДокументов.КодСтроки = &КодСтроки";
	
	Запрос.УстановитьПараметр("Документ"		, ВыбранныйДокумент);
	Запрос.УстановитьПараметр("Номенклатура"	, ВыбраннаяНоменклатура);
	Запрос.УстановитьПараметр("Характеристика"	, ВыбраннаяХарактеристика);
	Запрос.УстановитьПараметр("КодСтроки"		, ВыбранныйКодСтроки);
	Запрос.Выполнить().Выгрузить();	
	
	СвойстваТовара.Загрузить(Запрос.Выполнить().Выгрузить());	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоТовару();
	
	НовыйНабор = РегистрыСведений.Б_СвойстваТоваровДокументов.СоздатьНаборЗаписей();
	НовыйНабор.Отбор.Документ.Установить(ВыбранныйДокумент); 
	НовыйНабор.Отбор.Номенклатура.Установить(ВыбраннаяНоменклатура); 
	НовыйНабор.Отбор.Характеристика.Установить(ВыбраннаяХарактеристика); 
	НовыйНабор.Отбор.КодСтроки.Установить(ВыбранныйКодСтроки); 
	
	Для каждого ТекСтрока из СвойстваТовара Цикл
		
		Если Значениезаполнено(ТекСтрока.Свойство) тогда
			НоваяЗапись = НовыйНабор.Добавить();
			
			НоваяЗапись.Документ 					= ВыбранныйДокумент;	
			НоваяЗапись.Номенклатура 				= ВыбраннаяНоменклатура;	
			НоваяЗапись.Характеристика 				= ВыбраннаяХарактеристика;	
			НоваяЗапись.КодСтроки 					= ВыбранныйКодСтроки;	
			НоваяЗапись.Значение 					= ТекСтрока.Значение;	
			НоваяЗапись.НаименованиеСвойства 		= ТекСтрока.Свойство;	
		
		КонецЕсли;	
	КонецЦикла;
	
	НовыйНабор.Записать();	
	
	//Регистрируем изменение документа и меняем его версию	
	лОбъект = ВыбранныйДокумент.ПолучитьОбъект();
	лОбъект.Записать();

КонецПроцедуры

&НаСервере
Функция	ПолучитьНомерДокумента(Документ)
	Возврат Документ.Номер;
КонецФункции
#КонецОбласти

