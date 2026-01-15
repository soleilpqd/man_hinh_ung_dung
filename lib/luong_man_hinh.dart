/*
MIT License

Copyright © 2025 Phạm Quang Dương

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:man_hinh_ung_dung/man_hinh_ung_dung.dart';

/// Dữ liệu truyền vào khi cập nhật trạng thái widget của màn hình
typedef ThamSoDieuKhienWidgetManHinh = Map<String, dynamic>;

/// Mục trong luồng màn hình
class MucTrongLuongManHinh {

  ValueKey<int> key;
  final DieuKhienManHinh manHinh;

  MucTrongLuongManHinh({required this.key, required this.manHinh});

  /// Tạo Widget container chứa
  Container taoContainer(BuildContext context, Map<String, dynamic>? thamSo) => Container(
    key: key,
    color: manHinh.mauNenWidgetChua ?? Colors.white.withAlpha(0),
    child: manHinh.xayDungGiaoDienNguoiDung(context, thamSo)
  );

}

class ThamSoDieuKhienWidgetLuongManHinh {

  /// Tham số gán cho widget từ các hàm như `themManHinh`, `loaiManHinh`...
  final ThamSoDieuKhienWidgetManHinh? thamSoDieuKhienThayDoiManHinh;
  /// Màn hình chuyển thành màn hình chính.
  final MucTrongLuongManHinh? manHinhMoi;
  /// Màn hình hiện tại thôi làm màn hình chính.
  final MucTrongLuongManHinh? manHinhCu;
  /// Danh sách toàn bộ các màn hình (cùng với key định danh).
  final List<MucTrongLuongManHinh> danhSachManHinh;
  /// Bắt buộc gọi hàm này sau khi đã hoàn tất cập nhật.
  void Function() hoatTatThayDoi;

  ThamSoDieuKhienWidgetLuongManHinh({
    required this.hoatTatThayDoi,
    required this.danhSachManHinh,
    this.manHinhMoi,
    this.manHinhCu,
    this.thamSoDieuKhienThayDoiManHinh
  });

}

/// Luồng màn hình
/// Widget cho luồng màn hình cần là StatefuleWidget để cập nhật lại UI.
/// State của widget cho luồng màn hình cần triển khai `TrangThaiWidgetManHinh`,
/// trong đó `duLieuDinhKem` đầu vào của hàm `capNhatGiaoDienCuaManHinh` chứa các key `KeyThamSoDieuKhienWidget*`,
/// cần chú ý chạy hàm từ key `KeyThamSoDieuKhienWidgetKhiHoanTatCapNhat` sau khi đã cập nhật lại xong.
class LuongManHinh extends DieuKhienManHinh {

  static const kKeyThamSoDieuKhienWidgetLuongMH = "_luong";

  final List<MucTrongLuongManHinh> _danhSachManHinh = [];
  MucTrongLuongManHinh? _manHinhHienTai;

  bool _dangCapNhat = false;
  final List<void Function()> _hangDoiCapNhat = [];

  bool _kiemTraDangCapNhat() {
    if (_dangCapNhat) {
      return true;
    }
    for (final muc in _danhSachManHinh) {
      if (muc.manHinh is LuongManHinh) {
        final LuongManHinh luongCon = muc.manHinh as LuongManHinh;
        if (luongCon._kiemTraDangCapNhat()) {
          return true;
        }
      }
    }
    return false;
  }

  void _luongConDaCapNhatXong(LuongManHinh luongCon) {
    if (_hangDoiCapNhat.isNotEmpty) {
      _dayHangDoiCapNhat();
    } else {
      luongManHinh?._luongConDaCapNhatXong(luongCon);
    }
  }

  // Các APIs để khởi tạo widget cho luồng màn hình
  List<MucTrongLuongManHinh> get dsManHinhThuocLuong => _danhSachManHinh.toList();
  MucTrongLuongManHinh? get manHinhHienTaiCuaLuong => _manHinhHienTai;

  /// Màn hình hiện tại
  DieuKhienManHinh? get manHinhHienTai => _manHinhHienTai?.manHinh;

  /// Kiểm thử widget
  List<DateTime> _kiemThuWidget = [];

  /// Gán màn hình hiện tại
  /// - [thamSo]: tham số điều khiển widget của luồng màn hình hiện tại
  /// - [khiHoanThanh]: hành động khi thay đổi xong màn hình
  void ganManHinhHienTai({required int stt, ThamSoDieuKhienWidgetManHinh? thamSo, void Function()? khiHoanThanh}) {
    MucTrongLuongManHinh? mhht = _manHinhHienTai;
    if (stt >= 0 && stt < _danhSachManHinh.length) {
      mhht = _danhSachManHinh[stt];
    }
    _capNhatLaiGiaoDien(mhht, null, thamSo, khiHoanThanh);
  }

  /// Tìm số thứ tự của màn hình trong luồng màn hình
  int? timSoThuTuManHinhTrongLuong(DieuKhienManHinh manHinh) {
    int sttHienTai = 0;
    for (final muc in _danhSachManHinh) {
      if (muc.manHinh == manHinh) {
        return sttHienTai;
      }
      sttHienTai += 1;
    }
    return null;
  }

  /// Danh sách các màn hình trong luồng
  List<DieuKhienManHinh> get danhSachManHinh => _danhSachManHinh.map((phanTu) => phanTu.manHinh).toList();

  /// Tìm kiếm đệ quy màn hình hiện tại cuối cùng (luồng cha -> luồng con ... -> màn hình hiện tại).
  /// Nếu không có màn hình con thì trả lại chính màn hình luồng hiện tại.
  DieuKhienManHinh? timKiemManHinhHienTaiCuoiCung() {
    if (_manHinhHienTai?.manHinh is LuongManHinh) {
      return (_manHinhHienTai?.manHinh as LuongManHinh).timKiemManHinhHienTaiCuoiCung();
    }
    return _manHinhHienTai?.manHinh ?? this;
  }

  /// Gán lại toàn bộ danh sách màn hình
  /// - [thuTuManHinhHienTaiMoi]: số thứ tự màn hình sẽ được hiển thị, mặc định là màn hình cuối danh sách
  /// - [thamSo]: tham số điều khiển widget của luồng màn hình hiện tại
  /// - [khiHoanThanh]: hành động khi thay đổi xong màn hình
  void ganDanhSachManHinh({required List<DieuKhienManHinh> danhSachMoi, int? thuTuManHinhHienTaiMoi, ThamSoDieuKhienWidgetManHinh? thamSo, void Function()? khiHoanThanh}) {
    List<MucTrongLuongManHinh> dsMoi = [];
    for (final DieuKhienManHinh manHinhMoi in danhSachMoi) {
      MucTrongLuongManHinh muc;
      try {
        muc = _danhSachManHinh.firstWhere((phanTu) => phanTu.manHinh == manHinhMoi);
      } catch (_) {
        muc = MucTrongLuongManHinh(key: const ValueKey(0), manHinh: manHinhMoi);
      }
      dsMoi.add(muc);
    }
    List<MucTrongLuongManHinh> dsMhBiLoai = [];
    for (final muc in _danhSachManHinh) {
      if (!dsMoi.contains(muc)) {
        dsMhBiLoai.add(muc);
      }
    }
    _danhSachManHinh.clear();
    _danhSachManHinh.addAll(dsMoi);
    _kiemTraDSManHinh();
    int stt = thuTuManHinhHienTaiMoi ?? danhSachMoi.length - 1;
    MucTrongLuongManHinh? mucHtMoi = _manHinhHienTai;
    if (stt >= 0 && stt < _danhSachManHinh.length) {
      mucHtMoi = _danhSachManHinh[stt];
    }
    _capNhatLaiGiaoDien(mucHtMoi, dsMhBiLoai, thamSo, khiHoanThanh);
  }

  /// Tạo mã (key)
  int _taoMaManHinh() {
    int ma = 1;
    bool daCo = true;
    while (daCo) {
      try {
        final _ = _danhSachManHinh.firstWhere((phanTu) => phanTu.key.value == ma);
        ma += 1;
      } catch (_) {
        daCo = false;
      }
    }
    return ma;
  }

  /// Gán key và luồng màn hình cho các màn hình con
  void _kiemTraDSManHinh() {
    for (final muc in _danhSachManHinh) {
      if (muc.key.value == 0) {
        muc.key = ValueKey(_taoMaManHinh());
      }
      if (muc.manHinh.luongManHinh != null && muc.manHinh.luongManHinh != this) {
        throw Exception("${tuMieuTa()}: không tự gán luồng màn hình vào `luongManHinh` hoặc sử dụng chung DieuKhienManHinh trong nhiều luồng màn hình");
      }
      if (muc.manHinh.luongManHinh == null) {
        muc.manHinh.luongManHinh = this;
        muc.manHinh.manHinhDuocThemVaoLuong();
      }
    }
  }

  /// Kiểm tra màn hình cuối thay đổi thì cập nhật lại giao diện
  void _capNhatLaiGiaoDien(
    MucTrongLuongManHinh? manHinhHienTaiMoi,
    List<MucTrongLuongManHinh>? cacManHinhBiLoaiBo,
    ThamSoDieuKhienWidgetManHinh? thamSo,
    void Function()? khiHoanThanh
  ) {
    if (manHinhHienTaiMoi != _manHinhHienTai) {
      _napLai(_manHinhHienTai, manHinhHienTaiMoi, cacManHinhBiLoaiBo, thamSo, khiHoanThanh);
    } else if (cacManHinhBiLoaiBo != null && cacManHinhBiLoaiBo.isNotEmpty) {
      _hoanTatLoaiBoManHinh(cacManHinhBiLoaiBo);
    }
  }

  /// Hoàn tất loại bỏ màn hình
  void _hoanTatLoaiBoManHinh(List<MucTrongLuongManHinh> cacManHinhBiLoaiBo) {
    for (final muc in cacManHinhBiLoaiBo) {
      muc.manHinh.luongManHinh = null;
      muc.manHinh.manHinhBiLoaiBoKhoiLuong();
    }
  }

  void _napLai(
    MucTrongLuongManHinh? manHinhCu,
    MucTrongLuongManHinh? manHinhMoi,
    List<MucTrongLuongManHinh>? cacManHinhBiLoaiBo,
    ThamSoDieuKhienWidgetManHinh? thamSo,
    void Function()? khiHoanThanh
  ) {
    _hangDoiCapNhat.add(() {
      _thucHienNapLai(manHinhCu, manHinhMoi, cacManHinhBiLoaiBo, thamSo, khiHoanThanh);
    });
    _dayHangDoiCapNhat();
  }

  void _dayHangDoiCapNhat() {
    if (_hangDoiCapNhat.isEmpty) {
      return;
    }
    if (!_kiemTraDangCapNhat()) {
      final hanhDong = _hangDoiCapNhat.removeAt(0);
      hanhDong.call();
    }
  }

  void _thucHienNapLai(
    MucTrongLuongManHinh? manHinhCu,
    MucTrongLuongManHinh? manHinhMoi,
    List<MucTrongLuongManHinh>? cacManHinhBiLoaiBo,
    ThamSoDieuKhienWidgetManHinh? thamSo,
    void Function()? khiHoanThanh
  ) {
    _dangCapNhat = true;
    // print("NAP LAI ${manHinhCu?.manHinh.tuMieuTa()} => ${manHinhMoi?.manHinh.tuMieuTa()}; $trangThai");
    manHinhCu?.manHinh.manHinhSeThoiLamManHinhChinhTrongLuong();
    manHinhMoi?.manHinh.manHinhSeThanhManHinhChinhTrongLuong();
    _manHinhHienTai = manHinhMoi;

    final DateTime now = DateTime.now();
    _kiemThuWidget.add(now);
    hanhDongKhiXong() {
      _kiemThuWidget.remove(now);
      if (cacManHinhBiLoaiBo != null && cacManHinhBiLoaiBo.isNotEmpty) {
        _hoanTatLoaiBoManHinh(cacManHinhBiLoaiBo);
      }
      manHinhCu?.manHinh.manHinhDaThoiLamManHinhChinhTrongLuong();
      manHinhMoi?.manHinh.manHinhDaThanhManHinhChinhTrongLuong();
      khiHoanThanh?.call();
      _dangCapNhat = false;
      luongManHinh?._luongConDaCapNhatXong(this);
    }

    final ThamSoDieuKhienWidgetLuongManHinh thamSoDK = ThamSoDieuKhienWidgetLuongManHinh(
      hoatTatThayDoi: hanhDongKhiXong,
      danhSachManHinh: _danhSachManHinh.toList(),
      manHinhMoi: manHinhMoi,
      manHinhCu: manHinhCu,
      thamSoDieuKhienThayDoiManHinh: thamSo
    );
    if (trangThaiWidgetManHinh != null) {
      trangThaiWidgetManHinh!.capNhatGiaoDienCuaManHinh(dieuKhienManHinh: this, duLieuDinhKem: {kKeyThamSoDieuKhienWidgetLuongMH: thamSoDK});
      final String mieuTa = "Trạng thái Widget $trangThaiWidgetManHinh của luồng màn hình ${tuMieuTa()} cần gọi hàm theo key `KeyThamSoDieuKhienWidgetKhiHoanTatCapNhat` khi cập nhật màn hình xong (giới hạn 1s)";
      Future.delayed(const Duration(seconds: 1)).then((value) {
        if (_kiemThuWidget.contains(now)) {
          throw Exception(mieuTa);
        }
      });
    } else {
      hanhDongKhiXong();
    }
  }

  /// Thêm màn hình vào luồng
  /// - [hienThiLuon]: `true` để hiển thị luôn màn hình mới, `false` thì ko thay đổi màn hình hiện tại
  /// - [thamSo]: tham số điều khiển widget của luồng màn hình hiện tại
  /// - [khiHoanThanh]: hành động khi thay đổi xong màn hình
  void themManHinh({required DieuKhienManHinh manHinh, bool hienThiLuon = true, ThamSoDieuKhienWidgetManHinh? thamSo, void Function()? khiHoanThanh}) {
    bool daCo = false;
    try {
      final MucTrongLuongManHinh _ = _danhSachManHinh.firstWhere((phanTu) => phanTu.manHinh == manHinh);
      daCo = true;
    } catch (_) {
      daCo = false;
    }
    if (daCo) {
      throw Exception("Không thể thêm màn hình ${manHinh.tuMieuTa()} đã có trong luồng ${tuMieuTa()}");
    }
    _danhSachManHinh.add(MucTrongLuongManHinh(key: const ValueKey(0), manHinh: manHinh));
    _kiemTraDSManHinh();
    if (hienThiLuon) {
      _capNhatLaiGiaoDien(_danhSachManHinh.last, null, thamSo, khiHoanThanh);
    } else {
      _capNhatLaiGiaoDien(_manHinhHienTai, null, thamSo, khiHoanThanh);
    }
  }

  /// Loại màn hình khỏi luồng
  /// Nếu [manHinh] không được chỉ định thì loại màn hình cuối
  /// Nếu màn hình bị loại là màn hình hiện tại thì gán màn hình hiện tại theo [sttHienTaiMoi].
  /// Nếu [sttHienTaiMoi] không được chỉ định thì gán màn hình tiếp theo hay liền trước.
  /// - [thamSo]: tham số điều khiển widget của luồng màn hình hiện tại
  /// - [khiHoanThanh]: hành động khi thay đổi xong màn hình
  void loaiManHinh({DieuKhienManHinh? manHinh, int? sttHienTaiMoi, ThamSoDieuKhienWidgetManHinh? thamSo, void Function()? khiHoanThanh}) {
    int? stt;
    if (manHinh != null) {
      stt = timSoThuTuManHinhTrongLuong(manHinh);
      if (stt == null) {
        throw Exception("Không tìm thấy màn hình ${manHinh.tuMieuTa()} trong luồng ${tuMieuTa()}");
      }
    }
    loaiManHinhTaiThuTu(soThuTu: stt, sttHienTaiMoi: sttHienTaiMoi, thamSo: thamSo, khiHoanThanh: khiHoanThanh);
  }

  /// Loại màn hình khỏi luồng
  /// Nếu [soThuTu] không được chỉ định thì loại màn hình cuối.
  /// Nếu màn hình bị loại là màn hình hiện tại thì gán màn hình hiện tại theo [sttHienTaiMoi].
  /// Nếu [sttHienTaiMoi] không được chỉ định thì gán màn hình tiếp theo hay liền trước.
  /// - [thamSo]: tham số điều khiển widget của luồng màn hình hiện tại
  /// - [khiHoanThanh]: hành động khi thay đổi xong màn hình
  void loaiManHinhTaiThuTu({int? soThuTu, int? sttHienTaiMoi, ThamSoDieuKhienWidgetManHinh? thamSo, void Function()? khiHoanThanh}) {
    int stt = soThuTu ?? _danhSachManHinh.length - 1;
    if (stt < 0) {
      throw Exception("Không loại bỏ được màn hình vì luồng màn hình ${tuMieuTa()} đang rỗng");
    }
    if (stt >= _danhSachManHinh.length) {
      throw Exception("Không loại bỏ được màn hình vì thứ tự màn hình $stt không đúng (luồng ${tuMieuTa()} đang có ${_danhSachManHinh.length} màn hình)");
    }
    MucTrongLuongManHinh mhBiLoai = _danhSachManHinh.removeAt(stt);
    MucTrongLuongManHinh? mhhtMoi = _manHinhHienTai;
    if (mhBiLoai == _manHinhHienTai) {
      int? sttHt = sttHienTaiMoi;
      if (sttHt == null) {
        sttHt = stt;
        if (sttHt >= _danhSachManHinh.length) {
          sttHt = _danhSachManHinh.length - 1;
        }
        if (sttHt < 0) {
          sttHt = null;
        }
      }
      if (sttHt != null) {
        mhhtMoi = _danhSachManHinh[sttHt];
      }
    }

    _capNhatLaiGiaoDien(mhhtMoi, [mhBiLoai], thamSo, khiHoanThanh);
  }

  /// Loại các màn hình đứng sau màn hình chỉ định
  /// Nếu màn hình hiện tại bị loại boả thì gán màn hình hiện tại theo [sttHienTaiMoi].
  /// Nếu [sttHienTaiMoi] không được chỉ định thì gán màn hình cuối.
  /// - [thamSo]: tham số điều khiển widget của luồng màn hình hiện tại
  /// - [khiHoanThanh]: hành động khi thay đổi xong màn hình
  void loaiCacManHinhSauManHinh({required DieuKhienManHinh manHinh, int? sttHienTaiMoi, ThamSoDieuKhienWidgetManHinh? thamSo, void Function()? khiHoanThanh}) {
    int? stt = timSoThuTuManHinhTrongLuong(manHinh);
    if (stt == null) {
      throw Exception("Không tìm thấy màn hình trong luồng");
    }
    loaiCacManHinhSauThuTu(soThuTu: stt, sttHienTaiMoi: sttHienTaiMoi, thamSo: thamSo, khiHoanThanh: khiHoanThanh);
  }

  /// Loại các màn hình đứng sau thứ tự chỉ định
  /// Nếu màn hình hiện tại bị loại boả thì gán màn hình hiện tại theo [sttHienTaiMoi].
  /// Nếu [sttHienTaiMoi] không được chỉ định thì gán màn hình cuối.
  /// - [thamSo]: tham số điều khiển widget của luồng màn hình hiện tại
  /// - [khiHoanThanh]: hành động khi thay đổi xong màn hình
  void loaiCacManHinhSauThuTu({required int soThuTu, int? sttHienTaiMoi, ThamSoDieuKhienWidgetManHinh? thamSo, void Function()? khiHoanThanh}) {
    if (soThuTu < 0) {
      throw Exception("Chỉ số không đúng: $soThuTu");
    }
    List<MucTrongLuongManHinh> dsMhBiLoai = [];
    while (_danhSachManHinh.length > soThuTu + 1) {
      MucTrongLuongManHinh mhBiLoai = _danhSachManHinh.removeLast();
      dsMhBiLoai.add(mhBiLoai);
    }
    MucTrongLuongManHinh? mhht = _manHinhHienTai;
    if ((mhht != null && !_danhSachManHinh.contains(mhht)) || mhht == null) {
      int stt = sttHienTaiMoi ?? _danhSachManHinh.length - 1;
      if (stt >= 0 && stt < _danhSachManHinh.length) {
        mhht = _danhSachManHinh[stt];
      }
    }
    _capNhatLaiGiaoDien(mhht, dsMhBiLoai, thamSo, khiHoanThanh);
  }

  @override
  void manHinhDuocThemVaoLuong() {
    super.manHinhDuocThemVaoLuong();
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhDuocThemVaoLuong(this);
    }
  }

  @override
  void luongManHinhDuocThemVaoLuong(LuongManHinh luong) {
    super.luongManHinhDuocThemVaoLuong(luong);
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhDuocThemVaoLuong(luong);
    }
  }

  @override
  void manHinhBiLoaiBoKhoiLuong() {
    List<MucTrongLuongManHinh> nhanBan = _danhSachManHinh.toList();
    for (final muc in nhanBan) {
      muc.manHinh.luongManHinhBiLoaiKhoiLuong(this);
    }
    // Luồng hiện tại bị loại bỏ => đồng thời loại bỏ các màn hình con của luồng hiện tại
    _kiemThuWidget.clear();
    _danhSachManHinh.clear();
    _manHinhHienTai = null;
    for (final muc in nhanBan) {
      muc.manHinh.luongManHinh = null;
      muc.manHinh.manHinhBiLoaiBoKhoiLuong();
    }
    _capNhatLaiGiaoDien(null, null, null, null);
    super.manHinhBiLoaiBoKhoiLuong();
  }

  @override
  void luongManHinhBiLoaiKhoiLuong(LuongManHinh luong) {
    super.luongManHinhBiLoaiKhoiLuong(luong);
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhBiLoaiKhoiLuong(luong);
    }
  }

  @override
  void manHinhSeThanhManHinhChinhTrongLuong() {
    super.manHinhSeThanhManHinhChinhTrongLuong();
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhSeThanhManHinhChinhTrongLuong(this);
    }
  }

  @override
  void luongManHinhSeThanhManHinhChinhTrongLuong(LuongManHinh luong) {
    super.luongManHinhSeThanhManHinhChinhTrongLuong(luong);
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhSeThanhManHinhChinhTrongLuong(luong);
    }
  }

  @override
  void manHinhDaThanhManHinhChinhTrongLuong() {
    super.manHinhDaThanhManHinhChinhTrongLuong();
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhDaThanhManHinhChinhTrongLuong(this);
    }
  }

  @override
  void luongManHinhDaThanhManHinhChinhTrongLuong(LuongManHinh luong) {
    super.luongManHinhDaThanhManHinhChinhTrongLuong(luong);
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhDaThanhManHinhChinhTrongLuong(luong);
    }
  }

  @override
  void manHinhSeThoiLamManHinhChinhTrongLuong() {
    super.manHinhSeThoiLamManHinhChinhTrongLuong();
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhSeThoiLamManHinhChinhTrongLuong(this);
    }
  }

  @override
  void luongManHinhSeThoiLamManHinhChinhTrongLuong(LuongManHinh luong) {
    super.luongManHinhSeThoiLamManHinhChinhTrongLuong(luong);
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhSeThoiLamManHinhChinhTrongLuong(luong);
    }
  }

  @override
  void manHinhDaThoiLamManHinhChinhTrongLuong() {
    super.manHinhDaThoiLamManHinhChinhTrongLuong();
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhDaThoiLamManHinhChinhTrongLuong(this);
    }
  }

  @override
  void luongManHinhDaThoiLamManHinhChinhTrongLuong(LuongManHinh luong) {
    super.luongManHinhDaThoiLamManHinhChinhTrongLuong(luong);
    for (final muc in _danhSachManHinh) {
      muc.manHinh.luongManHinhDaThoiLamManHinhChinhTrongLuong(luong);
    }
  }

}
