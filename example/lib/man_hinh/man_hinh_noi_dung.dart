import 'package:example/Views/thanh_dieu_huong.dart';
import 'package:example/main.dart';
import 'package:example/man_hinh/man_hinh_cho.dart';
import 'package:example/man_hinh/man_hinh_thong_bao.dart';
import 'package:example/models/du_lieu_toan_cuc.dart';
import 'package:flutter/material.dart';
import 'package:man_hinh_ung_dung/luong_man_hinh.dart';
import 'package:man_hinh_ung_dung/man_hinh_ung_dung.dart';
import 'package:man_hinh_ung_dung/muc_danh_sach.dart';
import 'package:man_hinh_ung_dung/widget_luong_man_hinh_truot.dart';
import 'package:man_hinh_ung_dung/widget_luong_man_hinh_xep_lop.dart';

class DieuKhienManHinhNoiDung extends DieuKhienManHinh {

  final int maManHinh;
  final MucDanhSach mucChinh = MucDanhSach(xayDungWidgetChinh: (p0, p1) => []);

  DieuKhienManHinhNoiDung({required this.maManHinh}) {
    final MucDanhSach mucSoLan = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [Text("Số lần: ${muc.duLieuDinhKem as int}")];
    });
    mucSoLan.duLieuDinhKem = 0;

    final MucDanhSach mucDL = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      final List<dynamic> thongTin = muc.duLieuDinhKem as List<dynamic>;
      return [
        Text("Số trạm dữ liệu: ${thongTin[1] as int}"),
        Row(children: [
          const Text("Giá trị dữ liệu: "),
          Checkbox(
            value: thongTin[0] as bool,
            onChanged: thongTin[2] as void Function(bool?)
          )
        ])
      ];
    });
    mucDL.duLieuDinhKem = [false, 0, _khiDLThayDoi];

    final MucDanhSach mucVanBan = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [Text(muc.duLieuDinhKem as String)];
    });
    mucVanBan.duLieuDinhKem = "Nhập văn bản vào ô dưới rồi nhấn OK";

    final MucDanhSach mucONhap = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [TextField(controller: muc.duLieuDinhKem as TextEditingController)];
    });
    mucONhap.duLieuDinhKem = TextEditingController(text: "Thử nghiệm");

    final MucDanhSach mucOK = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [TextButton(onPressed: muc.duLieuDinhKem as void Function(), child: const Text("OK"))];
    });
    mucOK.duLieuDinhKem = khiNhanNutOK;

    final MucDanhSach mucThem = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [TextButton(onPressed: muc.duLieuDinhKem as void Function(), child: const Text("Thêm màn hình"))];
    });
    mucThem.duLieuDinhKem = khiNhanNutThem;

    final MucDanhSach mucAlert = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [TextButton(onPressed: muc.duLieuDinhKem as void Function(), child: const Text("Alert"))];
    });
    mucAlert.duLieuDinhKem = khiNhanNutAlert;

    final MucDanhSach mucMenu = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [
        PopupMenuButton(
          initialValue: "Muc 1",
          itemBuilder: (ctx) {
            List<PopupMenuItem<String>> ketQua = [];
            final data = ["Mục 1", "Mục 2", "Mục 3"];
            for (final dat in data) {
              ketQua.add(
                PopupMenuItem(
                  value: dat,
                  child: Text(dat)
                )
              );
            }
            return ketQua;
          },
          onSelected: muc.duLieuDinhKem as void Function(String),
          child: const Text("Menu")
        )
      ];
    });
    mucMenu.duLieuDinhKem = khiNhanNutMenuThaXuong;

    final MucDanhSach mucKhoaMH = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [TextButton(onPressed: muc.duLieuDinhKem as void Function(), child: const Text("Khoá màn hình"))];
    });
    mucKhoaMH.duLieuDinhKem = khiNhanNutKhoaManHinh;

    final MucDanhSach mucModal = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [TextButton(onPressed: muc.duLieuDinhKem as void Function(), child: const Text("Modal"))];
    });
    mucModal.duLieuDinhKem = khiNhanNutThemLuongModal;

    final MucDanhSach mucTb = MucDanhSach(xayDungWidgetChinh: (context, muc) {
      return [TextButton(onPressed: muc.duLieuDinhKem as void Function(), child: const Text("Thông báo"))];
    });
    mucTb.duLieuDinhKem = _khiNhanThongBao;

    mucChinh.cacMucCon = [
      mucSoLan,
      mucDL,
      mucVanBan,
      mucONhap,
      mucOK,
      mucThem,
      mucAlert,
      mucMenu,
      mucKhoaMH,
      mucTb,
      mucModal
    ];
  }

  @override
  void manHinhDuocThemVaoLuong() {
    super.manHinhDuocThemVaoLuong();
    print("MH NoiDung VAO LUONG $maManHinh");
    if (luongManHinh is LuongManHinhCuaToi && (luongManHinh as LuongManHinhCuaToi).dinhDanh == DinhDanhLuongManHinh.lop) {
      mucChinh.cacMucCon.removeLast();
    }
    DuLieuToanCuc().addListener(_khiDuLieuToanCucThayDoi);
  }

  @override
  void manHinhBiLoaiBoKhoiLuong() {
    super.manHinhBiLoaiBoKhoiLuong();
    print("MH NoiDung RA LUONG $maManHinh");
    DuLieuToanCuc().removeListener(_khiDuLieuToanCucThayDoi);
  }

  @override
  void manHinhSeThanhManHinhChinhTrongLuong() {
    super.manHinhSeThanhManHinhChinhTrongLuong();
    print("MH NoiDung SE HIEN THI $maManHinh");
  }

  @override
  void manHinhDaThanhManHinhChinhTrongLuong() {
    super.manHinhDaThanhManHinhChinhTrongLuong();
    print("MH NoiDung DA HIEN THI $maManHinh");
    mucChinh.cacMucCon[0].duLieuDinhKem += 1;
    trangThaiWidgetManHinh?.capNhaptGiaoDienCuaManHinh(dieuKhienManHinh: this);
  }

  @override
  void luongManHinhDuocThemVaoLuong(LuongManHinh luong) {
    super.luongManHinhDuocThemVaoLuong(luong);
    // Sau khi luồng được thêm vào luồng cha thì `luongManHinhDaThanhManHinhChinhTrongLuong` sẽ được gọi => tăng số đếm.
    // Chỗ này sẽ trừ bớt số lượng các lần hiển thị do thêm các luồng màn hình
    // Chỉ áp dụng với màn hình đầu tiên của luồng 1 (màn hình 1st của màn hình tab)
    if (luongManHinh != null && luongManHinh is LuongManHinhCuaToi) {
      LuongManHinhCuaToi luongToi = luongManHinh! as LuongManHinhCuaToi;
      final stt = luongToi.timSoThuTuManHinhTrongLuong(this);
      if (luongToi.dinhDanh == DinhDanhLuongManHinh.luong1 && stt == 0) {
        mucChinh.cacMucCon[0].duLieuDinhKem -= 1;
      }
    }
  }

  @override
  void luongManHinhDaThanhManHinhChinhTrongLuong(LuongManHinh luong) {
    super.luongManHinhDaThanhManHinhChinhTrongLuong(luong);
    print("MH Luong cha cua $maManHinh da thanh MH chinh ${luong.tuMieuTa()}");
    if (laManHinhChinhTrongLuong() ?? false) {
      mucChinh.cacMucCon[0].duLieuDinhKem += 1;
      trangThaiWidgetManHinh?.capNhaptGiaoDienCuaManHinh(dieuKhienManHinh: this);
    }
  }

  @override
  void manHinhSeThoiLamManHinhChinhTrongLuong() {
    super.manHinhSeThoiLamManHinhChinhTrongLuong();
    print("MH NoiDung SE BI AN $maManHinh");
  }

  @override
  void manHinhDaThoiLamManHinhChinhTrongLuong() {
    super.manHinhDaThoiLamManHinhChinhTrongLuong();
    print("MH NoiDung DA BI AN $maManHinh");
  }

  void khiNhanNutOK() {
    mucChinh.cacMucCon[2].duLieuDinhKem = "Xin chào ${(mucChinh.cacMucCon[3].duLieuDinhKem as TextEditingController).text}";
    trangThaiWidgetManHinh?.capNhaptGiaoDienCuaManHinh(dieuKhienManHinh: this);
  }

  void khiNhanNutThem() {
    final DieuKhienManHinhNoiDung mhMoi = DieuKhienManHinhNoiDung(maManHinh: maManHinh + 1);
    // Xác định luồng để thêm màn hình mới
    if (luongManHinh is LuongManHinhCuaToi) {
      final LuongManHinhCuaToi luongMh = luongManHinh as LuongManHinhCuaToi;
      switch (luongMh.dinhDanh) {
        case DinhDanhLuongManHinh.chinh:
        case DinhDanhLuongManHinh.luong1: // màn hình này đang nằm trong luồng 1
        case DinhDanhLuongManHinh.lop: // màn hình này đang nằm trong luồng modal
          luongMh.themManHinh(
            manHinh: mhMoi,
            thamSo: {WidgetLuongManHinhTruot.kKeyThamSoHoatHoa: maManHinh.isEven}, // Chuyển màn hình với chuyển động màn hình khi mã màn hình lẻ
            khiHoanThanh: () {
              print("Đã hoàn thành chuyển sang màn hình mới từ ${tuMieuTa()}}");
            }
          ); // thêm màn hình mới vào luồng cha
          break;
        case DinhDanhLuongManHinh.tab: // màn hình này nằm trực tiếp trong luồng tab (tab #2)
          final LuongManHinhCuaToi? luongChinh = timKiemLuong((luongChua) {
            if (luongChua is LuongManHinhCuaToi) {
              return luongChua.dinhDanh == DinhDanhLuongManHinh.chinh;
            }
            return false;
          }) as LuongManHinhCuaToi?;
          if (luongChinh != null) {
            luongChinh.themManHinh(manHinh: mhMoi);
          }
          break;
        default:
          break;
      }
    }
  }

  void khiNhanNutAlert() {
    (trangThaiWidgetManHinh as _TrangThaiManHinhNoiDung?)?.hienThiAlert(() {
      print("Đóng hộp thoại thông báo của SDK");
    });
  }

  void khiNhanNutMenuThaXuong(String muc) {
    print("MENU $muc");
  }

  void khiNhanNutKhoaManHinh() {
    final ManHinhCho mhKhoa = ManHinhCho();
    final LuongManHinhCuaToi? luongGoc = timKiemLuong((luongChua) {
      if (luongChua is LuongManHinhCuaToi) {
        return luongChua.dinhDanh == DinhDanhLuongManHinh.goc;
      }
      return false;
    }) as LuongManHinhCuaToi?;
    luongGoc?.themManHinh(manHinh: mhKhoa, thamSo: {WidgetLuongManHinhXepLop.kKeyThamSoChoPhepHoatHinh: false});
    Future.delayed(const Duration(seconds: 5)).then((_) {
      luongGoc?.loaiManHinh(manHinh: mhKhoa, thamSo: {WidgetLuongManHinhXepLop.kKeyThamSoChoPhepHoatHinh: false});
    });
  }

  void khiNhanNutThemLuongModal() {
    final LuongManHinhCuaToi? luongGoc = timKiemLuong((luongChua) {
      if (luongChua is LuongManHinhCuaToi) {
        return luongChua.dinhDanh == DinhDanhLuongManHinh.goc;
      }
      return false;
    }) as LuongManHinhCuaToi?;
    final LuongManHinhCuaToi luongXepLop = LuongManHinhCuaToi(dinhDanh: DinhDanhLuongManHinh.lop);
    luongXepLop.widgetCuaManHinh = WidgetLuongManHinhTruot(dieuKhienManHinh: luongXepLop, phuongHuong: PhuongHuongLuongManHinhTruot.duoiLenTren);
    final DieuKhienManHinhNoiDung mh1 = DieuKhienManHinhNoiDung(maManHinh: 300);
    luongXepLop.themManHinh(manHinh: mh1);
    luongGoc?.themManHinh(manHinh: luongXepLop); //, thamSo: {WidgetLuongManHinhXepLop.kKeyThamSoHoatHinh: WidgetLuongManHinhXepLop.xayDungLopTruotXuong});
  }

  void _khiNhanThongBao() {
    final LuongManHinhCuaToi? luongGoc = timKiemLuong((luongChua) {
      if (luongChua is LuongManHinhCuaToi) {
        return luongChua.dinhDanh == DinhDanhLuongManHinh.goc;
      }
      return false;
    }) as LuongManHinhCuaToi?;
    final DieuKhienManHinhThongBao mhTb = DieuKhienManHinhThongBao(noiDung: "Thông báo tự thân");
    luongGoc?.themManHinh(manHinh: mhTb);
  }

  bool coTheQuayLai() {
    if (luongManHinh is LuongManHinhCuaToi && (luongManHinh as LuongManHinhCuaToi).dinhDanh == DinhDanhLuongManHinh.tab) {
      return false;
    }
    int? viTri  = luongManHinh?.timSoThuTuManHinhTrongLuong(this);
    if (viTri != null && viTri > 0) {
      return true;
    }
    return false;
  }

  bool thuocLuongXepLop() {
    return (luongManHinh is LuongManHinhCuaToi) && (luongManHinh as LuongManHinhCuaToi).dinhDanh == DinhDanhLuongManHinh.lop;
  }

  bool thuocLuongChinh() {
    return (luongManHinh is LuongManHinhCuaToi) && (luongManHinh as LuongManHinhCuaToi).dinhDanh == DinhDanhLuongManHinh.chinh;
  }

  void khiNhanDongLop() {
    final LuongManHinh? luongOng = luongManHinh?.luongManHinh;
    luongOng?.loaiManHinh(manHinh: luongManHinh!);
  }

  void khiNhanQuayLai() {
    luongManHinh?.loaiManHinh(manHinh: this, khiHoanThanh: () {
      print("Đã hoàn thành quay lại từ ${tuMieuTa()}}");
    });
  }

  void _phanChieuDuLieu() {
    final DuLieuToanCuc dlToanCuc = DuLieuToanCuc();
    final MucDanhSach mucDl = mucChinh.cacMucCon[1];
    mucDl.duLieuDinhKem = [dlToanCuc.value, dlToanCuc.soDem, _khiDLThayDoi];
  }

  // Khi dữ liệu thay đổi
  void _khiDuLieuToanCucThayDoi() {
    print("DL TOAN CUC THAY DOI");
    _phanChieuDuLieu();
    trangThaiWidgetManHinh?.capNhaptGiaoDienCuaManHinh(dieuKhienManHinh: this);
  }

  // Khi nhấn checkbox -> thay đổi DL
  void _khiDLThayDoi(bool? giaTri) {
    print("CHECKBOX $giaTri");
    DuLieuToanCuc().value = giaTri ?? false;
  }

  @override
  String tuMieuTa() {
    return "${super.tuMieuTa()}: $maManHinh";
  }

  @override
  Widget xayDungGiaoDienNguoiDung(BuildContext context, Map<String, dynamic>? thamSo) {
    return ManHinhNoiDung(dieuKhienManHinh: this);
  }

}

class ManHinhNoiDung extends WidgetCuaDieuKhienManHinh<DieuKhienManHinhNoiDung> {

  const ManHinhNoiDung({super.key, required super.dieuKhienManHinh});

  @override
  State<StatefulWidget> createState() => _TrangThaiManHinhNoiDung();

}

class _TrangThaiManHinhNoiDung extends TrangThaiWidgetCuaDieuKhien<ManHinhNoiDung> {

  void hienThiAlert(void Function() khiDong) {
    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        title: const Text("Hộp thoại thông báo của SDK"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              khiDong.call();
            },
            child: const Text("Đóng")
          )
        ],
      );
    });
  }

  @override
  void capNhaptGiaoDienCuaManHinh({required DieuKhienManHinh dieuKhienManHinh, Map<String, dynamic>? duLieuDinhKem}) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget? nutTrai;
    Widget? nutPhai;
    if (widget.dieuKhienManHinh.coTheQuayLai()) {
      if (widget.dieuKhienManHinh.thuocLuongChinh()) {
        nutPhai = IconButton(onPressed: widget.dieuKhienManHinh.khiNhanQuayLai, icon: const Icon(Icons.arrow_forward));
      } else if (widget.dieuKhienManHinh.thuocLuongXepLop()) {
        nutTrai = IconButton(onPressed: widget.dieuKhienManHinh.khiNhanQuayLai, icon: const Icon(Icons.arrow_downward));
      } else {
        nutTrai = IconButton(onPressed: widget.dieuKhienManHinh.khiNhanQuayLai, icon: const Icon(Icons.arrow_back));
      }
    }
    if (widget.dieuKhienManHinh.thuocLuongXepLop()) {
      nutPhai = IconButton(onPressed: widget.dieuKhienManHinh.khiNhanDongLop, icon: const Icon(Icons.close));
    }
    return ThanhDieuHuong(
      tieuDe: Text("Nội dung ${widget.dieuKhienManHinh.maManHinh}"),
      nutTrai: nutTrai,
      nutPhai: nutPhai,
      noiDung: Container(
        color: widget.dieuKhienManHinh.thuocLuongXepLop() ? Colors.limeAccent : (widget.dieuKhienManHinh.maManHinh.isOdd ? Colors.lightGreenAccent : Colors.white),
        child: ListView(children: widget.dieuKhienManHinh.mucChinh.xayDungDanhSachWidgets(context))
      )

    );
  }

}