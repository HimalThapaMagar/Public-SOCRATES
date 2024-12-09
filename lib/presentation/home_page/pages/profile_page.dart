// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/common/widgets/basic_app_bar.dart';
import 'package:socrates/presentation/auth/sign_in_page.dart';
import 'package:socrates/presentation/home_page/bloc/profile_info_cubit.dart';
import 'package:socrates/presentation/home_page/bloc/profile_state.dart';
import 'package:socrates/service_locator.dart';
// this is the profile page which is used to show the profile of the user. It is a stateless widget because this doesnot need to maintain any state.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        hideBack: true,
        title: Text(
          'Profile'
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           _profileInfo(context),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit(sl())..getUser(),
      child: Container(
        height: MediaQuery.of(context).size.height * .35 ,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode(context) ? const Color(0xff2C2B2B) : Colors.white,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50)
          )
        ),
        child: BlocBuilder<ProfileInfoCubit,ProfileInfoState>(
        builder: (context, state) {
          if(state is ProfileInfoLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator()
            );
          } 
          if(state is ProfileInfoLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        state.userEntity.imageURL!
                      )
                    )
                  ),
                ),
                const SizedBox(height: 15,),
                Text(
                  state.userEntity.email!
                ),
                const SizedBox(height: 10,),
                Text(
                  state.userEntity.fullName!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10,),
                TextButton(onPressed: () async { 
                  await context.read<ProfileInfoCubit>().logout();
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => SignInPage()),
                        (Route<dynamic> route) => false,
                      );
                 },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            );
          }

          if(state is ProfileInfoFailure) {
            return const Text(
              'Please try again'
            );
          }
          return Container();
        }, 
      ),
      ),
    );
  }
}