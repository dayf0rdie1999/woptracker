// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  group('WopTracker App', () {

    // Todo: Connecting to the widgets in the SignInUI;
    final _emailTextFormField = find.byValueKey("EmailTextFormField");
    final _passwordTextFormField = find.byValueKey("PasswordTextFormField");
    final _signInButton = find.byValueKey("signIn");
    final _navigateToSignUpUI = find.byValueKey("NavigateSignUpUI");


    // Todo: Connecting to the widgets in SignUpUI;
    final _signUpEmailTextFormField = find.byValueKey("signUpEmailTextField");
    final _signUpPasswordTextFormField = find.byValueKey("signUpPasswordTextField");
    final _signUpConfirmedPasswordTextFormField = find.byValueKey("signUpConfirmedPasswordTextField");
    final _signUpButton = find.byValueKey("SignUpButton");
    final signUpBackButton = find.byTooltip('Back');

    // Todo: Connecting to the widgets in GoogleMapUI;
    final _SignOutButton = find.byValueKey('SignOutButton');


    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });



    group('Sign Up Testing', () {

      test('testing successfully signing up the application', () async {
        await driver.tap(_navigateToSignUpUI);
        await driver.tap(_signUpEmailTextFormField);
        await driver.enterText("paulduonganh@gmail.com");
        await driver.tap(_signUpPasswordTextFormField);
        await driver.enterText("Relive19");
        await driver.tap(_signUpConfirmedPasswordTextFormField);
        await driver.enterText("Relive19");
        await driver.tap(_signUpButton);
        await driver.tap(_SignOutButton);
      });

      test('testing failure signing up from not having the same password', () async {
        await driver.tap(_navigateToSignUpUI);
        await driver.tap(_signUpEmailTextFormField);
        await driver.enterText("paulduonganh@gmail.com");
        await driver.tap(_signUpPasswordTextFormField);
        await driver.enterText("Relive19");
        await driver.tap(_signUpConfirmedPasswordTextFormField);
        await driver.enterText("123456");
        await driver.tap(_signUpButton);
        await driver.waitFor(find.text("Password and Confirmed Password are not the same"));
      });


      test('testing failure signing up from email already exists', () async {
        await driver.tap(_signUpEmailTextFormField);
        await driver.enterText("paulduonganh@gmail.com");
        await driver.tap(_signUpPasswordTextFormField);
        await driver.enterText("Relive19#");
        await driver.tap(_signUpConfirmedPasswordTextFormField);
        await driver.enterText("Relive19#");
        await driver.tap(_signUpButton);
        await driver.waitFor(find.text("The account already exists for that email."));
      });

      test('testing failure signing up from having weak password', () async {
        await driver.tap(_signUpEmailTextFormField);
        await driver.enterText("paulduonganh@gmail.com");
        await driver.tap(_signUpPasswordTextFormField);
        await driver.enterText("asd");
        await driver.tap(_signUpConfirmedPasswordTextFormField);
        await driver.enterText("asd");
        await driver.tap(_signUpButton);
        await driver.waitFor(find.text("The password is weak"));
        await driver.tap(signUpBackButton);
      });
    });

    group("Sign In Testing", () {


      test("Failed To Signed In With Wrong Email", () async {
        await driver.tap(_emailTextFormField);
        await driver.enterText("duongvu0401@gmail.com");
        await driver.tap(_passwordTextFormField);
        await driver.enterText("Relive19");
        await driver.tap(_signInButton);
        await driver.waitFor(find.text("No user found for that email."));
      });

      test("Failed To Signed In With Wrong Password", () async {
        await driver.tap(_emailTextFormField);
        await driver.enterText("paulduonganh@gmail.com");
        await driver.tap(_passwordTextFormField);
        await driver.enterText("asd123");
        await driver.tap(_signInButton);
        await driver.waitFor(find.text("Wrong password provided for that user"));
      });

      test("Successfully Sign In With Email And Password", () async {
        await driver.tap(_emailTextFormField);
        await driver.enterText("paulduonganh@gmail.com");
        await driver.tap(_passwordTextFormField);
        await driver.enterText("Relive19");
        await driver.tap(_signInButton);
        await driver.tap(_SignOutButton);
      });

    });

  });

}