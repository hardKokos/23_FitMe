import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  const CustomForm ({Key? key}) : super(key: key);

  @override
  State<CustomForm> createState() {
    return _CustomFormState();
  }
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            child: Column(
              // Start creating form
            ),
          )
        ],
      ),
    );
  }
}