package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.BanAn;
import util.DBConnect;

public class BanAnDAO {

    public ArrayList<BanAn> getAll() {
        ArrayList<BanAn> list = new ArrayList<>();

        String sql = "SELECT * FROM BanAn ORDER BY MaBan";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BanAn ban = new BanAn();
                ban.setMaBan(rs.getString("MaBan"));
                ban.setTenBan(rs.getString("TenBan"));
                ban.setTrangThai(rs.getString("TrangThai"));

                list.add(ban);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public BanAn findById(String maBan) {
        String sql = "SELECT * FROM BanAn WHERE MaBan = ?";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, maBan);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                BanAn ban = new BanAn();
                ban.setMaBan(rs.getString("MaBan"));
                ban.setTenBan(rs.getString("TenBan"));
                ban.setTrangThai(rs.getString("TrangThai"));

                rs.close();
                ps.close();
                conn.close();

                return ban;
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insert(BanAn ban) {
        String sql = "INSERT INTO BanAn (MaBan, TenBan, TrangThai) VALUES (?, ?, ?)";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, ban.getMaBan());
            ps.setString(2, ban.getTenBan());
            ps.setString(3, ban.getTrangThai());

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(BanAn ban) {
        String sql = "UPDATE BanAn SET TenBan = ?, TrangThai = ? WHERE MaBan = ?";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, ban.getTenBan());
            ps.setString(2, ban.getTrangThai());
            ps.setString(3, ban.getMaBan());

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(String maBan, String trangThai) {
        String sql = "UPDATE BanAn SET TrangThai = ? WHERE MaBan = ?";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, trangThai);
            ps.setString(2, maBan);

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(String maBan) {
        String sql = "DELETE FROM BanAn WHERE MaBan = ?";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, maBan);

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}