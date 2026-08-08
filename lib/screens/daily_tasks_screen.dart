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
      backgroundColor: const Color(0xFF082017),
      appBar: AppBar(
        backgroundColor: const Color(0xFF163024),
        elevation: 0,
        title: Text(
          'Daily Tasks & Streak',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Color(0xFFCCA236), size: 20),
            tooltip: 'Shuffle Tasks',
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
            margin: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E4A39), Color(0xFF163024)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFCCA236), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCCA236).withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DAILY STREAK',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFCCA236),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            '${taskService.streakCount} Days Active',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF082017),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        '$completedCount / $totalCount',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFCCA236),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFF082017),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFCCA236)),
                  ),
                ),
              ],
            ),
          ),

          // Title & Shuffle Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Today\'s Spiritual Tasks',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => taskService.shuffleRandomTasks(),
                  icon: const Icon(Icons.refresh, size: 14, color: Color(0xFFCCA236)),
                  label: Text(
                    'Shuffle',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFCCA236),
                      fontSize: 11,
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              itemCount: taskService.currentTasks.length,
              itemBuilder: (ctx, idx) {
                final task = taskService.currentTasks[idx];

                return GestureDetector(
                  onTap: () => taskService.toggleTask(task.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: task.isCompleted ? const Color(0xFF1B382C) : const Color(0xFF163024),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: task.isCompleted ? const Color(0xFFCCA236) : Colors.white12,
                        width: task.isCompleted ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Checkbox(
                            value: task.isCompleted,
                            activeColor: const Color(0xFFCCA236),
                            checkColor: const Color(0xFF082017),
                            onChanged: (val) => taskService.toggleTask(task.id),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.titleUrdu,
                                      style: GoogleFonts.notoNastaliqUrdu(
                                        color: task.isCompleted ? const Color(0xFFCCA236) : Colors.white,
                                        fontSize: 14,
                                        height: 1.8,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF082017),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      task.category,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFCCA236),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.titleEnglish,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.stars, color: Color(0xFFCCA236), size: 12),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Virtue: ${task.rewardVirtue}',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFCCA236),
                                        fontSize: 10,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
