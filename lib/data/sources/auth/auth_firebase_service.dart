import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socrates/core/configs/constants/app_urls.dart';
import 'package:socrates/data/models/auth/create_user_req.dart';
import 'package:socrates/data/models/auth/sign_in_user_req.dart';
import 'package:socrates/data/models/auth/user.dart';
import 'package:socrates/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SigninUserReq signinUserReq);
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> getUser();

  Future<void> signOut();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );
      return const Right('Success');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user is found with that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password is provided with that user';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );
      // gu jasto I forgot that this will create a random document name instead of
      // the user id fuuuuuuu this wasted about 1 week of debugging my whole life dammit
      // FirebaseFirestore.instance.collection('Users').add({
      //   // 'name' : data.user!.displayName,
      //   'name': createUserReq.fullName,
      //   'email': data.user!.email,
      // });

      //this is old schema design for now
      // FirebaseFirestore.instance.collection('Users').doc(data.user?.uid)
      // .set(
      //   {
      //     'name' : createUserReq.fullName,
      //     'email' : data.user?.email,
      //     'uid' : data.user?.uid,
      //   }
      // );
      FirebaseFirestore.instance.collection('Enumerators').doc(data.user?.uid)
      .set(
        {
          'name' : createUserReq.fullName,
          'email' : data.user?.email,
          'uid' : data.user?.uid,
          'active' : true,      // this is for the user to be active or not
          'assignable' : true,  // by default the user is assignable to any supervisor for now
          'createdAt' : FieldValue.serverTimestamp(),
        }
      );
    

      return const Right('Success');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      return Left(message);
    }
  }

  @override
  Future < Either > getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = await firebaseFirestore.collection('Enumerators').doc(
        firebaseAuth.currentUser?.uid
      ).get();

      UserModel userModel = UserModel.fromJson(user.data() !);
      userModel.imageURL = firebaseAuth.currentUser?.photoURL ?? AppURLs.defaultImage;
      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return const Left('An error occurred');
    }
  }

    @override
  Future<void> signOut() async { // Sign out method
    await FirebaseAuth.instance.signOut();
  }
}
