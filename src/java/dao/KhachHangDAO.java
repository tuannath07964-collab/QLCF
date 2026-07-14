package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.KhachHang;
import util.DBConnect;

public class KhachHangDAO {

    public ArrayList<KhachHang> getAll() {
        ArrayList<KhachHang> list = new ArrayList<>();
        String sql = "SELECT * FROM KhachHang ORDER BY MaKH";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                KhachHang kh = new KhachHang();
                kh.setMaKH(rs.getString("MaKH"));
                kh.setTenKH(rs.getString("TenKH"));
                kh.setSdt(rs.getString("SDT"));

                list.add(kh);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public KhachHang findById(String maKH) {
        String sql = "SELECT * FROM KhachHang WHERE MaKH = ?";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, maKH);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                KhachHang kh = new KhachHang();
                kh.setMaKH(rs.getString("MaKH"));
                kh.setTenKH(rs.getString("TenKH"));
                kh.setSdt(rs.getString("SDT"));

                rs.close();
                ps.close();
                conn.close();

                return kh;
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insert(KhachHang kh) {
        String sql = "INSERT INTO KhachHang (MaKH, TenKH, SDT) VALUES (?, ?, ?)";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, kh.getMaKH());
            ps.setString(2, kh.getTenKH());
            ps.setString(3, kh.getSdt());

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(KhachHang kh) {
        String sql = "UPDATE KhachHang SET TenKH = ?, SDT = ? WHERE MaKH = ?";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, kh.getTenKH());
            ps.setString(2, kh.getSdt());
            ps.setString(3, kh.getMaKH());

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(String maKH) {
        String sql = "DELETE FROM KhachHang WHERE MaKH = ?";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, maKH);

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}