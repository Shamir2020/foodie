import 'package:flutter/material.dart';

const colorBlack = Colors.black;
const colorWhite = Colors.white;

TextStyle TextHead1(color){
  return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: color,
      height: 1.5

  );
}

TextStyle TextHead4(color){
  return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: color,
      height: 1.2

  );
}

TextStyle TextHead5(color){
  return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: color,
      height: 1.5

  );
}

TextStyle NormalText(color){
  return TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: color,
    height: 1.5,
  );
}

TextStyle ButtonText(color){
  return TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: color,
  );
}

TextStyle SmallText(color){
  return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: color,
      fontSize: 12,
      height: 1.5
  );
}