import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';

class LoginTextField extends StatefulWidget {
  final FormFieldSetter<String?> onSaved;
  final FormFieldValidator<String?> validator;
  final String? hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;

  const LoginTextField({
    required this.onSaved,
    required this.validator,
    this.obscureText = false,
    this.hintText,
    Key? key,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onSaved: widget.onSaved,
      validator: widget.validator,
      cursorColor: SECONDARY_COLOR,
      // true일 경우 텍스트 필드에 입력된 값이 보이지 않도록 설정
      // 비밀번호 텍스트필드를 만들때 유용
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        // 텍스트 필드에 아무것도 입력 안했을때 보여줄 수 있는 힌트 문자
        hintText: widget.hintText,
        // 활성화된 상태의 보더
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: TEXT_FIELD_FILL_COLOR,
          ),
        ),
        // 포커스된 상태의 보더
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: SECONDARY_COLOR,
          ),
        ),
        // 에러 상태의 보더
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ERROR_COLOR,
          ),
        ),
        // 포커스된 상태에서 에러가 났을때 보더
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ERROR_COLOR,
          ),
        ),
      ),
    );
  }
}
