package dao;

import model.BanAn;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BanAnDAO {

    public List<BanAn> getAllBan(
            String khuVuc
    ) {
        List<BanAn> list =
                new ArrayList<>();

        boolean coLoc =
                khuVuc != null
                && !khuVuc.isBlank();

        String sql = """
            SELECT MaBan,
                   TenBan,
                   SoCho,
                   KhuVuc,
                   TrangThai,
                   MaDonHang
            FROM BanAn
            """
            + (
                coLoc
                    ? " WHERE KhuVuc = ? "
                    : ""
            )
            + " ORDER BY MaBan";

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            if (coLoc) {
                ps.setString(
                        1,
                        khuVuc.trim()
                );
            }

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                while (rs.next()) {
                    BanAn ban =
                            new BanAn();

                    ban.setMaBan(
                            rs.getInt("MaBan")
                    );

                    ban.setTenBan(
                            rs.getString("TenBan")
                    );

                    ban.setSoCho(
                            rs.getInt("SoCho")
                    );

                    ban.setKhuVuc(
                            rs.getString("KhuVuc")
                    );

                    ban.setTrangThai(
                            rs.getInt("TrangThai")
                    );

                    ban.setMaDonHang(
                            rs.getString(
                                    "MaDonHang"
                            )
                    );

                    list.add(ban);
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được danh sách bàn.",
                    e
            );
        }

        return list;
    }
}