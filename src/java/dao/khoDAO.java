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
            SELECT MaNL,
                   TenNL,
                   SoLuong,
                   DonVi
            FROM Kho
            ORDER BY MaNL
            """;

        String sqlCongThuc = """
            SELECT ct.MaNL,
                   m.TenMon,
                   ct.SoLuongCan,
                   k.DonVi
            FROM CongThucMon ct
            JOIN Menu m
                ON m.MaMon = ct.MaMon
            JOIN Kho k
                ON k.MaNL = ct.MaNL
            ORDER BY ct.MaNL,
                     m.MaMon
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement psKho =
                    conn.prepareStatement(
                            sqlKho
                    );

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
                PreparedStatement psCongThuc =
                        conn.prepareStatement(
                                sqlCongThuc
                        );

                ResultSet rsCongThuc =
                        psCongThuc.executeQuery()
            ) {
                while (rsCongThuc.next()) {
                    String maNL =
                            rsCongThuc.getString(
                                    "MaNL"
                            );

                    NguyenLieu nl =
                            data.get(maNL);

                    if (nl == null) {
                        continue;
                    }

                    String dongCongThuc =
                            rsCongThuc.getString(
                                    "TenMon"
                            )
                            + ": "
                            + formatNumber(
                                rsCongThuc
                                    .getBigDecimal(
                                        "SoLuongCan"
                                    )
                            )
                            + " "
                            + rsCongThuc.getString(
                                    "DonVi"
                            )
                            + "/phần";

                    if (
                        nl.getCongThucSuDung()
                            == null
                        || nl.getCongThucSuDung()
                            .isBlank()
                    ) {
                        nl.setCongThucSuDung(
                                dongCongThuc
                        );

                    } else {
                        nl.setCongThucSuDung(
                                nl.getCongThucSuDung()
                                + " • "
                                + dongCongThuc
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
            SELECT MaNL,
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
            ps.setString(
                    1,
                    maNL
            );

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
        validateNguyenLieu(nl);

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
                    nl.getMaNL().trim()
            );

            ps.setString(
                    2,
                    nl.getTenNL().trim()
            );

            ps.setBigDecimal(
                    3,
                    nl.getSoLuong()
            );

            ps.setString(
                    4,
                    nl.getDonVi().trim()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            if (
                e.getMessage() != null
                && e.getMessage()
                    .toLowerCase()
                    .contains("duplicate")
            ) {
                throw new IllegalStateException(
                        "Mã nguyên liệu đã tồn tại.",
                        e
                );
            }

            throw new IllegalStateException(
                    "Không thêm được nguyên liệu.",
                    e
            );
        }
    }

    public boolean updateNguyenLieu(
            NguyenLieu nl
    ) {
        validateNguyenLieu(nl);

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
                    nl.getTenNL().trim()
            );

            ps.setBigDecimal(
                    2,
                    nl.getSoLuong()
            );

            ps.setString(
                    3,
                    nl.getDonVi().trim()
            );

            ps.setString(
                    4,
                    nl.getMaNL().trim()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không cập nhật được nguyên liệu.",
                    e
            );
        }
    }

    /*
     * Không có hàm xóa nguyên liệu.
     * Nguyên liệu chỉ được thêm hoặc cập nhật.
     */

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

    private void validateNguyenLieu(
            NguyenLieu nl
    ) {
        if (nl == null) {
            throw new IllegalArgumentException(
                    "Thông tin nguyên liệu không hợp lệ."
            );
        }

        if (
            nl.getMaNL() == null
            || nl.getMaNL().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Mã nguyên liệu là bắt buộc."
            );
        }

        if (
            nl.getTenNL() == null
            || nl.getTenNL().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Tên nguyên liệu là bắt buộc."
            );
        }

        if (nl.getSoLuong() == null) {
            throw new IllegalArgumentException(
                    "Số lượng nguyên liệu là bắt buộc."
            );
        }

        if (
            nl.getSoLuong().compareTo(
                    BigDecimal.ZERO
            ) < 0
        ) {
            throw new IllegalArgumentException(
                    "Số lượng nguyên liệu không được âm."
            );
        }

        if (
            nl.getDonVi() == null
            || nl.getDonVi().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Đơn vị tính là bắt buộc."
            );
        }
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
}