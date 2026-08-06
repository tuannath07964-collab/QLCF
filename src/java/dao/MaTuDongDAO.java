package dao;

import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MaTuDongDAO {

    private static final Object LOCK = new Object();

    public String taoMaSanPham() {
        return taoMa(
                """
                SELECT ISNULL(
                    MAX(
                        TRY_CONVERT(
                            INT,
                            SUBSTRING(MaSanPham, 2, 20)
                        )
                    ),
                    0
                ) + 1 AS SoTiepTheo
                FROM SanPham
                WHERE MaSanPham LIKE 'M%'
                """,
                "M"
        );
    }

    public String taoMaDanhMuc() {
        return taoMa(
                """
                SELECT ISNULL(
                    MAX(
                        TRY_CONVERT(
                            INT,
                            SUBSTRING(MaDanhMuc, 3, 20)
                        )
                    ),
                    0
                ) + 1 AS SoTiepTheo
                FROM DanhMucSanPham
                WHERE MaDanhMuc LIKE 'DM%'
                """,
                "DM"
        );
    }

    public String taoMaNguyenLieu() {
        return taoMa(
                """
                SELECT ISNULL(
                    MAX(
                        TRY_CONVERT(
                            INT,
                            SUBSTRING(MaNguyenLieu, 3, 20)
                        )
                    ),
                    0
                ) + 1 AS SoTiepTheo
                FROM NguyenLieu
                WHERE MaNguyenLieu LIKE 'NL%'
                """,
                "NL"
        );
    }

    private String taoMa(
            String sql,
            String prefix
    ) {
        synchronized (LOCK) {
            try (
                    Connection connection =
                            DBConnect.getConnection();

                    PreparedStatement statement =
                            connection.prepareStatement(sql);

                    ResultSet resultSet =
                            statement.executeQuery()
            ) {
                if (!resultSet.next()) {
                    throw new IllegalStateException(
                            "Không tạo được mã tự động."
                    );
                }

                int soTiepTheo =
                        resultSet.getInt(
                                "SoTiepTheo"
                        );

                return prefix
                        + String.format(
                                "%02d",
                                soTiepTheo
                        );

            } catch (SQLException exception) {
                throw new IllegalStateException(
                        "Không tạo được mã tự động: "
                        + exception.getMessage(),
                        exception
                );
            }
        }
    }
}