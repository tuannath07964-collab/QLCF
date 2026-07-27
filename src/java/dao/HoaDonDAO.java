package dao;

import model.HoaDon;
import util.DBConnect;

import java.math.BigDecimal;
import java.math.RoundingMode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

import java.util.ArrayList;

public class HoaDonDAO {

    private static final BigDecimal VAT_RATE =
            new BigDecimal("0.08");

    private static final BigDecimal
            MONEY_PER_POINT =
            new BigDecimal("10000");

    public ArrayList<HoaDon> getAll() {
        ArrayList<HoaDon> list =
                new ArrayList<>();

        String sql = """
            SELECT
                MaHD,
                MaBan,
                MaNV,
                MaKH,
                NgayTao,
                TamTinh,
                ThueVAT,
                TongTien,
                DiemCong,
                TrangThai,
                DanhSachMon,
                PhuongThucThanhToan,
                NgayThanhToan
            FROM HoaDon
            ORDER BY MaHD DESC
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
            String maHD
    ) {
        String sql = """
            SELECT
                MaHD,
                MaBan,
                MaNV,
                MaKH,
                NgayTao,
                TamTinh,
                ThueVAT,
                TongTien,
                DiemCong,
                TrangThai,
                DanhSachMon,
                PhuongThucThanhToan,
                NgayThanhToan
            FROM HoaDon
            WHERE MaHD = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(
                    1,
                    Integer.parseInt(maHD)
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
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

    public int taoHoacLayHoaDonDangPhucVu(
            String maNV,
            int maBan
    ) throws SQLException {

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            conn.setAutoCommit(false);

            try {
                kiemTraBanTonTai(
                        conn,
                        maBan
                );

                Integer maHD =
                        timHoaDonDangPhucVu(
                                conn,
                                maBan
                        );

                if (maHD == null) {
                    maHD = taoHoaDonMoi(
                            conn,
                            maNV,
                            maBan
                    );
                }

                ganHoaDonChoBan(
                        conn,
                        maBan,
                        maHD
                );

                conn.commit();
                return maHD;

            } catch (SQLException e) {
                conn.rollback();
                throw e;

            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public void luuDonHang(
            HoaDon hoaDon,
            String[] maMons,
            String[] soLuongs
    ) throws SQLException {

        if (hoaDon.getMaHD() == null
                || hoaDon.getMaBan() == null) {

            throw new SQLException(
                    "Thiếu mã hóa đơn hoặc mã bàn."
            );
        }

        if (maMons == null
                || soLuongs == null
                || maMons.length == 0
                || maMons.length
                    != soLuongs.length) {

            throw new SQLException(
                    "Vui lòng chọn ít nhất một món."
            );
        }

        int maHD = Integer.parseInt(
                hoaDon.getMaHD()
        );

        int maBan = Integer.parseInt(
                hoaDon.getMaBan()
        );

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            conn.setAutoCommit(false);

            try {
                kiemTraHoaDonChuaThanhToan(
                        conn,
                        maHD
                );

                kiemTraBanTonTai(
                        conn,
                        maBan
                );

                try (
                    PreparedStatement ps =
                        conn.prepareStatement(
                            "DELETE FROM "
                            + "ChiTietHoaDon "
                            + "WHERE MaHD = ?"
                        )
                ) {
                    ps.setInt(1, maHD);
                    ps.executeUpdate();
                }

                String priceSql = """
                    SELECT TenMon, Gia
                    FROM Menu
                    WHERE MaMon = ?
                    """;

                String detailSql = """
                    INSERT INTO ChiTietHoaDon(
                        MaHD,
                        MaMon,
                        SoLuong,
                        DonGia
                    )
                    VALUES (?, ?, ?, ?)
                    """;

                BigDecimal tamTinh =
                        BigDecimal.ZERO;

                try (
                    PreparedStatement pricePs =
                        conn.prepareStatement(
                                priceSql
                        );

                    PreparedStatement detailPs =
                        conn.prepareStatement(
                                detailSql
                        )
                ) {
                    for (
                        int i = 0;
                        i < maMons.length;
                        i++
                    ) {
                        String maMon =
                                maMons[i] == null
                                ? ""
                                : maMons[i].trim();

                        int soLuong;

                        try {
                            soLuong =
                                Integer.parseInt(
                                    soLuongs[i]
                                );
                        } catch (
                            NumberFormatException e
                        ) {
                            throw new SQLException(
                                "Số lượng món "
                                + "không hợp lệ."
                            );
                        }

                        if (maMon.isBlank()
                                || soLuong <= 0) {

                            throw new SQLException(
                                "Món hoặc số lượng "
                                + "không hợp lệ."
                            );
                        }

                        pricePs.setString(
                                1,
                                maMon
                        );

                        BigDecimal donGia;

                        try (
                            ResultSet rs =
                                pricePs.executeQuery()
                        ) {
                            if (!rs.next()) {
                                throw new SQLException(
                                    "Không tìm thấy món "
                                    + maMon
                                    + "."
                                );
                            }

                            donGia =
                                rs.getBigDecimal(
                                    "Gia"
                                );
                        }

                        detailPs.setInt(
                                1,
                                maHD
                        );

                        detailPs.setString(
                                2,
                                maMon
                        );

                        detailPs.setInt(
                                3,
                                soLuong
                        );

                        detailPs.setBigDecimal(
                                4,
                                donGia
                        );

                        detailPs.addBatch();

                        tamTinh = tamTinh.add(
                            donGia.multiply(
                                BigDecimal.valueOf(
                                    soLuong
                                )
                            )
                        );
                    }

                    detailPs.executeBatch();
                }

                BigDecimal thueVAT =
                        tamTinh
                            .multiply(VAT_RATE)
                            .setScale(
                                0,
                                RoundingMode.HALF_UP
                            );

                BigDecimal tongTien =
                        tamTinh.add(thueVAT);

                String updateSql = """
                    UPDATE HoaDon
                    SET MaBan = ?,
                        MaKH = ?,
                        DanhSachMon = ?,
                        TamTinh = ?,
                        ThueVAT = ?,
                        TongTien = ?,
                        TrangThai =
                            N'Đang phục vụ'
                    WHERE MaHD = ?
                    """;

                try (
                    PreparedStatement ps =
                        conn.prepareStatement(
                                updateSql
                        )
                ) {
                    ps.setInt(
                            1,
                            maBan
                    );

                    setNullableString(
                            ps,
                            2,
                            hoaDon.getMaKH()
                    );

                    ps.setString(
                            3,
                            hoaDon.getDanhSachMon()
                    );

                    ps.setBigDecimal(
                            4,
                            tamTinh
                    );

                    ps.setBigDecimal(
                            5,
                            thueVAT
                    );

                    ps.setBigDecimal(
                            6,
                            tongTien
                    );

                    ps.setInt(
                            7,
                            maHD
                    );

                    if (
                        ps.executeUpdate() != 1
                    ) {
                        throw new SQLException(
                            "Không lưu được hóa đơn."
                        );
                    }
                }

                ganHoaDonChoBan(
                        conn,
                        maBan,
                        maHD
                );

                conn.commit();

            } catch (SQLException e) {
                conn.rollback();
                throw e;

            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public void thanhToanHoaDon(
            int maHD,
            String maKH,
            String phuongThucThanhToan
    ) throws SQLException {

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            conn.setAutoCommit(false);

            try {
                int maBan =
                    kiemTraHoaDonChuaThanhToan(
                            conn,
                            maHD
                    );

                kiemTraHoaDonCoMon(
                        conn,
                        maHD
                );

                kiemTraTatCaMonDaCoCongThuc(
                        conn,
                        maHD
                );

                kiemTraDuNguyenLieu(
                        conn,
                        maHD
                );

                BigDecimal tamTinh =
                        layTamTinh(
                                conn,
                                maHD
                        );

                BigDecimal thueVAT =
                        tamTinh
                            .multiply(VAT_RATE)
                            .setScale(
                                0,
                                RoundingMode.HALF_UP
                            );

                BigDecimal tongTien =
                        tamTinh.add(thueVAT);

                int diemCong = 0;

                if (maKH != null
                        && !maKH.isBlank()) {

                    diemCong =
                        tongTien.divide(
                                MONEY_PER_POINT,
                                0,
                                RoundingMode.DOWN
                        ).intValue();
                }

                truKho(conn, maHD);

                String updateHoaDon = """
                    UPDATE HoaDon
                    SET MaKH = ?,
                        TamTinh = ?,
                        ThueVAT = ?,
                        TongTien = ?,
                        DiemCong = ?,
                        TrangThai =
                            N'Đã thanh toán',
                        PhuongThucThanhToan = ?,
                        NgayThanhToan =
                            GETDATE()
                    WHERE MaHD = ?
                    """;

                try (
                    PreparedStatement ps =
                        conn.prepareStatement(
                                updateHoaDon
                        )
                ) {
                    setNullableString(
                            ps,
                            1,
                            maKH
                    );

                    ps.setBigDecimal(
                            2,
                            tamTinh
                    );

                    ps.setBigDecimal(
                            3,
                            thueVAT
                    );

                    ps.setBigDecimal(
                            4,
                            tongTien
                    );

                    ps.setInt(
                            5,
                            diemCong
                    );

                    ps.setString(
                            6,
                            phuongThucThanhToan
                    );

                    ps.setInt(
                            7,
                            maHD
                    );

                    ps.executeUpdate();
                }

                if (diemCong > 0) {
                    String updateDiem = """
                        UPDATE KhachHang
                        SET DiemTichLuy =
                            DiemTichLuy + ?
                        WHERE MaKH = ?
                        """;

                    try (
                        PreparedStatement ps =
                            conn.prepareStatement(
                                    updateDiem
                            )
                    ) {
                        ps.setInt(
                                1,
                                diemCong
                        );

                        ps.setString(
                                2,
                                maKH.trim()
                        );

                        if (
                            ps.executeUpdate()
                                    != 1
                        ) {
                            throw new SQLException(
                                "Không tìm thấy "
                                + "khách hàng để "
                                + "cộng điểm."
                            );
                        }
                    }
                }

                try (
                    PreparedStatement ps =
                        conn.prepareStatement(
                            """
                            UPDATE BanAn
                            SET TrangThai = 0,
                                MaDonHang = NULL
                            WHERE MaBan = ?
                            """
                        )
                ) {
                    ps.setInt(1, maBan);
                    ps.executeUpdate();
                }

                conn.commit();

            } catch (SQLException e) {
                conn.rollback();
                throw e;

            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public void delete(
            String maHDValue
    ) {
        int maHD = Integer.parseInt(
                maHDValue
        );

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            conn.setAutoCommit(false);

            try {
                int maBan =
                    kiemTraHoaDonChuaThanhToan(
                            conn,
                            maHD
                    );

                try (
                    PreparedStatement ps =
                        conn.prepareStatement(
                            "DELETE FROM HoaDon "
                            + "WHERE MaHD = ?"
                        )
                ) {
                    ps.setInt(1, maHD);
                    ps.executeUpdate();
                }

                try (
                    PreparedStatement ps =
                        conn.prepareStatement(
                            """
                            UPDATE BanAn
                            SET TrangThai = 0,
                                MaDonHang = NULL
                            WHERE MaBan = ?
                            """
                        )
                ) {
                    ps.setInt(1, maBan);
                    ps.executeUpdate();
                }

                conn.commit();

            } catch (SQLException e) {
                conn.rollback();

                throw new IllegalStateException(
                        "Không xóa được hóa đơn.",
                        e
                );

            } finally {
                conn.setAutoCommit(true);
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không kết nối được database.",
                    e
            );
        }
    }

    private Integer timHoaDonDangPhucVu(
            Connection conn,
            int maBan
    ) throws SQLException {

        String sql = """
            SELECT TOP 1 MaHD
            FROM HoaDon
                WITH (UPDLOCK, HOLDLOCK)
            WHERE MaBan = ?
              AND TrangThai =
                  N'Đang phục vụ'
            ORDER BY MaHD DESC
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maBan);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                return rs.next()
                        ? rs.getInt("MaHD")
                        : null;
            }
        }
    }

    private int taoHoaDonMoi(
            Connection conn,
            String maNV,
            int maBan
    ) throws SQLException {

        String sql = """
            INSERT INTO HoaDon(
                MaNV,
                MaBan,
                NgayTao,
                TamTinh,
                ThueVAT,
                TongTien,
                DiemCong,
                TrangThai
            )
            VALUES (
                ?,
                ?,
                GETDATE(),
                0,
                0,
                0,
                0,
                N'Đang phục vụ'
            )
            """;

        try (
            PreparedStatement ps =
                conn.prepareStatement(
                    sql,
                    Statement
                        .RETURN_GENERATED_KEYS
                )
        ) {
            ps.setString(1, maNV);
            ps.setInt(2, maBan);
            ps.executeUpdate();

            try (
                ResultSet keys =
                        ps.getGeneratedKeys()
            ) {
                if (!keys.next()) {
                    throw new SQLException(
                        "Không tự tạo được "
                        + "mã hóa đơn."
                    );
                }

                return keys.getInt(1);
            }
        }
    }

    private void ganHoaDonChoBan(
            Connection conn,
            int maBan,
            int maHD
    ) throws SQLException {

        String maHienThi =
                String.format(
                        "HD%06d",
                        maHD
                );

        String sql = """
            UPDATE BanAn
            SET TrangThai = 1,
                MaDonHang = ?
            WHERE MaBan = ?
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    maHienThi
            );

            ps.setInt(
                    2,
                    maBan
            );

            if (
                ps.executeUpdate() != 1
            ) {
                throw new SQLException(
                    "Không cập nhật được "
                    + "trạng thái bàn."
                );
            }
        }
    }

    private void kiemTraBanTonTai(
            Connection conn,
            int maBan
    ) throws SQLException {

        String sql = """
            SELECT MaBan
            FROM BanAn
            WHERE MaBan = ?
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maBan);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (!rs.next()) {
                    throw new SQLException(
                            "Bàn không tồn tại."
                    );
                }
            }
        }
    }

    private int kiemTraHoaDonChuaThanhToan(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            SELECT
                MaBan,
                TrangThai
            FROM HoaDon
                WITH (UPDLOCK, HOLDLOCK)
            WHERE MaHD = ?
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maHD);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (!rs.next()) {
                    throw new SQLException(
                            "Không tìm thấy hóa đơn."
                    );
                }

                if (
                    "Đã thanh toán"
                        .equalsIgnoreCase(
                            rs.getString(
                                "TrangThai"
                            )
                        )
                ) {
                    throw new SQLException(
                            "Hóa đơn đã thanh toán."
                    );
                }

                return rs.getInt("MaBan");
            }
        }
    }

    private void kiemTraHoaDonCoMon(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            SELECT TOP 1 MaCT
            FROM ChiTietHoaDon
            WHERE MaHD = ?
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maHD);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (!rs.next()) {
                    throw new SQLException(
                            "Hóa đơn chưa có món."
                    );
                }
            }
        }
    }

    private void
            kiemTraTatCaMonDaCoCongThuc(
                    Connection conn,
                    int maHD
            ) throws SQLException {

        String sql = """
            SELECT TOP 1 m.TenMon
            FROM ChiTietHoaDon ct
            JOIN Menu m
                ON m.MaMon = ct.MaMon
            WHERE ct.MaHD = ?
              AND NOT EXISTS (
                  SELECT 1
                  FROM CongThucMon ctm
                  WHERE ctm.MaMon =
                        ct.MaMon
              )
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maHD);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (rs.next()) {
                    throw new SQLException(
                        "Món chưa có công thức "
                        + "nguyên liệu: "
                        + rs.getString("TenMon")
                    );
                }
            }
        }
    }

    private BigDecimal layTamTinh(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            SELECT ISNULL(
                SUM(SoLuong * DonGia),
                0
            ) AS TamTinh
            FROM ChiTietHoaDon
            WHERE MaHD = ?
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maHD);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                rs.next();

                return rs.getBigDecimal(
                        "TamTinh"
                );
            }
        }
    }

    private void kiemTraDuNguyenLieu(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            WITH CanDung AS (
                SELECT
                    ctm.MaNL,
                    SUM(
                        ctm.SoLuongCan
                        * cthd.SoLuong
                    ) AS SoLuongCan
                FROM ChiTietHoaDon cthd
                JOIN CongThucMon ctm
                    ON ctm.MaMon =
                       cthd.MaMon
                WHERE cthd.MaHD = ?
                GROUP BY ctm.MaNL
            )
            SELECT TOP 1
                k.TenNL,
                k.SoLuong,
                cd.SoLuongCan,
                k.DonVi
            FROM CanDung cd
            LEFT JOIN Kho k
                ON k.MaNL = cd.MaNL
            WHERE k.MaNL IS NULL
               OR k.SoLuong <
                  cd.SoLuongCan
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maHD);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (rs.next()) {
                    String ten =
                            rs.getString(
                                "TenNL"
                            );

                    if (ten == null) {
                        ten =
                            "nguyên liệu "
                            + "không tồn tại "
                            + "trong kho";
                    }

                    throw new SQLException(
                            "Không đủ nguyên liệu: "
                            + ten
                            + "."
                    );
                }
            }
        }
    }

    private void truKho(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            WITH CanDung AS (
                SELECT
                    ctm.MaNL,
                    SUM(
                        ctm.SoLuongCan
                        * cthd.SoLuong
                    ) AS SoLuongCan
                FROM ChiTietHoaDon cthd
                JOIN CongThucMon ctm
                    ON ctm.MaMon =
                       cthd.MaMon
                WHERE cthd.MaHD = ?
                GROUP BY ctm.MaNL
            )
            UPDATE k
            SET k.SoLuong =
                k.SoLuong
                - cd.SoLuongCan
            FROM Kho k
            JOIN CanDung cd
                ON cd.MaNL = k.MaNL
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(1, maHD);
            ps.executeUpdate();
        }
    }

    private void setNullableString(
            PreparedStatement ps,
            int index,
            String value
    ) throws SQLException {

        if (value == null
                || value.isBlank()) {

            ps.setNull(
                    index,
                    Types.NVARCHAR
            );
        } else {
            ps.setString(
                    index,
                    value.trim()
            );
        }
    }

    private HoaDon mapRow(
            ResultSet rs
    ) throws SQLException {

        HoaDon hd = new HoaDon();

        hd.setMaHD(
                rs.getString("MaHD")
        );

        hd.setMaBan(
                rs.getString("MaBan")
        );

        hd.setMaNV(
                rs.getString("MaNV")
        );

        hd.setMaKH(
                rs.getString("MaKH")
        );

        hd.setNgayTao(
                rs.getString("NgayTao")
        );

        hd.setTamTinh(
                rs.getDouble("TamTinh")
        );

        hd.setThueVAT(
                rs.getDouble("ThueVAT")
        );

        hd.setTongTien(
                rs.getDouble("TongTien")
        );

        hd.setDiemCong(
                rs.getInt("DiemCong")
        );

        hd.setTrangThai(
                rs.getString("TrangThai")
        );

        hd.setDanhSachMon(
                rs.getString("DanhSachMon")
        );

        hd.setPhuongThucThanhToan(
                rs.getString(
                    "PhuongThucThanhToan"
                )
        );

        hd.setNgayThanhToan(
                rs.getString(
                    "NgayThanhToan"
                )
        );

        return hd;
    }
}