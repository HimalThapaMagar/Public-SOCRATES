import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socrates/presentation/add_data_page/bloc/add_data_location_cubit.dart';
import 'package:socrates/presentation/choose_mode/bloc/theme_cubit.dart';
// this is the settings page which is used to show the settings of the app to the user.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
// this is the state of the settings page which is used to show the settings of the app to the user.
class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text('Settings'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          _refreshLocationCacheButtton(context),
          const SizedBox(
            height: 20,
          ),
          _themeModeToggle(context),
        ],
      ),
    );
  }
}
// this refresh location cache button is used to refresh the location cache of the app.
_refreshLocationCacheButtton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Refresh Location Cache",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          context.read<AddDataLocationCubit>().refreshGeofence();
          if (kDebugMode) {
            print("Refreshed Location Cache");
          }
        },
      ),
    ],
  );
}
// this theme mode toggle is used to toggle the theme mode of the app.
Widget _themeModeToggle(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Dark Mode",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      const SizedBox(width: 10),
      BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (bool isDark) {
              context.read<ThemeCubit>().updateTheme(
                    isDark ? ThemeMode.dark : ThemeMode.light,
                  );
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: Colors.white,
          );
        },
      ),
    ],
  );
}