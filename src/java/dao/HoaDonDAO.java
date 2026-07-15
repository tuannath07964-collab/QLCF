package dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.HoaDon;
import util.DBConnect;

public class HoaDonDAO {

    public ArrayList<HoaDon> getAll() {
        ArrayList<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM HoaDon ORDER BY NgayTao DESC";

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
                hd.setTongTien(rs.getDouble("TongTien"));
                hd.setTrangThai(rs.getString("TrangThai"));
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
        String sql = "SELECT * FROM HoaDon WHERE MaHD = ?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, maHD);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HoaDon hd = new HoaDon();
                hd.setMaHD(rs.getString("MaHD"));
                hd.setMaBan(rs.getString("MaBan"));
                hd.setMaNV(rs.getString("MaNV"));
                hd.setNgayTao(rs.getString("NgayTao"));
                hd.setTongTien(rs.getDouble("TongTien"));
                hd.setTrangThai(rs.getString("TrangThai"));
                
                rs.close(); ps.close(); conn.close();
                return hd;
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(HoaDon hd) {
        String sql = "INSERT INTO HoaDon (MaHD, MaBan, MaNV, NgayTao, TongTien, TrangThai) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hd.getMaHD());
            ps.setString(2, hd.getMaBan());
            ps.setString(3, hd.getMaNV());
            ps.setString(4, hd.getNgayTao());
            ps.setDouble(5, hd.getTongTien());
            ps.setString(6, hd.getTrangThai());
            ps.executeUpdate();
            ps.close(); conn.close();
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
            ps.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(String maHD, String trangThai) {
        String sql = "UPDATE HoaDon SET TrangThai = ? WHERE MaHD = ?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, trangThai);
            ps.setString(2, maHD);
            ps.executeUpdate();
            ps.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(String maHD) {
        String sql = "DELETE FROM HoaDon WHERE MaHD = ?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, maHD);
            ps.executeUpdate();
            ps.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}