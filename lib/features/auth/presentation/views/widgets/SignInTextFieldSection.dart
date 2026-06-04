import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../core/functions/custom_validator.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'CustomPasswordTextField.dart';

class SignInTextFieldSection extends StatelessWidget {
  const SignInTextFieldSection({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'بريد الشركة',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          FormBuilderTextField(
            name: "email",
            keyboardType: TextInputType.emailAddress,
            validator: CustomValidator.emailValidator,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(labelText: 'البريدالكتروني'),
          ),
          SizedBox(height: 16),
          Text(
            ' كلمة المرور',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          CustomPasswordTextField(
            name: 'password',
            label: 'كلمة المرور',
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
          ),
        ],
      ),
    );
  }
}
