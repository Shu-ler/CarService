// 
//	Аутсорсинг Групп 
//		+7 495 241 10 64
//		+7 3852 59 50 96
//		
//	Филимонов И.В.
//		+7 913 240 81 77
//
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	КоллекцияКлючей = Неопределено;

	ОбщегоНазначенияУТ.ИнициализироватьКешТекущейСтроки(ЭтотОбъект, "КлючиМоделей");

	// Получение дополнительных реквизитов
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыСеанса.КА2_ПВХ);
	
	// Заполнение ТЗ наименованиями полей и пустыми значениями соответствующего типа
	МассивПустыеПоля = ПараметрыСеанса.КА2_КлючиМоделейПустыеПоля;
	Для Каждого Элемент Из МассивПустыеПоля Цикл
		НовСтр = ПустыеПоля.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Элемент);
	КонецЦикла;

	ДляНоменклатуры = ЗначениеЗаполнено(Параметры.Номенклатура);
	ДляЗаменыКлюча = ЗначениеЗаполнено(Параметры.КлючМодели);

	Если ДляНоменклатуры Тогда
		КоллекцияКлючей = Справочники.КА2_КлючиМоделей.НайтиПоНоменклатуре(Параметры.Номенклатура,
																		   Параметры.ХарактеристикаНоменклатуры);
	ИначеЕсли ДляЗаменыКлюча Тогда
		КоллекцияКлючей = Справочники.КА2_КлючиМоделей.НайтиПоКлючуМодели(Параметры.КлючМодели);
	КонецЕсли;

	Объект.КлючиМоделей.Загрузить(КоллекцияКлючей);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ДляНоменклатуры Тогда
		СтрокаВНаименованиеНоменклатуры = КА2_КаталогАвтомобилейКлиентСервер.СформироватьСтрокуВНаименование(Объект.КлючиМоделей);
	ИначеЕсли ДляЗаменыКлюча Тогда
		Элементы.СтрокаВНаименованиеНоменклатуры.Видимость = Ложь;
		Элементы.Совместимо.Видимость = Ложь;
		Элементы.КомандаПеренестиИЗакрыть.Заголовок = "Заменить и закрыть";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если Модифицированность Тогда

		Если ЗавершениеРаботы Тогда
			Отказ = Истина;
			ТекстПредупреждения = "При закрытии данные (состав моделей автомобилей) будут утеряны. Продолжить?";
		Иначе
			//TODO: Вставить содержимое обработчика
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКлючиМоделей

&НаКлиенте
Процедура КлючиМоделейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока И Не Копирование Тогда
		Элемент.ТекущиеДанные.Совместимо = Истина;
	КонецЕсли;

	ОбщегоНазначенияУТКлиент.КешироватьТекущуюСтроку(ЭтотОбъект, "КлючиМоделей");

КонецПроцедуры

&НаКлиенте
Процедура КлючиМоделейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	Если Не ОтменаРедактирования Тогда
		Модифицированность = Истина;
		СтрокаВНаименованиеНоменклатуры = КА2_КаталогАвтомобилейКлиентСервер.СформироватьСтрокуВНаименование(Объект.КлючиМоделей);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КлючиМоделейПослеУдаления(Элемент)

	Модифицированность = Истина;
	СтрокаВНаименованиеНоменклатуры = КА2_КаталогАвтомобилейКлиентСервер.СформироватьСтрокуВНаименование(Объект.КлючиМоделей);
	КешНомераСтроки = Элемент.ТекущиеДанные.НомерСтроки;

КонецПроцедуры

&НаКлиенте
Процедура КлючиМоделейПриИзменении(Элемент)

	Если Элемент.ТекущиеДанные.НомерСтроки <> КешНомераСтроки Тогда
		СтрокаВНаименованиеНоменклатуры = КА2_КаталогАвтомобилейКлиентСервер.СформироватьСтрокуВНаименование(Объект.КлючиМоделей);
		КешНомераСтроки = Элемент.ТекущиеДанные.НомерСтроки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КлючиМоделейПриАктивизацииСтроки(Элемент)

	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		КешНомераСтроки = Элемент.ТекущиеДанные.НомерСтроки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КлючиМоделейЭлементПриИзменении(Элемент)

	// Переменные для упрощения кода
	ТекущиеДанные = Элементы.КлючиМоделей.ТекущиеДанные;
	Колонка = Элемент.Имя;
	ПолеОчищено = ТекущиеДанные[Колонка].Пустая();

	// Проверка на изменение поля. Если старое и новое значение совпадают - игнорирование действий
	Если ТекущиеДанные[Колонка] = КлючиМоделейКешТекущейСтроки[Колонка]
		 И Колонка <> "МаркаНаименование"
		 И Колонка <> "МодельНаименование" И Колонка <> "Поколение" Тогда
		Возврат;
	КонецЕсли;

	// Очистка и заполнение полей
	ОчиститьПоляПравееПоля(Колонка, ТекущиеДанные);
	ЗаполнитьДополнительныеПоля(Колонка, ТекущиеДанные, ПолеОчищено);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПеренестиИЗакрыть(Команда)

	Если ДляНоменклатуры Тогда
			
		// Установка модифицированности в форме элемента номенклатуры
		ВладелецФормы.Модифицированность = Истина;
	
		// Установка дополнительных реквизитов на форме номенклатуры
		УстановитьРеквизитыНаВладельцеФорме();

		// Обновление ключей в справочнике КА2_КлючиМоделей и регистре КА2_МоделиАвтомобилейДляНоменклатуры
		КА2_КаталогАвтомобилейВызовСервера.ОбновитьКлючиМоделейДляНоменклатуры(Параметры.Номенклатура,
																			   Параметры.ХарактеристикаНоменклатуры,
																			   Объект.КлючиМоделей);
	КонецЕсли;

	Если ДляЗаменыКлюча Тогда

		Результат = КА2_КаталогАвтомобилейВызовСервера.ЗаменитьКлючиМоделей(Параметры.КлючМодели, Объект.КлючиМоделей);

		ОповеститьОбИзменении(Параметры.КлючМодели);

		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = Результат;
		Сообщение.ИдентификаторНазначения = ЭтотОбъект.ВладелецФормы.УникальныйИдентификатор;
		Сообщение.Сообщить();

	КонецЕсли;

	ЭтотОбъект.Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриПереносе

// Устанавливает значение реквизитов МаркиМодели и ТекстПоискаМодели на форме-владельце
// 
&НаКлиенте
Процедура УстановитьРеквизитыНаВладельцеФорме()

	// Поиск элементов формы-владельца
	ПоискМаркиМодели = Новый Структура("Свойство", ПВХМаркиМодели);
	ПоискОтборПоКаталогуАвтомобилей = Новый Структура("Свойство", ПВХОтборПоКаталогуАвтомобилей);
	ПоискТекстПоискаМодели = Новый Структура("Свойство", ПВХТекстПоискаМодели);

	ДопРеквизитыВладельца = ВладелецФормы.Свойства_ОписаниеДополнительныхРеквизитов;

	МаркиМодели = ДопРеквизитыВладельца.НайтиСтроки(ПоискМаркиМодели)[0].ИмяРеквизитаЗначение;
	ТекстПоискаМодели = ДопРеквизитыВладельца.НайтиСтроки(ПоискТекстПоискаМодели)[0].ИмяРеквизитаЗначение;
	ОтборПоКаталогуАвтомобилей = ДопРеквизитыВладельца.НайтиСтроки(ПоискОтборПоКаталогуАвтомобилей)[0].ИмяРеквизитаЗначение; 	 
	
	// Установка реквизита на форме-владельце
	СтрокиОтбораИПоиска = КА2_КаталогАвтомобилейВызовСервера.СформироватьСтрокиОтбора(Объект.КлючиМоделей);
	ВладелецФормы[МаркиМодели] = СтрокаВНаименованиеНоменклатуры;
	ВладелецФормы[ТекстПоискаМодели] = СтрокиОтбораИПоиска.СДР_Поиск;
	ВладелецФормы[ОтборПоКаталогуАвтомобилей] = СтрокиОтбораИПоиска.СДР_КА2_Отбор;

КонецПроцедуры

#КонецОбласти

#Область РедактированиеПолейТабличнойЧасти

&НаКлиенте
Процедура ОчиститьПоляПравееПоля(Знач Колонка, ТекущиеДанные)

	НомерКолонки = НомерСтрокиВТЗПустыеПоля(Колонка);

	Для ай = НомерКолонки + 1 По ПустыеПоля.Количество() - 1 Цикл
		ТекущиеДанные[ПустыеПоля[ай].ИмяПоля] = ПустыеПоля[ай].ПустоеЗначение;
	КонецЦикла;

КонецПроцедуры

Функция ДоступныДополнительныеДанные(Колонка)

	Возврат Колонка = "МаркаНаименование" Или Колонка = "МодельНаименование" Или Колонка = "Поколение" Или Колонка = "Кузов"

КонецФункции

&НаКлиенте
Процедура ЗаполнитьДополнительныеПоля(Знач Колонка, ТекущиеДанные, ПолеОчищено)

	АктуальнаяКолонка = "";

	Если ПолеОчищено Тогда
		//@skip-warning
		Если (Колонка = "Кузов" И Не ЗначениеЗаполнено(ТекущиеДанные["Поколение"])) Или Колонка = "Поколение" Тогда
			АктуальнаяКолонка = "МодельНаименование";
		ИначеЕсли Колонка = "МодельНаименование" Тогда
			АктуальнаяКолонка = "МаркаНаименование";
		КонецЕсли;
	ИначеЕсли ДоступныДополнительныеДанные(Колонка) Тогда
		АктуальнаяКолонка = Колонка;
	КонецЕсли;

	Если Не ПустаяСтрока(АктуальнаяКолонка) Тогда
		ДополнительныеДанные = ДополнительныеДанныеДляКолонки(АктуальнаяКолонка, ТекущиеДанные[АктуальнаяКолонка]);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДополнительныеДанные);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДополнительныеДанныеДляКолонки(Знач Колонка, ЗначениеПоля)

	ИмяСправочника = Неопределено;
	СправочникиИПоля = ПараметрыСеанса.КА2_ПоляКлючейМоделей;

	Для Каждого Элемент Из СправочникиИПоля Цикл
		Если Элемент.Значение = Колонка Тогда
			ИмяСправочника = Элемент.Ключ;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если ИмяСправочника = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат Справочники[ИмяСправочника].ДополнительныеДанные(ЗначениеПоля);
	КонецЕсли;

КонецФункции

// Возвращает номер строки для Колонка в таблице значений ПустыеПоля
// 
// Параметры:
// 	Колонка - Строка - Наименование колонки
// Возвращаемое значение:
// 	Неопределено, Число - Номер строки
&НаКлиенте
Функция НомерСтрокиВТЗПустыеПоля(Знач Колонка)

	НайденыСтроки = ПустыеПоля.НайтиСтроки(Новый Структура("ИмяПоля", Колонка));

	Если НайденыСтроки.Количество() <> 1 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат НайденыСтроки[0].НомерСтроки

КонецФункции

#КонецОбласти

#КонецОбласти