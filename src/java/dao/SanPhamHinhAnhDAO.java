package dao;

import model.SanPham;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SanPhamHinhAnhDAO {

    public String findHinhAnh(
            String maSanPham
    ) {
        String sql = """
            SELECT HinhAnh
            FROM SanPham
            WHERE MaSanPham = ?
            """;

        try (
                Connection connection =
                        DBConnect.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    maSanPham
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {
                if (resultSet.next()) {
                    return resultSet.getString(
                            "HinhAnh"
                    );
                }
            }

            return null;

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được ảnh sản phẩm.",
                    exception
            );
        }
    }

    public void updateHinhAnh(
            String maSanPham,
            String hinhAnh
    ) {
        String sql = """
            UPDATE SanPham
            SET HinhAnh = ?
            WHERE MaSanPham = ?
            """;

        try (
                Connection connection =
                        DBConnect.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {
            if (
                    hinhAnh == null
                    || hinhAnh.isBlank()
            ) {
                statement.setNull(
                        1,
                        Types.NVARCHAR
                );

            } else {
                statement.setString(
                        1,
                        hinhAnh.trim()
                );
            }

            statement.setString(
                    2,
                    maSanPham
            );

            if (statement.executeUpdate() != 1) {
                throw new IllegalStateException(
                        "Không tìm thấy sản phẩm để cập nhật ảnh."
                );
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không cập nhật được ảnh sản phẩm.",
                    exception
            );
        }
    }

    public void boSungHinhAnh(
            List<SanPham> sanPhamList
    ) {
        if (
                sanPhamList == null
                || sanPhamList.isEmpty()
        ) {
            return;
        }

        Map<String, SanPham> sanPhamMap =
                new LinkedHashMap<>();

        for (SanPham sanPham : sanPhamList) {
            if (
                    sanPham != null
                    && sanPham.getMaSanPham() != null
                    && !sanPham.getMaSanPham().isBlank()
            ) {
                sanPhamMap.put(
                        sanPham.getMaSanPham(),
                        sanPham
                );
            }
        }

        if (sanPhamMap.isEmpty()) {
            return;
        }

        String placeholders =
                String.join(
                        ", ",
                        Collections.nCopies(
                                sanPhamMap.size(),
                                "?"
                        )
                );

        String sql =
                "SELECT MaSanPham, HinhAnh "
                + "FROM SanPham "
                + "WHERE MaSanPham IN ("
                + placeholders
                + ")";

        try (
                Connection connection =
                        DBConnect.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {
            int index = 1;

            for (String maSanPham : sanPhamMap.keySet()) {
                statement.setString(
                        index++,
                        maSanPham
                );
            }

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {
                while (resultSet.next()) {
                    String maSanPham =
                            resultSet.getString(
                                    "MaSanPham"
                            );

                    SanPham sanPham =
                            sanPhamMap.get(
                                    maSanPham
                            );

                    if (sanPham != null) {
                        sanPham.setHinhAnh(
                                resultSet.getString(
                                        "HinhAnh"
                                )
                        );
                    }
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được ảnh danh sách sản phẩm.",
                    exception
            );
        }
    }
}