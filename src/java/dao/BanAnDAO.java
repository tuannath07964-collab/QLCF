package dao;

import model.BanAn;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * BanAnDAO - Data Access Object for Dining Tables (Bàn Ăn)
 * Sử dụng try-with-resources pattern để tự động đóng tài nguyên
 */
public class BanAnDAO {

    // Lấy tất cả bàn
    public List<BanAn> getAll() {
        List<BanAn> list = new ArrayList<>();
        String sql = "SELECT * FROM BanAn";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToBanAn(rs));
            }

        } catch (Exception e) {
            System.err.println("[BanAnDAO] Error in getAll: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // Lấy bàn theo mã
    public BanAn getById(int id) {
        String sql = "SELECT * FROM BanAn WHERE MaBan=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBanAn(rs);
                }
            }

        } catch (Exception e) {
            System.err.println("[BanAnDAO] Error in getById: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Thêm bàn
    public boolean insert(BanAn b) {
        String sql = "INSERT INTO BanAn(TenBan,ViTri,SoGhe,TrangThai) VALUES(?,?,?,?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, b.getTenBan());
            ps.setString(2, b.getViTri());
            ps.setInt(3, b.getSoGhe());
            ps.setString(4, b.getTrangThai());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[BanAnDAO] Error in insert: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật bàn
    public boolean update(BanAn b) {
        String sql = "UPDATE BanAn SET TenBan=?,ViTri=?,SoGhe=?,TrangThai=? WHERE MaBan=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, b.getTenBan());
            ps.setString(2, b.getViTri());
            ps.setInt(3, b.getSoGhe());
            ps.setString(4, b.getTrangThai());
            ps.setInt(5, b.getMaBan());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[BanAnDAO] Error in update: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Xóa bàn
    public boolean delete(int id) {
        String sql = "DELETE FROM BanAn WHERE MaBan=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[BanAnDAO] Error in delete: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Helper method - Map ResultSet to BanAn
    private BanAn mapResultSetToBanAn(ResultSet rs) throws Exception {
        BanAn b = new BanAn();
        b.setMaBan(rs.getInt("MaBan"));
        b.setTenBan(rs.getString("TenBan"));
        b.setViTri(rs.getString("ViTri"));
        b.setSoGhe(rs.getInt("SoGhe"));
        b.setTrangThai(rs.getString("TrangThai"));
        return b;
    }
}
