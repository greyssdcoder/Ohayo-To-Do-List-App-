import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ohayo/db/database_helper.dart';
import 'package:ohayo/screen/homeScreen.dart'; // reuses the Task class + Task.fromMap
import 'package:ohayo/theme_notifier.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Task> _allTasks = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final rows = await DatabaseHelper.instance.getTasks();
    setState(() => _allTasks = rows.map((row) => Task.fromMap(row)).toList());
  }

  List<Appointment> get _appointments {
    return _allTasks
        .where((t) => t.dueDate != null)
        .map((t) => Appointment(
      startTime: t.dueDate!,
      endTime: t.dueDate!.add(const Duration(hours: 1)),
      subject: t.title,
      isAllDay: true,
      color: t.priority == 'important' ? Colors.redAccent : Colors.blueAccent,
    ))
        .toList();
  }

  List<Task> get _tasksForSelectedDay {
    return _allTasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == _selectedDate.year &&
          t.dueDate!.month == _selectedDate.month &&
          t.dueDate!.day == _selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: AppTheme.accentColor,
      builder: (context, accent, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFC);
        final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF1E1E2A);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: accent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Calendar",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              Container(
                color: surface,
                height: 400,
                child: SfCalendar(
                  view: CalendarView.month,
                  backgroundColor: surface,
                  dataSource: _AppointmentDataSource(_appointments),
                  todayHighlightColor: accent,
                  headerStyle: CalendarHeaderStyle(
                    backgroundColor: accent.withOpacity(0.1),
                    textStyle: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  viewHeaderStyle: ViewHeaderStyle(
                    backgroundColor: surface,
                    dayTextStyle: TextStyle(color: textColor.withOpacity(0.6), fontWeight: FontWeight.w600),
                  ),
                  selectionDecoration: BoxDecoration(
                    border: Border.all(color: accent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                    monthCellStyle: MonthCellStyle(
                      textStyle: TextStyle(color: textColor),
                      todayTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      todayBackgroundColor: accent,
                    ),
                  ),
                  onTap: (details) {
                    if (details.date != null) {
                      setState(() => _selectedDate = details.date!);
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                color: surface,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.event_note, size: 18, color: accent),
                    const SizedBox(width: 8),
                    Text(
                      "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: bg,
                  child: _tasksForSelectedDay.isEmpty
                      ? Center(
                    child: Text(
                      "No tasks due this day",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: _tasksForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final task = _tasksForSelectedDay[index];
                      final dotColor = task.priority == 'important' ? Colors.redAccent : accent;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border(left: BorderSide(color: dotColor, width: 4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            if (task.priority == 'important')
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(Icons.flag, size: 16, color: Colors.redAccent),
                              ),
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  color: task.done ? Colors.grey : textColor,
                                  decoration: task.done ? TextDecoration.lineThrough : null,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (task.done)
                              const Icon(Icons.check_circle, size: 18, color: Colors.green),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}