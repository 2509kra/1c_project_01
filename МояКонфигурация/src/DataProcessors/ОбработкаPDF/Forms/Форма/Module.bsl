
&НаСервере
Процедура Команда1НаСервере(Путь,АдресФайлаВХранилище)
	// Вставить содержимое обработчика. 
	
	ТЗ_Структура_БД = ПолучитьСтруктуруХраненияБазыДанных(); 
Сообщить(ТЗ_Структура_БД.Количество()); 
ВхСтруктура = Новый Структура;

Массив = Новый Массив;

Массив.Добавить(ТЗ_Структура_БД); 
   ВхСтруктура.Вставить("МассивТЗ",Массив);

   
   
  СписокКолонокТЗ = "";
    Для Каждого КолонкаТЗ Из ТЗ_Структура_БД.Колонки Цикл
        СписокКолонокТЗ = СписокКолонокТЗ + ?(СписокКолонокТЗ = "", "", ",") + КолонкаТЗ.Имя;  
		Сообщить(КолонкаТЗ.Имя) ;
    КонецЦикла;

	////Цикл по ТЗ
	//Для Каждого СтрТЗ Из ТЗ_Структура_БД Цикл
	//    //Структура для каждой строки
	//    СтруктураСтроки = Новый Структура(СписокКолонокТЗ);

	//    //Копируем значения строк в структуру
	//    ЗаполнитьЗначенияСвойств(СтруктураСтроки, СтрТЗ);

	//    //Выгрузим в структуру по индексу    
	//	Попытка
	//    ВхСтруктура.Вставить("Строка" + ТЗ_Структура_БД.Индекс(СтрТЗ), СтруктураСтроки); 
	//Исключение
	//	КонецПопытки;
	//КонецЦикла;


////Цикл по ТЗ
//    Для Каждого СтрТЗ Из ТЗ_Структура_БД Цикл
//        //Структура для каждой строки
//        СтруктураСтрокиТЗ = Новый Структура;
//        Для Каждого КолонкаТЗ Из ТЗ_Структура_БД.Колонки Цикл
//            СтруктураСтрокиТЗ.Вставить(КолонкаТЗ.Имя, СтрТЗ[КолонкаТЗ.Имя]);
//        КонецЦикла;
//        //Выгрузим в структуру по индексу
//        ВхСтруктура.Вставить("Строка" + ТЗ_Структура_БД.Индекс(СтрТЗ), СтруктураСтрокиТЗ);
//    КонецЦикла;

АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(
        ТЗ_Структура_БД,
        Новый УникальныйИдентификатор
    );



//	Попытка
//    Если ЗначениеВФайл(Путь, ТЗ_Структура_БД) Тогда
//        Сообщить("Выгрузка успешно завершена!");
//    Иначе
//         Сообщить("1 Возникли проблемы при выгрузке!");
//    КонецЕсли;
//Исключение                                                           
//    Сообщить("2 Возникли проблемы при выгрузке! " + ОписаниеОшибки());
//КонецПопытки;



КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	Путь = КаталогВременныхФайлов()+"20220526.txt";

//Массив = Новый Массив;
АдресФайлаВХранилище = "";  
//ВхСтруктура = Новый Структура;
//Массив.Добавить(ТЗ_Структура_БД);

//Попытка
//    Если ЗначениеВФайл(Путь, Массив.ТЗ_Структура_БД) Тогда
//        Сообщить("Выгрузка успешно завершена!");
//    Иначе
//         Сообщить("Возникли проблемы при выгрузке!");
//    КонецЕсли;
//Исключение                                                           
//    Сообщить("Возникли проблемы при выгрузке! " + ОписаниеОшибки());
//КонецПопытки;
	
	
	Команда1НаСервере(Путь,АдресФайлаВХранилище);  
	
	
//	Попытка
//    Если ЗначениеВФайл(Путь, Массив.ТЗ_Структура_БД) Тогда
//        Сообщить("Выгрузка успешно завершена!");
//    Иначе
//         Сообщить("Возникли проблемы при выгрузке!");
//    КонецЕсли;
//Исключение                                                           
//    Сообщить("Возникли проблемы при выгрузке! " + ОписаниеОшибки()); 


//АдресВХранилище = ПоместитьВоВременноеХранилище(
//        Массив.ТЗ_Структура_БД,
//        Новый УникальныйИдентификатор
//    );

//КонецПопытки; 
 //ТЗ =Массив.Получить(0); 
 Сообщить("АдресФайлаВХранилище: "+Строка(АдресФайлаВХранилище));

Если АдресФайлаВХранилище = "" Тогда
        Сообщить("Сначала нужно сохранить файл на сервере.");
        Сообщить("Воспользуйтесь кнопкой 'Передача файла с клиента...'");
        Возврат;
    КонецЕсли;
	
	
СписокИзХранилища = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
    Если СписокИзХранилища = Неопределено Тогда
        Сообщить("Значение по этому адресу уже удалено из хранилища.");
    Иначе
        Сообщить(СписокИзХранилища); // Владивосток
    КонецЕсли;	
	
	
 //////   ОповещениеОЗавершении = Новый ОписаниеОповещения(
 //////       "ВыполнитьПослеПолученияФайлов", ЭтотОбъект
 //////   );
 //////
 //////   ПолучаемыеФайлы = Новый Массив;
 //////   ПолучаемыеФайлы.Добавить(
 //////       Новый ОписаниеПередаваемогоФайла(
 //////           "D:\from_server.txt", // куда сохранять на клиента
 //////           АдресФайлаВХранилище // адрес в хранилище на сервере
 //////       )
 //////   );
 //////
 //////   НачатьПолучениеФайлов(
 //////       ОповещениеОЗавершении,
 //////       ПолучаемыеФайлы,
 //////       ,
 //////       Ложь // интерактивно
 //////   );
 



КонецПроцедуры    

&НаКлиенте
Процедура ВыполнитьПослеПолученияФайлов(ПолученныеФайлы,
    ДополнительныеПараметры) Экспорт
 
    Для Каждого Файл Из ПолученныеФайлы Цикл
        Сообщить("Получен " + Файл.Имя + " из " + Файл.Хранение);
    КонецЦикла;
 
КонецПроцедуры

&AtServer
Procedure РаботаPDFAtServer()
	// Вставить содержимое обработчика. 
	DocPDF = New PDFDocument(); 
	
	
EndProcedure

&AtClient
Procedure РаботаPDF(Command)
	РаботаPDFAtServer();
EndProcedure
