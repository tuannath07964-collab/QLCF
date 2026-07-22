package dao;

import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import model.HoaDon;
import model.Menu;

public class HoaDonDAO extends DBConnect {

    // Lấy mã hóa đơn tiếp theo dựa vào giá trị tự tăng IDENTITY hiện tại
    public String getNextMaHD() {
        int nextId = 1;
        String sql = "SELECT IDENT_CURRENT('HoaDon') + 1";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                nextId = (int) rs.getDouble(1);
                if (nextId <= 0) {
                    nextId = 1;
                }
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return String.valueOf(nextId);
    }

    public boolean isBanExists(String maBan) {
        String sql = "SELECT MaBan FROM BanAn WHERE MaBan = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, maBan);
            ResultSet rs = ps.executeQuery();
            boolean exists = rs.next();
            rs.close();
            ps.close();
            return exists;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<HoaDon> getAll() {
        ArrayList<HoaDon> list = new ArrayList<>();
        String sql = "SELECT MaHD, MaBan, MaNV, NgayTao, TongTien, TrangThai FROM HoaDon";
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
                        rs.getDouble("TongTien"),
                        rs.getString("TrangThai")
                ));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace(); // Bấm xem NetBeans Console nếu có lỗi màu đỏ
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
                HoaDon hd = new HoaDon(
                        rs.getString("MaHD"),
                        rs.getString("MaBan"),
                        rs.getString("MaNV"),
                        rs.getString("NgayTao"),
                        rs.getDouble("TongTien"),
                        rs.getString("TrangThai")
                );
                rs.close();
                ps.close();
                return hd;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(HoaDon hd) {
        // Bỏ MaHD ra khỏi câu lệnh INSERT vì nó là cột tự tăng (IDENTITY)
        String sql = "INSERT INTO HoaDon (MaBan, MaNV, NgayTao, TongTien, TrangThai) VALUES (?,?,?,?,?)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, hd.getMaBan());
            ps.setString(2, hd.getMaNV());
            ps.setString(3, hd.getNgayTao());
            ps.setDouble(4, hd.getTongTien());
            ps.setString(5, hd.getTrangThai());
            ps.executeUpdate();
            ps.close();
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
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace(); // Lỗi sẽ hiện ở đây
        }
    }

    public void updateStatus(String maHD, String trangThai) {
        String sql = "UPDATE HoaDon SET TrangThai=? WHERE MaHD=?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, trangThai);
            ps.setString(2, maHD);
            ps.executeUpdate();
            ps.close();
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
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateBanStatus(String maBan, String trangThai) {
        String sql = "UPDATE BanAn SET TrangThai = ? WHERE MaBan = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, trangThai);
            ps.setString(2, maBan);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Menu> getAllMenu() {
        ArrayList<Menu> list = new ArrayList<>();
        String sql = "SELECT maMon, tenMon, loaiMon, gia, trangThai FROM menu";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Menu(
                        rs.getString("maMon"),
                        rs.getString("tenMon"),
                        rs.getString("loaiMon"),
                        rs.getBigDecimal("gia"),
                        rs.getBoolean("trangThai")
                ));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
