//class yang berisi string message pada aplikasi

class AppMessage{
  //message validasi textForm name
  static const String errorNameEmpty = "Name cannot be empty.";
  static const String errorNameMinLength = "Name must be at least 3 characters long.";
  static const String errorEmailEmpty = "Email cannot be empty.";

  //message validasi textForm password
  static const String errorEmailNotValid = "Please enter a valid email address.";
  static const String errorPasswordEmpty = "Password cannot be empty.";
  static const String errorPasswordMinLength = "Password must be at least 6 characters long.";
  static const String errorPasswordNotContainUppercase = "Password must contain at least one uppercase letter";
  static const String errorPasswordNotContainLowercase = "Password must contain at least one lowercase letter";
  static const String errorPasswordNotContainNumber = "Password must contain at least one number";

  //message default error
  static const String defaultError="An error occurred. Please try again later";

  //message ketika login error
  static const String errorLogin = "Can't log in. Please check your email address and password.";
  //message ketika register error(email sudah digunakan)
  static const String errorEmailAlreadyInUse="The new email address is already in use.";

  //message yang ditampilkan di verify email page
  static const String emailVerificationHasBeenSent = "The verification link has been sent to your email.";
  static const String letsVerifyEmail = "Let's verify your email now to continue!";

  //message ketika tombol resendEmailVerification diklik pada verify email page
  static const String resentEmailVerification = "Email verification sent to your email";

  //message ketika berhasil mengubah nama
  static const String successUpdateProfileName = "Updated name successfully";

  //message ketika berhasil mengubah foto profile
  static const String successUpdateProfilePic = "Updated profile photo successfully";

  //message ketika change password dan current password salah
  static const String errorCurrentPasswordIncorrect = "The current password is incorrect";

  //message ketika change password yang mana current dan new password sama
  static const String errorNewPasswordSameCurrentPassword = "The new password cannot be the same as the current password";

  //message ketika berhasil mengubah password
  static const String successUpdatePassword = "Change password successfully";

  //message ketika belum ada sama sekali chat
  static const String noChatMessage = "Click the + to start a new conversation";

  //message ketika fitur belum ada(coming soon)
  static const String comingSoon = "Coming Soon!";


}