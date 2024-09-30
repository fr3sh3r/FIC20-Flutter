part of 'get_holiday_bloc.dart';

@freezed
class GetHolidayEvent with _$GetHolidayEvent {
  const factory GetHolidayEvent.started() = _Started;
  const factory GetHolidayEvent.getHolidays() = _GetHolidays;
}

//PENJELASAN
// const factory GetHolidayEvent.getHoliday() = _GetHoliday;:

// const factory: This indicates that the constructor is a factory constructor, which means it doesn't create a new instance of the class directly but delegates the creation to another constructor.
// GetHolidayEvent: This is the name of the class that the constructor belongs to.
// .getHoliday(): This is the name of the factory constructor.
// = _GetHoliday;: This part specifies that the getHoliday() constructor is an alias for the _GetHoliday constructor.
// In summary:

// This line of code defines a factory constructor named getHoliday() within the GetHolidayEvent class. When this constructor is called, it will create an instance of the _GetHoliday variant of the GetHolidayEvent class. 