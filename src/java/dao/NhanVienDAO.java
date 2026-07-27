package dao;

import model.NhanVien;
import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.sql.Types;

public class NhanVienDAO {

    public ArrayList<NhanVien> getAllNhanVien() {
        ArrayList<NhanVien> list = new ArrayList<>();
        String sql = "SELECT MaNV, HoTen, GioiTinh, NgaySinh, SDT, ChucVu, LuongCoBan, MatKhau, caSang, caChieu, caToi, gioBatDau, gioKetThuc FROM NhanVien";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.err.println("LỖI KẾT NỐI DATABASE: " + e.getMessage());
        }
        return list;
    }

    public NhanVien getNhanVienById(String maNV) {
        String sql = "SELECT * FROM NhanVien WHERE MaNV = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maNV);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String insertNhanVien(NhanVien nv) throws SQLException {
        String sql = """
        INSERT INTO NhanVien(
            MaNV,
            HoTen,
            ChucVu,
            SDT,
            LuongCoBan,
            GioiTinh,
            NgaySinh,
            MatKhau
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """;

        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) {
                throw new SQLException("Không kết nối được database.");
            }

            conn.setAutoCommit(false);

            try {
                String maNVMoi = taoMaNhanVien(conn);

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, maNVMoi);
                    ps.setString(2, nv.getHoTen());

                    if (nv.getChucVu() == null
                            || nv.getChucVu().isBlank()) {
                        ps.setNull(3, Types.NVARCHAR);
                    } else {
                        ps.setString(3, nv.getChucVu().trim());
                    }

                    ps.setString(4, nv.getSdt());

                    ps.setBigDecimal(
                            5,
                            nv.getLuongCoBan() == null
                            ? BigDecimal.ZERO
                            : nv.getLuongCoBan()
                    );

                    ps.setString(6, nv.getGioiTinh());

                    if (nv.getNgaySinh() == null) {
                        ps.setNull(7, Types.DATE);
                    } else {
                        ps.setDate(7, nv.getNgaySinh());
                    }

                    String matKhau = nv.getMatKhau();

                    ps.setString(
                            8,
                            matKhau == null || matKhau.isBlank()
                            ? "123456"
                            : matKhau.trim()
                    );

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException(
                                "Không thêm được nhân viên."
                        );
                    }
                }

                conn.commit();
                return maNVMoi;

            } catch (SQLException e) {
                conn.rollback();
                throw e;

            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    private String taoMaNhanVien(Connection conn)
            throws SQLException {

        String sql = """
        SELECT N'NV'
             + RIGHT(
                 N'0000'
                 + CAST(
                     NEXT VALUE FOR dbo.Seq_NhanVien
                     AS NVARCHAR(10)
                 ),
                 4
             )
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getString(1);
            }
        }

        throw new SQLException(
                "Không tự sinh được mã nhân viên."
        );
    }

    public boolean updateNhanVien(NhanVien nv) {
        // Đã bổ sung cập nhật thêm cột MatKhau vào câu lệnh UPDATE
        String sql = "UPDATE NhanVien SET HoTen=?, ChucVu=?, SDT=?, LuongCoBan=?, GioiTinh=?, NgaySinh=?, MatKhau=? WHERE MaNV=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nv.getHoTen());
            if (nv.getChucVu() == null
                    || nv.getChucVu().isBlank()) {
                ps.setNull(2, Types.NVARCHAR);
            } else {
                ps.setString(2, nv.getChucVu().trim());
            }
            ps.setString(3, nv.getSdt());
            ps.setBigDecimal(
                    4,
                    nv.getLuongCoBan() == null
                    ? BigDecimal.ZERO
                    : nv.getLuongCoBan()
            );
            ps.setString(5, nv.getGioiTinh());

            if (nv.getNgaySinh() != null) {
                ps.setDate(6, new java.sql.Date(nv.getNgaySinh().getTime()));
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }

            ps.setString(7, nv.getMatKhau()); // Thêm tham số mật khẩu khi sửa
            ps.setString(8, nv.getMaNV());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteNhanVien(String maNV) {
        String sql = "DELETE FROM NhanVien WHERE MaNV=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maNV);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateCaLam(String maNV, boolean caSang, boolean caChieu, boolean caToi, String gioBatDau, String gioKetThuc) throws Exception {
        String sql = "UPDATE NhanVien SET caSang = ?, caChieu = ?, caToi = ?, gioBatDau = ?, gioKetThuc = ? WHERE MaNV = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, caSang);
            ps.setBoolean(2, caChieu);
            ps.setBoolean(3, caToi);
            ps.setString(4, gioBatDau);
            ps.setString(5, gioKetThuc);
            ps.setString(6, maNV);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public NhanVien checkLogin(
            String maNV,
            String matKhau
    ) {
        if (maNV == null || matKhau == null) {
            return null;
        }

        String sql = """
        SELECT *
        FROM NhanVien
        WHERE UPPER(LTRIM(RTRIM(MaNV))) = UPPER(?)
          AND MatKhau = ?
    """;

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maNV.trim());
            ps.setString(2, matKhau.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    private NhanVien mapRow(ResultSet rs) throws SQLException {
        NhanVien nv = new NhanVien();
        nv.setMaNV(rs.getString("MaNV"));
        nv.setHoTen(rs.getString("HoTen"));
        nv.setChucVu(rs.getString("ChucVu"));
        nv.setSdt(rs.getString("SDT"));
        nv.setLuongCoBan(rs.getBigDecimal("LuongCoBan"));
        nv.setGioiTinh(rs.getString("GioiTinh"));
        nv.setNgaySinh(rs.getDate("NgaySinh"));

        try {
            nv.setMatKhau(rs.getString("MatKhau"));
        } catch (Exception e) {
            // Phòng hờ
        }

        nv.setCaSang(rs.getBoolean("caSang"));
        nv.setCaChieu(rs.getBoolean("caChieu"));
        nv.setCaToi(rs.getBoolean("caToi"));
        nv.setGioBatDau(rs.getString("gioBatDau"));
        nv.setGioKetThuc(rs.getString("gioKetThuc"));

        return nv;
    }
}
