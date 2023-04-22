import 'package:flutter/material.dart';

class CustomDustbin {

  Path getPath(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width*0.0582857,size.height*0.0908113);
    path0.lineTo(size.width*0.9440000,size.height*0.0908113);
    path0.quadraticBezierTo(size.width*0.8797143,size.height*0.7417547,size.width*0.8582857,size.height*0.9587358);
    path0.quadraticBezierTo(size.width*0.8571429,size.height*1.0004717,size.width*0.8011429,size.height*0.9964717);
    path0.lineTo(size.width*0.2011429,size.height*0.9964717);
    path0.quadraticBezierTo(size.width*0.1478000,size.height*1.0023396,size.width*0.1411429,size.height*0.9587358);
    path0.quadraticBezierTo(size.width*0.1204286,size.height*0.7417547,size.width*0.0582857,size.height*0.0908113);
    path0.close();

    Path path1 = Path();
    path1.moveTo(size.width*0.0028571,size.height*0.0905660);
    path1.lineTo(size.width*0.9971429,size.height*0.0905660);
    path1.lineTo(size.width*0.9971429,size.height*0.0566038);
    path1.quadraticBezierTo(size.width*1.0003143,size.height*0.0005660,size.width*0.9142857,0);
    path1.cubicTo(size.width*0.7071429,0,size.width*0.2928571,0,size.width*0.0857143,0);
    path1.quadraticBezierTo(size.width*0.0015143,size.height*0.0004717,size.width*0.0028571,size.height*0.0566038);
    path1.lineTo(size.width*0.0028571,size.height*0.0905660);
    path1.close();

    Path path2 = Path();
    path2.moveTo(0,size.height*0.0433962);
    path2.lineTo(size.width,size.height*0.0433962);
    path2.lineTo(size.width,size.height*0.0622642);
    path2.lineTo(0,size.height*0.0622642);
    path2.lineTo(0,size.height*0.0433962);
    path2.close();

    final combinedPath = Path.combine(PathOperation.xor, path0, path1);
    final finalPath = Path.combine(PathOperation.difference, combinedPath, path2);

    return finalPath;
  }

}
