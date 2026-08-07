package dao;

import model.TaiKhoan;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TaiKhoanDAO {

    public TaiKhoan checkLogin(
            String maTaiKhoan,
            String matKhau
    ) {
        String sql = """
            SELECT MaTaiKhoan,
                   HoTen,
                   MatKhau,
                   VaiTro,
                   TrangThai
            FROM TaiKhoan
            WHERE MaTaiKhoan = ?
              AND MatKhau = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    maTaiKhoan
            );

            ps.setString(
                    2,
                    matKhau
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (!rs.next()) {
                    return null;
                }

                TaiKhoan taiKhoan =
                        new TaiKhoan();

                taiKhoan.setMaTaiKhoan(
                        rs.getString(
                                "MaTaiKhoan"
                        )
                );

                taiKhoan.setHoTen(
                        rs.getString(
                                "HoTen"
                        )
                );

                taiKhoan.setMatKhau(
                        rs.getString(
                                "MatKhau"
                        )
                );

                taiKhoan.setVaiTro(
                        rs.getString(
                                "VaiTro"
                        )
                );

                taiKhoan.setTrangThai(
                        rs.getBoolean(
                                "TrangThai"
                        )
                );

                return taiKhoan;
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không kiểm tra được tài khoản.",
                    e
            );
        }
    }
}