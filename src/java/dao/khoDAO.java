package dao;

import model.NguyenLieu;
import util.DBConnect;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class khoDAO {

    public ArrayList<NguyenLieu>
            getAllNguyenLieu() {

        Map<String, NguyenLieu> data =
                new LinkedHashMap<>();

        String sqlKho = """
            SELECT
                MaNL,
                TenNL,
                SoLuong,
                DonVi
            FROM Kho
            ORDER BY MaNL
            """;

        String sqlCongThuc = """
            SELECT
                ct.MaNL,
                m.TenMon,
                ct.SoLuongCan,
                k.DonVi
            FROM CongThucMon ct
            JOIN Menu m
                ON m.MaMon = ct.MaMon
            JOIN Kho k
                ON k.MaNL = ct.MaNL
            ORDER BY
                ct.MaNL,
                m.MaMon
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement psKho =
                    conn.prepareStatement(sqlKho);

            ResultSet rsKho =
                    psKho.executeQuery()
        ) {
            while (rsKho.next()) {
                NguyenLieu nl =
                        mapRow(rsKho);

                data.put(
                        nl.getMaNL(),
                        nl
                );
            }

            try (
                PreparedStatement ps =
                        conn.prepareStatement(
                                sqlCongThuc
                        );

                ResultSet rs =
                        ps.executeQuery()
            ) {
                while (rs.next()) {
                    NguyenLieu nl =
                            data.get(
                                rs.getString(
                                    "MaNL"
                                )
                            );

                    if (nl == null) {
                        continue;
                    }

                    String dong =
                            rs.getString("TenMon")
                            + ": "
                            + formatNumber(
                                rs.getBigDecimal(
                                    "SoLuongCan"
                                )
                            )
                            + " "
                            + rs.getString("DonVi")
                            + "/phần";

                    if (
                        nl.getCongThucSuDung()
                                == null
                        || nl.getCongThucSuDung()
                                .isBlank()
                    ) {
                        nl.setCongThucSuDung(
                                dong
                        );
                    } else {
                        nl.setCongThucSuDung(
                            nl.getCongThucSuDung()
                            + " • "
                            + dong
                        );
                    }
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được dữ liệu kho.",
                    e
            );
        }

        return new ArrayList<>(
                data.values()
        );
    }

    public NguyenLieu getNguyenLieuById(
            String maNL
    ) {
        String sql = """
            SELECT
                MaNL,
                TenNL,
                SoLuong,
                DonVi
            FROM Kho
            WHERE MaNL = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(1, maNL);

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                return rs.next()
                        ? mapRow(rs)
                        : null;
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tìm thấy nguyên liệu.",
                    e
            );
        }
    }

    public boolean insertNguyenLieu(
            NguyenLieu nl
    ) {
        String sql = """
            INSERT INTO Kho(
                MaNL,
                TenNL,
                SoLuong,
                DonVi
            )
            VALUES (?, ?, ?, ?)
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    nl.getMaNL()
            );

            ps.setString(
                    2,
                    nl.getTenNL()
            );

            ps.setBigDecimal(
                    3,
                    nl.getSoLuong()
            );

            ps.setString(
                    4,
                    nl.getDonVi()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không thêm được nguyên liệu.",
                    e
            );
        }
    }

    public boolean updateNguyenLieu(
            NguyenLieu nl
    ) {
        String sql = """
            UPDATE Kho
            SET TenNL = ?,
                SoLuong = ?,
                DonVi = ?
            WHERE MaNL = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    nl.getTenNL()
            );

            ps.setBigDecimal(
                    2,
                    nl.getSoLuong()
            );

            ps.setString(
                    3,
                    nl.getDonVi()
            );

            ps.setString(
                    4,
                    nl.getMaNL()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không cập nhật được nguyên liệu.",
                    e
            );
        }
    }

    public boolean deleteNguyenLieu(
            String maNL
    ) {
        String sql =
                "DELETE FROM Kho "
                + "WHERE MaNL = ?";

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(1, maNL);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không thể xóa nguyên liệu "
                    + "đang được dùng trong công thức.",
                    e
            );
        }
    }

    private NguyenLieu mapRow(
            ResultSet rs
    ) throws SQLException {

        NguyenLieu nl =
                new NguyenLieu();

        nl.setMaNL(
                rs.getString("MaNL")
        );

        nl.setTenNL(
                rs.getString("TenNL")
        );

        nl.setSoLuong(
                rs.getBigDecimal("SoLuong")
        );

        nl.setDonVi(
                rs.getString("DonVi")
        );

        return nl;
    }

    private String formatNumber(
            BigDecimal value
    ) {
        return value
                .stripTrailingZeros()
                .toPlainString();
    }
}