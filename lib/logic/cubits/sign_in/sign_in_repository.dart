part of 'sign_in_cubit.dart';

typedef void OnLogin(AuthModel authDto);
typedef void OnNewUser(String phone, String token);

typedef void OnError(Exception error);

class SignInRepository {
  SignInRepository({
    required this.onLogin,
    required this.onWrongCode,
    required this.onOtherError,
  });

  final OnLogin onLogin;

  final VoidCallback onWrongCode;
  final OnError onOtherError;
  final api = PhoneVerification();
  ChatService chatService = getIt.get<ChatService>();

  String phone = '';

  Future<Either<Exception, bool>> requestCode(String phone) async {
    this.phone = phone;
    return await api.requestCode(phone);
  }

  Future<Either<Exception, AuthModel>> sendCode(String code) async {
    return await api.requestToken(phone, code);
  }
}
