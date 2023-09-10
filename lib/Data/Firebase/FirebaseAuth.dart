import 'package:chat/Data/Models/User/UserDTO.dart';
import 'package:chat/Domain/Exception/FirebaseAuthException.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthConfig {
  // triển khai của mẫu Singleton
  FirebaseAuthConfig._();
  static FirebaseAuthConfig? _instance;
  static FirebaseAuthConfig getFirebaseAuthConfig() {
    _instance ??= FirebaseAuthConfig._();
    return _instance!;
  }

  // lấy phiên bản xác thực firebase để sử dụng nó trong auth
  var firebase = FirebaseAuth.instance;

  // Tạo tài khoản cho người dùng bằng UserData
  Future<User> createAccount(UserDTO user) async {
    await firebase
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((value) => value.user!.updateDisplayName(user.name))
        .timeout(const Duration(seconds: 15));
    return firebase.currentUser!;
  }

  // đăng nhập người dùng bằng email và mật khẩu
  Future<User> loginAccount(String email, String password) async {
    await firebase.signInWithEmailAndPassword(email: email, password: password);
    return firebase.currentUser!;
  }

  // đăng nhập người dùng bằng tài khoản google
  Future<User> signInWithGoogle() async {
    await GoogleSignIn().signOut();
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final user = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await firebase.signInWithCredential(user);
    return firebase.currentUser!;
  }

  // chức năng đăng xuất người dùng
  Future<void> signOut() async {
    await firebase.signOut();
  }

  Future<void> deleteUser() async {
    await firebase.currentUser!.delete();
  }

  // chức năng gửi email đặt lại mật khẩu
  Future<void> resetPasswordEmail(String email) async {
    await firebase.sendPasswordResetEmail(email: email);
  }
}
