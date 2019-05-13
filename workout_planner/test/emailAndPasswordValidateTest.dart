import 'package:flutter_test/flutter_test.dart';
import 'package:workout_planner/loginPage.dart';

void main() {

  test('empty email returns error', (){

    var returnString = EmailValidator.validate('');
    expect(returnString, "Email can\'t be empty");

  });

  test('non-empty email returns null', (){

    var returnString = EmailValidator.validate('test@test.com');
    expect(returnString, null);

  });

  test('empty password returns error', (){

    var returnString = PasswordValidator.validate('');
    expect(returnString, "Password can\'t be empty");

  });

  test('non-empty password returns null', (){

    var returnString = PasswordValidator.validate('testpass');
    expect(returnString, null);

  });

}
