package dao;

import model.HoaDon;
import model.NguyenLieu;
import util.DBConnect;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.List;

public class HomepageDAO {

    private static final DateTimeFormatter DATE_TIME_FORMAT =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public HomepageSummary getSummary() {

        String sql = """
            SELECT
                (
                    SELECT COUNT(*)
                    FROM HoaDon
                    WHERE TrangThai = N'Chờ thanh toán'
                ) AS DonChoThanhToan,

                (
                    SELECT COUNT(*)
                    FROM HoaDon
                    WHERE TrangThai = N'Đã thanh toán'
                      AND CAST(NgayThanhToan AS DATE)
                          = CAST(GETDATE() AS DATE)
                ) AS DonHomNay,

                (
                    SELECT ISNULL(SUM(TongTien), 0)
                    FROM HoaDon
                    WHERE TrangThai = N'Đã thanh toán'
                      AND CAST(NgayThanhToan AS DATE)
                          = CAST(GETDATE() AS DATE)
                ) AS DoanhThuHomNay,

                (
                    SELECT COUNT(*)
                    FROM SanPham
                    WHERE TrangThai = 1
                ) AS SanPhamDangBan,

                (
                    SELECT COUNT(*)
                    FROM NguyenLieu
                    WHERE TrangThai = 1
                      AND SoLuongTon <= MucNhapCoDinh
                ) AS NguyenLieuCanNhap
            """;

        try (
            Connection connection =
                    DBConnect.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            HomepageSummary summary =
                    new HomepageSummary();

            if (resultSet.next()) {
                summary.setDonChoThanhToan(
                        resultSet.getInt("DonChoThanhToan")
                );

                summary.setDonHomNay(
                        resultSet.getInt("DonHomNay")
                );

                summary.setDoanhThuHomNay(
                        resultSet.getBigDecimal("DoanhThuHomNay")
                );

                summary.setSanPhamDangBan(
                        resultSet.getInt("SanPhamDangBan")
                );

                summary.setNguyenLieuCanNhap(
                        resultSet.getInt("NguyenLieuCanNhap")
                );
            }

            return summary;

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được tổng quan trang chủ.",
                    exception
            );
        }
    }

    public List<HoaDon> getDonChoThanhToan() {

        List<HoaDon> list =
                new ArrayList<>();

        String sql = """
            SELECT TOP 8
                   h.MaHD,
                   h.MaTaiKhoan,
                   tk.HoTen AS TenTaiKhoan,
                   h.MaKH,

                   COALESCE(
                       NULLIF(h.TenKhachHang, N''),
                       kh.HoTen,
                       N'Khách lẻ'
                   ) AS TenKhachHang,

                   h.NgayTao,
                   h.TongTien,
                   h.TrangThai

            FROM HoaDon h

            JOIN TaiKhoan tk
                ON tk.MaTaiKhoan = h.MaTaiKhoan

            LEFT JOIN KhachHang kh
                ON kh.MaKH = h.MaKH

            WHERE h.TrangThai = N'Chờ thanh toán'

            ORDER BY h.MaHD DESC
            """;

        try (
            Connection connection =
                    DBConnect.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            while (resultSet.next()) {
                HoaDon hoaDon =
                        new HoaDon();

                hoaDon.setMaHD(
                        resultSet.getInt("MaHD")
                );

                hoaDon.setMaTaiKhoan(
                        resultSet.getString("MaTaiKhoan")
                );

                hoaDon.setTenTaiKhoan(
                        resultSet.getString("TenTaiKhoan")
                );

                hoaDon.setMaKH(
                        resultSet.getString("MaKH")
                );

                hoaDon.setTenKhachHang(
                        resultSet.getString("TenKhachHang")
                );

                hoaDon.setNgayTao(
                        formatTimestamp(
                                resultSet.getTimestamp("NgayTao")
                        )
                );

                BigDecimal tongTien =
                        resultSet.getBigDecimal("TongTien");

                hoaDon.setTongTien(
                        tongTien == null
                                ? BigDecimal.ZERO
                                : tongTien
                );

                hoaDon.setTrangThai(
                        resultSet.getString("TrangThai")
                );

                list.add(hoaDon);
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được đơn chờ thanh toán.",
                    exception
            );
        }

        return list;
    }

    public List<NguyenLieu> getNguyenLieuCanNhap() {

        List<NguyenLieu> list =
                new ArrayList<>();

        String sql = """
            SELECT TOP 8
                   MaNguyenLieu,
                   TenNguyenLieu,
                   SoLuongTon,
                   MucNhapCoDinh,
                   DonVi,
                   TrangThai

            FROM NguyenLieu

            WHERE TrangThai = 1
              AND SoLuongTon <= MucNhapCoDinh

            ORDER BY
                CASE
                    WHEN SoLuongTon = 0 THEN 0
                    ELSE 1
                END,
                SoLuongTon ASC,
                TenNguyenLieu ASC
            """;

        try (
            Connection connection =
                    DBConnect.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            while (resultSet.next()) {
                NguyenLieu nguyenLieu =
                        new NguyenLieu();

                nguyenLieu.setMaNguyenLieu(
                        resultSet.getString("MaNguyenLieu")
                );

                nguyenLieu.setTenNguyenLieu(
                        resultSet.getString("TenNguyenLieu")
                );

                nguyenLieu.setSoLuongTon(
                        resultSet.getInt("SoLuongTon")
                );

                nguyenLieu.setMucNhapCoDinh(
                        resultSet.getInt("MucNhapCoDinh")
                );

                nguyenLieu.setDonVi(
                        resultSet.getString("DonVi")
                );

                nguyenLieu.setTrangThai(
                        resultSet.getBoolean("TrangThai")
                );

                list.add(nguyenLieu);
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được cảnh báo kho.",
                    exception
            );
        }

        return list;
    }

    private String formatTimestamp(
            Timestamp timestamp
    ) {
        if (timestamp == null) {
            return "";
        }

        return timestamp
                .toLocalDateTime()
                .format(DATE_TIME_FORMAT);
    }

    public static class HomepageSummary {

        private int donChoThanhToan;
        private int donHomNay;
        private int sanPhamDangBan;
        private int nguyenLieuCanNhap;

        private BigDecimal doanhThuHomNay =
                BigDecimal.ZERO;

        public int getDonChoThanhToan() {
            return donChoThanhToan;
        }

        public void setDonChoThanhToan(
                int donChoThanhToan
        ) {
            this.donChoThanhToan =
                    donChoThanhToan;
        }

        public int getDonHomNay() {
            return donHomNay;
        }

        public void setDonHomNay(
                int donHomNay
        ) {
            this.donHomNay =
                    donHomNay;
        }

        public int getSanPhamDangBan() {
            return sanPhamDangBan;
        }

        public void setSanPhamDangBan(
                int sanPhamDangBan
        ) {
            this.sanPhamDangBan =
                    sanPhamDangBan;
        }

        public int getNguyenLieuCanNhap() {
            return nguyenLieuCanNhap;
        }

        public void setNguyenLieuCanNhap(
                int nguyenLieuCanNhap
        ) {
            this.nguyenLieuCanNhap =
                    nguyenLieuCanNhap;
        }

        public BigDecimal getDoanhThuHomNay() {
            return doanhThuHomNay;
        }

        public void setDoanhThuHomNay(
                BigDecimal doanhThuHomNay
        ) {
            this.doanhThuHomNay =
                    doanhThuHomNay == null
                            ? BigDecimal.ZERO
                            : doanhThuHomNay;
        }
    }
}