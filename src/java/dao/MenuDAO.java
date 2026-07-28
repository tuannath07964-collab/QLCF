package dao;

import model.Menu;
import util.DBConnect;

import java.math.BigDecimal;
import java.math.RoundingMode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class MenuDAO {

    private static final String SELECT_BASE = """
        SELECT MaMon,
               TenMon,
               LoaiMon,
               Gia,
               TrangThai
        FROM Menu
        """;

    public ArrayList<Menu> getAllMenu() {
        return loadMenuList(
                SELECT_BASE
                + " ORDER BY MaMon",
                null
        );
    }

    public Menu getMenuById(String maMon) {
        ArrayList<Menu> list =
                loadMenuList(
                        SELECT_BASE
                        + " WHERE MaMon = ?",
                        maMon
                );

        return list.isEmpty()
                ? null
                : list.get(0);
    }

    public ArrayList<Menu> getMenuByType(
            String loaiMon
    ) {
        return loadMenuList(
                SELECT_BASE
                + " WHERE LoaiMon = ?"
                + " ORDER BY MaMon",
                loaiMon
        );
    }

    public List<Menu> searchMenu(
            String keyword
    ) {
        ArrayList<Menu> list =
                new ArrayList<>();

        String sql =
                SELECT_BASE
                + """
                  WHERE TenMon LIKE ?
                     OR MaMon LIKE ?
                  ORDER BY MaMon
                  """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            String searchKey =
                    "%"
                    + (
                        keyword == null
                            ? ""
                            : keyword.trim()
                    )
                    + "%";

            ps.setString(1, searchKey);
            ps.setString(2, searchKey);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

            boSungCongThucVaTonKho(
                    conn,
                    list
            );

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được danh sách menu.",
                    e
            );
        }

        return list;
    }

    public boolean insertMenu(Menu menu) {
        validateMenu(menu);

        String sql = """
            INSERT INTO Menu(
                MaMon,
                TenMon,
                LoaiMon,
                Gia,
                TrangThai
            )
            VALUES (?, ?, ?, ?, ?)
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    menu.getMaMon().trim()
            );

            ps.setString(
                    2,
                    menu.getTenMon().trim()
            );

            ps.setString(
                    3,
                    menu.getLoaiMon().trim()
            );

            ps.setBigDecimal(
                    4,
                    menu.getGia()
            );

            ps.setBoolean(
                    5,
                    menu.isTrangThai()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không thêm được món. "
                    + "Kiểm tra mã món đã tồn tại.",
                    e
            );
        }
    }

    public boolean updateMenu(Menu menu) {
        validateMenu(menu);

        String sql = """
            UPDATE Menu
            SET TenMon = ?,
                LoaiMon = ?,
                Gia = ?,
                TrangThai = ?
            WHERE MaMon = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    menu.getTenMon().trim()
            );

            ps.setString(
                    2,
                    menu.getLoaiMon().trim()
            );

            ps.setBigDecimal(
                    3,
                    menu.getGia()
            );

            ps.setBoolean(
                    4,
                    menu.isTrangThai()
            );

            ps.setString(
                    5,
                    menu.getMaMon().trim()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không cập nhật được món.",
                    e
            );
        }
    }

    public boolean deleteMenu(String maMon) {
        String sql = """
            DELETE FROM Menu
            WHERE MaMon = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(1, maMon);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không thể xóa món đã có "
                    + "trong hóa đơn hoặc công thức.",
                    e
            );
        }
    }

    private ArrayList<Menu> loadMenuList(
            String sql,
            String parameter
    ) {
        ArrayList<Menu> list =
                new ArrayList<>();

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            if (parameter != null) {
                ps.setString(1, parameter);
            }

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

            boSungCongThucVaTonKho(
                    conn,
                    list
            );

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được dữ liệu menu.",
                    e
            );
        }

        return list;
    }

    private void boSungCongThucVaTonKho(
            Connection conn,
            List<Menu> list
    ) throws SQLException {

        String sql = """
            SELECT k.TenNL,
                   k.SoLuong,
                   k.DonVi,
                   ct.SoLuongCan
            FROM CongThucMon ct
            JOIN Kho k
                ON k.MaNL = ct.MaNL
            WHERE ct.MaMon = ?
            ORDER BY ct.ThuTu,
                     k.MaNL
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            for (Menu menu : list) {
                ps.setString(
                        1,
                        menu.getMaMon()
                );

                StringBuilder nguyenLieu =
                        new StringBuilder();

                int soPhan =
                        Integer.MAX_VALUE;

                boolean coCongThuc =
                        false;

                try (
                    ResultSet rs =
                            ps.executeQuery()
                ) {
                    while (rs.next()) {
                        coCongThuc = true;

                        BigDecimal tonKho =
                                rs.getBigDecimal(
                                        "SoLuong"
                                );

                        BigDecimal soLuongCan =
                                rs.getBigDecimal(
                                        "SoLuongCan"
                                );

                        String donVi =
                                rs.getString(
                                        "DonVi"
                                );

                        if (nguyenLieu.length() > 0) {
                            nguyenLieu.append(", ");
                        }

                        nguyenLieu
                                .append(
                                    formatNumber(
                                            soLuongCan
                                    )
                                )
                                .append(" ")
                                .append(donVi)
                                .append(" ")
                                .append(
                                    rs.getString(
                                            "TenNL"
                                    )
                                );

                        int phanTheoNguyenLieu =
                                tonKho.divide(
                                        soLuongCan,
                                        0,
                                        RoundingMode.DOWN
                                ).intValue();

                        soPhan =
                                Math.min(
                                        soPhan,
                                        phanTheoNguyenLieu
                                );
                    }
                }

                if (!coCongThuc) {
                    menu.setNguyenLieuCan(
                            "Chưa cấu hình công thức"
                    );

                    menu.setSoPhanCoThePha(0);

                    menu.setTrangThai(false);

                } else {
                    menu.setNguyenLieuCan(
                            nguyenLieu.toString()
                    );

                    menu.setSoPhanCoThePha(
                            Math.max(0, soPhan)
                    );

                    /*
                     * Món phải được bật trong bảng Menu
                     * và còn đủ nguyên liệu.
                     */
                    menu.setTrangThai(
                            menu.isTrangThai()
                            && soPhan > 0
                    );
                }
            }
        }
    }

    private Menu mapRow(
            ResultSet rs
    ) throws SQLException {

        Menu menu = new Menu();

        menu.setMaMon(
                rs.getString("MaMon")
        );

        menu.setTenMon(
                rs.getString("TenMon")
        );

        menu.setLoaiMon(
                rs.getString("LoaiMon")
        );

        menu.setGia(
                rs.getBigDecimal("Gia")
        );

        menu.setTrangThai(
                rs.getBoolean("TrangThai")
        );

        return menu;
    }

    private String formatNumber(
            BigDecimal value
    ) {
        if (value == null) {
            return "0";
        }

        return value
                .stripTrailingZeros()
                .toPlainString();
    }

    private void validateMenu(Menu menu) {
        if (menu == null) {
            throw new IllegalArgumentException(
                    "Thông tin món không hợp lệ."
            );
        }

        if (
            menu.getMaMon() == null
            || menu.getMaMon().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Mã món là bắt buộc."
            );
        }

        if (
            menu.getTenMon() == null
            || menu.getTenMon().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Tên món là bắt buộc."
            );
        }

        if (
            menu.getLoaiMon() == null
            || menu.getLoaiMon().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Loại món là bắt buộc."
            );
        }

        if (
            menu.getGia() == null
            || menu.getGia().compareTo(
                    BigDecimal.ZERO
            ) < 0
        ) {
            throw new IllegalArgumentException(
                    "Giá món không hợp lệ."
            );
        }
    }
}