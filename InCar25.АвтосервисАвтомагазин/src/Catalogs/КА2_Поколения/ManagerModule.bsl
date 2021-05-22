// 
//	Аутсорсинг Групп 
//		+7 495 241 10 64
//		+7 3852 59 50 96
//		
//	Филимонов И.В.
//		+7 913 240 81 77
//
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обновляет справочник данными из файла поставщика
// 
// Параметры:
// 	ИмяФайла - Строка - Полное имя файла
// Возвращаемое значение:
// 	Структура - Описание:
// * ИмяСправочника - Строка - Наименование справочника
// * Загружено - Число - Количество обновленных элементов справочника
// * Ошибок - Число - Количество ошибок обновления
Функция Обновить(ИмяФайла) Экспорт

	Возврат КА2_КаталогАвтомобилейВызовСервера.ОбновитьСправочник(Метаданные.Справочники.КА2_Поколения.Имя, ИмяФайла);

КонецФункции

// Возвращает выборку элементов справочника с пустым полем date_create
// 
// Возвращаемое значение:
// 	ВыборкаИзРезультатаЗапроса - Описание
Функция Некорректные() Экспорт

	Возврат КА2_КаталогАвтомобилейВызовСервера.КоллекцияНекорректных(Метаданные.Справочники.КА2_Поколения.Имя);

КонецФункции

// Возвращает коллекцию поколений по наименованию марки и наименованию модели
// 
// Параметры:
// 	Марка - СправочникСсылка.КА2_НаименованияМарок - Наименование марки
// 	Модель - СправочникСсылка.КА2_НаименованияМоделей - Наименование модели 
// Возвращаемое значение:
// 	Массив из СправочникСсылка.КА2_Поколения - Массив ссылок на отобранные элементы справочника КА2_Поколения
Функция НайтиПоНаименованиямМаркиИМодели(Марка, Модель) Экспорт

	Если ТипЗнч(Марка) <> Тип("СправочникСсылка.КА2_НаименованияМарок")
		 Или ТипЗнч(Модель) <> Тип("СправочникСсылка.КА2_НаименованияМоделей") Тогда
		Возврат Неопределено;
	КонецЕсли;

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	КА2_Поколения.Ссылка
						  |ИЗ
						  |	Справочник.КА2_Поколения КАК КА2_Поколения
						  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КА2_Модели КАК КА2_Модели
						  |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КА2_Марки КАК КА2_Марки
						  |			ПО КА2_Модели.id_car_mark = КА2_Марки.Код
						  |		ПО КА2_Поколения.Владелец = КА2_Модели.Ссылка
						  |ГДЕ
						  |	КА2_Марки.Владелец = &Марка
						  |	И КА2_Модели.Владелец = &Модель");
	Запрос.УстановитьПараметр("Марка", Марка);
	Запрос.УстановитьПараметр("Модель", Модель);

	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");

КонецФункции

Функция ДополнительныеДанные(Ссылка) Экспорт

	РеквизитыДляПолучения = "year_begin, year_end, id_car_type, id_car_model, Владелец";

	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, РеквизитыДляПолучения);

	МаркаКод = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначенияРеквизитов.Владелец, "id_car_mark");

	ТипТС = Справочники.КА2_Типы.НайтиПоКоду(ЗначенияРеквизитов.id_car_type);
	Марка = Справочники.КА2_Марки.НайтиПоКоду(МаркаКод);

	ДополнительныеДанные = Новый Структура;
	ДополнительныеДанные.Вставить("ТипТС", ТипТС);
	ДополнительныеДанные.Вставить("Марка", Марка);
	ДополнительныеДанные.Вставить("Модель", ЗначенияРеквизитов.Владелец);
	ДополнительныеДанные.Вставить("ГодНП", ЗначенияРеквизитов.year_begin);
	ДополнительныеДанные.Вставить("ГодОП", ЗначенияРеквизитов.year_end);

	ГодыВыпуска = КА2_КаталогАвтомобилейКлиентСервер.ГодыВыпускаСтрока(ДополнительныеДанные.ГодНП, ДополнительныеДанные.ГодОП);

	ДополнительныеДанные.Вставить("ГодыВыпуска", ГодыВыпуска);

	Возврат ДополнительныеДанные;

КонецФункции

#КонецОбласти

#КонецЕсли