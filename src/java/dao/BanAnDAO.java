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
        String sql = "SELECT * FROM BanAn";
        try {
            Connection conn = DBConnect.getConnection();
            if (conn == null) {
                System.out.println("LỖI: Không kết nối được Database!");
                return list;
            }

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BanAn b = new BanAn();
                b.setMaBan(rs.getString("MaBan"));
                b.setTenBan(rs.getString("TenBan"));
                b.setTrangThai(rs.getString("TrangThai"));
                list.add(b);
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
                BanAn b = new BanAn();
                b.setMaBan(rs.getString("MaBan"));
                b.setTenBan(rs.getString("TenBan"));
                b.setTrangThai(rs.getString("TrangThai"));
                rs.close();
                ps.close();
                conn.close();
                return b;
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(BanAn b) {
        String sql = "INSERT INTO BanAn (TenBan, TrangThai) VALUES (?, ?)";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, b.getTenBan());
            ps.setString(2, b.getTrangThai());
            ps.executeUpdate();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(BanAn b) {
        String sql = "UPDATE BanAn SET TenBan = ?, TrangThai = ? WHERE MaBan = ?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, b.getTenBan());
            ps.setString(2, b.getTrangThai());
            ps.setString(3, b.getMaBan());
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

    public String getChiTietHtml(int maBan) {
        StringBuilder html = new StringBuilder();
        String sql = "SELECT H.NgayLap, M.TenMon, CT.SoLuong, CT.DonGia, (CT.SoLuong * CT.DonGia) AS ThanhTien "
                + "FROM HoaDon H "
                + "JOIN ChiTietHoaDon CT ON H.MaHD = CT.MaHD "
                + "JOIN Menu M ON CT.MaMon = M.MaMon "
                + "WHERE H.MaBan = ? AND H.TrangThai = 0";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, maBan);
            ResultSet rs = ps.executeQuery();

            ArrayList<String> rows = new ArrayList<>();
            double tongCong = 0;
            String ngayLap = "";

            while (rs.next()) {
                ngayLap = rs.getString("NgayLap");
                double thanhTien = rs.getDouble("ThanhTien");
                tongCong += thanhTien;
                rows.add("<tr><td>" + rs.getString("TenMon") + "</td><td>" + rs.getInt("SoLuong")
                        + "</td><td>" + String.format("%,.0f", rs.getDouble("DonGia"))
                        + "</td><td>" + String.format("%,.0f", thanhTien) + "</td></tr>");
            }

            // KIỂM TRA: Nếu không có món nào (rows rỗng) thì báo là bàn trống
            html.append("<div style='font-family: monospace;'>");
            if (rows.isEmpty()) {
                html.append("<h3>BÀN ").append(maBan).append(" 🟢 Trống</h3>");
                html.append("<p>Không có hóa đơn đang mở.</p>");
            } else {
                html.append("<h3>BÀN ").append(maBan).append(" 🔴 Đang phục vụ</h3>");
                html.append("Thời gian : ").append(ngayLap).append("<hr>");
                html.append("<table width='100%'><tr><th>Món</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th></tr>");
                for (String row : rows) {
                    html.append(row);
                }
                html.append("</table><hr>");
                html.append("<strong>Tạm tính : ").append(String.format("%,.0f", tongCong)).append("đ</strong>");
            }

            html.append("<br><br><button onclick='closeModal()'>Đóng</button></div>");

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi database: " + e.getMessage();
        }
        return html.toString();
    }
}
