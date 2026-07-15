package dao;

import model.Menu;
import util.DatabaseConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * MenuDAO - Data Access Object for Menu Items.
 * Uses try-with-resources pattern for safe resource management.
 */
public class MenuDAO {

    // Lấy tất cả món
    public List<Menu> getAll() {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT * FROM Menu";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Menu m = mapResultSetToMenu(rs);
                list.add(m);
            }

        } catch (Exception e) {
            System.err.println("[MenuDAO] Error in getAll: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // Tìm theo mã
    public Menu getById(int id) {
        String sql = "SELECT * FROM Menu WHERE MaMon=?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMenu(rs);
                }
            }

        } catch (Exception e) {
            System.err.println("[MenuDAO] Error in getById: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Thêm món
    public boolean insert(Menu m) {
        String sql = "INSERT INTO Menu(TenMon,Loai,Gia,TrangThai,HinhAnh) VALUES(?,?,?,?,?)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getTenMon());
            ps.setString(2, m.getLoai());
            ps.setDouble(3, m.getGia());
            ps.setString(4, m.getTrangThai());
            ps.setString(5, m.getHinhAnh());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[MenuDAO] Error in insert: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Sửa món
    public boolean update(Menu m) {
        String sql = "UPDATE Menu SET TenMon=?,Loai=?,Gia=?,TrangThai=?,HinhAnh=? WHERE MaMon=?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getTenMon());
            ps.setString(2, m.getLoai());
            ps.setDouble(3, m.getGia());
            ps.setString(4, m.getTrangThai());
            ps.setString(5, m.getHinhAnh());
            ps.setInt(6, m.getMaMon());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[MenuDAO] Error in update: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Xóa món
    public boolean delete(int id) {
        String sql = "DELETE FROM Menu WHERE MaMon=?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("[MenuDAO] Error in delete: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Helper method
    private Menu mapResultSetToMenu(ResultSet rs) throws Exception {
        Menu m = new Menu();
        m.setMaMon(rs.getInt("MaMon"));
        m.setTenMon(rs.getString("TenMon"));
        m.setLoai(rs.getString("Loai"));
        m.setGia(rs.getDouble("Gia"));
        m.setTrangThai(rs.getString("TrangThai"));
        m.setHinhAnh(rs.getString("HinhAnh"));
        return m;
    }
}
