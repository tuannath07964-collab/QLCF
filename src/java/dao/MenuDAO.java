package dao;

import model.Menu;
import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;

public class MenuDAO {

    public ArrayList<Menu> getAllMenu() {
        ArrayList<Menu> list = new ArrayList<>();
        String sql = "SELECT maMon, tenMon, loaiMon, gia, trangThai FROM menu";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.err.println("LỖI KẾT NỐI DATABASE: " + e.getMessage());
        }
        return list;
    }

    public Menu getMenuById(String maMon) {
        String sql = "SELECT * FROM menu WHERE maMon = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maMon);
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

    public boolean insertMenu(Menu m) {
        String sql = "INSERT INTO menu(maMon, tenMon, loaiMon, gia, trangThai) VALUES(?,?,?,?,?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getMaMon());
            ps.setString(2, m.getTenMon());
            ps.setString(3, m.getLoaiMon());
            ps.setBigDecimal(4, m.getGia());
            ps.setBoolean(5, m.isTrangThai());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateMenu(Menu m) {
        String sql = "UPDATE menu SET tenMon=?, loaiMon=?, gia=?, trangThai=? WHERE maMon=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getTenMon());
            ps.setString(2, m.getLoaiMon());
            ps.setBigDecimal(3, m.getGia());
            ps.setBoolean(4, m.isTrangThai());
            ps.setString(5, m.getMaMon());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteMenu(String maMon) {
        String sql = "DELETE FROM menu WHERE maMon=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maMon);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Menu mapRow(ResultSet rs) throws SQLException {
        Menu m = new Menu();
        m.setMaMon(rs.getString("maMon"));
        m.setTenMon(rs.getString("tenMon"));
        m.setLoaiMon(rs.getString("loaiMon"));
        m.setGia(rs.getBigDecimal("gia"));
        m.setTrangThai(rs.getBoolean("trangThai"));
        return m;
    }
    
    public ArrayList<Menu> getMenuByType(String loaiMon) {
    ArrayList<Menu> list = new ArrayList<>();
    String sql = "SELECT * FROM menu WHERE loaiMon = ?";
    try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, loaiMon);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}