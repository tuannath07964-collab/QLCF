package dao;

import model.ChiTietHoaDon;
import model.HoaDon;
import util.DBConnect;

import java.math.BigDecimal;
import java.math.RoundingMode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;

import java.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.List;

public class HoaDonDAO {

    private static final BigDecimal VAT_RATE
            = new BigDecimal("0.08");

    private static final BigDecimal MONEY_PER_POINT
            = new BigDecimal("10000");

    private static final DateTimeFormatter DATE_FORMAT
            = DateTimeFormatter.ofPattern(
                    "dd/MM/yyyy HH:mm"
            );

    public int taoHoaDon(
            String maTaiKhoan
    ) {
        String sql = """
            INSERT INTO HoaDon(
                MaTaiKhoan,
                TrangThai
            )
            VALUES (
                ?,
                N'Chờ thanh toán'
            )
            """;

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(
                        sql,
                        Statement.RETURN_GENERATED_KEYS
                )) {
            ps.setString(
                    1,
                    maTaiKhoan
            );

            ps.executeUpdate();

            try (
                    ResultSet keys
                    = ps.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new IllegalStateException(
                            "Không tạo được mã hóa đơn."
                    );
                }

                return keys.getInt(1);
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tạo được hóa đơn.",
                    e
            );
        }
    }

    public List<HoaDon> getAll() {

        List<HoaDon> list
                = new ArrayList<>();

        String sql = """
            SELECT h.MaHD,
                   h.MaTaiKhoan,
                   tk.HoTen AS TenTaiKhoan,
                   h.MaKH,
                   COALESCE(
                       NULLIF(h.TenKhachHang, N''),
                       kh.HoTen,
                       N'Khách lẻ'
                   ) AS TenKhachHang,
                   h.NgayTao,
                   h.NgayThanhToan,
                   h.TamTinh,
                   h.ThueVAT,
                   h.TongTien,
                   h.DiemCong,
                   h.TrangThai,
                   h.PhuongThucThanhToan,
                   h.LyDoHuy
            FROM HoaDon h
            JOIN TaiKhoan tk
                ON tk.MaTaiKhoan =
                   h.MaTaiKhoan
            LEFT JOIN KhachHang kh
                ON kh.MaKH = h.MaKH
            ORDER BY h.MaHD DESC
            """;

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được danh sách hóa đơn.",
                    e
            );
        }

        return list;
    }

    public HoaDon findById(
            int maHD
    ) {
        String sql = """
            SELECT h.MaHD,
                   h.MaTaiKhoan,
                   tk.HoTen AS TenTaiKhoan,
                   h.MaKH,
                   COALESCE(
                       NULLIF(h.TenKhachHang, N''),
                       kh.HoTen,
                       N'Khách lẻ'
                   ) AS TenKhachHang,
                   h.NgayTao,
                   h.NgayThanhToan,
                   h.TamTinh,
                   h.ThueVAT,
                   h.TongTien,
                   h.DiemCong,
                   h.TrangThai,
                   h.PhuongThucThanhToan,
                   h.LyDoHuy
            FROM HoaDon h
            JOIN TaiKhoan tk
                ON tk.MaTaiKhoan =
                   h.MaTaiKhoan
            LEFT JOIN KhachHang kh
                ON kh.MaKH = h.MaKH
            WHERE h.MaHD = ?
            """;

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {
                return rs.next()
                        ? mapRow(rs)
                        : null;
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tìm thấy hóa đơn.",
                    e
            );
        }
    }

    public List<ChiTietHoaDon>
            getChiTiet(
                    int maHD
            ) {

        List<ChiTietHoaDon> list
                = new ArrayList<>();

        String sql = """
            SELECT ct.MaCT,
                   ct.MaHD,
                   ct.MaSanPham,
                   sp.TenSanPham,
                   ct.SoLuong,
                   ct.DonGia
            FROM ChiTietHoaDon ct
            JOIN SanPham sp
                ON sp.MaSanPham =
                   ct.MaSanPham
            WHERE ct.MaHD = ?
            ORDER BY ct.MaCT
            """;

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {
                while (rs.next()) {
                    ChiTietHoaDon item
                            = new ChiTietHoaDon();

                    item.setMaCT(
                            rs.getInt(
                                    "MaCT"
                            )
                    );

                    item.setMaHD(
                            rs.getInt(
                                    "MaHD"
                            )
                    );

                    item.setMaSanPham(
                            rs.getString(
                                    "MaSanPham"
                            )
                    );

                    item.setTenSanPham(
                            rs.getString(
                                    "TenSanPham"
                            )
                    );

                    item.setSoLuong(
                            rs.getInt(
                                    "SoLuong"
                            )
                    );

                    item.setDonGia(
                            rs.getBigDecimal(
                                    "DonGia"
                            )
                    );

                    list.add(item);
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được chi tiết hóa đơn.",
                    e
            );
        }

        return list;
    }

    public void luuHoaDon(
            int maHD,
            String maKH,
            String tenKhachHang,
            List<ChiTietHoaDon> items
    ) {
        try (
                Connection conn
                = DBConnect.getConnection()) {
            conn.setAutoCommit(false);

            try {
                kiemTraHoaDonChuaKetThuc(
                        conn,
                        maHD
                );

                thayChiTiet(
                        conn,
                        maHD,
                        items
                );

                BigDecimal tamTinh
                        = layTamTinh(
                                conn,
                                maHD
                        );

                BigDecimal thue
                        = tinhVAT(tamTinh);

                BigDecimal tong
                        = tamTinh.add(thue);

                String sql = """
                    UPDATE HoaDon
                    SET MaKH = ?,
                        TenKhachHang = ?,
                        TamTinh = ?,
                        ThueVAT = ?,
                        TongTien = ?
                    WHERE MaHD = ?
                    """;

                try (
                        PreparedStatement ps
                        = conn.prepareStatement(sql)) {
                    setNullableString(
                            ps,
                            1,
                            maKH
                    );

                    setNullableString(
                            ps,
                            2,
                            tenKhachHang
                    );

                    ps.setBigDecimal(
                            3,
                            tamTinh
                    );

                    ps.setBigDecimal(
                            4,
                            thue
                    );

                    ps.setBigDecimal(
                            5,
                            tong
                    );

                    ps.setInt(
                            6,
                            maHD
                    );

                    ps.executeUpdate();
                }

                conn.commit();

            } catch (Exception e) {
                conn.rollback();

                throw new IllegalStateException(
                        e.getMessage(),
                        e
                );

            } finally {
                conn.setAutoCommit(true);
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không lưu được hóa đơn.",
                    e
            );
        }
    }

    public void thanhToanHoaDon(
            int maHD,
            String maKH,
            String tenKhachHang,
            boolean luuKhachMoi,
            List<ChiTietHoaDon> items
    ) {
        try (
                Connection conn
                = DBConnect.getConnection()) {
            conn.setAutoCommit(false);

            try {
                kiemTraHoaDonChuaKetThuc(
                        conn,
                        maHD
                );

                thayChiTiet(
                        conn,
                        maHD,
                        items
                );

                kiemTraSanPhamCoCongThuc(
                        conn,
                        maHD
                );

                kiemTraDuTonKho(
                        conn,
                        maHD
                );

                String maKhachThanhToan
                        = trimToNull(maKH);

                String tenKhachHienThi
                        = trimToNull(
                                tenKhachHang
                        );

                if (maKhachThanhToan != null) {
                    tenKhachHienThi
                            = layTenKhachHang(
                                    conn,
                                    maKhachThanhToan
                            );

                } else if (luuKhachMoi
                        && tenKhachHienThi != null) {
                    maKhachThanhToan
                            = taoKhachHangNhanh(
                                    conn,
                                    tenKhachHienThi
                            );
                }

                if (tenKhachHienThi == null) {
                    tenKhachHienThi
                            = "Khách lẻ";
                }

                BigDecimal tamTinh
                        = layTamTinh(
                                conn,
                                maHD
                        );

                BigDecimal thue
                        = tinhVAT(tamTinh);

                BigDecimal tong
                        = tamTinh.add(thue);

                int diemCong
                        = maKhachThanhToan == null
                                ? 0
                                : tong.divide(
                                        MONEY_PER_POINT,
                                        0,
                                        RoundingMode.DOWN
                                ).intValue();

                truTonKho(
                        conn,
                        maHD
                );

                String sql = """
    UPDATE HoaDon
    SET MaKH = ?,
        TenKhachHang = ?,
        TamTinh = ?,
        ThueVAT = ?,
        TongTien = ?,
        DiemCong = ?,
        TrangThai = N'Đã thanh toán',
        PhuongThucThanhToan = N'Tiền mặt',
        NgayThanhToan = SYSDATETIME(),
        LyDoHuy = NULL
    WHERE MaHD = ?
    """;

                try (
                        PreparedStatement ps
                        = conn.prepareStatement(sql)) {
                    setNullableString(
                            ps,
                            1,
                            maKhachThanhToan
                    );

                    ps.setString(
                            2,
                            tenKhachHienThi
                    );

                    ps.setBigDecimal(
                            3,
                            tamTinh
                    );

                    ps.setBigDecimal(
                            4,
                            thue
                    );

                    ps.setBigDecimal(
                            5,
                            tong
                    );

                    ps.setInt(
                            6,
                            diemCong
                    );

                    ps.setInt(
                            7,
                            maHD
                    );

                    ps.executeUpdate();
                }

                if (diemCong > 0
                        && maKhachThanhToan != null) {
                    try (
                            PreparedStatement ps
                            = conn.prepareStatement(
                                    """
                                UPDATE KhachHang
                                SET DiemTichLuy =
                                    DiemTichLuy + ?
                                WHERE MaKH = ?
                                """
                            )) {
                                ps.setInt(
                                        1,
                                        diemCong
                                );

                                ps.setString(
                                        2,
                                        maKhachThanhToan
                                );

                                ps.executeUpdate();
                            }
                }

                conn.commit();

            } catch (Exception e) {
                conn.rollback();

                throw new IllegalStateException(
                        e.getMessage(),
                        e
                );

            } finally {
                conn.setAutoCommit(true);
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không thanh toán được hóa đơn.",
                    e
            );
        }
    }

    public void huyHoaDon(
            int maHD,
            String lyDo
    ) {
        String reason
                = trimToNull(lyDo);

        if (reason == null) {
            throw new IllegalArgumentException(
                    "Vui lòng nhập lý do hủy."
            );
        }

        String sql = """
            UPDATE HoaDon
            SET TrangThai = N'Đã hủy',
                LyDoHuy = ?,
                PhuongThucThanhToan = NULL,
                NgayThanhToan = NULL,
                DiemCong = 0
            WHERE MaHD = ?
              AND TrangThai =
                  N'Chờ thanh toán'
            """;

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setString(
                    1,
                    reason
            );

            ps.setInt(
                    2,
                    maHD
            );

            if (ps.executeUpdate() != 1) {
                throw new IllegalStateException(
                        "Hóa đơn đã kết thúc "
                        + "hoặc không tồn tại."
                );
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không hủy được hóa đơn.",
                    e
            );
        }
    }

    private void thayChiTiet(
            Connection conn,
            int maHD,
            List<ChiTietHoaDon> items
    ) throws SQLException {

        if (items == null
                || items.isEmpty()) {
            throw new IllegalArgumentException(
                    "Hóa đơn phải có ít nhất một sản phẩm."
            );
        }

        try (
                PreparedStatement ps
                = conn.prepareStatement(
                        """
                    DELETE FROM ChiTietHoaDon
                    WHERE MaHD = ?
                    """
                )) {
                    ps.setInt(
                            1,
                            maHD
                    );

                    ps.executeUpdate();
                }

                String productSql = """
            SELECT GiaBan
            FROM SanPham
            WHERE MaSanPham = ?
            """;

                String insertSql = """
            INSERT INTO ChiTietHoaDon(
                MaHD,
                MaSanPham,
                SoLuong,
                DonGia
            )
            VALUES (?, ?, ?, ?)
            """;

                try (
                        PreparedStatement productPs
                        = conn.prepareStatement(
                                productSql
                        ); PreparedStatement insertPs
                        = conn.prepareStatement(
                                insertSql
                        )) {
                            for (ChiTietHoaDon item
                                    : items) {
                                if (item.getMaSanPham() == null
                                        || item.getMaSanPham()
                                                .isBlank()
                                        || item.getSoLuong() <= 0) {
                                    throw new IllegalArgumentException(
                                            "Sản phẩm hoặc số lượng "
                                            + "không hợp lệ."
                                    );
                                }

                                productPs.setString(
                                        1,
                                        item.getMaSanPham()
                                );

                                BigDecimal donGia;

                                try (
                                        ResultSet rs
                                        = productPs.executeQuery()) {
                                    if (!rs.next()) {
                                        throw new IllegalArgumentException(
                                                "Không tìm thấy sản phẩm "
                                                + item.getMaSanPham()
                                                + "."
                                        );
                                    }

                                    donGia
                                            = rs.getBigDecimal(
                                                    "GiaBan"
                                            );
                                }

                                insertPs.setInt(
                                        1,
                                        maHD
                                );

                                insertPs.setString(
                                        2,
                                        item.getMaSanPham()
                                );

                                insertPs.setInt(
                                        3,
                                        item.getSoLuong()
                                );

                                insertPs.setBigDecimal(
                                        4,
                                        donGia
                                );

                                insertPs.addBatch();
                            }

                            insertPs.executeBatch();
                        }
    }

    private void kiemTraHoaDonChuaKetThuc(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            SELECT TrangThai
            FROM HoaDon
                WITH (UPDLOCK, HOLDLOCK)
            WHERE MaHD = ?
            """;

        try (
                PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalArgumentException(
                            "Không tìm thấy hóa đơn."
                    );
                }

                if (!"Chờ thanh toán"
                        .equalsIgnoreCase(
                                rs.getString(
                                        "TrangThai"
                                )
                        )) {
                    throw new IllegalArgumentException(
                            "Hóa đơn đã kết thúc."
                    );
                }
            }
        }
    }

    private void kiemTraSanPhamCoCongThuc(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            SELECT TOP 1
                   sp.TenSanPham
            FROM ChiTietHoaDon ct
            JOIN SanPham sp
                ON sp.MaSanPham =
                   ct.MaSanPham
            WHERE ct.MaHD = ?
              AND NOT EXISTS (
                  SELECT 1
                  FROM CongThucSanPham c
                  WHERE c.MaSanPham =
                        ct.MaSanPham
              )
            """;

        try (
                PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {
                if (rs.next()) {
                    throw new IllegalArgumentException(
                            "Sản phẩm chưa có công thức: "
                            + rs.getString(
                                    "TenSanPham"
                            )
                    );
                }
            }
        }
    }

    private void kiemTraDuTonKho(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            WITH CanDung AS (
                SELECT ct.MaNguyenLieu,
                       SUM(
                           ct.SoLuongCan
                           * hd.SoLuong
                       ) AS SoLuongCan
                FROM ChiTietHoaDon hd
                JOIN CongThucSanPham ct
                    ON ct.MaSanPham =
                       hd.MaSanPham
                WHERE hd.MaHD = ?
                GROUP BY ct.MaNguyenLieu
            )
            SELECT TOP 1
                   nl.TenNguyenLieu,
                   nl.SoLuongTon,
                   cd.SoLuongCan
            FROM CanDung cd
            JOIN NguyenLieu nl
                ON nl.MaNguyenLieu =
                   cd.MaNguyenLieu
            WHERE nl.TrangThai = 0
               OR nl.SoLuongTon
                  < cd.SoLuongCan
            ORDER BY nl.TenNguyenLieu
            """;

        try (
                PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {
                if (rs.next()) {
                    throw new IllegalArgumentException(
                            "Không đủ nguyên liệu: "
                            + rs.getString(
                                    "TenNguyenLieu"
                            )
                            + ". Tồn "
                            + rs.getInt(
                                    "SoLuongTon"
                            )
                            + ", cần "
                            + rs.getInt(
                                    "SoLuongCan"
                            )
                            + " đơn vị."
                    );
                }
            }
        }
    }

    private void truTonKho(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            WITH CanDung AS (
                SELECT ct.MaNguyenLieu,
                       SUM(
                           ct.SoLuongCan
                           * hd.SoLuong
                       ) AS SoLuongCan
                FROM ChiTietHoaDon hd
                JOIN CongThucSanPham ct
                    ON ct.MaSanPham =
                       hd.MaSanPham
                WHERE hd.MaHD = ?
                GROUP BY ct.MaNguyenLieu
            )
            UPDATE nl
            SET nl.SoLuongTon =
                nl.SoLuongTon
                - cd.SoLuongCan
            FROM NguyenLieu nl
            JOIN CanDung cd
                ON cd.MaNguyenLieu =
                   nl.MaNguyenLieu
            """;

        try (
                PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setInt(
                    1,
                    maHD
            );

            ps.executeUpdate();
        }
    }

    private BigDecimal layTamTinh(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            SELECT CAST(
                ISNULL(
                    SUM(
                        SoLuong * DonGia
                    ),
                    0
                )
                AS DECIMAL(18,0)
            ) AS TamTinh
            FROM ChiTietHoaDon
            WHERE MaHD = ?
            """;

        try (
                PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {
                rs.next();

                return rs.getBigDecimal(
                        "TamTinh"
                );
            }
        }
    }

    private BigDecimal tinhVAT(
            BigDecimal tamTinh
    ) {
        return tamTinh
                .multiply(VAT_RATE)
                .setScale(
                        0,
                        RoundingMode.HALF_UP
                );
    }

    private String layTenKhachHang(
            Connection conn,
            String maKH
    ) throws SQLException {

        String sql = """
            SELECT HoTen
            FROM KhachHang
            WHERE MaKH = ?
            """;

        try (
                PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setString(
                    1,
                    maKH
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalArgumentException(
                            "Không tìm thấy khách hàng."
                    );
                }

                return rs.getString(
                        "HoTen"
                );
            }
        }
    }

    private String taoKhachHangNhanh(
            Connection conn,
            String hoTen
    ) throws SQLException {

        int sequenceValue;

        try (
                PreparedStatement ps
                = conn.prepareStatement(
                        """
                    SELECT NEXT VALUE FOR
                           dbo.Seq_KhachHang
                           AS GiaTri
                    """
                ); ResultSet rs
                = ps.executeQuery()) {
                    rs.next();

                    sequenceValue
                            = rs.getInt(
                                    "GiaTri"
                            );
                }

                String maKH
                        = String.format(
                                "KH%03d",
                                sequenceValue
                        );

                try (
                        PreparedStatement ps
                        = conn.prepareStatement(
                                """
                    INSERT INTO KhachHang(
                        MaKH,
                        HoTen,
                        SDT,
                        DiemTichLuy
                    )
                    VALUES (?, ?, NULL, 0)
                    """
                        )) {
                            ps.setString(
                                    1,
                                    maKH
                            );

                            ps.setString(
                                    2,
                                    hoTen
                            );

                            ps.executeUpdate();
                        }

                        return maKH;
    }

    private HoaDon mapRow(
            ResultSet rs
    ) throws SQLException {

        HoaDon hoaDon
                = new HoaDon();

        hoaDon.setMaHD(
                rs.getInt(
                        "MaHD"
                )
        );

        hoaDon.setMaTaiKhoan(
                rs.getString(
                        "MaTaiKhoan"
                )
        );

        hoaDon.setTenTaiKhoan(
                rs.getString(
                        "TenTaiKhoan"
                )
        );

        hoaDon.setMaKH(
                rs.getString(
                        "MaKH"
                )
        );

        hoaDon.setTenKhachHang(
                rs.getString(
                        "TenKhachHang"
                )
        );

        hoaDon.setNgayTao(
                formatTimestamp(
                        rs.getTimestamp(
                                "NgayTao"
                        )
                )
        );

        hoaDon.setNgayThanhToan(
                formatTimestamp(
                        rs.getTimestamp(
                                "NgayThanhToan"
                        )
                )
        );

        hoaDon.setTamTinh(
                getMoney(
                        rs,
                        "TamTinh"
                )
        );

        hoaDon.setThueVAT(
                getMoney(
                        rs,
                        "ThueVAT"
                )
        );

        hoaDon.setTongTien(
                getMoney(
                        rs,
                        "TongTien"
                )
        );

        hoaDon.setDiemCong(
                rs.getInt(
                        "DiemCong"
                )
        );

        hoaDon.setTrangThai(
                rs.getString(
                        "TrangThai"
                )
        );

        hoaDon.setPhuongThucThanhToan(
                rs.getString(
                        "PhuongThucThanhToan"
                )
        );

        hoaDon.setLyDoHuy(
                rs.getString(
                        "LyDoHuy"
                )
        );

        return hoaDon;
    }

    private BigDecimal getMoney(
            ResultSet rs,
            String column
    ) throws SQLException {

        BigDecimal value
                = rs.getBigDecimal(column);

        return value == null
                ? BigDecimal.ZERO
                : value;
    }

    private String formatTimestamp(
            Timestamp value
    ) {
        if (value == null) {
            return "";
        }

        return value
                .toLocalDateTime()
                .format(DATE_FORMAT);
    }

    private void setNullableString(
            PreparedStatement ps,
            int index,
            String value
    ) throws SQLException {

        String cleaned
                = trimToNull(value);

        if (cleaned == null) {
            ps.setNull(
                    index,
                    Types.NVARCHAR
            );

        } else {
            ps.setString(
                    index,
                    cleaned
            );
        }
    }

    private String trimToNull(
            String value
    ) {
        return value == null
                || value.isBlank()
                ? null
                : value.trim();
    }
}
