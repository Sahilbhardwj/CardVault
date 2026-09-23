class BankErrorMapper {
  static String message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
