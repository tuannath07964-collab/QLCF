package dao;

import model.KhachHang;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import java.util.ArrayList;

public class KhachHangDAO {

    public ArrayList<KhachHang>
            getAllKhachHang() {

        ArrayList<KhachHang> list =
                new ArrayList<>();

        String sql = """
            SELECT MaKH,
                   HoTen,
                   SDT,
                   DiemTichLuy
            FROM KhachHang
            ORDER BY MaKH
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery()
        ) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được danh sách khách hàng.",
                    e
            );
        }

        return list;
    }

    public KhachHang getKhachHangById(
            String maKH
    ) {
        String sql = """
            SELECT MaKH,
                   HoTen,
                   SDT,
                   DiemTichLuy
            FROM KhachHang
            WHERE MaKH = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(1, maKH);

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
                    "Không tìm thấy khách hàng.",
                    e
            );
        }
    }

    public boolean insertKhachHang(
            KhachHang kh
    ) {
        validateKhachHang(kh);

        String sql = """
            INSERT INTO KhachHang(
                MaKH,
                HoTen,
                SDT,
                DiemTichLuy
            )
            VALUES (?, ?, ?, 0)
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    kh.getMaKH().trim()
            );

            ps.setString(
                    2,
                    kh.getHoTen().trim()
            );

            setNullableString(
                    ps,
                    3,
                    kh.getSdt()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không thêm được khách hàng. "
                    + "Kiểm tra mã hoặc số điện thoại.",
                    e
            );
        }
    }

    public boolean updateKhachHang(
            KhachHang kh
    ) {
        validateKhachHang(kh);

        String sql = """
            UPDATE KhachHang
            SET HoTen = ?,
                SDT = ?
            WHERE MaKH = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    kh.getHoTen().trim()
            );

            setNullableString(
                    ps,
                    2,
                    kh.getSdt()
            );

            ps.setString(
                    3,
                    kh.getMaKH().trim()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không cập nhật được khách hàng.",
                    e
            );
        }
    }

    public boolean deleteKhachHang(
            String maKH
    ) {
        String sql = """
            DELETE FROM KhachHang
            WHERE MaKH = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(1, maKH);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không xóa được khách hàng "
                    + "đã liên kết với hóa đơn.",
                    e
            );
        }
    }

    private KhachHang mapRow(
            ResultSet rs
    ) throws SQLException {

        KhachHang kh =
                new KhachHang();

        kh.setMaKH(
                rs.getString("MaKH")
        );

        kh.setHoTen(
                rs.getString("HoTen")
        );

        kh.setSdt(
                rs.getString("SDT")
        );

        kh.setDiemTichLuy(
                rs.getInt("DiemTichLuy")
        );

        return kh;
    }

    private void validateKhachHang(
            KhachHang kh
    ) {
        if (kh == null) {
            throw new IllegalArgumentException(
                    "Thông tin khách hàng không hợp lệ."
            );
        }

        if (
            kh.getMaKH() == null
            || kh.getMaKH().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Mã khách hàng là bắt buộc."
            );
        }

        if (
            kh.getHoTen() == null
            || kh.getHoTen().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Họ tên khách hàng là bắt buộc."
            );
        }
    }

    private void setNullableString(
            PreparedStatement ps,
            int index,
            String value
    ) throws SQLException {

        if (
            value == null
            || value.isBlank()
        ) {
            ps.setNull(
                    index,
                    Types.NVARCHAR
            );
        } else {
            ps.setString(
                    index,
                    value.trim()
            );
        }
    }
}