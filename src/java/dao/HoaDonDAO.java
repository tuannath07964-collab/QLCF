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

    private static final BigDecimal MONEY_PER_POINT =
            new BigDecimal("10000");

    private static final String SELECT_INVOICE = """
        SELECT h.MaHD,
               h.MaBan,
               h.MaNV,
               h.MaKH,
               COALESCE(
                   h.TenKhachHang,
                   kh.HoTen
               ) AS TenKhachHang,
               h.NgayTao,
               h.TamTinh,
               h.ThueVAT,
               h.TongTien,
               h.DiemCong,
               h.TrangThai,
               h.DanhSachMon,
               h.PhuongThucThanhToan,
               h.NgayThanhToan,
               h.HinhThuc,
               h.LyDoHuy
        FROM HoaDon h
        LEFT JOIN KhachHang kh
            ON kh.MaKH = h.MaKH
        """;

    public ArrayList<HoaDon> getAll() {
        ArrayList<HoaDon> list =
                new ArrayList<>();

        String sql =
                SELECT_INVOICE
                + " ORDER BY h.MaHD DESC";

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
        String sql =
                SELECT_INVOICE
                + " WHERE h.MaHD = ?";

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

    public Integer getMaHoaDonDangPhucVuTheoBan(
            int maBan
    ) {
        String sql = """
            SELECT TOP 1 MaHD
            FROM HoaDon
            WHERE MaBan = ?
              AND HinhThuc = N'Tại bàn'
              AND TrangThai = N'Đang phục vụ'
            ORDER BY MaHD DESC
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

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

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tìm được hóa đơn của bàn.",
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
                            maBan,
                            "Tại bàn"
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

    public int taoHoaDonMangVe(
            String maNV
    ) throws SQLException {

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            return taoHoaDonMoi(
                    conn,
                    maNV,
                    null,
                    "Mang về"
            );
        }
    }

    public void luuDonHang(
            HoaDon hoaDon,
            String[] maMons,
            String[] soLuongs
    ) throws SQLException {

        if (hoaDon.getMaHD() == null) {
            throw new SQLException(
                    "Thiếu mã hóa đơn."
            );
        }

        if (
            maMons == null
            || soLuongs == null
            || maMons.length == 0
            || maMons.length
                != soLuongs.length
        ) {
            throw new SQLException(
                    "Vui lòng chọn ít nhất một món."
            );
        }

        int maHD =
                Integer.parseInt(
                        hoaDon.getMaHD()
                );

        Integer maBan =
                parseNullableInt(
                        hoaDon.getMaBan()
                );

        String hinhThuc =
                chuanHoaHinhThuc(
                        hoaDon.getHinhThuc(),
                        maBan
                );

        if (
            "Tại bàn".equals(hinhThuc)
            && maBan == null
        ) {
            throw new SQLException(
                    "Hóa đơn tại bàn phải có bàn phục vụ."
            );
        }

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            conn.setAutoCommit(false);

            try {
                kiemTraHoaDonChuaKetThuc(
                        conn,
                        maHD
                );

                if (maBan != null) {
                    kiemTraBanTonTai(
                            conn,
                            maBan
                    );
                }

                try (
                    PreparedStatement ps =
                        conn.prepareStatement(
                            """
                            DELETE FROM ChiTietHoaDon
                            WHERE MaHD = ?
                            """
                        )
                ) {
                    ps.setInt(1, maHD);
                    ps.executeUpdate();
                }

                String priceSql = """
                    SELECT Gia
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
                                    "Số lượng món không hợp lệ."
                            );
                        }

                        if (
                            maMon.isBlank()
                            || soLuong <= 0
                        ) {
                            throw new SQLException(
                                    "Món hoặc số lượng không hợp lệ."
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

                        tamTinh =
                                tamTinh.add(
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
                        tinhVAT(tamTinh);

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
                        HinhThuc = ?,
                        TrangThai = N'Đang phục vụ'
                    WHERE MaHD = ?
                    """;

                try (
                    PreparedStatement ps =
                            conn.prepareStatement(
                                    updateSql
                            )
                ) {
                    setNullableInt(
                            ps,
                            1,
                            maBan
                    );

                    setNullableString(
                            ps,
                            2,
                            hoaDon.getMaKH()
                    );

                    setNullableString(
                            ps,
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

                    ps.setString(
                            7,
                            hinhThuc
                    );

                    ps.setInt(
                            8,
                            maHD
                    );

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException(
                                "Không lưu được hóa đơn."
                        );
                    }
                }

                if (
                    maBan != null
                    && "Tại bàn".equals(
                            hinhThuc
                    )
                ) {
                    ganHoaDonChoBan(
                            conn,
                            maBan,
                            maHD
                    );
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

    public void thanhToanHoaDon(
            int maHD,
            String maKH,
            String tenKhachMoi,
            boolean luuKhachMoi,
            String phuongThucThanhToan
    ) throws SQLException {

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            conn.setAutoCommit(false);

            try {
                InvoiceLock invoice =
                        khoaHoaDon(
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

                String maKhachThanhToan =
                        trimToNull(maKH);

                String tenKhachHienThi =
                        null;

                if (maKhachThanhToan != null) {
                    tenKhachHienThi =
                            layTenKhachHang(
                                    conn,
                                    maKhachThanhToan
                            );

                } else if (luuKhachMoi) {
                    String tenMoi =
                            trimToNull(
                                    tenKhachMoi
                            );

                    if (tenMoi == null) {
                        throw new SQLException(
                                "Vui lòng nhập họ tên khách hàng cần lưu."
                        );
                    }

                    maKhachThanhToan =
                            taoKhachHangNhanh(
                                    conn,
                                    tenMoi
                            );

                    tenKhachHienThi =
                            tenMoi;
                }

                BigDecimal tamTinh =
                        layTamTinh(
                                conn,
                                maHD
                        );

                BigDecimal thueVAT =
                        tinhVAT(tamTinh);

                BigDecimal tongTien =
                        tamTinh.add(thueVAT);

                int diemCong =
                        maKhachThanhToan == null
                        ? 0
                        : tongTien.divide(
                                MONEY_PER_POINT,
                                0,
                                RoundingMode.DOWN
                        ).intValue();

                truKho(
                        conn,
                        maHD
                );

                String updateHoaDon = """
                    UPDATE HoaDon
                    SET MaKH = ?,
                        TenKhachHang = ?,
                        TamTinh = ?,
                        ThueVAT = ?,
                        TongTien = ?,
                        DiemCong = ?,
                        TrangThai = N'Đã thanh toán',
                        PhuongThucThanhToan = ?,
                        NgayThanhToan = GETDATE(),
                        LyDoHuy = NULL
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
                            maKhachThanhToan
                    );

                    setNullableString(
                            ps,
                            2,
                            tenKhachHienThi
                    );

                    ps.setBigDecimal(
                            3,
                            tamTinh
                    );

                    ps.setBigDecimal(
                            4,
                            thueVAT
                    );

                    ps.setBigDecimal(
                            5,
                            tongTien
                    );

                    ps.setInt(
                            6,
                            diemCong
                    );

                    ps.setString(
                            7,
                            phuongThucThanhToan
                    );

                    ps.setInt(
                            8,
                            maHD
                    );

                    ps.executeUpdate();
                }

                if (diemCong > 0) {
                    try (
                        PreparedStatement ps =
                            conn.prepareStatement(
                                """
                                UPDATE KhachHang
                                SET DiemTichLuy =
                                    DiemTichLuy + ?
                                WHERE MaKH = ?
                                """
                            )
                    ) {
                        ps.setInt(
                                1,
                                diemCong
                        );

                        ps.setString(
                                2,
                                maKhachThanhToan
                        );

                        if (
                            ps.executeUpdate() != 1
                        ) {
                            throw new SQLException(
                                    "Không cộng được điểm khách hàng."
                            );
                        }
                    }
                }

                if (
                    invoice.maBan != null
                    && "Tại bàn".equals(
                            invoice.hinhThuc
                    )
                ) {
                    giaiPhongBan(
                            conn,
                            invoice.maBan
                    );
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

    public void huyHoaDon(
            int maHD,
            String lyDo
    ) throws SQLException {

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            conn.setAutoCommit(false);

            try {
                InvoiceLock invoice =
                        khoaHoaDon(
                                conn,
                                maHD
                        );

                try (
                    PreparedStatement ps =
                        conn.prepareStatement(
                            """
                            UPDATE HoaDon
                            SET TrangThai = N'Đã hủy',
                                LyDoHuy = ?,
                                DiemCong = 0,
                                PhuongThucThanhToan = NULL,
                                NgayThanhToan = NULL
                            WHERE MaHD = ?
                            """
                        )
                ) {
                    setNullableString(
                            ps,
                            1,
                            lyDo
                    );

                    ps.setInt(
                            2,
                            maHD
                    );

                    ps.executeUpdate();
                }

                if (
                    invoice.maBan != null
                    && "Tại bàn".equals(
                            invoice.hinhThuc
                    )
                ) {
                    giaiPhongBan(
                            conn,
                            invoice.maBan
                    );
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

    private Integer timHoaDonDangPhucVu(
            Connection conn,
            int maBan
    ) throws SQLException {

        String sql = """
            SELECT TOP 1 MaHD
            FROM HoaDon
                WITH (UPDLOCK, HOLDLOCK)
            WHERE MaBan = ?
              AND HinhThuc = N'Tại bàn'
              AND TrangThai = N'Đang phục vụ'
            ORDER BY MaHD DESC
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(
                    1,
                    maBan
            );

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
            Integer maBan,
            String hinhThuc
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
                TrangThai,
                HinhThuc
            )
            VALUES (
                ?,
                ?,
                GETDATE(),
                0,
                0,
                0,
                0,
                N'Đang phục vụ',
                ?
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
            ps.setString(
                    1,
                    maNV
            );

            setNullableInt(
                    ps,
                    2,
                    maBan
            );

            ps.setString(
                    3,
                    hinhThuc
            );

            ps.executeUpdate();

            try (
                ResultSet keys =
                        ps.getGeneratedKeys()
            ) {
                if (!keys.next()) {
                    throw new SQLException(
                            "Không tự tạo được mã hóa đơn."
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
                    String.format(
                            "HD%06d",
                            maHD
                    )
            );

            ps.setInt(
                    2,
                    maBan
            );

            if (ps.executeUpdate() != 1) {
                throw new SQLException(
                        "Không cập nhật được trạng thái bàn."
                );
            }
        }
    }

    private void giaiPhongBan(
            Connection conn,
            int maBan
    ) throws SQLException {

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
            ps.setInt(
                    1,
                    maBan
            );

            ps.executeUpdate();
        }
    }

    private void kiemTraBanTonTai(
            Connection conn,
            int maBan
    ) throws SQLException {

        try (
            PreparedStatement ps =
                conn.prepareStatement(
                    """
                    SELECT MaBan
                    FROM BanAn
                    WHERE MaBan = ?
                    """
                )
        ) {
            ps.setInt(
                    1,
                    maBan
            );

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

    private InvoiceLock khoaHoaDon(
            Connection conn,
            int maHD
    ) throws SQLException {

        String sql = """
            SELECT MaBan,
                   HinhThuc,
                   TrangThai
            FROM HoaDon
                WITH (UPDLOCK, HOLDLOCK)
            WHERE MaHD = ?
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (!rs.next()) {
                    throw new SQLException(
                            "Không tìm thấy hóa đơn."
                    );
                }

                String trangThai =
                        rs.getString(
                                "TrangThai"
                        );

                if (
                    "Đã thanh toán"
                        .equalsIgnoreCase(
                                trangThai
                        )
                ) {
                    throw new SQLException(
                            "Hóa đơn đã thanh toán."
                    );
                }

                if (
                    "Đã hủy"
                        .equalsIgnoreCase(
                                trangThai
                        )
                ) {
                    throw new SQLException(
                            "Hóa đơn đã hủy."
                    );
                }

                Integer maBan =
                        (Integer) rs.getObject(
                                "MaBan"
                        );

                return new InvoiceLock(
                        maBan,
                        rs.getString(
                                "HinhThuc"
                        )
                );
            }
        }
    }

    private void kiemTraHoaDonChuaKetThuc(
            Connection conn,
            int maHD
    ) throws SQLException {

        khoaHoaDon(
                conn,
                maHD
        );
    }

    private void kiemTraHoaDonCoMon(
            Connection conn,
            int maHD
    ) throws SQLException {

        try (
            PreparedStatement ps =
                conn.prepareStatement(
                    """
                    SELECT TOP 1 MaCT
                    FROM ChiTietHoaDon
                    WHERE MaHD = ?
                    """
                )
        ) {
            ps.setInt(
                    1,
                    maHD
            );

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

    private void kiemTraTatCaMonDaCoCongThuc(
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
                  WHERE ctm.MaMon = ct.MaMon
              )
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (rs.next()) {
                    throw new SQLException(
                            "Món chưa có công thức nguyên liệu: "
                            + rs.getString(
                                    "TenMon"
                            )
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
            SELECT CAST(
                ISNULL(
                    SUM(SoLuong * DonGia),
                    0
                )
                AS DECIMAL(18,0)
            ) AS TamTinh
            FROM ChiTietHoaDon
            WHERE MaHD = ?
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(
                    1,
                    maHD
            );

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
                SELECT ctm.MaNL,
                       SUM(
                           ctm.SoLuongCan
                           * cthd.SoLuong
                       ) AS SoLuongCan
                FROM ChiTietHoaDon cthd
                JOIN CongThucMon ctm
                    ON ctm.MaMon = cthd.MaMon
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
               OR k.SoLuong < cd.SoLuongCan
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (rs.next()) {
                    String ten =
                            rs.getString(
                                    "TenNL"
                            );

                    throw new SQLException(
                            "Không đủ nguyên liệu: "
                            + (
                                ten == null
                                ? "nguyên liệu không tồn tại trong kho"
                                : ten
                            )
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
                SELECT ctm.MaNL,
                       SUM(
                           ctm.SoLuongCan
                           * cthd.SoLuong
                       ) AS SoLuongCan
                FROM ChiTietHoaDon cthd
                JOIN CongThucMon ctm
                    ON ctm.MaMon = cthd.MaMon
                WHERE cthd.MaHD = ?
                GROUP BY ctm.MaNL
            )
            UPDATE k
            SET k.SoLuong =
                k.SoLuong - cd.SoLuongCan
            FROM Kho k
            JOIN CanDung cd
                ON cd.MaNL = k.MaNL
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setInt(
                    1,
                    maHD
            );

            ps.executeUpdate();
        }
    }

    private String layTenKhachHang(
            Connection conn,
            String maKH
    ) throws SQLException {

        try (
            PreparedStatement ps =
                conn.prepareStatement(
                    """
                    SELECT HoTen
                    FROM KhachHang
                    WHERE MaKH = ?
                    """
                )
        ) {
            ps.setString(
                    1,
                    maKH
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (!rs.next()) {
                    throw new SQLException(
                            "Không tìm thấy khách hàng đã chọn."
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

        String maKH;

        try (
            PreparedStatement ps =
                conn.prepareStatement(
                    """
                    SELECT N'KH'
                        + RIGHT(
                            N'000'
                            + CAST(
                                NEXT VALUE FOR
                                dbo.Seq_KhachHang
                                AS NVARCHAR(10)
                            ),
                            3
                        )
                    """
                );

            ResultSet rs =
                    ps.executeQuery()
        ) {
            if (!rs.next()) {
                throw new SQLException(
                        "Không tự tạo được mã khách hàng."
                );
            }

            maKH =
                    rs.getString(1);
        }

        try (
            PreparedStatement ps =
                conn.prepareStatement(
                    """
                    INSERT INTO KhachHang(
                        MaKH,
                        HoTen,
                        SDT,
                        DiemTichLuy
                    )
                    VALUES (?, ?, NULL, 0)
                    """
                )
        ) {
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

    private String chuanHoaHinhThuc(
            String hinhThuc,
            Integer maBan
    ) {
        if (
            "Mang về".equalsIgnoreCase(
                    hinhThuc
            )
        ) {
            return "Mang về";
        }

        return maBan == null
                ? "Mang về"
                : "Tại bàn";
    }

    private Integer parseNullableInt(
            String value
    ) {
        String text =
                trimToNull(value);

        return text == null
                ? null
                : Integer.valueOf(text);
    }

    private String trimToNull(
            String value
    ) {
        return value == null
                || value.isBlank()
                ? null
                : value.trim();
    }

    private void setNullableString(
            PreparedStatement ps,
            int index,
            String value
    ) throws SQLException {

        String text =
                trimToNull(value);

        if (text == null) {
            ps.setNull(
                    index,
                    Types.NVARCHAR
            );
        } else {
            ps.setString(
                    index,
                    text
            );
        }
    }

    private void setNullableInt(
            PreparedStatement ps,
            int index,
            Integer value
    ) throws SQLException {

        if (value == null) {
            ps.setNull(
                    index,
                    Types.INTEGER
            );
        } else {
            ps.setInt(
                    index,
                    value
            );
        }
    }

    private HoaDon mapRow(
            ResultSet rs
    ) throws SQLException {

        HoaDon hd =
                new HoaDon();

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

        hd.setTenKhachHang(
                rs.getString(
                        "TenKhachHang"
                )
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
                rs.getString(
                        "DanhSachMon"
                )
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

        hd.setHinhThuc(
                rs.getString("HinhThuc")
        );

        hd.setLyDoHuy(
                rs.getString("LyDoHuy")
        );

        return hd;
    }

    private static final class InvoiceLock {

        private final Integer maBan;
        private final String hinhThuc;

        private InvoiceLock(
                Integer maBan,
                String hinhThuc
        ) {
            this.maBan = maBan;
            this.hinhThuc = hinhThuc;
        }
    }
}