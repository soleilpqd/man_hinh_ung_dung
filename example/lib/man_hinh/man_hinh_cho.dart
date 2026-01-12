import 'package:flutter/material.dart';
import 'package:man_hinh_ung_dung/man_hinh_ung_dung.dart';
import 'package:man_hinh_ung_dung/widget_luong_man_hinh_xep_lop.dart';

/// Màn hình chờ
class ManHinhCho extends DieuKhienManHinh {

  ManHinhCho() {
    thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoLopTrong] = true;
  }

  @override
  Widget xayDungGiaoDienNguoiDung(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(128),
      child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
    );
  }

}
