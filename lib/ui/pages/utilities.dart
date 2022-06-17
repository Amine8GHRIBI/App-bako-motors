/*
int createUniqueId(){
  return DateTime.now().microsecondsSinceEpoch.remainder(100000);

}

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;


  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });

}
Future<NotificationWeekAndTime?> pickSchedule(
BuildContext context,
)async{
  List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
     'Fri',
    'Sat',
    'Sun'
  ];
  TimeOfDay? timeOfDay;
  DateTime now = DateTime.now();
  int? selectedDay;

}

Future<void> createWaterReminderNotification(
    NotificationWeekAndTime notificationSchedule) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: '${Emojis.wheater_droplet} Add some water to your plant!',
      body: 'Water your plant regularly to keep it healthy.',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      )
    ],
    schedule: NotificationCalendar(
      weekday: notificationSchedule.dayOfTheWeek,
      hour: notificationSchedule.timeOfDay.hour,
      minute: notificationSchedule.timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}*/