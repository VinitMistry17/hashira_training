import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import '../widgets/task_card.dart';
import '../widgets/streak_banner.dart';
import '../utils/streak_helper.dart';
import '../models/task.dart';
import '../screens/profile_screen.dart';
import 'task_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int streakDays = 0;
  bool isLocked = false;

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    checkDateAndResetTasks();
    loadTasks();
    loadLockStatus();
    StreakHelper.updateStreak().then((_) {
      loadStreak();
      loadLockStatus();
    });
  }

  void checkDateAndResetTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toString().substring(0, 10);
    final lastCompletedDate = prefs.getString('lastCompletedDate');

    if (lastCompletedDate != today) {
      prefs.setStringList('doneTasks', []);
      prefs.setBool('isTasksLocked', false);
      prefs.setString('lastCompletedDate', today);
    }
  }

  void addTask(String note) async {
    int nextNumber = tasks.length + 1;
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Defeat Inner Demon $nextNumber',
      notes: note,
    );
    setState(() {
      tasks.add(newTask);
    });
    await saveTasks();
  }

  void deleteTask(Task task) async {
    setState(() {
      tasks.remove(task);
    });
    await saveTasks();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> doneTasks =
    tasks.where((task) => task.isDone).map((task) => task.id).toList();
    List<String> allTasks =
    tasks.map((task) => '${task.id}|${task.notes ?? ''}').toList();
    await prefs.setStringList('doneTasks', doneTasks);
    await prefs.setStringList('allTasks', allTasks);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> doneTasks = prefs.getStringList('doneTasks') ?? [];
    List<String>? allTasks = prefs.getStringList('allTasks');

    List<Task> loaded = [];

    if (allTasks != null && allTasks.isNotEmpty) {
      for (int i = 0; i < allTasks.length; i++) {
        final parts = allTasks[i].split('|');
        loaded.add(
          Task(
            id: parts[0],
            title: 'Defeat Inner Demon ${i + 1}',
            notes: parts.length > 1 ? parts[1] : null,
            isDone: doneTasks.contains(parts[0]),
          ),
        );
      }
    } else {
      loaded = List.generate(5, (i) {
        final id = (i + 1).toString();
        return Task(
          id: id,
          title: 'Defeat Inner Demon ${i + 1}',
          isDone: false,
        );
      });
    }

    setState(() {
      tasks = loaded;
    });
  }

  void saveLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTasksLocked', isLocked);
  }

  void loadLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLocked = prefs.getBool('isTasksLocked') ?? false;
    });
  }

  void resetTodayTasks() async {
    setState(() {
      for (var task in tasks) {
        task.isDone = false;
      }
      isLocked = false;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('doneTasks', []);
    prefs.setBool('isTasksLocked', false);
  }

  void checkAllTasksDone() async {
    bool allDone = tasks.every((task) => task.isDone);
    saveTasks();
    if (allDone) {
      loadStreak();
    }
  }

  Future<void> loadStreak() async {
    int days = await StreakHelper.getStreak();
    setState(() {
      streakDays = days;
    });
  }

  @override
  Widget build(BuildContext context) {
    int demonsPerTask = 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Training Arc',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(streakDays: streakDays),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final note = await showDialog<String>(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('Add Inner Demon Notes'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Your notes'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(context, controller.text.trim()),
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );

          if (note != null && note.isNotEmpty) {
            addTask(note);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Hashira ⚔️',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            StreakBanner(
              streakDays: streakDays,
              rank: StreakHelper.getRank(streakDays),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: Key(task.id),
                    background: Container(color: Colors.red),
                    onDismissed: (_) => deleteTask(task),
                    child: TaskCard(
                      title: task.title,
                      isDone: task.isDone,
                      onTap: () {
                        if (isLocked) return;
                        setState(() {
                          task.isDone = !task.isDone;
                        });
                        saveTasks();
                        checkAllTasksDone();
                      },
                      onDetailTap: () async {
                        if (isLocked) return;
                        final updatedNotes = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(task: task),
                          ),
                        );
                        if (updatedNotes != null) {
                          setState(() {
                            task.notes = updatedNotes;
                          });
                          saveTasks();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: (tasks.every((t) => t.isDone) && !isLocked)
                    ? () async {
                  setState(() {
                    isLocked = true;
                  });
                  saveLockStatus();
                  int demonsToday = tasks.length * demonsPerTask;
                  await StreakHelper.addDemonsSlain(demonsToday);
                  await StreakHelper.markAllTasksDone();

                  final prefs =
                  await SharedPreferences.getInstance();
                  prefs.setString(
                    'lastCompletedDate',
                    DateTime.now().toString().substring(0, 10),
                  );

                  loadStreak();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '🗡️ Slayer Mission Locked! +$demonsToday Demons Slain'),
                    ),
                  );
                }
                    : null,
                child: const Text('🗡️ Mark Mission Complete'),
              ),
            ),
            const SizedBox(height: 10),
            if (isLocked)
              Center(
                child: TextButton(
                  onPressed: () {
                    resetTodayTasks();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('🔄 Tasks Unlocked!')),
                    );
                  },
                  child: const Text(
                    '🔄 Restart Today\'s Tasks',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
