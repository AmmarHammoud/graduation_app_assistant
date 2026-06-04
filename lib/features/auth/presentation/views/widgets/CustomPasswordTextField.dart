import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../../../core/functions/custom_validator.dart';

class CustomPasswordTextField extends StatefulWidget {
  const CustomPasswordTextField({
    super.key,
    required this.name,
    required this.label,
    this.isPasswordConfirm = false,
    this.textInputAction = TextInputAction.next,
    this.autofillHints = const [AutofillHints.password],
  });

  final String name;
  final String label;
  final bool isPasswordConfirm;
  final TextInputAction textInputAction;
  final List<String> autofillHints;

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscure = true;

  void _toggle() => setState(() => _obscure = !_obscure);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: widget.name,
      obscureText: _obscure,
      obscuringCharacter: '•',
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: _toggle,
        ),
      ),
      validator: (value) {
        if (widget.isPasswordConfirm) {
          final pass =
              FormBuilder.of(context)?.instantValue['password'] as String? ??
              '';
          return CustomValidator.confirmPasswordValidator(value, pass);
        } else {
          return CustomValidator.passwordValidator(value);
        }
      },
    );
  }
}
