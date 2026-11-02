import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/domain/entities/reminder.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_event.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_state.dart';
import 'package:startwar_movie_app/presentation/reminder/widgets/reminder_card.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/app_snackbar.dart';
import 'package:startwar_movie_app/presentation/widgets/app_state_views.dart';
import 'package:startwar_movie_app/presentation/widgets/starfield_background.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderBloc, ReminderState>(
      builder: (context, state) {
        if (state is ReminderLoading || state is ReminderInitial) {
          return const StarfieldBackground(
            child: AppLoadingView(message: 'Checking your reminders...'),
          );
        }

        if (state is ReminderError) {
          return StarfieldBackground(
            child: AppErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<ReminderBloc>().add(LoadRemindersEvent()),
            ),
          );
        }

        if (state is ReminderLoaded) {
          final reminders = [...state.reminders]
            ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

          if (reminders.isEmpty) {
            return StarfieldBackground(
              child: AppEmptyView(
                icon: Icons.notifications_none_rounded,
                title: 'No reminders yet',
                message:
                    'Set a reminder from a cinema and it will appear here before showtime.',
                action: OutlinedButton.icon(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.local_movies_rounded, size: 18),
                  label: const Text('Browse movies'),
                ),
              ),
            );
          }

          return StarfieldBackground(
            child: RefreshIndicator(
              color: AppColors.gold,
              backgroundColor: AppColors.surfaceHigh,
              onRefresh: () async {
                final bloc = context.read<ReminderBloc>();
                final done = bloc.stream.firstWhere(
                  (state) =>
                      state is ReminderLoaded || state is ReminderError,
                );
                bloc.add(LoadRemindersEvent());
                await done.timeout(
                  const Duration(seconds: 10),
                  onTimeout: () => bloc.state,
                );
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                itemCount: reminders.length + 1,
                separatorBuilder: (context, index) => SizedBox(
                  height: index == 0 ? 22 : 12,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _ReminderHeader(count: reminders.length);
                  }

                  final reminder = reminders[index - 1];
                  return ReminderCard(
                    reminder: reminder,
                    onCancel: () => _cancelReminder(context, reminder),
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _cancelReminder(BuildContext context, Reminder reminder) {
    context.read<ReminderBloc>().add(
      CancelReminderEvent(
        cinemaId: reminder.cinemaId,
        reminderId: reminder.id,
      ),
    );

    showAppSnackBar(
      context,
      message:
          'Reminder for ${reminder.filmDetail.title ?? 'this movie'} cancelled',
      icon: Icons.notifications_off_outlined,
    );
  }
}

class _ReminderHeader extends StatelessWidget {
  const _ReminderHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('UPCOMING SHOWS', style: AppTheme.label),
        const SizedBox(height: 10),
        Text(
          'Your Reminders',
          style: AppTheme.display.copyWith(fontSize: 30),
        ),
        const SizedBox(height: 8),
        Text(
          '$count reminder${count == 1 ? '' : 's'} scheduled',
          style: AppTheme.body.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}
