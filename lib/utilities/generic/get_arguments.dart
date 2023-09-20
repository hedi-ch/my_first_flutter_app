import 'package:flutter/material.dart';

extension GetArguments on BuildContext{
  T? getArguments<T>(){
    final modal = ModalRoute.of(this);
    if(modal != null){
      final args = modal.settings.arguments;
      if(args!= null && args is T){
        return args as T;
      }
    }
    else {
      return null;
    }
    return null;
  }
}