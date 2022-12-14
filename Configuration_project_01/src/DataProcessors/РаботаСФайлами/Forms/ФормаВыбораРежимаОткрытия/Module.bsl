///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БольшеНеСпрашивать = Ложь;
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
	ВариантОткрытияФайла = РаботаСФайлами.НастройкиРаботыСФайлами().ВариантОткрытияФайла;
	Если ВариантОткрытияФайла = "Редактировать" Тогда
		КакОткрывать = 1;
	КонецЕсли;
	КакОткрыватьСохраненныйВариант = КакОткрывать;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если КакОткрыватьСохраненныйВариант <> КакОткрывать Тогда
		РежимОткрытия = ?(КакОткрывать = 1, "Редактировать", "Открыть");
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиОткрытияФайлов", "ВариантОткрытияФайла", РежимОткрытия,,, Истина);
	КонецЕсли;
	
	Если БольшеНеСпрашивать = Истина Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиОткрытияФайлов", "СпрашиватьРежимРедактированияПриОткрытииФайла", Ложь,,, Истина);
		
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("БольшеНеСпрашивать", БольшеНеСпрашивать);
	РезультатВыбора.Вставить("КакОткрывать", КакОткрывать);
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ОповеститьОВыборе(КодВозвратаДиалога.Отмена);
КонецПроцедуры

#КонецОбласти
