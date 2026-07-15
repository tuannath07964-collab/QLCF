package dao;

import model.KhachHang;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * KhachHangDAO - Data Access Object for Customers (Khách Hàng)
 * Sử dụng try-with-resources pattern để tự động đóng tài nguyên
 */
public class KhachHangDAO {

    // Lấy tất cả khách hàng
    public List<KhachHang> getAll() {
        List<KhachHang> list = new ArrayList<>();
        String sql = "SELECT * FROM KhachHang";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToKhachHang(rs));
            }

        } catch (Exception e) {
            System.err.println("[KhachHangDAO] Error in getAll: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // Lấy khách hàng theo mã
    public KhachHang getById(int id) {
        String sql = "SELECT * FROM KhachHang WHERE MaKH=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToKhachHang(rs);
                }
            }

        } catch (Exception e) {
            System.err.println("[KhachHangDAO] Error in getById: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Thêm khách hàng
    public boolean insert(KhachHang kh) {
        String sql = "INSERT INTO KhachHang(TenKH,SDT,DiaChi,GioiTinh,TrangThai) VALUES(?,?,?,?,?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, kh.getTenKH());
            ps.setString(2, kh.getSdt());
            ps.setString(3, kh.getDiaChi());
            ps.setString(4, kh.getGioiTinh());
            ps.setString(5, kh.getTrangThai());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[KhachHangDAO] Error in insert: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật khách hàng
    public boolean update(KhachHang kh) {
        String sql = "UPDATE KhachHang SET TenKH=?,SDT=?,DiaChi=?,GioiTinh=?,TrangThai=? WHERE MaKH=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, kh.getTenKH());
            ps.setString(2, kh.getSdt());
            ps.setString(3, kh.getDiaChi());
            ps.setString(4, kh.getGioiTinh());
            ps.setString(5, kh.getTrangThai());
            ps.setInt(6, kh.getMaKH());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[KhachHangDAO] Error in update: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Xóa khách hàng
    public boolean delete(int id) {
        String sql = "DELETE FROM KhachHang WHERE MaKH=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[KhachHangDAO] Error in delete: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Tìm kiếm khách hàng
    public List<KhachHang> search(String keyword) {
        List<KhachHang> list = new ArrayList<>();
        String sql = "SELECT * FROM KhachHang WHERE TenKH LIKE ? OR SDT LIKE ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToKhachHang(rs));
                }
            }

        } catch (Exception e) {
            System.err.println("[KhachHangDAO] Error in search: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // Helper method - Map ResultSet to KhachHang
    private KhachHang mapResultSetToKhachHang(ResultSet rs) throws Exception {
        KhachHang kh = new KhachHang();
        kh.setMaKH(rs.getInt("MaKH"));
        kh.setTenKH(rs.getString("TenKH"));
        kh.setSdt(rs.getString("SDT"));
        kh.setDiaChi(rs.getString("DiaChi"));
        kh.setGioiTinh(rs.getString("GioiTinh"));
        kh.setTrangThai(rs.getString("TrangThai"));
        return kh;
    }
}
