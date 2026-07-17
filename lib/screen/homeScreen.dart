import 'package:flutter/material.dart';
import 'package:ohayo/display.dart';
import 'package:ohayo/setting.dart';

// Homescreen is the app's root widget (called from runApp in main.dart).
// This is the ONLY MaterialApp in the tree — it provides Directionality,
// Navigator, theming, etc. to everything below it.
class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreentwo(),
    );
  }
}

class Task {
  Task({required this.title, this.done = false});
  String title;
  bool done;
}

class HomeScreentwo extends StatefulWidget {
  const HomeScreentwo({super.key});

  @override
  State<HomeScreentwo> createState() => _HomeScreentwoState();
}

class _HomeScreentwoState extends State<HomeScreentwo>
    with SingleTickerProviderStateMixin {
  // Color palette pulled out so it's consistent everywhere instead of
  // repeating hex codes all over the widget tree.
  static const bg = Color(0xFF836664);
  static const accent = Color.fromRGBO(128, 57, 41, 1.0);
  static const highlight = Color(0xFFCA5750);

  late final TabController _tabController;

  // In-memory only for now — swap this for SQLite reads/writes later.
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Task> get _activeTasks => _tasks.where((t) => !t.done).toList();
  List<Task> get _completedTasks => _tasks.where((t) => t.done).toList();

  void _privacy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Privacy and Policy"),
        content: const Text("Your privacy policy text goes here."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Fancy formal add-task sheet: a Card holding a TextField, opened from
  // the FAB. showModalBottomSheet instead of a plain AlertDialog so it
  // slides up and feels more like a proper form.
  void _addTaskSheet() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.add_task, color: accent),
                        const SizedBox(width: 8),
                        const Text(
                          "New Task",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Task title",
                        hintText: "e.g. Finish CpEPC 120 lab",
                        prefixIcon: const Icon(Icons.edit_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: accent, width: 2),
                        ),
                      ),
                      onSubmitted: (_) => _submitTask(controller),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _submitTask(controller),
                          icon: const Icon(Icons.check),
                          label: const Text("Add Task"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitTask(TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() => _tasks.add(Task(title: text)));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      drawer: Drawer(
        backgroundColor: bg.withOpacity(0.95),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: accent),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Menu",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.font_download, color: Colors.white),
                title: const Text("Display", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Display()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text("Settings", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined, color: Colors.white),
                title: const Text("Privacy and Policy", style: TextStyle(color: Colors.white)),
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
        backgroundColor: accent,
        elevation: 4,
        title: const Text(
          "To-Do List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "Tasks (${_activeTasks.length})"),
            Tab(text: "Completed (${_completedTasks.length})"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accent,
        onPressed: _addTaskSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // TabBarView gives the swipe-between-tabs behavior for free —
      // swiping left/right moves between Tasks and Completed, and it
      // stays in sync with the TabBar above.
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF6EDEC),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _TaskList(
              tasks: _activeTasks,
              accent: accent,
              emptyMessage: "Add a task by tapping +",
              onToggle: (task) => setState(() => task.done = !task.done),
              onDelete: (task) => setState(() => _tasks.remove(task)),
            ),
            _TaskList(
              tasks: _completedTasks,
              accent: accent,
              emptyMessage: "No completed tasks yet",
              onToggle: (task) => setState(() => task.done = !task.done),
              onDelete: (task) => setState(() => _tasks.remove(task)),
            ),
          ],
        ),
      ),
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
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: Checkbox(
              value: task.done,
              activeColor: accent,
              onChanged: (_) => onToggle(task),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null,
                color: task.done ? Colors.grey : Colors.black87,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () => onDelete(task),
            ),
          ),
        );
      },
    );
  }
}