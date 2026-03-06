import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/utils/utils.dart';

class WorkoutSummaryDialog extends StatefulWidget {
  final WorkoutModel currentWorkout;
  final WorkoutModel? previousWorkout;
  final Duration duration;
  final VoidCallback onClose;

  const WorkoutSummaryDialog({
    super.key,
    required this.currentWorkout,
    this.previousWorkout,
    required this.duration,
    required this.onClose,
  });

  @override
  State<WorkoutSummaryDialog> createState() => _WorkoutSummaryDialogState();
}

class _WorkoutSummaryDialogState extends State<WorkoutSummaryDialog> {
  final GlobalKey _shareKey = GlobalKey();
  bool _isSharing = false;

  // 🔥 Функція, яка робить фото і викликає меню "Поділитися"
  Future<void> _shareWorkout() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      RenderRepaintBoundary boundary =
          _shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/workout_summary.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      await Share.shareXFiles([
        XFile(imagePath),
      ], text: 'Щойно завершив тренування в Gym Tracker! 🔥');
    } catch (e) {
      debugPrint('Помилка поширення: $e');
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String durationStr =
        "${twoDigits(widget.duration.inHours)}:${twoDigits(widget.duration.inMinutes.remainder(60))}:${twoDigits(widget.duration.inSeconds.remainder(60))}";

    return Dialog(
      backgroundColor: Colors.transparent, // Прозорий фон
      elevation: 0,
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔥 ОБГОРТАЄМО У REPAINT BOUNDARY ТЕ, ЩО БУДЕ НА ФОТО
          RepaintBoundary(
            key: _shareKey,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: const BoxConstraints(maxHeight: 550),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loc.greatJob,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${loc.durationLabel}: $durationStr",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.currentWorkout.exercises.length,
                      itemBuilder: (context, index) {
                        final currentEx =
                            widget.currentWorkout.exercises[index];
                        final prevEx = widget.previousWorkout?.exercises
                            .firstWhere(
                              (e) => _isSameExercise(e, currentEx),
                              orElse: () => WorkoutExercise(name: '', sets: []),
                            );

                        return _buildExerciseComparisonCard(
                          context,
                          currentEx,
                          prevEx,
                          loc,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.fitness_center,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Gym Tracker App',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔥 КНОПКИ (Знаходяться поза межами скріншоту)
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    loc.close,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              SizedBox(
                height: 50,
                width: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.cardColor,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSharing ? null : _shareWorkout,
                  child: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.ios_share, color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- ВІДНОВЛЕНІ ДОПОМІЖНІ МЕТОДИ ---

  bool _isSameExercise(WorkoutExercise a, WorkoutExercise b) {
    if (a.exerciseId != null && b.exerciseId != null) {
      return a.exerciseId == b.exerciseId;
    }
    return a.name == b.name;
  }

  Color _getBorderColor(WorkoutExercise current, WorkoutExercise? previous) {
    if (previous == null || previous.name.isEmpty) {
      return Colors.transparent;
    }

    double getVolume(List<SetData> sets) {
      return sets.fold(
        0.0,
        (sum, set) => sum + (set.weight ?? 0) * (set.reps ?? 0),
      );
    }

    final currentVol = getVolume(current.sets);
    final prevVol = getVolume(previous.sets);

    if (currentVol > prevVol) {
      return Colors.green.withValues(alpha: 0.6);
    } else if (currentVol < prevVol) {
      return Colors.red.withValues(alpha: 0.6);
    } else {
      return Colors.yellow.withValues(alpha: 0.6);
    }
  }

  Widget _buildExerciseComparisonCard(
    BuildContext context,
    WorkoutExercise current,
    WorkoutExercise? previous,
    AppLocalizations loc,
  ) {
    final bool hasHistory = previous != null && previous.name.isNotEmpty;
    final borderColor = _getBorderColor(current, previous);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            current.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            if (!hasHistory)
              Text(
                loc.noPreviousData,
                style: const TextStyle(color: Colors.grey),
              )
            else
              _buildComparisonTable(context, current.sets, previous.sets, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable(
    BuildContext context,
    List<SetData> currentSets,
    List<SetData> prevSets,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  loc.repsLabel,
                  style: _headerStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  loc.weightLabel,
                  style: _headerStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        ...List.generate(currentSets.length, (i) {
          final currSet = currentSets[i];
          final prevSet = (i < prevSets.length) ? prevSets[i] : null;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    "${i + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: _buildMetricComparison(
                    current: currSet.reps,
                    previous: prevSet?.reps,
                    isWeight: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricComparison(
                    current: currSet.weight,
                    previous: prevSet?.weight,
                    isWeight: true,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  TextStyle _headerStyle(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
  );

  Widget _buildMetricComparison({
    num? current,
    num? previous,
    required bool isWeight,
  }) {
    if (current == null) return const SizedBox();

    Color bgColor = Colors.grey.shade200;
    Color textColor = Colors.black87;

    if (previous != null) {
      if (current > previous) {
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
      } else if (current < previous) {
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
      } else {
        bgColor = Colors.yellow.shade100;
        textColor = Colors.yellow.shade900;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isWeight ? formatDouble(current.toDouble()) : "$current",
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          if (previous != null) ...[
            const SizedBox(width: 4),
            Text(
              isWeight
                  ? "(${formatDouble(previous.toDouble())})"
                  : "($previous)",
              style: TextStyle(
                fontSize: 10,
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
