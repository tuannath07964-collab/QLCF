package dao;

import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import model.HoaDon;
import model.Menu;
import model.MaGiamGia;
import java.sql.Statement;
import java.sql.Types;

public class HoaDonDAO extends DBConnect {

    // Lấy mã hóa đơn tiếp theo dựa vào giá trị tự tăng IDENTITY hiện tại
    public String getNextMaHD() {
        int nextId = 1;
        String sql = "SELECT IDENT_CURRENT('HoaDon') + 1";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                nextId = (int) rs.getDouble(1);
                if (nextId <= 0) {
                    nextId = 1;
                }
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return String.valueOf(nextId);
    }

    public boolean isBanExists(String maBan) {
        String sql = "SELECT MaBan FROM BanAn WHERE MaBan = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, maBan);
            ResultSet rs = ps.executeQuery();
            boolean exists = rs.next();
            rs.close();
            ps.close();
            return exists;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<HoaDon> getAll() {
        ArrayList<HoaDon> list = new ArrayList<>();
        String sql = "SELECT MaHD, MaBan, MaNV, NgayTao, MaGiamGia, TongTien, TrangThai, DanhsachMon FROM HoaDon";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HoaDon hd = new HoaDon();
                hd.setMaHD(rs.getString("MaHD"));
                hd.setMaBan(rs.getString("MaBan"));
                hd.setMaNV(rs.getString("MaNV"));
                hd.setNgayTao(rs.getString("NgayTao"));
                hd.setMaGiamGia(rs.getString("MaGiamGia"));
                hd.setTongTien(rs.getDouble("TongTien"));
                hd.setTrangThai(rs.getString("TrangThai"));
                hd.setDanhSachMon(rs.getString("DanhsachMon"));
                list.add(hd);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public HoaDon findById(String maHD) {
        String sql = "SELECT MaHD, MaBan, MaNV, NgayTao, TongTien, TrangThai, DanhsachMon, MaGiamGia FROM HoaDon WHERE MaHD = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maHD);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HoaDon hd = new HoaDon();
                    hd.setMaHD(rs.getString("MaHD"));
                    hd.setMaBan(rs.getString("MaBan"));
                    hd.setMaNV(rs.getString("MaNV"));
                    hd.setNgayTao(rs.getString("NgayTao"));
                    hd.setTongTien(rs.getDouble("TongTien"));
                    hd.setTrangThai(rs.getString("TrangThai"));
                    hd.setDanhSachMon(rs.getString("DanhsachMon"));
                    hd.setMaGiamGia(rs.getString("MaGiamGia"));
                    return hd;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(HoaDon hd) {
        String sql = "INSERT INTO HoaDon (MaBan, MaNV, NgayTao, TongTien, TrangThai) VALUES (?,?,?,?,?)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, hd.getMaBan());
            ps.setString(2, hd.getMaNV());
            ps.setString(3, hd.getNgayTao());
            ps.setDouble(4, hd.getTongTien());
            ps.setString(5, hd.getTrangThai());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(HoaDon hd) {
        String sql = "UPDATE HoaDon SET MaBan = ?, MaNV = ?, NgayTao = ?, TongTien = ?, TrangThai = ? WHERE MaHD = ?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hd.getMaBan());
            ps.setString(2, hd.getMaNV());
            ps.setString(3, hd.getNgayTao());
            ps.setDouble(4, hd.getTongTien());
            ps.setString(5, hd.getTrangThai());
            ps.setString(6, hd.getMaHD());
            ps.executeUpdate();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(String maHD, String trangThai) {
        String sql = "UPDATE HoaDon SET TrangThai=? WHERE MaHD=?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, trangThai);
            ps.setString(2, maHD);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(String maHD) {
        String sql = "DELETE FROM HoaDon WHERE MaHD = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, maHD);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateBanStatus(String maBan, String trangThai) {
        String sql = "UPDATE BanAn SET TrangThai = ? WHERE MaBan = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, trangThai);
            ps.setString(2, maBan);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Menu> getAllMenu() {
        ArrayList<Menu> list = new ArrayList<>();
        String sql = "SELECT maMon, tenMon, loaiMon, gia, trangThai FROM menu";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Menu(
                        rs.getString("maMon"),
                        rs.getString("tenMon"),
                        rs.getString("loaiMon"),
                        rs.getBigDecimal("gia"),
                        rs.getBoolean("trangThai")
                ));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm insert đầy đủ dùng cho Servlet mới
    public void insertHoaDon(HoaDon hd) {
        String sql = "INSERT INTO HoaDon (MaNV, MaBan, NgayTao, MaGiamGia, TongTien, TrangThai, DanhsachMon) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hd.getMaNV());
            ps.setString(2, hd.getMaBan());
            ps.setString(3, hd.getNgayTao());
            ps.setString(4, hd.getMaGiamGia());
            ps.setDouble(5, hd.getTongTien());
            ps.setString(6, hd.getTrangThai());
            ps.setString(7, hd.getDanhSachMon());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Hàm update đầy đủ dùng cho Servlet mới
    public void updateHoaDon(HoaDon hd) {
        String sql = "UPDATE HoaDon SET MaBan = ?, TongTien = ?, TrangThai = ?, DanhsachMon = ?, MaGiamGia = ? WHERE MaHD = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hd.getMaBan());
            ps.setDouble(2, hd.getTongTien());
            ps.setString(3, hd.getTrangThai());
            ps.setString(4, hd.getDanhSachMon());
            ps.setString(5, hd.getMaGiamGia());
            ps.setString(6, hd.getMaHD());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- CÁC HÀM XỬ LÝ MÃ GIẢM GIÁ (ĐÃ ĐỒNG BỘ TIẾNG VIỆT & DBConnect) ---
    public ArrayList<MaGiamGia> getAllMaGiamGia() {
        ArrayList<MaGiamGia> list = new ArrayList<>();
        String query = "SELECT * FROM MaGiamGia";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MaGiamGia m = new MaGiamGia();
                m.setIDGiamGia(rs.getInt("IDGiamGia"));
                m.setMaCode(rs.getString("MaCode"));
                m.setPhanTramGiam(rs.getDouble("PhanTramGiam"));
                m.setDieuKienDonToiTieu(rs.getDouble("DieuKienDonToiTieu"));
                m.setNgayHetHan(rs.getString("NgayHetHan"));
                m.setTrangThai(rs.getInt("TrangThai"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertMaGiamGia(MaGiamGia m) {
        String query = "INSERT INTO MaGiamGia (MaCode, PhanTramGiam, DieuKienDonToiTieu, NgayHetHan, TrangThai) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, m.getMaCode());
            ps.setDouble(2, m.getPhanTramGiam());
            ps.setDouble(3, m.getDieuKienDonToiTieu());
            ps.setString(4, m.getNgayHetHan());
            ps.setInt(5, m.getTrangThai());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateMaGiamGia(MaGiamGia m) {
        String query = "UPDATE MaGiamGia SET MaCode = ?, PhanTramGiam = ?, DieuKienDonToiTieu = ?, NgayHetHan = ?, TrangThai = ? WHERE IDGiamGia = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, m.getMaCode());
            ps.setDouble(2, m.getPhanTramGiam());
            ps.setDouble(3, m.getDieuKienDonToiTieu());
            ps.setString(4, m.getNgayHetHan());
            ps.setInt(5, m.getTrangThai());
            ps.setInt(6, m.getIDGiamGia());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
        public Integer getMaHoaDonDangPhucVu(int maBan) {
    String sql = """
        SELECT TOP 1 MaHD
        FROM HoaDon
        WHERE MaBan = ?
          AND TrangThai = N'Đang phục vụ'
        ORDER BY MaHD DESC
    """;

    try (
        Connection con = DBConnect.getConnection();
        PreparedStatement ps = con.prepareStatement(sql)
    ) {
        ps.setInt(1, maBan);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("MaHD");
            }
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }

    return null;
}
    
    public Integer taoHoaDonMoi(String maNV, int maBan) {
    String sql = """
        INSERT INTO HoaDon (
            MaNV,
            MaBan,
            NgayTao,
            TongTien,
            TrangThai
        )
        VALUES (?, ?, GETDATE(), 0, N'Đang phục vụ')
    """;

    try (
        Connection con = DBConnect.getConnection();
        PreparedStatement ps = con.prepareStatement(
                sql,
                Statement.RETURN_GENERATED_KEYS
        )
    ) {
        ps.setString(1, maNV);
        ps.setInt(2, maBan);

        int affectedRows = ps.executeUpdate();

        if (affectedRows > 0) {
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }

    return null;
}
    
    public int taoHoacLayHoaDonDangPhucVu(
        String maNV,
        int maBan
) throws SQLException {

    try (Connection conn = DBConnect.getConnection()) {
        conn.setAutoCommit(false);

        try {
            Integer maHD = null;

            String findSql = """
                SELECT TOP 1 MaHD
                FROM HoaDon
                    WITH (UPDLOCK, HOLDLOCK)
                WHERE MaBan = ?
                  AND TrangThai = N'Đang phục vụ'
                ORDER BY MaHD DESC
            """;

            try (
                PreparedStatement ps =
                        conn.prepareStatement(findSql)
            ) {
                ps.setInt(1, maBan);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        maHD = rs.getInt("MaHD");
                    }
                }
            }

            if (maHD == null) {
                String insertSql = """
                    INSERT INTO HoaDon(
                        MaNV,
                        MaBan,
                        NgayTao,
                        TamTinh,
                        TienGiam,
                        ThueVAT,
                        TongTien,
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
                                    insertSql,
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
                                "Không tạo được hóa đơn."
                            );
                        }

                        maHD = keys.getInt(1);
                    }
                }
            }

            String updateBan = """
                UPDATE BanAn
                SET TrangThai = 1,
                    MaDonHang = ?
                WHERE MaBan = ?
            """;

            try (
                PreparedStatement ps =
                        conn.prepareStatement(updateBan)
            ) {
                ps.setString(
                        1,
                        String.valueOf(maHD)
                );

                ps.setInt(2, maBan);

                if (ps.executeUpdate() != 1) {
                    throw new SQLException(
                        "Không cập nhật được bàn."
                    );
                }
            }

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
        HoaDon hd,
        String[] maMons,
        String[] soLuongs
) throws SQLException {

    int maHD = Integer.parseInt(hd.getMaHD());
    int maBan = Integer.parseInt(hd.getMaBan());

    if (maMons == null
            || soLuongs == null
            || maMons.length == 0
            || maMons.length != soLuongs.length) {

        throw new SQLException(
            "Chưa chọn món cho đơn hàng."
        );
    }

    try (Connection conn = DBConnect.getConnection()) {
        conn.setAutoCommit(false);

        try {
            kiemTraHoaDonChuaThanhToan(
                    conn,
                    maHD
            );

            try (
                PreparedStatement ps =
                    conn.prepareStatement(
                        "DELETE FROM ChiTietHoaDon "
                        + "WHERE MaHD = ?"
                    )
            ) {
                ps.setInt(1, maHD);
                ps.executeUpdate();
            }

            long tamTinh = 0;

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

            try (
                PreparedStatement pricePs =
                        conn.prepareStatement(priceSql);

                PreparedStatement detailPs =
                        conn.prepareStatement(detailSql)
            ) {
                for (int i = 0;
                     i < maMons.length;
                     i++) {

                    String maMon =
                            maMons[i].trim();

                    int soLuong =
                            Integer.parseInt(
                                    soLuongs[i]
                            );

                    if (soLuong <= 0) {
                        throw new SQLException(
                            "Số lượng món không hợp lệ."
                        );
                    }

                    pricePs.setString(1, maMon);

                    long donGia;

                    try (
                        ResultSet rs =
                                pricePs.executeQuery()
                    ) {
                        if (!rs.next()) {
                            throw new SQLException(
                                "Không tìm thấy món "
                                + maMon
                            );
                        }

                        donGia =
                                rs.getLong("Gia");
                    }

                    detailPs.setInt(1, maHD);
                    detailPs.setString(2, maMon);
                    detailPs.setInt(3, soLuong);
                    detailPs.setLong(4, donGia);
                    detailPs.addBatch();

                    tamTinh += donGia * soLuong;
                }

                detailPs.executeBatch();
            }

            DiscountResult discount =
                    tinhGiamGia(
                            conn,
                            hd.getMaGiamGia(),
                            tamTinh
                    );

            long sauGiam =
                    tamTinh - discount.tienGiam;

            long vat =
                    Math.round(sauGiam * 0.08d);

            long tongTien =
                    sauGiam + vat;

            String updateSql = """
                UPDATE HoaDon
                SET MaBan = ?,
                    MaGiamGia = ?,
                    DanhSachMon = ?,
                    TamTinh = ?,
                    TienGiam = ?,
                    ThueVAT = ?,
                    TongTien = ?,
                    TrangThai = N'Đang phục vụ'
                WHERE MaHD = ?
            """;

            try (
                PreparedStatement ps =
                        conn.prepareStatement(
                                updateSql
                        )
            ) {
                ps.setInt(1, maBan);

                setNullableString(
                        ps,
                        2,
                        discount.maCode
                );

                ps.setString(
                        3,
                        hd.getDanhSachMon()
                );

                ps.setLong(4, tamTinh);
                ps.setLong(
                        5,
                        discount.tienGiam
                );
                ps.setLong(6, vat);
                ps.setLong(7, tongTien);
                ps.setInt(8, maHD);

                if (ps.executeUpdate() != 1) {
                    throw new SQLException(
                        "Không lưu được hóa đơn."
                    );
                }
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
        String maGiamGia,
        String phuongThucThanhToan
) throws SQLException {

    try (Connection conn = DBConnect.getConnection()) {
        conn.setAutoCommit(false);

        try {
            int maBan =
                    kiemTraHoaDonChuaThanhToan(
                            conn,
                            maHD
                    );

            long tamTinh =
                    layTamTinh(conn, maHD);

            if (tamTinh <= 0) {
                throw new SQLException(
                    "Hóa đơn chưa có món."
                );
            }

            DiscountResult discount =
                    tinhGiamGia(
                            conn,
                            maGiamGia,
                            tamTinh
                    );

            kiemTraDuNguyenLieu(
                    conn,
                    maHD
            );

            truKho(
                    conn,
                    maHD
            );

            long sauGiam =
                    tamTinh - discount.tienGiam;

            long vat =
                    Math.round(sauGiam * 0.08d);

            long tongTien =
                    sauGiam + vat;

            String sql = """
                UPDATE HoaDon
                SET MaGiamGia = ?,
                    TamTinh = ?,
                    TienGiam = ?,
                    ThueVAT = ?,
                    TongTien = ?,
                    TrangThai = N'Đã thanh toán',
                    PhuongThucThanhToan = ?,
                    NgayThanhToan = GETDATE()
                WHERE MaHD = ?
            """;

            try (
                PreparedStatement ps =
                        conn.prepareStatement(sql)
            ) {
                setNullableString(
                        ps,
                        1,
                        discount.maCode
                );

                ps.setLong(2, tamTinh);
                ps.setLong(
                        3,
                        discount.tienGiam
                );
                ps.setLong(4, vat);
                ps.setLong(5, tongTien);
                ps.setString(
                        6,
                        phuongThucThanhToan
                );
                ps.setInt(7, maHD);

                if (ps.executeUpdate() != 1) {
                    throw new SQLException(
                        "Không cập nhật được thanh toán."
                    );
                }
            }

            String updateBan = """
                UPDATE BanAn
                SET TrangThai = 0,
                    MaDonHang = NULL
                WHERE MaBan = ?
            """;

            try (
                PreparedStatement ps =
                    conn.prepareStatement(updateBan)
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
    
    private int kiemTraHoaDonChuaThanhToan(
        Connection conn,
        int maHD
) throws SQLException {

    String sql = """
        SELECT MaBan, TrangThai
        FROM HoaDon
            WITH (UPDLOCK, HOLDLOCK)
        WHERE MaHD = ?
    """;

    try (
        PreparedStatement ps =
                conn.prepareStatement(sql)
    ) {
        ps.setInt(1, maHD);

        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                throw new SQLException(
                    "Không tìm thấy hóa đơn."
                );
            }

            if ("Đã thanh toán".equalsIgnoreCase(
                    rs.getString("TrangThai")
            )) {
                throw new SQLException(
                    "Hóa đơn đã thanh toán."
                );
            }

            return rs.getInt("MaBan");
        }
    }
}

private long layTamTinh(
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

        try (ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getLong("TamTinh");
        }
    }
}

private DiscountResult tinhGiamGia(
        Connection conn,
        String maGiamGia,
        long tamTinh
) throws SQLException {

    if (maGiamGia == null
            || maGiamGia.isBlank()) {
        return new DiscountResult(
                null,
                0
        );
    }

    String sql = """
        SELECT MaCode, PhanTramGiam
        FROM MaGiamGia
        WHERE MaCode = ?
          AND TrangThai = 1
          AND (
              NgayHetHan IS NULL
              OR NgayHetHan
                 >= CAST(GETDATE() AS DATE)
          )
          AND DieuKienDonToiTieu <= ?
    """;

    try (
        PreparedStatement ps =
                conn.prepareStatement(sql)
    ) {
        ps.setString(
                1,
                maGiamGia.trim()
        );

        ps.setLong(2, tamTinh);

        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                throw new SQLException(
                    "Mã giảm giá không hợp lệ, "
                    + "đã hết hạn hoặc đơn "
                    + "chưa đủ điều kiện."
                );
            }

            double phanTram =
                    rs.getDouble(
                            "PhanTramGiam"
                    );

            long tienGiam =
                    Math.round(
                            tamTinh
                            * phanTram
                            / 100d
                    );

            return new DiscountResult(
                    rs.getString("MaCode"),
                    tienGiam
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
                CTM.MaNL,
                SUM(
                    CTM.SoLuongCan
                    * CTHD.SoLuong
                ) AS SoLuongCan
            FROM ChiTietHoaDon CTHD
            JOIN CongThucMon CTM
                ON CTM.MaMon = CTHD.MaMon
            WHERE CTHD.MaHD = ?
            GROUP BY CTM.MaNL
        )
        SELECT TOP 1
            K.MaNL,
            K.TenNL,
            K.SoLuong,
            CD.SoLuongCan
        FROM CanDung CD
        LEFT JOIN Kho K
            ON K.MaNL = CD.MaNL
        WHERE K.MaNL IS NULL
           OR K.SoLuong < CD.SoLuongCan
    """;

    try (
        PreparedStatement ps =
                conn.prepareStatement(sql)
    ) {
        ps.setInt(1, maHD);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String tenNL =
                        rs.getString("TenNL");

                if (tenNL == null) {
                    tenNL =
                            rs.getString("MaNL");
                }

                throw new SQLException(
                    "Không đủ nguyên liệu: "
                    + tenNL
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
                CTM.MaNL,
                SUM(
                    CTM.SoLuongCan
                    * CTHD.SoLuong
                ) AS SoLuongCan
            FROM ChiTietHoaDon CTHD
            JOIN CongThucMon CTM
                ON CTM.MaMon = CTHD.MaMon
            WHERE CTHD.MaHD = ?
            GROUP BY CTM.MaNL
        )
        UPDATE K
        SET K.SoLuong =
            K.SoLuong - CD.SoLuongCan
        FROM Kho K
        JOIN CanDung CD
            ON CD.MaNL = K.MaNL
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

    if (value == null || value.isBlank()) {
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

private static final class DiscountResult {

    private final String maCode;
    private final long tienGiam;

    private DiscountResult(
            String maCode,
            long tienGiam
    ) {
        this.maCode = maCode;
        this.tienGiam = tienGiam;
    }
}

public ArrayList<MaGiamGia>
getMaGiamGiaConHieuLuc() {

    ArrayList<MaGiamGia> list =
            new ArrayList<>();

    String sql = """
        SELECT *
        FROM MaGiamGia
        WHERE TrangThai = 1
          AND (
              NgayHetHan IS NULL
              OR NgayHetHan
                 >= CAST(GETDATE() AS DATE)
          )
        ORDER BY IDGiamGia DESC
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
            MaGiamGia m =
                    new MaGiamGia();

            m.setIDGiamGia(
                    rs.getInt("IDGiamGia")
            );

            m.setMaCode(
                    rs.getString("MaCode")
            );

            m.setPhanTramGiam(
                    rs.getDouble(
                            "PhanTramGiam"
                    )
            );

            m.setDieuKienDonToiTieu(
                    rs.getDouble(
                        "DieuKienDonToiTieu"
                    )
            );

            m.setNgayHetHan(
                    rs.getString("NgayHetHan")
            );

            m.setTrangThai(
                    rs.getInt("TrangThai")
            );

            list.add(m);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}
}
