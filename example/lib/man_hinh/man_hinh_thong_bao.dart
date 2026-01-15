import 'package:flutter/material.dart';
import 'package:man_hinh_ung_dung/man_hinh_ung_dung.dart';
import 'package:man_hinh_ung_dung/widget_luong_man_hinh_xep_lop.dart';
import 'package:man_hinh_ung_dung/xay_dung_widget_hoat_hinh.dart';

class DieuKhienManHinhThongBao extends DieuKhienManHinh {

  final String noiDung;
  final void Function()? hanhDong;

  DieuKhienManHinhThongBao({required this.noiDung, this.hanhDong}) {
    mauNenWidgetChua = Colors.black.withAlpha(128);
    thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoLopTrong] = true;
    thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoHoatHinh] = xayDungLopDoMo;
  }

  @override
  Widget xayDungGiaoDienNguoiDung(BuildContext context, Map<String, dynamic>? thamSo) {
    AnimationController? dkHoatHinh;
    final temp = thamSo?[WidgetLuongManHinhXepLop.kKeyDieuKhienHoatHoa];
    if (temp is AnimationController) {
      dkHoatHinh = temp;
    }
    return _ManHinhThongBao(dieuKhienManHinh: this, dkChuyenDong: dkHoatHinh);
  }

  void _khiNhanOK() {
    luongManHinh?.loaiManHinh(manHinh: this, khiHoanThanh: hanhDong);
  }

}

class _ManHinhThongBao extends StatelessWidget { // WidgetCuaDieuKhienManHinh<DieuKhienManHinhThongBao> {

  final DieuKhienManHinhThongBao dieuKhienManHinh;
  final AnimationController? dkChuyenDong;

  const _ManHinhThongBao({required this.dieuKhienManHinh, required this.dkChuyenDong});

  @override
  Widget build(BuildContext context) {
    final viewChinh = Center(
      child: SizedBox(
        width: 300,
        height: 200,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Text(dieuKhienManHinh.noiDung, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium),
              const Spacer(),
              TextButton(onPressed: dieuKhienManHinh._khiNhanOK, child: const Text("OK"))
          ]),
        ),
      )
    );
    if (dkChuyenDong != null) {
      return xayDungLopThuPhong(context, viewChinh, dkChuyenDong!);
    }
    return viewChinh;
  }

}
