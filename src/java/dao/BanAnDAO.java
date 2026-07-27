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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertBan(BanAn ban) {
        String sql = """
        INSERT INTO BanAn(
            TenBan,
            SoCho,
            KhuVuc,
            TrangThai,
            MaDonHang
        )
        VALUES (?, ?, ?, 0, NULL)
    """;

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ban.getTenBan());
            ps.setInt(2, ban.getSoCho());
            ps.setString(3, ban.getKhuVuc());

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean nhanBan(
            int maBan,
            String maDonHangMoi
    ) {
        String sql = """
        UPDATE BanAn
        SET TrangThai = 1,
            MaDonHang = ?
        WHERE MaBan = ?
    """;

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maDonHangMoi);
            ps.setInt(2, maBan);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean capNhatTrangThai(int maBan, int trangThai) {

        String sql = """
        UPDATE BanAn
        SET TrangThai = ?
        WHERE MaBan = ?
    """;

        try (
                Connection connection = DBConnect.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, trangThai);
            statement.setInt(2, maBan);

            return statement.executeUpdate() > 0;

        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean traBan(int maBan) {

        String sql = """
        UPDATE BanAn
        SET TrangThai = 0,
            MaDonHang = NULL
        WHERE MaBan = ?
    """;

        try (
                Connection connection = DBConnect.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, maBan);

            return statement.executeUpdate() > 0;

        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }
}
