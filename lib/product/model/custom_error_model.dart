import 'package:equatable/equatable.dart';

class CustomErrorModel extends Equatable {
  final String code;
  final String message;
  final String plugin;

  const CustomErrorModel({
    this.code = '',
    this.message = '',
    this.plugin = '',
  });

  @override
  List<Object> get props => [code, message, plugin];

  @override
  String toString() => 'CustomErrorModel(code: $code, message: $message, plugin: $plugin)';
}
