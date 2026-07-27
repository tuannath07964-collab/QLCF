package dao;

import model.Menu;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {

    private static final String SELECT_MENU = """
    SELECT
        m.MaMon,
        m.TenMon,
        m.LoaiMon,
        m.Gia,

        CAST(
            CASE
                WHEN m.TrangThai = 0 THEN 0

                WHEN EXISTS (
                    SELECT 1
                    FROM CongThucMon ct
                    LEFT JOIN Kho k
                        ON k.MaNL = ct.MaNL
                    WHERE ct.MaMon = m.MaMon
                      AND (
                          k.MaNL IS NULL
                          OR k.SoLuong < ct.SoLuongCan
                      )
                )
                THEN 0

                ELSE 1
            END
        AS BIT) AS TrangThai

    FROM Menu m
""";
    
public ArrayList<Menu> getAllMenu() {
    ArrayList<Menu> list = new ArrayList<>();

    String sql =
            SELECT_MENU
            + " ORDER BY m.MaMon";

    try (
        Connection conn = DBConnect.getConnection();
        PreparedStatement ps =
                conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery()
    ) {
        while (rs.next()) {
            list.add(mapRow(rs));
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}

    public Menu getMenuById(String maMon) {
        String sql = """
                     SELECT maMon, tenMon, loaiMon, gia, trangThai
                     FROM Menu
                     WHERE maMon = ?
                     """;

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maMon);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Lỗi MenuDAO.getMenuById()");
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertMenu(Menu menu) {
        String sql = """
                     INSERT INTO Menu
                         (maMon, tenMon, loaiMon, gia, trangThai)
                     VALUES (?, ?, ?, ?, ?)
                     """;

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, menu.getMaMon());
            ps.setString(2, menu.getTenMon());
            ps.setString(3, menu.getLoaiMon());
            ps.setBigDecimal(4, menu.getGia());
            ps.setBoolean(5, menu.isTrangThai());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi MenuDAO.insertMenu()");
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateMenu(Menu menu) {
        String sql = """
                     UPDATE Menu
                     SET tenMon = ?,
                         loaiMon = ?,
                         gia = ?,
                         trangThai = ?
                     WHERE maMon = ?
                     """;

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, menu.getTenMon());
            ps.setString(2, menu.getLoaiMon());
            ps.setBigDecimal(3, menu.getGia());
            ps.setBoolean(4, menu.isTrangThai());
            ps.setString(5, menu.getMaMon());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi MenuDAO.updateMenu()");
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteMenu(String maMon) {
        String sql = "DELETE FROM Menu WHERE maMon = ?";

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, maMon);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Lỗi MenuDAO.deleteMenu()");
            e.printStackTrace();
        }

        return false;
    }

    public ArrayList<Menu> getMenuByType(String loaiMon) {
        ArrayList<Menu> list = new ArrayList<>();

        String sql = """
                     SELECT maMon, tenMon, loaiMon, gia, trangThai
                     FROM Menu
                     WHERE loaiMon = ?
                     ORDER BY maMon
                     """;

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loaiMon);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Lỗi MenuDAO.getMenuByType()");
            e.printStackTrace();
        }

        return list;
    }

    public List<Menu> searchMenu(String keyword) {
        List<Menu> list = new ArrayList<>();

        String sql = """
                     SELECT maMon, tenMon, loaiMon, gia, trangThai
                     FROM Menu
                     WHERE tenMon LIKE ?
                        OR maMon LIKE ?
                     ORDER BY maMon
                     """;

        try (
                Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchKey = "%" + keyword + "%";

            ps.setString(1, searchKey);
            ps.setString(2, searchKey);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Lỗi MenuDAO.searchMenu()");
            e.printStackTrace();
        }

        return list;
    }

    private Menu mapRow(ResultSet rs) throws SQLException {
        Menu menu = new Menu();

        menu.setMaMon(rs.getString("maMon"));
        menu.setTenMon(rs.getString("tenMon"));
        menu.setLoaiMon(rs.getString("loaiMon"));
        menu.setGia(rs.getBigDecimal("gia"));
        menu.setTrangThai(rs.getBoolean("trangThai"));

        return menu;
    }
}
