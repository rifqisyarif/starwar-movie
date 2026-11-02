import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_state.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderBloc, ReminderState>(
      builder: (context, state) {
        if (state is ReminderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReminderLoaded) {
          final reminders = state.reminders;
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return ListTile(
                title: Text('Reminder for ${reminder.filmDetail.title}'),
                subtitle: Text(
                    'Scheduled at ${reminder.scheduledAt.toLocal().toString()}'),
              );
            },
          );
        } else if (state is ReminderError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('No reminders available.'));
        }
      },
    );
  }
}