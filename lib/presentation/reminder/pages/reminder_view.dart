import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_event.dart';
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
          if (reminders.isEmpty) {
            return Center(child: Text('No reminders available.'));
          }
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return ListTile(
                title: Text('Reminder for ${reminder.filmDetail.title}'),
                subtitle: Text(
                  'Scheduled at ${DateFormat('dd/MM/yyyy HH:mm:ss a').format(reminder.scheduledAt.toLocal())}',
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    context.read<ReminderBloc>().add(
                      CancelReminderEvent(
                        cinemaId: reminder.cinemaId,
                        reminderId: reminder.id,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reminder for ${reminder.filmDetail.title} cancelled',
                        ),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(label: 'OK', onPressed: () {}),
                      ),
                    );
                  },
                  child: Text('Cancel'),
                ),
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
