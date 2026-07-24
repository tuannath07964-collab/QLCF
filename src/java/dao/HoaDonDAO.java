package dao;

import util.DBConnect;
import java.sql.*;
import java.util.ArrayList;
import model.HoaDon;
import model.Menu;
import model.MaGiamGia;

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
        String sql = "SELECT MaHD, MaBan, MaNV, NgayTao, MaGiamGia, TongTien, TrangThai, DanhsachMon FROM HoaDon";
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
                hd.setMaGiamGia(rs.getString("MaGiamGia"));
                hd.setTongTien(rs.getDouble("TongTien"));
                hd.setTrangThai(rs.getString("TrangThai"));
                hd.setDanhSachMon(rs.getString("DanhsachMon"));
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
        String sql = "SELECT MaHD, MaBan, MaNV, NgayTao, TongTien, TrangThai, DanhsachMon, MaGiamGia FROM HoaDon WHERE MaHD = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maHD);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HoaDon hd = new HoaDon();
                    hd.setMaHD(rs.getString("MaHD"));
                    hd.setMaBan(rs.getString("MaBan"));
                    hd.setMaNV(rs.getString("MaNV"));
                    hd.setNgayTao(rs.getString("NgayTao"));
                    hd.setTongTien(rs.getDouble("TongTien"));
                    hd.setTrangThai(rs.getString("TrangThai"));
                    hd.setDanhSachMon(rs.getString("DanhsachMon"));
                    hd.setMaGiamGia(rs.getString("MaGiamGia"));
                    return hd;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(HoaDon hd) {
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

    // Hàm insert đầy đủ dùng cho Servlet mới
    public void insertHoaDon(HoaDon hd) {
        String sql = "INSERT INTO HoaDon (MaNV, MaBan, NgayTao, MaGiamGia, TongTien, TrangThai, DanhsachMon) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hd.getMaNV());
            ps.setString(2, hd.getMaBan());
            ps.setString(3, hd.getNgayTao());
            ps.setString(4, hd.getMaGiamGia());
            ps.setDouble(5, hd.getTongTien());
            ps.setString(6, hd.getTrangThai());
            ps.setString(7, hd.getDanhSachMon());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Hàm update đầy đủ dùng cho Servlet mới
    public void updateHoaDon(HoaDon hd) {
        String sql = "UPDATE HoaDon SET MaBan = ?, TongTien = ?, TrangThai = ?, DanhsachMon = ?, MaGiamGia = ? WHERE MaHD = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hd.getMaBan());
            ps.setDouble(2, hd.getTongTien());
            ps.setString(3, hd.getTrangThai());
            ps.setString(4, hd.getDanhSachMon());
            ps.setString(5, hd.getMaGiamGia());
            ps.setString(6, hd.getMaHD());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- CÁC HÀM XỬ LÝ MÃ GIẢM GIÁ (ĐÃ ĐỒNG BỘ TIẾNG VIỆT & DBConnect) ---
    public ArrayList<MaGiamGia> getAllMaGiamGia() {
        ArrayList<MaGiamGia> list = new ArrayList<>();
        String query = "SELECT * FROM MaGiamGia";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MaGiamGia m = new MaGiamGia();
                m.setIDGiamGia(rs.getInt("IDGiamGia"));
                m.setMaCode(rs.getString("MaCode"));
                m.setPhanTramGiam(rs.getDouble("PhanTramGiam"));
                m.setDieuKienDonToiTieu(rs.getDouble("DieuKienDonToiTieu"));
                m.setNgayHetHan(rs.getString("NgayHetHan"));
                m.setTrangThai(rs.getInt("TrangThai"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertMaGiamGia(MaGiamGia m) {
        String query = "INSERT INTO MaGiamGia (MaCode, PhanTramGiam, DieuKienDonToiTieu, NgayHetHan, TrangThai) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, m.getMaCode());
            ps.setDouble(2, m.getPhanTramGiam());
            ps.setDouble(3, m.getDieuKienDonToiTieu());
            ps.setString(4, m.getNgayHetHan());
            ps.setInt(5, m.getTrangThai());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateMaGiamGia(MaGiamGia m) {
        String query = "UPDATE MaGiamGia SET MaCode = ?, PhanTramGiam = ?, DieuKienDonToiTieu = ?, NgayHetHan = ?, TrangThai = ? WHERE IDGiamGia = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, m.getMaCode());
            ps.setDouble(2, m.getPhanTramGiam());
            ps.setDouble(3, m.getDieuKienDonToiTieu());
            ps.setString(4, m.getNgayHetHan());
            ps.setInt(5, m.getTrangThai());
            ps.setInt(6, m.getIDGiamGia());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
