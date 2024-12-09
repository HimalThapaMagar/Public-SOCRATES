// these are the all the imports that are needed for this..
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socrates/core/configs/themes/app_theme.dart';
import 'package:socrates/firebase_options.dart';
import 'package:socrates/presentation/add_data_page/bloc/add_data_location_cubit.dart';
import 'package:socrates/presentation/add_data_page/service/add_data_location_service.dart';
import 'package:socrates/presentation/add_data_page/service/location_firebase_service.dart';
import 'package:socrates/presentation/add_data_page/service/location_storage_service.dart';
import 'package:socrates/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:socrates/presentation/home_page/bloc/tracking_cubit.dart';
import 'package:socrates/presentation/home_page/services/location_service.dart';
import 'package:socrates/presentation/splash/splash.dart';
import 'package:socrates/service_locator.dart';


// main function, this is entry point of the app and it is async function
Future<void> main() async {
  // this ensures all the widgets are properly initialized otherwise it will throw an error
  WidgetsFlutterBinding.ensureInitialized();

  //sets up hydratdBloc which are persistent storage for the app
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  // Initialize Firebase to communicate with firebase services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //initialize the dependencies injection and global services for the application
  await initializeDependencies();

  // intialize the shared preferences to store some cache data for the app
  final prefs = await SharedPreferences.getInstance();

  // initialize the location service
  final locationService = LocationService(prefs);

  // Initialize required services
  final storageService = StorageService(prefs);
  final firebaseService = FirebaseService();
  final addDataLocationService = AddDataLocationService();
  // Create the AddDataLocationCubit
  final addDataLocationCubit = AddDataLocationCubit(
    addDataLocationService: addDataLocationService,
    storageService: storageService,
    firebaseService: firebaseService,
  );
  // this will run the application with root widget as MyApp
  runApp(MyApp(
      locationService: locationService,
      addDataLocationCubit: addDataLocationCubit));
}
// this is the root of the applications, essentially flutter is a tree of widgets and classes and this is the root of the tree or top if you want to go from top haha.
class MyApp extends StatelessWidget {
  // this service is for managing the location of the user
  final LocationService locationService;
  // this is the cubit for adding data location
  final AddDataLocationCubit addDataLocationCubit;
  const MyApp(
      {super.key,
      required this.locationService,
      required this.addDataLocationCubit});

  // This widget is the root of our application. so maybe the top of the tree or the root of the tree whatever you want to call it. ha
  @override
  Widget build(BuildContext context) {
    // this provides the bloc to the application that makes the internal components of the app to communicate with each other and sync with each other and also to manage the state of the application.
    return MultiBlocProvider(
      providers: [
        // this one provides theme to the application so that the theme can be changed dynamically like dark mode or light mode you know.
        BlocProvider(create: (_) => ThemeCubit()),
        // this one provides the tracking cubit to the application so that the tracking of the user can be managed and the location of the user can be tracked.
        BlocProvider<TrackingCubit>(
          create: (context) => TrackingCubit(locationService)..initialize(),
        ),
        // this one provides the add data location cubit to the application so that the data can be added to the location and the location can be tracked.
        BlocProvider.value(
          value: addDataLocationCubit,
        ),
      ],
      // this reacts to the change in the theme of the application and changes the theme of the application accordingly dynamically so kinda cool. I guess...
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          themeMode: mode,
          darkTheme: AppTheme.darkTheme,
          theme: AppTheme.lightTheme,
          // initially the splash page is shown to the user of the application so that the user can see the splash screen and then the app is loaded. so kinda splashhhh, get it? haha
          home: const SplashPage(),
        ),
      ),
    );
  }
}
