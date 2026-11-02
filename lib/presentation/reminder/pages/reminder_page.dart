import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_event.dart';
import 'package:startwar_movie_app/presentation/reminder/pages/reminder_view.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: BlocProvider(
        create: (context) => ReminderBloc(
          repository: RepositoryProvider.of(context),
          eventBus: RepositoryProvider.of(context),
        )..add(LoadRemindersEvent()),
        child: const ReminderView(),
      ),
    );
  }
}
