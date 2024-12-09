import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:socrates/presentation/home_page/pages/first_home_page.dart';
import 'package:socrates/presentation/home_page/pages/data_page.dart';
import 'package:socrates/presentation/home_page/pages/profile_page.dart';
import 'package:socrates/presentation/home_page/pages/settings_page.dart';

// This HomePage is the main page of the app where the user can navigate to different pages of the app. It uses PageView to navigate between pages and GNav for the bottom navigation bar.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index of the selected page this tracks the current page index
  int selectedIndex = 0;
  // this is a pagecontroller which is used to control the pageview basically it is used to navigate between pages in the application.
  final PageController _pageController = PageController();
  // this is the list of pages that are shown in the pageview, currently there are 4 pages in the app.
  final List<Widget> _pages = [
    FirstHomePage(), // this is the first page of the app
    DataPage(), // this is the data page of the app
    ProfilePage(), // this is the profile page of the app
    SettingsPage(), // this is the settings page of the app
  ];
  // this is the build method which is used to build the widget and show it on the screen and ovverides the build method of the stateful widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // this is the body of the scaffold which is the main body of the app and it is a pageview which is used to navigate between pages in the app.
      body: PageView(
        // this takes that page controller which is used to navigate between pages in the app.
        controller: _pageController,
        // this is the onPageChanged which is used to change the page when the page is changed. and setstate is called to basically rebuid the UI according to the new change or the new page.
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        // this is the children of the pageview which are the pages that are shown in the pageview. the upper part of the UI that is shown to the user.
        children: _pages,
      ),
      // so I kinda got lazy and imported GNAV from google_nav_bar package which is used to show the bottom navigation bar in the app. so this is the bottom navigation bar of the app. this is the reuse of the code and the code is not written from scratch.
      bottomNavigationBar: GNav(
        // selected index is the index of the selected page which is used to track the current page index. so 0 to 3 because we have 4 pages in total which is subject to change if more pages are added or is taken out the app.
        selectedIndex: selectedIndex,
        // this is the onTabChange which is used to change the page when the tab is changed and setstate is called to basically rebuid the UI according to the new change or the new page.
        onTabChange: (index) {
          setState(() {
            selectedIndex = index;
          });
          // here we are animating to the page that is selected by the user when the tab is changed.
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            // we can use different curves to animate the page change like easeInOut, easeIn, easeOut, etc.
            curve: Curves.easeInOut,
          );
        },
        // this is the tabs bottom tab of the page with icon that is intially shown and text confirming the user that that icon represents that particular page.
        tabs: const [
          GButton(
            icon: Icons.home_outlined,
            text: 'Home',
          ),
          GButton(
            icon: Icons.data_array_outlined,
            text: 'Data',
          ),
          GButton(
            icon: Icons.person_2_outlined,
            text: 'Profile',
          ),
          GButton(
            icon: Icons.settings_outlined,
            text: 'Settings',
          ),
        ],
      ),
    );
  }
}
