import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startwar_movie_app/data/datasource/cinema_mock_datasource.dart';
import 'package:startwar_movie_app/data/datasource/location_datasource.dart';
import 'package:startwar_movie_app/data/datasource/movie_datasource.dart';
import 'package:startwar_movie_app/data/datasource/reminder_local_datasource.dart';
import 'package:startwar_movie_app/data/datasource/routing_datasource.dart';
import 'package:startwar_movie_app/data/repositories/cinema_repository_impl.dart';
import 'package:startwar_movie_app/data/repositories/location_repository_impl.dart';
import 'package:startwar_movie_app/data/repositories/movie_repository_impl.dart';
import 'package:startwar_movie_app/data/repositories/reminder_repository_impl.dart';
import 'package:startwar_movie_app/data/repositories/routing_datasource_impl.dart';
import 'package:startwar_movie_app/data/services/reminder_notification_service.dart';
import 'package:startwar_movie_app/domain/repositories/cinema_repository.dart';
import 'package:startwar_movie_app/domain/repositories/location_repository.dart';
import 'package:startwar_movie_app/domain/repositories/movie_repository.dart';
import 'package:startwar_movie_app/domain/repositories/reminder_repository.dart';
import 'package:startwar_movie_app/domain/repositories/routing_repository.dart';
import 'package:startwar_movie_app/presentation/movie_list/pages/movie_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final reminderNotificationService = ReminderNotificationService();
  await reminderNotificationService.initialize();

  runApp(
    MainApp(
      sharedPreferences: sharedPreferences,
      reminderNotificationService: reminderNotificationService,
    ),
  );
}

class MainApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final ReminderNotificationService reminderNotificationService;

  const MainApp({
    super.key,
    required this.sharedPreferences,
    required this.reminderNotificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieDataSource>(
          create: (context) => MovieDataSourceImpl(),
        ),
        RepositoryProvider<MovieRepository>(
          create: (context) => MovieRepositoryImpl(
            RepositoryProvider.of<MovieDataSource>(context),
          ),
        ),

        RepositoryProvider<CinemaMockDataSource>(
          create: (context) => CinemaMockDataSourceImpl(),
        ),

        RepositoryProvider<CinemaRepository>(
          create: (context) => CinemaRepositoryImpl(
            dataSource: context.read<CinemaMockDataSource>(),
          ),
        ),
        RepositoryProvider<LocationDataSource>(
          create: (context) => LocationDataSourceImpl(),
        ),

        RepositoryProvider<LocationRepository>(
          create: (context) => LocationRepositoryImpl(
            RepositoryProvider.of<LocationDataSource>(context),
          ),
        ),

        RepositoryProvider<RoutingDataSource>(
          create: (context) => RoutingDataSourceImpl(),
        ),

        RepositoryProvider<RoutingRepository>(
          create: (context) =>
              RoutingRepositoryImpl(context.read<RoutingDataSource>()),
        ),

        RepositoryProvider<ReminderLocalDataSource>(
          create: (context) => ReminderLocalDataSourceImpl(
            sharedPreferences: sharedPreferences,
            notificationService: reminderNotificationService,
          ),
        ),

        RepositoryProvider<ReminderRepository>(
          create: (context) => ReminderRepositoryImpl(
            localDataSource: RepositoryProvider.of<ReminderLocalDataSource>(
              context,
            ),
          ),
        ),

        RepositoryProvider<EventBus>(create: (_) => EventBus()),
      ],
      child: MaterialApp(
        color: Colors.white,
        home: MovieListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
