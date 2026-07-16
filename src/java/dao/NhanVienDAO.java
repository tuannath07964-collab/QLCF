package dao;

import model.NhanVien;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class NhanVienDAO {

    // ==========================
    // Lấy toàn bộ nhân viên
    // ==========================
    public ArrayList<NhanVien> getAllNhanVien() {

        ArrayList<NhanVien> list = new ArrayList<>();

        String sql = "SELECT * FROM NhanVien ORDER BY MaNV";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                NhanVien nv = new NhanVien();

                nv.setMaNV(rs.getString("MaNV"));
                nv.setHoTen(rs.getString("HoTen"));
                nv.setGioiTinh(rs.getString("GioiTinh"));
                nv.setNgaySinh(rs.getDate("NgaySinh"));
                nv.setSdt(rs.getString("SDT"));
                nv.setDiaChi(rs.getString("DiaChi"));
                nv.setChucVu(rs.getString("ChucVu"));
                nv.setLuong(rs.getDouble("Luong"));
                nv.setTrangThai(rs.getString("TrangThai"));

                list.add(nv);
            }

            System.out.println("Đã lấy " + list.size() + " nhân viên.");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ==========================
    // Lấy theo mã
    // ==========================
    public NhanVien getNhanVienById(String maNV) {

        String sql = "SELECT * FROM NhanVien WHERE MaNV=?";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, maNV);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                NhanVien nv = new NhanVien();

                nv.setMaNV(rs.getString("MaNV"));
                nv.setHoTen(rs.getString("HoTen"));
                nv.setGioiTinh(rs.getString("GioiTinh"));
                nv.setNgaySinh(rs.getDate("NgaySinh"));
                nv.setSdt(rs.getString("SDT"));
                nv.setDiaChi(rs.getString("DiaChi"));
                nv.setChucVu(rs.getString("ChucVu"));
                nv.setLuong(rs.getDouble("Luong"));
                nv.setTrangThai(rs.getString("TrangThai"));

                return nv;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Alias
    public NhanVien getNhanVien(String maNV) {
        return getNhanVienById(maNV);
    }

// ==========================
// Thêm
// ==========================
public boolean insertNhanVien(NhanVien nv) {

    String sql =
        "INSERT INTO NhanVien(MaNV,HoTen,GioiTinh,NgaySinh,SDT,DiaChi,ChucVu,Luong,TrangThai) VALUES(?,?,?,?,?,?,?,?,?)";

    try (
Connection conn = DBConnect.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)
    ) {

        System.out.println("Connection = " + conn);

        ps.setString(1, nv.getMaNV());
        ps.setString(2, nv.getHoTen());
        ps.setString(3, nv.getGioiTinh());
        ps.setDate(4, new java.sql.Date(nv.getNgaySinh().getTime()));
        ps.setString(5, nv.getSdt());
        ps.setString(6, nv.getDiaChi());
        ps.setString(7, nv.getChucVu());
        ps.setDouble(8, nv.getLuong());
        ps.setString(9, nv.getTrangThai());

        int rows = ps.executeUpdate();

        System.out.println("Rows = " + rows);

        return rows > 0;

    } catch (Exception e) {

        e.printStackTrace();

    }

    return false;
}
    // ==========================
    // Sửa
    // ==========================
    public boolean updateNhanVien(NhanVien nv) {

        String sql = "UPDATE NhanVien SET "
                + "HoTen=?,"
                + "GioiTinh=?,"
                + "NgaySinh=?,"
                + "SDT=?,"
                + "DiaChi=?,"
                + "ChucVu=?,"
                + "Luong=?,"
                + "TrangThai=? "
                + "WHERE MaNV=?";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, nv.getHoTen());
            ps.setString(2, nv.getGioiTinh());
            ps.setDate(3, new java.sql.Date(nv.getNgaySinh().getTime()));
            ps.setString(4, nv.getSdt());
            ps.setString(5, nv.getDiaChi());
            ps.setString(6, nv.getChucVu());
            ps.setDouble(7, nv.getLuong());
            ps.setString(8, nv.getTrangThai());
            ps.setString(9, nv.getMaNV());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==========================
    // Xóa
    // ==========================
    public boolean deleteNhanVien(String maNV) {

        String sql = "DELETE FROM NhanVien WHERE MaNV=?";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, maNV);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==========================
    // Tìm kiếm
    // ==========================
    public ArrayList<NhanVien> searchNhanVien(String keyword) {

        ArrayList<NhanVien> list = new ArrayList<>();

        String sql = "SELECT * FROM NhanVien "
                + "WHERE MaNV LIKE ? OR HoTen LIKE ? "
                + "ORDER BY MaNV";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                NhanVien nv = new NhanVien();

                nv.setMaNV(rs.getString("MaNV"));
                nv.setHoTen(rs.getString("HoTen"));
                nv.setGioiTinh(rs.getString("GioiTinh"));
                nv.setNgaySinh(rs.getDate("NgaySinh"));
                nv.setSdt(rs.getString("SDT"));
                nv.setDiaChi(rs.getString("DiaChi"));
                nv.setChucVu(rs.getString("ChucVu"));
                nv.setLuong(rs.getDouble("Luong"));
                nv.setTrangThai(rs.getString("TrangThai"));

                list.add(nv);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}