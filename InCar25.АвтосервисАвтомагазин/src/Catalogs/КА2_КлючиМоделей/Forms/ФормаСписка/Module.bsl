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

	КешТекстаЗапроса = Список.ТекстЗапроса;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПроблемыПриИзменении(Элемент)

	ПроблемыПриИзмененииНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПроблемыПриИзмененииНаСервере()

	ДопОтборДобавленыИнтерактивно = " И (КА2_КлючиМоделей.Марка <> ЗНАЧЕНИЕ(Справочник.КА2_Марки.ПустаяСсылка)
									|	И КА2_КлючиМоделей.Марка.date_create = """"
									|	ИЛИ КА2_КлючиМоделей.Модель <> ЗНАЧЕНИЕ(Справочник.КА2_Модели.ПустаяСсылка)
									|		И КА2_КлючиМоделей.Модель.date_create = """"
									|	ИЛИ КА2_КлючиМоделей.Поколение <> ЗНАЧЕНИЕ(Справочник.КА2_Поколения.ПустаяСсылка)
									|		И КА2_КлючиМоделей.Поколение.date_create = """"
									|	ИЛИ КА2_КлючиМоделей.Кузов <> ЗНАЧЕНИЕ(Справочник.КА2_Кузова.ПустаяСсылка)
									|		И КА2_КлючиМоделей.Кузов.date_create = """"
									|	ИЛИ КА2_КлючиМоделей.Модификация <> ЗНАЧЕНИЕ(Справочник.КА2_Модификации.ПустаяСсылка)
									|		И КА2_КлючиМоделей.Модификация.date_create = """"
									|	ИЛИ КА2_КлючиМоделей.Комплектация <> ЗНАЧЕНИЕ(Справочник.КА2_Комплектации.ПустаяСсылка)
									|		И КА2_КлючиМоделей.Комплектация.date_create = """")";

	Если Проблемы = Перечисления.АС2_ПроблемыКлючейМоделей.ДобавленыИнтерактивно Тогда
		КешТекстаЗапроса = Список.ТекстЗапроса;
		Список.ТекстЗапроса = КешТекстаЗапроса + ДопОтборДобавленыИнтерактивно;
	Иначе
		Список.ТекстЗапроса = КешТекстаЗапроса;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КлючиМоделей", Строки.ПолучитьКлючи());
	Запрос.Текст = "ВЫБРАТЬ
				   |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КА2_МоделиАвтомобилейДляНоменклатуры.Номенклатура) КАК Вхождений,
				   |	КА2_МоделиАвтомобилейДляНоменклатуры.КлючМодели
				   |ИЗ
				   |	РегистрСведений.КА2_МоделиАвтомобилейДляНоменклатуры КАК КА2_МоделиАвтомобилейДляНоменклатуры
				   |ГДЕ
				   |	КА2_МоделиАвтомобилейДляНоменклатуры.КлючМодели В (&КлючиМоделей)
				   |СГРУППИРОВАТЬ ПО
				   |	КА2_МоделиАвтомобилейДляНоменклатуры.КлючМодели";

	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаСписка = Строки[Выборка.КлючМодели];
		СтрокаСписка.Данные["Вхождений"] = Выборка.Вхождений;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаменитьКлюч(Команда)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;

	ПараметрыВызова = Новый Структура("КлючМодели", ТекущиеДанные.Ссылка);

	ОткрытьФорму("Обработка.КА2_УправлениеНаборомМоделейДляНоменклатуры.Форма.ФормаЭлементаНоменклатуры",
				 ПараметрыВызова,
				 ЭтотОбъект,
				 ЭтотОбъект.КлючУникальности,
				 ,
				 ,
				 ,
				 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяВНоменклатуре(Команда)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;

	ПараметрыВызова = Новый Структура("КлючМодели", ТекущиеДанные.Ссылка);

	ОткрытьФорму("ОбщаяФорма.КА2_ФормаСпискаНоменклатуры",
				 ПараметрыВызова,
				 ЭтотОбъект,
				 ЭтотОбъект.КлючУникальности,
				 ,
				 ,
				 ,
				 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти