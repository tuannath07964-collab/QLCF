package dao;

import model.NguyenLieu;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class khoDAO {

    private static final Set<String> DON_VI_CHO_PHEP =
            new LinkedHashSet<>(
                    Arrays.asList(
                            "g",
                            "ml",
                            "cái",
                            "gói",
                            "hộp",
                            "chai",
                            "quả"
                    )
            );

    public List<NguyenLieu> getAll() {

        Map<String, NguyenLieu> nguyenLieuMap =
                new LinkedHashMap<>();

        String sqlNguyenLieu = """
            SELECT
                MaNguyenLieu,
                TenNguyenLieu,
                SoLuongTon,
                MucNhapCoDinh,
                DonVi,
                TrangThai
            FROM NguyenLieu
            ORDER BY MaNguyenLieu
            """;

        String sqlSanPhamSuDung = """
            SELECT
                ct.MaNguyenLieu,
                sp.TenSanPham
            FROM CongThucSanPham ct
            INNER JOIN SanPham sp
                ON sp.MaSanPham = ct.MaSanPham
            ORDER BY
                ct.MaNguyenLieu,
                sp.TenSanPham
            """;

        try (
            Connection connection = openConnection()
        ) {
            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                sqlNguyenLieu
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                while (resultSet.next()) {

                    NguyenLieu nguyenLieu =
                            mapRow(resultSet);

                    nguyenLieuMap.put(
                            nguyenLieu.getMaNguyenLieu(),
                            nguyenLieu
                    );
                }
            }

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                sqlSanPhamSuDung
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                while (resultSet.next()) {

                    String maNguyenLieu =
                            resultSet.getString(
                                    "MaNguyenLieu"
                            );

                    NguyenLieu nguyenLieu =
                            nguyenLieuMap.get(
                                    maNguyenLieu
                            );

                    if (nguyenLieu == null) {
                        continue;
                    }

                    String tenSanPham =
                            resultSet.getString(
                                    "TenSanPham"
                            );

                    String danhSachHienTai =
                            nguyenLieu.getSanPhamSuDung();

                    if (
                        danhSachHienTai == null
                        || danhSachHienTai.isBlank()
                    ) {
                        nguyenLieu.setSanPhamSuDung(
                                tenSanPham
                        );

                    } else {
                        nguyenLieu.setSanPhamSuDung(
                                danhSachHienTai
                                + ", "
                                + tenSanPham
                        );
                    }
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được danh sách nguyên liệu: "
                    + exception.getMessage(),
                    exception
            );
        }

        return new ArrayList<>(
                nguyenLieuMap.values()
        );
    }

    public NguyenLieu findById(
            String maNguyenLieu
    ) {
        if (
            maNguyenLieu == null
            || maNguyenLieu.isBlank()
        ) {
            return null;
        }

        String sql = """
            SELECT
                MaNguyenLieu,
                TenNguyenLieu,
                SoLuongTon,
                MucNhapCoDinh,
                DonVi,
                TrangThai
            FROM NguyenLieu
            WHERE MaNguyenLieu = ?
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    maNguyenLieu.trim()
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                if (resultSet.next()) {
                    return mapRow(resultSet);
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tìm được nguyên liệu: "
                    + exception.getMessage(),
                    exception
            );
        }

        return null;
    }

    public void insert(
            NguyenLieu nguyenLieu
    ) {
        validate(nguyenLieu);

        String sql = """
            INSERT INTO NguyenLieu (
                MaNguyenLieu,
                TenNguyenLieu,
                SoLuongTon,
                MucNhapCoDinh,
                DonVi,
                TrangThai
            )
            VALUES (?, ?, ?, ?, ?, ?)
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    nguyenLieu
                            .getMaNguyenLieu()
                            .trim()
            );

            statement.setString(
                    2,
                    nguyenLieu
                            .getTenNguyenLieu()
                            .trim()
            );

            statement.setInt(
                    3,
                    nguyenLieu.getSoLuongTon()
            );

            statement.setInt(
                    4,
                    nguyenLieu.getMucNhapCoDinh()
            );

            statement.setString(
                    5,
                    nguyenLieu.getDonVi()
            );

            statement.setBoolean(
                    6,
                    nguyenLieu.isTrangThai()
            );

            statement.executeUpdate();

        } catch (SQLException exception) {

            String message =
                    exception.getMessage() == null
                    ? ""
                    : exception
                            .getMessage()
                            .toLowerCase();

            if (
                message.contains("duplicate")
                || message.contains("primary key")
                || message.contains("unique")
            ) {
                throw new IllegalStateException(
                        "Mã nguyên liệu đã tồn tại.",
                        exception
                );
            }

            throw new IllegalStateException(
                    "Không thêm được nguyên liệu: "
                    + exception.getMessage(),
                    exception
            );
        }
    }

    public void update(
            NguyenLieu nguyenLieu
    ) {
        validate(nguyenLieu);

        String sql = """
            UPDATE NguyenLieu
            SET
                TenNguyenLieu = ?,
                MucNhapCoDinh = ?,
                DonVi = ?,
                TrangThai = ?
            WHERE MaNguyenLieu = ?
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    nguyenLieu
                            .getTenNguyenLieu()
                            .trim()
            );

            statement.setInt(
                    2,
                    nguyenLieu.getMucNhapCoDinh()
            );

            statement.setString(
                    3,
                    nguyenLieu.getDonVi()
            );

            statement.setBoolean(
                    4,
                    nguyenLieu.isTrangThai()
            );

            statement.setString(
                    5,
                    nguyenLieu
                            .getMaNguyenLieu()
                            .trim()
            );

            int soDongCapNhat =
                    statement.executeUpdate();

            if (soDongCapNhat != 1) {
                throw new IllegalStateException(
                        "Không tìm thấy nguyên liệu cần sửa."
                );
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không cập nhật được nguyên liệu: "
                    + exception.getMessage(),
                    exception
            );
        }
    }

    public void nhapKhoCoDinh(
            String maNguyenLieu
    ) {
        if (
            maNguyenLieu == null
            || maNguyenLieu.isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Mã nguyên liệu không hợp lệ."
            );
        }

        String sql = """
            UPDATE NguyenLieu
            SET SoLuongTon =
                SoLuongTon + MucNhapCoDinh
            WHERE MaNguyenLieu = ?
              AND TrangThai = 1
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    maNguyenLieu.trim()
            );

            int soDongCapNhat =
                    statement.executeUpdate();

            if (soDongCapNhat != 1) {
                throw new IllegalStateException(
                        "Không nhập được kho. "
                        + "Nguyên liệu không tồn tại "
                        + "hoặc đã ngừng sử dụng."
                );
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không nhập được kho: "
                    + exception.getMessage(),
                    exception
            );
        }
    }

    public List<String> getDonViChoPhep() {
        return new ArrayList<>(
                DON_VI_CHO_PHEP
        );
    }

    private NguyenLieu mapRow(
            ResultSet resultSet
    ) throws SQLException {

        NguyenLieu nguyenLieu =
                new NguyenLieu();

        nguyenLieu.setMaNguyenLieu(
                resultSet.getString(
                        "MaNguyenLieu"
                )
        );

        nguyenLieu.setTenNguyenLieu(
                resultSet.getString(
                        "TenNguyenLieu"
                )
        );

        nguyenLieu.setSoLuongTon(
                resultSet.getInt(
                        "SoLuongTon"
                )
        );

        nguyenLieu.setMucNhapCoDinh(
                resultSet.getInt(
                        "MucNhapCoDinh"
                )
        );

        nguyenLieu.setDonVi(
                resultSet.getString(
                        "DonVi"
                )
        );

        nguyenLieu.setTrangThai(
                resultSet.getBoolean(
                        "TrangThai"
                )
        );

        return nguyenLieu;
    }

    private void validate(
            NguyenLieu nguyenLieu
    ) {
        if (nguyenLieu == null) {
            throw new IllegalArgumentException(
                    "Dữ liệu nguyên liệu không hợp lệ."
            );
        }

        if (
            nguyenLieu.getMaNguyenLieu() == null
            || nguyenLieu
                    .getMaNguyenLieu()
                    .isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Mã nguyên liệu không được để trống."
            );
        }

        if (
            nguyenLieu.getTenNguyenLieu() == null
            || nguyenLieu
                    .getTenNguyenLieu()
                    .isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Tên nguyên liệu không được để trống."
            );
        }

        if (nguyenLieu.getSoLuongTon() < 0) {
            throw new IllegalArgumentException(
                    "Số lượng tồn không được nhỏ hơn 0."
            );
        }

        if (
            nguyenLieu.getMucNhapCoDinh() <= 0
        ) {
            throw new IllegalArgumentException(
                    "Mức nhập cố định phải lớn hơn 0."
            );
        }

        String donVi =
                nguyenLieu.getDonVi();

        if (donVi == null) {
            throw new IllegalArgumentException(
                    "Vui lòng chọn đơn vị nguyên liệu."
            );
        }

        donVi = donVi.trim();

        if (
            !DON_VI_CHO_PHEP.contains(
                    donVi
            )
        ) {
            throw new IllegalArgumentException(
                    "Đơn vị phải là g, ml, cái, "
                    + "gói, hộp, chai hoặc quả."
            );
        }

        nguyenLieu.setDonVi(donVi);
    }

    private Connection openConnection()
            throws SQLException {

        Connection connection =
                DBConnect.getConnection();

        if (connection == null) {
            throw new SQLException(
                    "DBConnect trả về kết nối null."
            );
        }

        if (connection.isClosed()) {
            throw new SQLException(
                    "Kết nối SQL Server đã bị đóng."
            );
        }

        return connection;
    }
}