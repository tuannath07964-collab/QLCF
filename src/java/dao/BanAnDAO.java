package dao;

import model.BanAn;
import util.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BanAnDAO {

    public List<BanAn> getAllBan(String khuVuc) {
        List<BanAn> list = new ArrayList<>();
        String sql = "SELECT * FROM BanAn";

        if (khuVuc != null && !khuVuc.trim().isEmpty()) {
            sql += " WHERE khuVuc = ?";
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (khuVuc != null && !khuVuc.trim().isEmpty()) {
                ps.setString(1, khuVuc);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BanAn ban = new BanAn();
                ban.setMaBan(rs.getInt("MaBan"));
                ban.setTenBan(rs.getString("TenBan"));
                ban.setSoCho(rs.getInt("soCho"));
                ban.setKhuVuc(rs.getString("khuVuc"));
                ban.setMaDonHang(rs.getString("MaDonHang"));
                String trangThaiDB = rs.getString("TrangThai");
                int trangThaiInt = 0; // Mặc định là 0 (Trống)

                if (trangThaiDB != null) {
                    if (trangThaiDB.equalsIgnoreCase("Đang phục vụ")) {
                        trangThaiInt = 1;
                    }
                }
                ban.setTrangThai(trangThaiInt);
                list.add(ban);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertBan(BanAn ban) {
        String sql = "INSERT INTO BanAn (TenBan, soCho, khuVuc, TrangThai) VALUES (?, ?, ?, N'Trống')";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ban.getTenBan());
            ps.setInt(2, ban.getSoCho());
            ps.setString(3, ban.getKhuVuc());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean nhanBan(int maBan, String maDonHangMoi) {
        String sql = "UPDATE BanAn SET TrangThai = N'Đang phục vụ', MaDonHang = ? WHERE MaBan = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, maDonHangMoi);
            ps.setInt(2, maBan);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
