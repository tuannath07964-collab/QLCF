package dao;

import model.DanhMucSanPham;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class DanhMucSanPhamDAO {

    public List<DanhMucSanPham> getAll() {

        List<DanhMucSanPham> list =
                new ArrayList<>();

        String sql = """
            SELECT dm.MaDanhMuc,
                   dm.TenDanhMuc,
                   dm.TrangThai,
                   COUNT(sp.MaSanPham)
                       AS SoLuongSanPham
            FROM DanhMucSanPham dm
            LEFT JOIN SanPham sp
                ON sp.MaDanhMuc =
                   dm.MaDanhMuc
            GROUP BY dm.MaDanhMuc,
                     dm.TenDanhMuc,
                     dm.TrangThai
            ORDER BY dm.MaDanhMuc
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
                    "Không tải được danh mục sản phẩm.",
                    e
            );
        }

        return list;
    }

    public List<DanhMucSanPham> getDangHoatDong() {

        List<DanhMucSanPham> list =
                new ArrayList<>();

        String sql = """
            SELECT MaDanhMuc,
                   TenDanhMuc,
                   TrangThai,
                   0 AS SoLuongSanPham
            FROM DanhMucSanPham
            WHERE TrangThai = 1
            ORDER BY TenDanhMuc
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
                    "Không tải được danh mục đang hoạt động.",
                    e
            );
        }

        return list;
    }

    public DanhMucSanPham findById(
            String maDanhMuc
    ) {
        String sql = """
            SELECT MaDanhMuc,
                   TenDanhMuc,
                   TrangThai,
                   0 AS SoLuongSanPham
            FROM DanhMucSanPham
            WHERE MaDanhMuc = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    maDanhMuc
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
                    "Không tìm thấy danh mục.",
                    e
            );
        }
    }

    public void insert(
            DanhMucSanPham danhMuc
    ) {
        validate(danhMuc);

        String sql = """
            INSERT INTO DanhMucSanPham(
                MaDanhMuc,
                TenDanhMuc,
                TrangThai
            )
            VALUES (?, ?, ?)
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    danhMuc
                            .getMaDanhMuc()
                            .trim()
            );

            ps.setString(
                    2,
                    danhMuc
                            .getTenDanhMuc()
                            .trim()
            );

            ps.setBoolean(
                    3,
                    danhMuc.isTrangThai()
            );

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không thêm được danh mục. "
                    + "Kiểm tra mã hoặc tên đã tồn tại.",
                    e
            );
        }
    }

    public void update(
            DanhMucSanPham danhMuc
    ) {
        validate(danhMuc);

        String sql = """
            UPDATE DanhMucSanPham
            SET TenDanhMuc = ?,
                TrangThai = ?
            WHERE MaDanhMuc = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    danhMuc
                            .getTenDanhMuc()
                            .trim()
            );

            ps.setBoolean(
                    2,
                    danhMuc.isTrangThai()
            );

            ps.setString(
                    3,
                    danhMuc
                            .getMaDanhMuc()
                            .trim()
            );

            if (ps.executeUpdate() != 1) {
                throw new IllegalStateException(
                        "Không tìm thấy danh mục cần sửa."
                );
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không cập nhật được danh mục.",
                    e
            );
        }
    }

    public void toggleStatus(
            String maDanhMuc
    ) {
        String sql = """
            UPDATE DanhMucSanPham
            SET TrangThai =
                CASE
                    WHEN TrangThai = 1
                    THEN 0
                    ELSE 1
                END
            WHERE MaDanhMuc = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    maDanhMuc
            );

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không đổi được trạng thái danh mục.",
                    e
            );
        }
    }

    private DanhMucSanPham mapRow(
            ResultSet rs
    ) throws SQLException {

        DanhMucSanPham danhMuc =
                new DanhMucSanPham();

        danhMuc.setMaDanhMuc(
                rs.getString(
                        "MaDanhMuc"
                )
        );

        danhMuc.setTenDanhMuc(
                rs.getString(
                        "TenDanhMuc"
                )
        );

        danhMuc.setTrangThai(
                rs.getBoolean(
                        "TrangThai"
                )
        );

        danhMuc.setSoLuongSanPham(
                rs.getInt(
                        "SoLuongSanPham"
                )
        );

        return danhMuc;
    }

    private void validate(
            DanhMucSanPham danhMuc
    ) {
        if (
            danhMuc == null
            || danhMuc.getMaDanhMuc() == null
            || danhMuc.getMaDanhMuc().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Mã danh mục là bắt buộc."
            );
        }

        if (
            danhMuc.getTenDanhMuc() == null
            || danhMuc.getTenDanhMuc().isBlank()
        ) {
            throw new IllegalArgumentException(
                    "Tên danh mục là bắt buộc."
            );
        }
    }
}