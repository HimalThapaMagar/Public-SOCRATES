import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socrates/presentation/home_page/bloc/tracking_cubit.dart';

// this is the first home page of the app which is shown to the user when the app is opened. this is the first page of the app when user logs in ofcourse.
// this is a statefull widget because the state of the widget changes when the user interacts with the app.
class FirstHomePage extends StatefulWidget {
  const FirstHomePage({super.key});
  
  @override
  State<FirstHomePage> createState() => _FirstHomePageState();
}

class _FirstHomePageState extends State<FirstHomePage> {
  // this is the build method which is used to build the widget and show it on the screen and ovverides the build method of the stateful widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // here as we can  see this is taking the tracking cubit which is used to track the location of the user and show the status of the tracking to the user.
      body: BlocBuilder<TrackingCubit, TrackingState>(
        builder: (context, state) {
          // this is the safe area which is used to show the content of the app in the safe area of the app so that the content is not hidden by the notch or the status bar of the app.
          return SafeArea(
            // here this single child scroll view is used to show the content of the app in a scrollable view so that the user can scroll the content of the app. this is more of a responsive design choice which is not needed for most of the user but is a good practice.
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // this is the greeting which is shown to the user according to the time of the day like good morning, good afternoon, good evening, good night.
                    _greetings(),
                    _getUserName(),
                    const SizedBox(height: 30),
                    // this is the status card which is used to show the status of the tracking to the user like if the tracking is active or inactive.
                    Center(child: _buildStatusCard(context, state)),
                    const SizedBox(height: 24),
                    // this is the toggle switch which is used to toggle the tracking of the user like if the tracking is active then the user can pause the tracking and if the tracking is paused then the user can start the tracking.
                    _buildToggleSwitch(context, state),
                    if (state.message.isNotEmpty) _buildMessageBanner(state),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  // this is that greetings widget.
  Widget _greetings() {
    final now = DateTime.now();
    String greeting = now.hour < 12
        ? 'Good Morning'
        : now.hour < 17
            ? 'Good Afternoon'
            : now.hour < 20
                ? 'Good Evening'
                : 'Good Night';
    return Text(
      greeting,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _getUserName() {
    return const Text(
      'Enumerator',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
  // this is that buildstatus card which is used to show the status of the tracking to the user.
  Widget _buildStatusCard(BuildContext context, TrackingState state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // this icon is used to show the status of the tracking to the user like if the tracking is active then the icon is green and if the tracking is inactive then the icon is grey.
            Icon(
              state.status == TrackingStatus.tracking
                  ? Icons.location_on
                  : Icons.location_off,
              size: 48,
              color: state.status == TrackingStatus.tracking
                  ? Colors.green
                  : Colors.grey,
            ),
            const SizedBox(height: 16),
            // this text is used to show the status of the tracking to the user like if the tracking is active then the text is tracking active and if the tracking is inactive then the text is tracking inactive.
            Text(
              state.status == TrackingStatus.tracking
                  ? 'Tracking Active'
                  : 'Tracking Inactive',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: state.status == TrackingStatus.tracking
                        ? Colors.green
                        : Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              state.status == TrackingStatus.tracking
                  ? 'Your location is being tracked'
                  : 'Location tracking is paused',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // this is the toggle switch to toggle the tracking of the user or not.
  Widget _buildToggleSwitch(BuildContext context, TrackingState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Enable Tracking',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 16),
        Switch(
          value: state.status == TrackingStatus.tracking,
          onChanged: (_) {
            context.read<TrackingCubit>().toggleTracking();
          },
        ),
      ],
    );
  }
  // this is the message banner which is used to show the message to the user like if the tracking is active then the message is tracking active and if the tracking is inactive then the message is tracking inactive.
  Widget _buildMessageBanner(TrackingState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: state.status == TrackingStatus.tracking
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              state.status == TrackingStatus.tracking
                  ? Icons.check_circle
                  : Icons.error,
              color: state.status == TrackingStatus.tracking
                  ? Colors.green
                  : Colors.red,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                state.message,
                style: TextStyle(
                  color: state.status == TrackingStatus.tracking
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}