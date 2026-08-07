import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/daily_task_service.dart';
import '../widgets/ad_banner_widget.dart';

class DailyTasksScreen extends StatelessWidget {
  const DailyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<DailyTaskService>(context);
    final completedCount = taskService.currentTasks.where((t) => t.isCompleted).length;
    final totalCount = taskService.currentTasks.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2C23),
        elevation: 0,
        title: Text(
          'Daily Noor Tasks & Streak',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Color(0xFFD4AF37)),
            tooltip: 'Shuffle New Random Tasks',
            onPressed: () {
              taskService.shuffleRandomTasks();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Streak & Progress Hero Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF194C3D), Color(0xFF0F2C23)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 26)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DAILY NOOR STREAK',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD4AF37),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              '${taskService.streakCount} Days Active',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF081B15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        '$completedCount / $totalCount Done',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFF081B15),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                  ),
                ),
              ],
            ),
          ),

          // Title & Randomize Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Random Spiritual Tasks',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => taskService.shuffleRandomTasks(),
                  icon: const Icon(Icons.refresh, size: 16, color: Color(0xFFD4AF37)),
                  label: Text(
                    'Shuffle',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD4AF37),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: taskService.currentTasks.length,
              itemBuilder: (ctx, idx) {
                final task = taskService.currentTasks[idx];

                return GestureDetector(
                  onTap: () => taskService.toggleTask(task.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: task.isCompleted ? const Color(0xFF13382D) : const Color(0xFF0F2C23),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: task.isCompleted
                            ? const Color(0xFFD4AF37)
                            : Colors.white12,
                        width: task.isCompleted ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          activeColor: const Color(0xFFD4AF37),
                          checkColor: const Color(0xFF081B15),
                          onChanged: (val) => taskService.toggleTask(task.id),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.titleUrdu,
                                      style: GoogleFonts.notoNastaliqUrdu(
                                        color: task.isCompleted ? const Color(0xFFD4AF37) : Colors.white,
                                        fontSize: 15,
                                        height: 1.8,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF081B15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      task.category,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFD4AF37),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                task.titleEnglish,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.stars, color: Color(0xFFD4AF37), size: 14),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Virtue: ${task.rewardVirtue}',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFD4AF37),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const AdBannerWidget(),
        ],
      ),
    );
  }
}
