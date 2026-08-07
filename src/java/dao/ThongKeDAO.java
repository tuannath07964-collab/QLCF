package dao;

import model.DoanhThuNgay;
import model.ThongKeHoaDon;
import model.TopSanPham;
import util.DBConnect;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.List;

public class ThongKeDAO {

    private static final DateTimeFormatter DATE_FORMAT =
            DateTimeFormatter.ofPattern(
                    "dd/MM/yyyy"
            );

    private static final DateTimeFormatter DATE_TIME_FORMAT =
            DateTimeFormatter.ofPattern(
                    "dd/MM/yyyy HH:mm"
            );

    public TongQuanThongKe getTongQuan(
            LocalDate tuNgay,
            LocalDate denNgay
    ) {
        validateDateRange(
                tuNgay,
                denNgay
        );

        String sql = """
            SELECT
                COUNT(*) AS SoHoaDon,

                ISNULL(
                    SUM(TongTien),
                    0
                ) AS TongDoanhThu,

                ISNULL(
                    AVG(
                        CAST(
                            TongTien AS DECIMAL(18, 2)
                        )
                    ),
                    0
                ) AS GiaTriTrungBinh

            FROM HoaDon

            WHERE TrangThai = N'Đã thanh toán'
              AND NgayThanhToan >= ?
              AND NgayThanhToan < DATEADD(DAY, 1, ?)
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            setDateRange(
                    statement,
                    tuNgay,
                    denNgay
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                TongQuanThongKe tongQuan =
                        new TongQuanThongKe();

                if (resultSet.next()) {

                    tongQuan.setSoHoaDon(
                            resultSet.getInt(
                                    "SoHoaDon"
                            )
                    );

                    tongQuan.setTongDoanhThu(
                            getMoney(
                                    resultSet,
                                    "TongDoanhThu"
                            )
                    );

                    tongQuan.setGiaTriTrungBinh(
                            getMoney(
                                    resultSet,
                                    "GiaTriTrungBinh"
                            )
                    );
                }

                return tongQuan;
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được tổng quan thống kê: "
                    + exception.getMessage(),
                    exception
            );
        }
    }

    public List<DoanhThuNgay> getDoanhThuTheoNgay(
            LocalDate tuNgay,
            LocalDate denNgay
    ) {
        validateDateRange(
                tuNgay,
                denNgay
        );

        List<DoanhThuNgay> danhSach =
                new ArrayList<>();

        String sql = """
            SELECT
                CAST(NgayThanhToan AS DATE) AS Ngay,
                SUM(TongTien) AS DoanhThu

            FROM HoaDon

            WHERE TrangThai = N'Đã thanh toán'
              AND NgayThanhToan >= ?
              AND NgayThanhToan < DATEADD(DAY, 1, ?)

            GROUP BY
                CAST(NgayThanhToan AS DATE)

            ORDER BY
                CAST(NgayThanhToan AS DATE)
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            setDateRange(
                    statement,
                    tuNgay,
                    denNgay
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                while (resultSet.next()) {

                    DoanhThuNgay doanhThuNgay =
                            new DoanhThuNgay();

                    Date ngay =
                            resultSet.getDate(
                                    "Ngay"
                            );

                    doanhThuNgay.setNgay(
                            ngay == null
                            ? ""
                            : ngay.toLocalDate()
                                    .format(
                                            DATE_FORMAT
                                    )
                    );

                    doanhThuNgay.setDoanhThu(
                            getMoney(
                                    resultSet,
                                    "DoanhThu"
                            )
                    );

                    danhSach.add(
                            doanhThuNgay
                    );
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được doanh thu theo ngày: "
                    + exception.getMessage(),
                    exception
            );
        }

        return danhSach;
    }

    public List<TopSanPham> getTopSanPham(
            LocalDate tuNgay,
            LocalDate denNgay
    ) {
        validateDateRange(
                tuNgay,
                denNgay
        );

        List<TopSanPham> danhSach =
                new ArrayList<>();

        String sql = """
            SELECT TOP 5
                sp.TenSanPham,
                SUM(ct.SoLuong) AS SoLuongBan,

                SUM(
                    ct.SoLuong * ct.DonGia
                ) AS DoanhThu

            FROM ChiTietHoaDon ct

            INNER JOIN HoaDon h
                ON h.MaHD = ct.MaHD

            INNER JOIN SanPham sp
                ON sp.MaSanPham = ct.MaSanPham

            WHERE h.TrangThai = N'Đã thanh toán'
              AND h.NgayThanhToan >= ?
              AND h.NgayThanhToan < DATEADD(DAY, 1, ?)

            GROUP BY
                sp.MaSanPham,
                sp.TenSanPham

            ORDER BY
                SUM(ct.SoLuong) DESC,
                SUM(ct.SoLuong * ct.DonGia) DESC,
                sp.TenSanPham ASC
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            setDateRange(
                    statement,
                    tuNgay,
                    denNgay
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                while (resultSet.next()) {

                    TopSanPham topSanPham =
                            new TopSanPham();

                    topSanPham.setTenSanPham(
                            resultSet.getString(
                                    "TenSanPham"
                            )
                    );

                    topSanPham.setSoLuongBan(
                            resultSet.getInt(
                                    "SoLuongBan"
                            )
                    );

                    topSanPham.setDoanhThu(
                            getMoney(
                                    resultSet,
                                    "DoanhThu"
                            )
                    );

                    danhSach.add(
                            topSanPham
                    );
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được 5 sản phẩm bán chạy: "
                    + exception.getMessage(),
                    exception
            );
        }

        return danhSach;
    }

    public List<ThongKeHoaDon> getDanhSachHoaDon(
            LocalDate tuNgay,
            LocalDate denNgay
    ) {
        validateDateRange(
                tuNgay,
                denNgay
        );

        List<ThongKeHoaDon> danhSach =
                new ArrayList<>();

        String sql = """
            SELECT
                h.MaHD,
                h.NgayThanhToan,
                tk.HoTen AS TenTaiKhoan,

                COALESCE(
                    NULLIF(
                        h.TenKhachHang,
                        N''
                    ),
                    kh.HoTen,
                    N'Khách lẻ'
                ) AS TenKhachHang,

                h.TongTien

            FROM HoaDon h

            INNER JOIN TaiKhoan tk
                ON tk.MaTaiKhoan = h.MaTaiKhoan

            LEFT JOIN KhachHang kh
                ON kh.MaKH = h.MaKH

            WHERE h.TrangThai = N'Đã thanh toán'
              AND h.NgayThanhToan >= ?
              AND h.NgayThanhToan < DATEADD(DAY, 1, ?)

            ORDER BY
                h.NgayThanhToan DESC,
                h.MaHD DESC
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            setDateRange(
                    statement,
                    tuNgay,
                    denNgay
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                while (resultSet.next()) {

                    ThongKeHoaDon hoaDon =
                            new ThongKeHoaDon();

                    hoaDon.setMaHD(
                            resultSet.getInt(
                                    "MaHD"
                            )
                    );

                    hoaDon.setNgayThanhToan(
                            formatTimestamp(
                                    resultSet.getTimestamp(
                                            "NgayThanhToan"
                                    )
                            )
                    );

                    hoaDon.setTenTaiKhoan(
                            resultSet.getString(
                                    "TenTaiKhoan"
                            )
                    );

                    hoaDon.setTenKhachHang(
                            resultSet.getString(
                                    "TenKhachHang"
                            )
                    );

                    hoaDon.setTongTien(
                            getMoney(
                                    resultSet,
                                    "TongTien"
                            )
                    );

                    danhSach.add(
                            hoaDon
                    );
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được danh sách hóa đơn thống kê: "
                    + exception.getMessage(),
                    exception
            );
        }

        return danhSach;
    }

    private void setDateRange(
            PreparedStatement statement,
            LocalDate tuNgay,
            LocalDate denNgay
    ) throws SQLException {

        statement.setDate(
                1,
                Date.valueOf(tuNgay)
        );

        statement.setDate(
                2,
                Date.valueOf(denNgay)
        );
    }

    private BigDecimal getMoney(
            ResultSet resultSet,
            String columnName
    ) throws SQLException {

        BigDecimal value =
                resultSet.getBigDecimal(
                        columnName
                );

        return value == null
                ? BigDecimal.ZERO
                : value;
    }

    private String formatTimestamp(
            Timestamp timestamp
    ) {
        if (timestamp == null) {
            return "";
        }

        return timestamp
                .toLocalDateTime()
                .format(
                        DATE_TIME_FORMAT
                );
    }

    private void validateDateRange(
            LocalDate tuNgay,
            LocalDate denNgay
    ) {
        if (
            tuNgay == null
            || denNgay == null
        ) {
            throw new IllegalArgumentException(
                    "Khoảng thời gian thống kê không hợp lệ."
            );
        }

        if (tuNgay.isAfter(denNgay)) {
            throw new IllegalArgumentException(
                    "Ngày bắt đầu không được sau ngày kết thúc."
            );
        }
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

    public static class TongQuanThongKe {

        private int soHoaDon;

        private BigDecimal tongDoanhThu =
                BigDecimal.ZERO;

        private BigDecimal giaTriTrungBinh =
                BigDecimal.ZERO;

        public int getSoHoaDon() {
            return soHoaDon;
        }

        public void setSoHoaDon(
                int soHoaDon
        ) {
            this.soHoaDon =
                    soHoaDon;
        }

        public BigDecimal getTongDoanhThu() {
            return tongDoanhThu;
        }

        public void setTongDoanhThu(
                BigDecimal tongDoanhThu
        ) {
            this.tongDoanhThu =
                    defaultMoney(
                            tongDoanhThu
                    );
        }

        public BigDecimal getGiaTriTrungBinh() {
            return giaTriTrungBinh;
        }

        public void setGiaTriTrungBinh(
                BigDecimal giaTriTrungBinh
        ) {
            this.giaTriTrungBinh =
                    defaultMoney(
                            giaTriTrungBinh
                    );
        }

        private BigDecimal defaultMoney(
                BigDecimal value
        ) {
            return value == null
                    ? BigDecimal.ZERO
                    : value;
        }
    }
}