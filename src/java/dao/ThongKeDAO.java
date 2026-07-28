package dao;

import model.DoanhThuNgay;
import model.ThongKeHoaDon;
import util.DBConnect;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import java.util.ArrayList;

public class ThongKeDAO {

    private static final DateTimeFormatter
            DISPLAY_DATE_FORMAT =
            DateTimeFormatter.ofPattern(
                    "dd/MM/yyyy"
            );

    private static final DateTimeFormatter
            DISPLAY_DATE_TIME_FORMAT =
            DateTimeFormatter.ofPattern(
                    "dd/MM/yyyy HH:mm"
            );

    public ArrayList<ThongKeHoaDon>
            getHoaDonDaThanhToan(
                    LocalDate tuNgay,
                    LocalDate denNgay
            ) {

        ArrayList<ThongKeHoaDon> list =
                new ArrayList<>();

        String sql = """
            SELECT MaHD,
                   NgayThanhToan,
                   PhuongThucThanhToan,
                   TongTien,
                   HinhThuc,
                   MaBan,
                   MaNV,
                   COALESCE(
                       NULLIF(
                           LTRIM(
                               RTRIM(
                                   TenKhachHang
                               )
                           ),
                           N''
                       ),
                       N'Khách lẻ'
                   ) AS TenKhachHang
            FROM HoaDon
            WHERE TrangThai = N'Đã thanh toán'
              AND NgayThanhToan IS NOT NULL
              AND CAST(
                    NgayThanhToan AS DATE
                  ) BETWEEN ? AND ?
            ORDER BY NgayThanhToan DESC,
                     MaHD DESC
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setDate(
                    1,
                    Date.valueOf(tuNgay)
            );

            ps.setDate(
                    2,
                    Date.valueOf(denNgay)
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                while (rs.next()) {
                    list.add(
                            mapHoaDon(rs)
                    );
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được danh sách "
                    + "hóa đơn đã thanh toán.",
                    e
            );
        }

        return list;
    }

    public TongQuanDoanhThu getTongQuan(
            LocalDate tuNgay,
            LocalDate denNgay
    ) {
        String sql = """
            SELECT COUNT(*) AS SoHoaDon,

                   COALESCE(
                       SUM(TongTien),
                       0
                   ) AS TongDoanhThu,

                   COALESCE(
                       SUM(
                           CASE
                               WHEN PhuongThucThanhToan
                                    = N'Tiền mặt'
                               THEN TongTien
                               ELSE 0
                           END
                       ),
                       0
                   ) AS DoanhThuTienMat,

                   COALESCE(
                       SUM(
                           CASE
                               WHEN PhuongThucThanhToan
                                    IS NULL
                                    OR PhuongThucThanhToan
                                       <> N'Tiền mặt'
                               THEN TongTien
                               ELSE 0
                           END
                       ),
                       0
                   ) AS DoanhThuKhac,

                   COALESCE(
                       SUM(
                           CASE
                               WHEN HinhThuc
                                    = N'Mang về'
                               THEN TongTien
                               ELSE 0
                           END
                       ),
                       0
                   ) AS DoanhThuMangVe,

                   COALESCE(
                       SUM(
                           CASE
                               WHEN HinhThuc
                                    = N'Tại bàn'
                               THEN TongTien
                               ELSE 0
                           END
                       ),
                       0
                   ) AS DoanhThuTaiBan

            FROM HoaDon
            WHERE TrangThai = N'Đã thanh toán'
              AND NgayThanhToan IS NOT NULL
              AND CAST(
                    NgayThanhToan AS DATE
                  ) BETWEEN ? AND ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setDate(
                    1,
                    Date.valueOf(tuNgay)
            );

            ps.setDate(
                    2,
                    Date.valueOf(denNgay)
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                if (rs.next()) {
                    TongQuanDoanhThu data =
                            new TongQuanDoanhThu();

                    data.setSoHoaDon(
                            rs.getInt(
                                    "SoHoaDon"
                            )
                    );

                    data.setTongDoanhThu(
                            getMoney(
                                    rs,
                                    "TongDoanhThu"
                            )
                    );

                    data.setDoanhThuTienMat(
                            getMoney(
                                    rs,
                                    "DoanhThuTienMat"
                            )
                    );

                    data.setDoanhThuKhac(
                            getMoney(
                                    rs,
                                    "DoanhThuKhac"
                            )
                    );

                    data.setDoanhThuMangVe(
                            getMoney(
                                    rs,
                                    "DoanhThuMangVe"
                            )
                    );

                    data.setDoanhThuTaiBan(
                            getMoney(
                                    rs,
                                    "DoanhThuTaiBan"
                            )
                    );

                    return data;
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không lấy được tổng quan doanh thu.",
                    e
            );
        }

        return new TongQuanDoanhThu();
    }

    public ArrayList<DoanhThuNgay>
            getDoanhThuTheoNgay(
                    LocalDate tuNgay,
                    LocalDate denNgay
            ) {

        ArrayList<DoanhThuNgay> list =
                new ArrayList<>();

        String sql = """
            SELECT CAST(
                       NgayThanhToan AS DATE
                   ) AS Ngay,

                   COUNT(*) AS SoHoaDon,

                   COALESCE(
                       SUM(TongTien),
                       0
                   ) AS DoanhThu

            FROM HoaDon

            WHERE TrangThai = N'Đã thanh toán'
              AND NgayThanhToan IS NOT NULL
              AND CAST(
                    NgayThanhToan AS DATE
                  ) BETWEEN ? AND ?

            GROUP BY CAST(
                         NgayThanhToan AS DATE
                     )

            ORDER BY Ngay
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setDate(
                    1,
                    Date.valueOf(tuNgay)
            );

            ps.setDate(
                    2,
                    Date.valueOf(denNgay)
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {
                while (rs.next()) {
                    Date sqlDate =
                            rs.getDate("Ngay");

                    String ngay =
                            sqlDate == null
                            ? ""
                            : sqlDate
                                .toLocalDate()
                                .format(
                                    DISPLAY_DATE_FORMAT
                                );

                    list.add(
                        new DoanhThuNgay(
                            ngay,
                            rs.getInt(
                                    "SoHoaDon"
                            ),
                            getMoney(
                                    rs,
                                    "DoanhThu"
                            )
                        )
                    );
                }
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không lấy được biểu đồ doanh thu.",
                    e
            );
        }

        return list;
    }

    private ThongKeHoaDon mapHoaDon(
            ResultSet rs
    ) throws SQLException {

        ThongKeHoaDon hoaDon =
                new ThongKeHoaDon();

        hoaDon.setMaHD(
                rs.getString("MaHD")
        );

        if (
            rs.getTimestamp(
                    "NgayThanhToan"
            ) != null
        ) {
            hoaDon.setNgayThanhToan(
                    rs.getTimestamp(
                            "NgayThanhToan"
                    )
                    .toLocalDateTime()
                    .format(
                        DISPLAY_DATE_TIME_FORMAT
                    )
            );
        }

        hoaDon.setPhuongThucThanhToan(
                rs.getString(
                        "PhuongThucThanhToan"
                )
        );

        hoaDon.setTongTien(
                getMoney(
                        rs,
                        "TongTien"
                )
        );

        hoaDon.setHinhThuc(
                rs.getString(
                        "HinhThuc"
                )
        );

        hoaDon.setMaBan(
                rs.getString(
                        "MaBan"
                )
        );

        hoaDon.setMaNV(
                rs.getString(
                        "MaNV"
                )
        );

        hoaDon.setTenKhachHang(
                rs.getString(
                        "TenKhachHang"
                )
        );

        return hoaDon;
    }

    private BigDecimal getMoney(
            ResultSet rs,
            String column
    ) throws SQLException {

        BigDecimal value =
                rs.getBigDecimal(column);

        return value == null
                ? BigDecimal.ZERO
                : value;
    }

    public static class TongQuanDoanhThu {

        private int soHoaDon;

        private BigDecimal tongDoanhThu =
                BigDecimal.ZERO;

        private BigDecimal doanhThuTienMat =
                BigDecimal.ZERO;

        private BigDecimal doanhThuKhac =
                BigDecimal.ZERO;

        private BigDecimal doanhThuMangVe =
                BigDecimal.ZERO;

        private BigDecimal doanhThuTaiBan =
                BigDecimal.ZERO;

        public int getSoHoaDon() {
            return soHoaDon;
        }

        public void setSoHoaDon(
                int soHoaDon
        ) {
            this.soHoaDon = soHoaDon;
        }

        public BigDecimal getTongDoanhThu() {
            return tongDoanhThu;
        }

        public void setTongDoanhThu(
                BigDecimal tongDoanhThu
        ) {
            this.tongDoanhThu =
                    tongDoanhThu;
        }

        public BigDecimal getDoanhThuTienMat() {
            return doanhThuTienMat;
        }

        public void setDoanhThuTienMat(
                BigDecimal doanhThuTienMat
        ) {
            this.doanhThuTienMat =
                    doanhThuTienMat;
        }

        public BigDecimal getDoanhThuKhac() {
            return doanhThuKhac;
        }

        public void setDoanhThuKhac(
                BigDecimal doanhThuKhac
        ) {
            this.doanhThuKhac =
                    doanhThuKhac;
        }

        public BigDecimal getDoanhThuMangVe() {
            return doanhThuMangVe;
        }

        public void setDoanhThuMangVe(
                BigDecimal doanhThuMangVe
        ) {
            this.doanhThuMangVe =
                    doanhThuMangVe;
        }

        public BigDecimal getDoanhThuTaiBan() {
            return doanhThuTaiBan;
        }

        public void setDoanhThuTaiBan(
                BigDecimal doanhThuTaiBan
        ) {
            this.doanhThuTaiBan =
                    doanhThuTaiBan;
        }
    }
}