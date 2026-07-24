package dao;

import java.sql.*;
import java.util.ArrayList;
import model.ChiTietHoaDon;
import util.DBConnect;

public class ChiTietHoaDonDAO extends DBConnect {

    // Lấy toàn bộ món của một hóa đơn
    public ArrayList<ChiTietHoaDon> getByHoaDon(String maHD) {

        ArrayList<ChiTietHoaDon> list = new ArrayList<>();

        String sql = "SELECT * FROM ChiTietHoaDon WHERE MaHD=?";

        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);

            ps.setString(1, maHD);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ChiTietHoaDon ct = new ChiTietHoaDon(
                        rs.getInt("MaCT"),
                        rs.getString("MaHD"),
                        rs.getString("MaMon"),
                        rs.getInt("SoLuong"),
                        rs.getDouble("DonGia")
                );

                list.add(ct);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Thêm một món vào hóa đơn
    public void insert(ChiTietHoaDon ct) {

        String sql = "INSERT INTO ChiTietHoaDon(MaHD,MaMon,SoLuong,DonGia) VALUES(?,?,?,?)";

        try {

            PreparedStatement ps = getConnection().prepareStatement(sql);

            ps.setString(1, ct.getMaHD());
            ps.setString(2, ct.getMaMon());
            ps.setInt(3, ct.getSoLuong());
            ps.setDouble(4, ct.getDonGia());

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    // Xóa toàn bộ món của hóa đơn
    public void deleteByHoaDon(String maHD) {

        String sql = "DELETE FROM ChiTietHoaDon WHERE MaHD=?";

        try {

            PreparedStatement ps = getConnection().prepareStatement(sql);

            ps.setString(1, maHD);

            ps.executeUpdate();

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}