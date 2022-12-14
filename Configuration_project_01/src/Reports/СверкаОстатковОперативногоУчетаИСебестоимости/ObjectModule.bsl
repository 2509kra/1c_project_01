#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ДобавитьПредупреждениеОбОсобенностяхФормированияОтчета(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПредупреждениеОбОсобенностяхФормированияОтчета(ДокументРезультат)
	
	Период = НачалоМесяца(КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Период").Значение);
	
	Если НЕ РасчетСебестоимостиПовтИсп.ВозможенРасчетСебестоимости(Период) Тогда
		
		ТекстПредупреждения = 
			НСтр("ru ='Отчет используется только при включенном учете себестоимости.'");
		
	ИначеЕсли НЕ РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(Период) Тогда
		
		ТекстПредупреждения = 
			НСтр("ru ='Отчет используется только при включенном партионном учете версии 2.2.'");
		
	Иначе
		
		// Отчет сформирован без особенностей.
		ТекстПредупреждения = "";
		
	КонецЕсли;
	
	ТаблицаПредупреждение = Новый ТабличныйДокумент;
	ОбластьПредупреждение = ТаблицаПредупреждение.Область(1,1,1,1);
	
	ОбластьПредупреждение.Текст 	 = СокрЛП(ТекстПредупреждения);
	ОбластьПредупреждение.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
	
	ДокументРезультат.ВставитьОбласть(
		ОбластьПредупреждение,
		ДокументРезультат.Область(1,1,1,1),
		ТипСмещенияТабличногоДокумента.ПоВертикали);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
