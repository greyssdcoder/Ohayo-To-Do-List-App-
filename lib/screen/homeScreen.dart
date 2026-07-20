import 'package:flutter/material.dart';
import 'package:ohayo/display.dart';
import 'package:ohayo/setting.dart';
import 'package:ohayo/theme_notifier.dart';
import 'package:ohayo/db/database_helper.dart';
import 'package:ohayo/calendar.dart';

// Homescreen is the app's root widget (called from runApp in main.dart).
// This is the ONLY MaterialApp in the tree.
class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const HomeScreentwo(),
        );
      },
    );
  }
}

class Task {
  Task({this.id, required this.title, this.done = false, this.dueDate, this.priority = 'normal'});
  int? id;
  String title;
  bool done;
  DateTime? dueDate;
  String priority;

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      done: (map['done'] as int) == 1,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate'] as String) : null,
      priority: (map['priority'] as String?) ?? 'normal',
    );
  }
}
class HomeScreentwo extends StatefulWidget {
  const HomeScreentwo({super.key});

  @override
  State<HomeScreentwo> createState() => _HomeScreentwoState();
}

class _HomeScreentwoState extends State<HomeScreentwo>
    with SingleTickerProviderStateMixin {
  // bg/textDark/textMuted stay fixed — only the accent color is dynamic
  // now, driven by AppTheme.accentColor (set from the Display screen).
  static const textMuted = Color(0xFF8B8B99);

  late final TabController _tabController;
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final rows = await DatabaseHelper.instance.getTasks();
    print("Loaded ${rows.length} tasks from DB");
    setState(() {
      _tasks
        ..clear()
        ..addAll(rows.map((row) => Task.fromMap(row)));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Task> get _activeTasks {
    final list = _tasks.where((t) => !t.done).toList();
    list.sort((a, b) => a.priority == b.priority ? 0 : (a.priority == 'important' ? -1 : 1));
    return list;
  }
  List<Task> get _completedTasks => _tasks.where((t) => t.done).toList();

  void _privacy() {
    final accent = AppTheme.accentColor.value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Privacy and Policy"),
        content: const Text("Your privacy policy text goes here."),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: accent),
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _addTaskSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFC);
    final textDark = isDark ? Colors.white : const Color(0xFF1E1E2A);
    final controller = TextEditingController();
    final accent = AppTheme.accentColor.value;
    DateTime? selectedDate;
    String selectedPriority = 'normal';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                     Text(
                      "New Task",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      style:  TextStyle(color: textDark),
                      decoration: InputDecoration(
                        hintText: "e.g. Finish CpEPC 120 lab",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: bg,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: accent, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(primary: accent),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          setSheetState(() => selectedDate = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey.shade500),
                            const SizedBox(width: 10),
                            Text(
                              selectedDate == null
                                  ? "Set due date (optional)"
                                  : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                              style: TextStyle(
                                color: selectedDate == null ? Colors.grey.shade500 : textDark,
                              ),
                            ),
                            const Spacer(),
                            if (selectedDate != null)
                              GestureDetector(
                                onTap: () => setSheetState(() => selectedDate = null),
                                child: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
                              ),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPriority,
                    isExpanded: true,
                    icon: Icon(Icons.flag_outlined, color: Colors.grey.shade500),
                    items: const [
                      DropdownMenuItem(value: 'important', child: Text("Important — do this now")),
                      DropdownMenuItem(value: 'normal', child: Text("Less important")),
                    ],
                    onChanged: (value) {
                      if (value != null) setSheetState(() => selectedPriority = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => _submitTask(controller, selectedDate, selectedPriority),
                        child: const Text("Add Task", style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _submitTask(TextEditingController controller, DateTime? dueDate, String priority) async {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      final id = await DatabaseHelper.instance.insertTask({
        'title': text,
        'done': 0,
        'dueDate': dueDate?.toIso8601String(),
        'priority': priority,
      });
      setState(() => _tasks.add(Task(id: id, title: text, dueDate: dueDate, priority: priority)));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds this whole screen whenever AppTheme.accentColor changes —
    // e.g. right after picking a new color on the Display screen.
    return ValueListenableBuilder<Color>(
      valueListenable: AppTheme.accentColor,
      builder: (context, accent, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFC);
        final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textDark = isDark ? Colors.white : const Color(0xFF1E1E2A);
        return Scaffold(
          backgroundColor: bg,
          drawer: Drawer(
            backgroundColor: surface,
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.check_circle_outline, color: accent),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Menu",
                          style: TextStyle(color: textDark, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.font_download_outlined,
                    label: "Display",
                    accent: accent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Display()));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: "Settings",
                    accent: accent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.calendar_month_outlined,
                    label: "Calendar",
                    accent: accent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Calendar()));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    label: "Privacy and Policy",
                    accent: accent,
                    onTap: () {
                      Navigator.pop(context);
                      _privacy();
                    },
                  ),


                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: surface,
            elevation: 0,
            surfaceTintColor: surface,
            iconTheme:  IconThemeData(color: textDark),
            title:  Text(
              "To-Do List",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textDark),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: accent,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: accent,
              unselectedLabelColor: textMuted,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: "Tasks (${_activeTasks.length})"),
                Tab(text: "Completed (${_completedTasks.length})"),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: accent,
            elevation: 2,
            onPressed: _addTaskSheet,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _TaskList(
                tasks: _activeTasks,
                accent: accent,
                emptyMessage: "No tasks yet — tap + to add one",
                onToggle: (task) async {
                  final updated = !task.done;
                  await DatabaseHelper.instance.updateTask(task.id!, {
                    'title': task.title,
                    'done': updated ? 1 : 0,
                    'dueDate': task.dueDate?.toIso8601String(),
                  });
                  setState(() => task.done = updated);
                },
                onDelete: (task) async {
                  await DatabaseHelper.instance.deleteTask(task.id!);
                  setState(() => _tasks.remove(task));
                },
              ),
              _TaskList(
                tasks: _completedTasks,
                accent: accent,
                emptyMessage: "No completed tasks yet",
                onToggle: (task) async {
                  final updated = !task.done;
                  await DatabaseHelper.instance.updateTask(task.id!, {
                    'title': task.title,
                    'done': updated ? 1 : 0,
                    'dueDate': task.dueDate?.toIso8601String(),
                  });
                  setState(() => task.done = updated);
                },
                onDelete: (task) async {
                  await DatabaseHelper.instance.deleteTask(task.id!);
                  setState(() => _tasks.remove(task));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: accent),
      title: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1E1E2A),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.accent,
    required this.emptyMessage,
    required this.onToggle,
    required this.onDelete,
  });

  final List<Task> tasks;
  final Color accent;
  final String emptyMessage;
  final void Function(Task) onToggle;
  final void Function(Task) onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checklist_rtl, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: GestureDetector(
              onTap: () => onToggle(task),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.done ? accent : Colors.transparent,
                  border: Border.all(color: task.done ? accent : Colors.grey.shade400, width: 2),
                ),
                child: task.done ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null,
                color: task.done ? Colors.grey.shade400 : (isDark ? Colors.white : const Color(0xFF1E1E2A)),
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: task.dueDate != null
                ? Text(
              "Due ${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.priority == 'important')
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.flag, size: 18, color: Colors.redAccent),
                  ),
                IconButton(
                  icon: Icon(Icons.close, size: 20, color: Colors.grey.shade400),
                  onPressed: () => onDelete(task),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}