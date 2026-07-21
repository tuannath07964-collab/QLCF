package dao;

import model.KhachHang;
import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;

public class KhachHangDAO {

    public ArrayList<KhachHang> getAllKhachHang() {
        ArrayList<KhachHang> list = new ArrayList<>();
        String sql = "SELECT MaKH, HoTen, SDT, MaGiamGia FROM KhachHang";
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.err.println("LỖI KẾT NỐI DATABASE: " + e.getMessage());
        }
        return list;
    }

    public KhachHang getKhachHangById(String maKH) {
        String sql = "SELECT MaKH, HoTen, SDT, MaGiamGia FROM KhachHang WHERE MaKH = ?";
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maKH);
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

    public boolean insertKhachHang(KhachHang kh) {
        String sql = "INSERT INTO KhachHang(MaKH, HoTen, SDT, MaGiamGia) VALUES(?,?,?,?)";
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kh.getMaKH());
            ps.setString(2, kh.getHoTen());
            ps.setString(3, kh.getSdt());
            ps.setString(4, kh.getMaGiamGia());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateKhachHang(KhachHang kh) {
        String sql = "UPDATE KhachHang SET HoTen=?, SDT=?, MaGiamGia=? WHERE MaKH=?";
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kh.getHoTen());
            ps.setString(2, kh.getSdt());
            ps.setString(3, kh.getMaGiamGia());
            ps.setString(4, kh.getMaKH());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteKhachHang(String maKH) {
        String sql = "DELETE FROM KhachHang WHERE MaKH=?";
        try (Connection conn = DBConnect.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maKH);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Phương thức ánh xạ dữ liệu từ ResultSet vào Object
    private KhachHang mapRow(ResultSet rs) throws SQLException {
        KhachHang kh = new KhachHang();
        kh.setMaKH(rs.getString("MaKH"));
        kh.setHoTen(rs.getString("HoTen"));
        kh.setSdt(rs.getString("SDT"));
        kh.setMaGiamGia(rs.getString("MaGiamGia"));
        return kh;
    }
}