import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_event.dart';
import 'package:startwar_movie_app/presentation/reminder/pages/reminder_view.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StarWarsTheme(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 64,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REMINDERS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                  color: AppColors.goldBright,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'UPCOMING SHOWS',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => ReminderBloc(
            repository: RepositoryProvider.of(context),
            eventBus: RepositoryProvider.of(context),
          )..add(LoadRemindersEvent()),
          child: const ReminderView(),
        ),
      ),
    );
  }
}
