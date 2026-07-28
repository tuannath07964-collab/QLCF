package dao;

import util.DBConnect;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.List;

public class HomepageDAO {

    private static final DateTimeFormatter DATE_TIME_FORMAT =
            DateTimeFormatter.ofPattern(
                    "dd/MM/yyyy HH:mm"
            );

    private static final DateTimeFormatter TIME_FORMAT =
            DateTimeFormatter.ofPattern(
                    "HH:mm"
            );

    public TongQuan getTongQuan() {

        String sql = """
            SELECT
                (
                    SELECT COUNT(*)
                    FROM BanAn
                ) AS TongBan,

                (
                    SELECT COUNT(*)
                    FROM BanAn
                    WHERE TrangThai = 0
                ) AS BanTrong,

                (
                    SELECT COUNT(*)
                    FROM BanAn
                    WHERE TrangThai = 1
                ) AS BanDangPhucVu,

                (
                    SELECT COUNT(*)
                    FROM BanAn
                    WHERE ISNULL(
                        TrangThai,
                        -1
                    ) NOT IN (0, 1)
                ) AS BanCanXuLy,

                (
                    SELECT COUNT(*)
                    FROM HoaDon
                    WHERE TrangThai =
                        N'Đang phục vụ'
                ) AS DonDangXuLy,

                (
                    SELECT COUNT(*)
                    FROM Kho
                    WHERE SoLuong <= 10
                ) AS NguyenLieuCanXuLy,

                (
                    SELECT COUNT(*)
                    FROM NhanVien

                    WHERE TrangThai =
                        N'Đang làm'

                      AND (
                          ChucVu =
                              N'Quản lý'

                          OR (
                              (
                                  CaSang = 1
                                  OR CaChieu = 1
                                  OR CaToi = 1
                              )

                              AND GioBatDau
                                  IS NOT NULL

                              AND GioKetThuc
                                  IS NOT NULL

                              AND (
                                  (
                                      GioKetThuc
                                          > GioBatDau

                                      AND CAST(
                                          GETDATE()
                                          AS TIME
                                      ) BETWEEN
                                          GioBatDau
                                          AND GioKetThuc
                                  )

                                  OR (
                                      GioKetThuc
                                          < GioBatDau

                                      AND (
                                          CAST(
                                              GETDATE()
                                              AS TIME
                                          ) >= GioBatDau

                                          OR CAST(
                                              GETDATE()
                                              AS TIME
                                          ) <= GioKetThuc
                                      )
                                  )
                              )
                          )
                      )
                ) AS NhanVienTrongCa
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery()
        ) {
            TongQuan data =
                    new TongQuan();

            if (rs.next()) {

                data.tongBan =
                        rs.getInt(
                                "TongBan"
                        );

                data.banTrong =
                        rs.getInt(
                                "BanTrong"
                        );

                data.banDangPhucVu =
                        rs.getInt(
                                "BanDangPhucVu"
                        );

                data.banCanXuLy =
                        rs.getInt(
                                "BanCanXuLy"
                        );

                data.donDangXuLy =
                        rs.getInt(
                                "DonDangXuLy"
                        );

                data.nguyenLieuCanXuLy =
                        rs.getInt(
                                "NguyenLieuCanXuLy"
                        );

                data.nhanVienTrongCa =
                        rs.getInt(
                                "NhanVienTrongCa"
                        );
            }

            return data;

        } catch (SQLException e) {

            throw new IllegalStateException(
                    "Không tải được tổng quan vận hành.",
                    e
            );
        }
    }

    public List<BanMini> getDanhSachBan() {

        List<BanMini> list =
                new ArrayList<>();

        String sql = """
            SELECT
                b.MaBan,
                b.TenBan,
                b.SoCho,
                b.KhuVuc,
                b.TrangThai,
                b.MaDonHang,
                hd.MaHD

            FROM BanAn b

            OUTER APPLY (
                SELECT TOP 1
                    h.MaHD

                FROM HoaDon h

                WHERE h.MaBan =
                    b.MaBan

                  AND h.TrangThai =
                    N'Đang phục vụ'

                  AND (
                      h.HinhThuc =
                          N'Tại bàn'

                      OR h.HinhThuc
                          IS NULL
                  )

                ORDER BY
                    h.MaHD DESC
            ) hd

            ORDER BY
                b.MaBan
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery()
        ) {
            while (rs.next()) {

                BanMini ban =
                        new BanMini();

                ban.maBan =
                        rs.getInt(
                                "MaBan"
                        );

                ban.tenBan =
                        rs.getString(
                                "TenBan"
                        );

                ban.soCho =
                        rs.getInt(
                                "SoCho"
                        );

                ban.khuVuc =
                        rs.getString(
                                "KhuVuc"
                        );

                ban.trangThai =
                        rs.getInt(
                                "TrangThai"
                        );

                ban.maDonHang =
                        rs.getString(
                                "MaDonHang"
                        );

                ban.maHD =
                        getNullableInteger(
                                rs,
                                "MaHD"
                        );

                list.add(ban);
            }

        } catch (SQLException e) {

            throw new IllegalStateException(
                    "Không tải được sơ đồ bàn trên trang chủ.",
                    e
            );
        }

        return list;
    }

    public List<DonDangXuLy>
            getDonDangXuLy() {

        List<DonDangXuLy> list =
                new ArrayList<>();

        String sql = """
            SELECT TOP 6
                h.MaHD,
                h.MaBan,
                h.MaNV,
                h.HinhThuc,
                h.NgayTao,
                h.TongTien,

                COALESCE(
                    NULLIF(
                        LTRIM(
                            RTRIM(
                                h.TenKhachHang
                            )
                        ),
                        N''
                    ),

                    kh.HoTen,
                    N'Khách lẻ'
                ) AS TenKhachHang

            FROM HoaDon h

            LEFT JOIN KhachHang kh
                ON kh.MaKH = h.MaKH

            WHERE h.TrangThai =
                N'Đang phục vụ'

            ORDER BY
                h.NgayTao DESC,
                h.MaHD DESC
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery()
        ) {
            while (rs.next()) {

                DonDangXuLy don =
                        new DonDangXuLy();

                don.maHD =
                        rs.getInt(
                                "MaHD"
                        );

                don.maBan =
                        getNullableInteger(
                                rs,
                                "MaBan"
                        );

                don.maNV =
                        rs.getString(
                                "MaNV"
                        );

                don.hinhThuc =
                        rs.getString(
                                "HinhThuc"
                        );

                don.tenKhachHang =
                        rs.getString(
                                "TenKhachHang"
                        );

                don.tongTien =
                        getMoney(
                                rs,
                                "TongTien"
                        );

                Timestamp ngayTao =
                        rs.getTimestamp(
                                "NgayTao"
                        );

                don.ngayTao =
                        ngayTao == null
                        ? ""
                        : ngayTao
                            .toLocalDateTime()
                            .format(
                                DATE_TIME_FORMAT
                            );

                list.add(don);
            }

        } catch (SQLException e) {

            throw new IllegalStateException(
                    "Không tải được các đơn đang xử lý.",
                    e
            );
        }

        return list;
    }

    public List<CanhBaoKho>
            getCanhBaoKho() {

        List<CanhBaoKho> list =
                new ArrayList<>();

        String sql = """
            SELECT TOP 6
                MaNL,
                TenNL,
                SoLuong,
                DonVi

            FROM Kho

            WHERE SoLuong <= 10

            ORDER BY
                SoLuong ASC,
                MaNL
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery()
        ) {
            while (rs.next()) {

                CanhBaoKho item =
                        new CanhBaoKho();

                item.maNL =
                        rs.getString(
                                "MaNL"
                        );

                item.tenNL =
                        rs.getString(
                                "TenNL"
                        );

                item.soLuong =
                        getMoney(
                                rs,
                                "SoLuong"
                        );

                item.donVi =
                        rs.getString(
                                "DonVi"
                        );

                list.add(item);
            }

        } catch (SQLException e) {

            throw new IllegalStateException(
                    "Không tải được cảnh báo kho.",
                    e
            );
        }

        return list;
    }

    public CaLamHienTai getCaLamHienTai(
            String maNV
    ) {
        CaLamHienTai caLam =
                new CaLamHienTai();

        if (
            maNV == null
            || maNV.isBlank()
        ) {
            return caLam;
        }

        String sql = """
            SELECT
                MaNV,
                HoTen,
                ChucVu,
                TrangThai,
                CaSang,
                CaChieu,
                CaToi,
                GioBatDau,
                GioKetThuc

            FROM NhanVien

            WHERE MaNV = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    maNV.trim()
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (!rs.next()) {
                    return caLam;
                }

                caLam.maNV =
                        rs.getString(
                                "MaNV"
                        );

                caLam.hoTen =
                        rs.getString(
                                "HoTen"
                        );

                caLam.chucVu =
                        rs.getString(
                                "ChucVu"
                        );

                caLam.trangThai =
                        rs.getString(
                                "TrangThai"
                        );

                caLam.caSang =
                        rs.getBoolean(
                                "CaSang"
                        );

                caLam.caChieu =
                        rs.getBoolean(
                                "CaChieu"
                        );

                caLam.caToi =
                        rs.getBoolean(
                                "CaToi"
                        );

                caLam.gioBatDau =
                        toLocalTime(
                                rs.getTime(
                                    "GioBatDau"
                                )
                        );

                caLam.gioKetThuc =
                        toLocalTime(
                                rs.getTime(
                                    "GioKetThuc"
                                )
                        );

                caLam.trongCa =
                        tinhDangTrongCa(
                                caLam
                        );
            }

        } catch (SQLException e) {

            throw new IllegalStateException(
                    "Không tải được thông tin ca làm hiện tại.",
                    e
            );
        }

        return caLam;
    }

    private boolean tinhDangTrongCa(
            CaLamHienTai caLam
    ) {
        if (
            !"Đang làm".equalsIgnoreCase(
                    caLam.trangThai
            )
        ) {
            return false;
        }

        if (caLam.isQuanLy()) {
            return true;
        }

        if (!caLam.isCoCaLam()) {
            return false;
        }

        LocalTime hienTai =
                LocalTime.now();

        LocalTime batDau =
                caLam.gioBatDau;

        LocalTime ketThuc =
                caLam.gioKetThuc;

        if (batDau.equals(ketThuc)) {
            return false;
        }

        if (ketThuc.isAfter(batDau)) {

            return !hienTai.isBefore(
                    batDau
            )
            && !hienTai.isAfter(
                    ketThuc
            );
        }

        return !hienTai.isBefore(
                batDau
        )
        || !hienTai.isAfter(
                ketThuc
        );
    }

    private LocalTime toLocalTime(
            Time value
    ) {
        return value == null
                ? null
                : value.toLocalTime();
    }

    private Integer getNullableInteger(
            ResultSet rs,
            String column
    ) throws SQLException {

        Object value =
                rs.getObject(column);

        return value == null
                ? null
                : ((Number) value)
                    .intValue();
    }

    private BigDecimal getMoney(
            ResultSet rs,
            String column
    ) throws SQLException {

        BigDecimal value =
                rs.getBigDecimal(column);

        return value == null
                ? BigDecimal.ZERO
                : value;
    }

    public static class TongQuan {

        private int tongBan;
        private int banTrong;
        private int banDangPhucVu;
        private int banCanXuLy;
        private int donDangXuLy;
        private int nguyenLieuCanXuLy;
        private int nhanVienTrongCa;

        public int getTongBan() {
            return tongBan;
        }

        public int getBanTrong() {
            return banTrong;
        }

        public int getBanDangPhucVu() {
            return banDangPhucVu;
        }

        public int getBanCanXuLy() {
            return banCanXuLy;
        }

        public int getDonDangXuLy() {
            return donDangXuLy;
        }

        public int getNguyenLieuCanXuLy() {
            return nguyenLieuCanXuLy;
        }

        public int getNhanVienTrongCa() {
            return nhanVienTrongCa;
        }
    }

    public static class BanMini {

        private int maBan;
        private String tenBan;
        private int soCho;
        private String khuVuc;
        private int trangThai;
        private String maDonHang;
        private Integer maHD;

        public int getMaBan() {
            return maBan;
        }

        public String getTenBan() {
            return tenBan;
        }

        public int getSoCho() {
            return soCho;
        }

        public String getKhuVuc() {
            return khuVuc;
        }

        public int getTrangThai() {
            return trangThai;
        }

        public String getMaDonHang() {
            return maDonHang;
        }

        public Integer getMaHD() {
            return maHD;
        }

        public String getTrangThaiText() {

            if (trangThai == 0) {
                return "Trống";
            }

            if (trangThai == 1) {
                return "Đang phục vụ";
            }

            return "Cần cập nhật";
        }

        public String getCssClass() {

            if (trangThai == 0) {
                return "empty";
            }

            if (trangThai == 1) {
                return "serving";
            }

            return "attention";
        }
    }

    public static class DonDangXuLy {

        private int maHD;
        private Integer maBan;
        private String maNV;
        private String hinhThuc;
        private String ngayTao;

        private BigDecimal tongTien =
                BigDecimal.ZERO;

        private String tenKhachHang;

        public int getMaHD() {
            return maHD;
        }

        public String getMaHienThi() {

            return String.format(
                    "HD%06d",
                    maHD
            );
        }

        public Integer getMaBan() {
            return maBan;
        }

        public String getMaNV() {
            return maNV;
        }

        public String getHinhThuc() {
            return hinhThuc;
        }

        public String getNgayTao() {
            return ngayTao;
        }

        public BigDecimal getTongTien() {
            return tongTien;
        }

        public String getTenKhachHang() {
            return tenKhachHang;
        }

        public String getViTriPhucVu() {

            if (
                "Mang về".equalsIgnoreCase(
                        hinhThuc
                )
                || maBan == null
            ) {
                return "Mang về";
            }

            return "Bàn " + maBan;
        }
    }

    public static class CanhBaoKho {

        private String maNL;
        private String tenNL;

        private BigDecimal soLuong =
                BigDecimal.ZERO;

        private String donVi;

        public String getMaNL() {
            return maNL;
        }

        public String getTenNL() {
            return tenNL;
        }

        public BigDecimal getSoLuong() {
            return soLuong;
        }

        public String getDonVi() {
            return donVi;
        }

        public String getMucDo() {

            if (
                soLuong.compareTo(
                        BigDecimal.ZERO
                ) <= 0
            ) {
                return "Hết hàng";
            }

            if (
                soLuong.compareTo(
                    new BigDecimal("5")
                ) <= 0
            ) {
                return "Rất thấp";
            }

            return "Sắp hết";
        }

        public String getCssClass() {

            if (
                soLuong.compareTo(
                        BigDecimal.ZERO
                ) <= 0
            ) {
                return "danger";
            }

            if (
                soLuong.compareTo(
                    new BigDecimal("5")
                ) <= 0
            ) {
                return "critical";
            }

            return "warning";
        }
    }

    public static class CaLamHienTai {

        private String maNV;
        private String hoTen;
        private String chucVu;
        private String trangThai;

        private boolean caSang;
        private boolean caChieu;
        private boolean caToi;

        private LocalTime gioBatDau;
        private LocalTime gioKetThuc;

        private boolean trongCa;

        public String getMaNV() {
            return maNV;
        }

        public String getHoTen() {
            return hoTen;
        }

        public String getChucVu() {
            return chucVu;
        }

        public String getTrangThai() {
            return trangThai;
        }

        public boolean isCaSang() {
            return caSang;
        }

        public boolean isCaChieu() {
            return caChieu;
        }

        public boolean isCaToi() {
            return caToi;
        }

        public boolean isTrongCa() {
            return trongCa;
        }

        public boolean isQuanLy() {

            return "Quản lý"
                    .equalsIgnoreCase(
                            chucVu
                    );
        }

        public boolean isCoCaLam() {

            return (
                caSang
                || caChieu
                || caToi
            )
            && gioBatDau != null
            && gioKetThuc != null;
        }

        public String getTenCa() {

            List<String> tenCa =
                    new ArrayList<>();

            if (caSang) {
                tenCa.add(
                        "Ca sáng"
                );
            }

            if (caChieu) {
                tenCa.add(
                        "Ca chiều"
                );
            }

            if (caToi) {
                tenCa.add(
                        "Ca tối"
                );
            }

            return tenCa.isEmpty()
                    ? "Chưa phân ca"
                    : String.join(
                        ", ",
                        tenCa
                    );
        }

        public String
                getGioBatDauHienThi() {

            return gioBatDau == null
                    ? "--:--"
                    : gioBatDau.format(
                        TIME_FORMAT
                    );
        }

        public String
                getGioKetThucHienThi() {

            return gioKetThuc == null
                    ? "--:--"
                    : gioKetThuc.format(
                        TIME_FORMAT
                    );
        }
    }
}