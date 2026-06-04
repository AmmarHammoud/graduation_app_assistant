import 'package:form_builder_validators/form_builder_validators.dart';

class CustomValidator {
  static String? emailValidator(String? value) {
    // Allow emails without a top-level domain (e.g. owner.khaled@alfanar)
    // while still enforcing a basic local@domain format.
    // The regex below allows letters, digits and common local-part chars,
    // and a domain part that may be a single label (no dot) or include dots.
    final relaxedEmail = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+$');
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.match(relaxedEmail,
          errorText: 'يرجى إدخال بريد إلكتروني صالح'),
    ])(value);
  }

  static String? passwordValidator(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(8),
    ])(value);
  }

  static String? confirmPasswordValidator(
    String? password,
    String? confirmPassword,
  ) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.match(
        RegExp('^${RegExp.escape(password ?? '')}\$'),
        errorText: 'كلمتا المرور غير متطابقتين',
      ),
    ])(confirmPassword);
  }

  static String? nameValidator(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(3),
    ])(value);
  }

  static String? addressValidator(String? value) {
    return FormBuilderValidators.required()(value);
  }

  static String? phoneValidator(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.numeric(),
      FormBuilderValidators.minLength(9),
    ])(value);
  }

  static String? amountValidator(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.numeric(),
      FormBuilderValidators.positiveNumber(),
    ])(value);
  }

  static String? complaintTitleValidator(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: "يرجى ادخال عنوان الشكوى"),
      FormBuilderValidators.minLength(5),
    ])(value);
  }

  static String? complaintDescriptionValidator(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'يرجى إدخال وصف الشكوى'),
      FormBuilderValidators.minLength(20, errorText: 'يُفضّل وصف أكثر تفصيلاً'),
    ])(value);
  }

  static String? complaintLocationValidator(String? value) {
    return FormBuilderValidators.required(
      errorText: 'يرجى تحديد موقع تقريبى للمشكلة',
    )(value);
  }
}
