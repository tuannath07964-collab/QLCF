package dao;

import model.NguyenLieu;
import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;

public class khoDAO {

    public ArrayList<NguyenLieu> getAllNguyenLieu() {
        ArrayList<NguyenLieu> list = new ArrayList<>();
        String sql = "SELECT maNL, tenNL, soLuong, donVi FROM kho";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.err.println("LỖI KẾT NỐI DATABASE KHO: " + e.getMessage());
        }
        return list;
    }

    public NguyenLieu getNguyenLieuById(String maNL) {
        String sql = "SELECT * FROM kho WHERE maNL = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maNL);
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

    public boolean insertNguyenLieu(NguyenLieu nl) {
        String sql = "INSERT INTO kho(maNL, tenNL, soLuong, donVi) VALUES(?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nl.getMaNL());
            ps.setString(2, nl.getTenNL());
            ps.setInt(3, nl.getSoLuong());
            ps.setString(4, nl.getDonVi());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateNguyenLieu(NguyenLieu nl) {
        String sql = "UPDATE kho SET tenNL = ?, soLuong = ?, donVi = ? WHERE maNL = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nl.getTenNL());
            ps.setInt(2, nl.getSoLuong());
            ps.setString(3, nl.getDonVi());
            ps.setString(4, nl.getMaNL());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteNguyenLieu(String maNL) {
        String sql = "DELETE FROM kho WHERE maNL = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maNL);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private NguyenLieu mapRow(ResultSet rs) throws SQLException {
        NguyenLieu nl = new NguyenLieu();
        nl.setMaNL(rs.getString("maNL"));
        nl.setTenNL(rs.getString("tenNL"));
        nl.setSoLuong(rs.getInt("soLuong"));
        nl.setDonVi(rs.getString("donVi"));
        return nl;
    }
}