package dao;

import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import model.HoaDon;

public class HoaDonDAO extends DBConnect {

    public String getNextMaHD() {
        String newId = "HD001";
        String sql = "SELECT TOP 1 MaHD FROM HoaDon ORDER BY MaHD DESC";
        try {
            // Sửa lỗi: Gọi getConnection() thay vì biến connection
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String lastId = rs.getString("MaHD");
                int number = Integer.parseInt(lastId.substring(2)) + 1;
                newId = "HD" + String.format("%03d", number);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newId;
    }

    public boolean isBanExists(String maBan) {
        String sql = "SELECT MaBan FROM Ban WHERE MaBan = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, maBan);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<HoaDon> getAll() {
        ArrayList<HoaDon> list = new ArrayList<>();
        String sql = "SELECT H.*, "
                + "(SELECT ISNULL(SUM(CT.SoLuong * CT.DonGia), 0) "
                + " FROM ChiTietHoaDon CT WHERE CT.MaHD = H.MaHD) AS TongTienMoi "
                + "FROM HoaDon H";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new HoaDon(
                        rs.getString("MaHD"),
                        rs.getString("MaBan"),
                        rs.getString("MaNV"),
                        rs.getString("NgayTao"),
                        rs.getDouble("TongTienMoi"), // Sử dụng kết quả tính toán từ subquery
                        rs.getString("TrangThai")
                ));
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
        String sql = "SELECT MaHD, MaBan, MaNV, NgayTao, TongTien, TrangThai FROM HoaDon WHERE MaHD = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, maHD);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new HoaDon(
                        rs.getString("MaHD"),
                        rs.getString("MaBan"),
                        rs.getString("MaNV"),
                        rs.getString("NgayTao"),
                        rs.getDouble("TongTien"),
                        rs.getString("TrangThai")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(HoaDon hd) {
        String sql = "INSERT INTO HoaDon VALUES (?,?,?,?,?,?)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, hd.getMaHD());
            ps.setString(2, hd.getMaBan());
            ps.setString(3, hd.getMaNV());
            ps.setString(4, hd.getNgayTao());
            ps.setDouble(5, hd.getTongTien());
            ps.setString(6, hd.getTrangThai());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(HoaDon hd) {
        String sql = "UPDATE HoaDon SET MaBan=?, MaNV=?, NgayTao=?, TongTien=?, TrangThai=? WHERE MaHD=?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, hd.getMaBan());
            ps.setString(2, hd.getMaNV());
            ps.setString(3, hd.getNgayTao());
            ps.setDouble(4, hd.getTongTien());
            ps.setString(5, hd.getTrangThai());
            ps.setString(6, hd.getMaHD());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(String maHD, String trangThai) {
        String sql = "UPDATE HoaDon SET TrangThai=? WHERE MaHD=?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, trangThai);
            ps.setString(2, maHD);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(String maHD) {
        String sql = "DELETE FROM HoaDon WHERE MaHD = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, maHD);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Thêm hàm này vào HoaDonDAO.java
    public void updateBanStatus(String maBan, String trangThai) {
        String sql = "UPDATE Ban SET TrangThai = ? WHERE MaBan = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, trangThai);
            ps.setString(2, maBan);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateTongTien(String maHD) {
        // Câu lệnh SQL tính tổng tiền từ chi tiết hóa đơn
        String sql = "UPDATE HoaDon SET TongTien = (SELECT SUM(SoLuong * DonGia) FROM ChiTietHoaDon WHERE MaHD = ?) WHERE MaHD = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, maHD);
            ps.setString(2, maHD);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
