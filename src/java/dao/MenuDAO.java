package dao;

import model.Menu;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {

    // Lấy danh sách món
    public List<Menu> getAll() {

        List<Menu> list = new ArrayList<>();

        String sql = "SELECT * FROM Menu ORDER BY MaMon";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Menu m = new Menu();

                m.setMaMon(rs.getInt("MaMon"));
                m.setTenMon(rs.getString("TenMon"));
                m.setLoai(rs.getString("Loai"));
                m.setGia(rs.getDouble("Gia"));
                m.setTrangThai(rs.getString("TrangThai"));
                m.setHinhAnh(rs.getString("HinhAnh"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Tìm món theo mã
    public Menu getById(int id) {

        String sql = "SELECT * FROM Menu WHERE MaMon=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Menu m = new Menu();

                m.setMaMon(rs.getInt("MaMon"));
                m.setTenMon(rs.getString("TenMon"));
                m.setLoai(rs.getString("Loai"));
                m.setGia(rs.getDouble("Gia"));
                m.setTrangThai(rs.getString("TrangThai"));
                m.setHinhAnh(rs.getString("HinhAnh"));

                return m;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm món
    public boolean insert(Menu m) {

        String sql = "INSERT INTO Menu(TenMon,Loai,Gia,TrangThai,HinhAnh) VALUES(?,?,?,?,?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getTenMon());
            ps.setString(2, m.getLoai());
            ps.setDouble(3, m.getGia());
            ps.setString(4, m.getTrangThai());
            ps.setString(5, m.getHinhAnh());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật món
    public boolean update(Menu m) {

        String sql = "UPDATE Menu SET TenMon=?, Loai=?, Gia=?, TrangThai=?, HinhAnh=? WHERE MaMon=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getTenMon());
            ps.setString(2, m.getLoai());
            ps.setDouble(3, m.getGia());
            ps.setString(4, m.getTrangThai());
            ps.setString(5, m.getHinhAnh());
            ps.setInt(6, m.getMaMon());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa món
    public boolean delete(int id) {

        String sql = "DELETE FROM Menu WHERE MaMon=?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}