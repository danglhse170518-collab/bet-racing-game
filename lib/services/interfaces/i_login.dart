abstract class ILogin {
  /// Hàm đăng nhập nhận vào username và password, trả về true nếu hợp lệ
  Future<bool> login(String username, String password);
}