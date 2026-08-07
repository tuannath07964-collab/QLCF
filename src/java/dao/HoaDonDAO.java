package dao;

import model.ChiTietHoaDon;
import model.HoaDon;
import model.VoucherKhachHang;
import util.DBConnect;

import java.math.BigDecimal;
import java.math.RoundingMode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;

import java.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.List;

public class HoaDonDAO {

    private static final BigDecimal VAT_RATE =
            new BigDecimal("0.08");

    private static final BigDecimal MONEY_PER_POINT =
            new BigDecimal("10000");

    private static final DateTimeFormatter DATE_FORMAT =
            DateTimeFormatter.ofPattern(
                    "dd/MM/yyyy HH:mm"
            );

    public int taoHoaDon(
            String maTaiKhoan
    ) {
        String sql = """
            INSERT INTO HoaDon (
                MaTaiKhoan,
                TrangThai
            )
            VALUES (
                ?,
                N'Chờ thanh toán'
            )
            """;

        try (
            Connection connection =
                    DBConnect.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            sql,
                            Statement.RETURN_GENERATED_KEYS
                    )
        ) {
            statement.setString(
                    1,
                    maTaiKhoan
            );

            statement.executeUpdate();

            try (
                ResultSet keys =
                        statement.getGeneratedKeys()
            ) {
                if (!keys.next()) {
                    throw new IllegalStateException(
                            "Không tạo được mã hóa đơn."
                    );
                }

                return keys.getInt(1);
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tạo được hóa đơn.",
                    exception
            );
        }
    }

    public List<HoaDon> getAll() {
        List<HoaDon> list =
                new ArrayList<>();

        String sql = """
            SELECT
                h.MaHD,
                h.MaTaiKhoan,
                tk.HoTen AS TenTaiKhoan,
                h.MaKH,

                COALESCE(
                    NULLIF(
                        h.TenKhachHang,
                        N''
                    ),
                    kh.HoTen,
                    N'Khách lẻ'
                ) AS TenKhachHang,

                COALESCE(
                    NULLIF(
                        h.SDTKhachHang,
                        ''
                    ),
                    kh.SDT,
                    ''
                ) AS SDTKhachHang,

                h.NgayTao,
                h.NgayThanhToan,
                h.TamTinh,
                h.ThueVAT,
                h.TongTien,
                h.DiemCong,
                h.TrangThai,
                h.PhuongThucThanhToan,
                h.LyDoHuy

            FROM HoaDon h

            INNER JOIN TaiKhoan tk
                ON tk.MaTaiKhoan =
                   h.MaTaiKhoan

            LEFT JOIN KhachHang kh
                ON kh.MaKH =
                   h.MaKH

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
                list.add(
                        mapRow(resultSet)
                );
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được danh sách hóa đơn.",
                    exception
            );
        }

        return list;
    }

    public HoaDon findById(
            int maHD
    ) {
        String sql = """
            SELECT
                h.MaHD,
                h.MaTaiKhoan,
                tk.HoTen AS TenTaiKhoan,
                h.MaKH,

                COALESCE(
                    NULLIF(
                        h.TenKhachHang,
                        N''
                    ),
                    kh.HoTen,
                    N'Khách lẻ'
                ) AS TenKhachHang,

                COALESCE(
                    NULLIF(
                        h.SDTKhachHang,
                        ''
                    ),
                    kh.SDT,
                    ''
                ) AS SDTKhachHang,

                h.NgayTao,
                h.NgayThanhToan,
                h.TamTinh,
                h.ThueVAT,
                h.TongTien,
                h.DiemCong,
                h.TrangThai,
                h.PhuongThucThanhToan,
                h.LyDoHuy

            FROM HoaDon h

            INNER JOIN TaiKhoan tk
                ON tk.MaTaiKhoan =
                   h.MaTaiKhoan

            LEFT JOIN KhachHang kh
                ON kh.MaKH =
                   h.MaKH

            WHERE h.MaHD = ?
            """;

        try (
            Connection connection =
                    DBConnect.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                return resultSet.next()
                        ? mapRow(resultSet)
                        : null;
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tìm thấy hóa đơn.",
                    exception
            );
        }
    }

    public List<ChiTietHoaDon> getChiTiet(
            int maHD
    ) {
        List<ChiTietHoaDon> list =
                new ArrayList<>();

        String sql = """
            SELECT
                ct.MaCT,
                ct.MaHD,
                ct.MaSanPham,
                sp.TenSanPham,
                ct.SoLuong,
                ct.DonGia

            FROM ChiTietHoaDon ct

            INNER JOIN SanPham sp
                ON sp.MaSanPham =
                   ct.MaSanPham

            WHERE ct.MaHD = ?

            ORDER BY ct.MaCT
            """;

        try (
            Connection connection =
                    DBConnect.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                while (resultSet.next()) {
                    ChiTietHoaDon item =
                            new ChiTietHoaDon();

                    item.setMaCT(
                            resultSet.getInt(
                                    "MaCT"
                            )
                    );

                    item.setMaHD(
                            resultSet.getInt(
                                    "MaHD"
                            )
                    );

                    item.setMaSanPham(
                            resultSet.getString(
                                    "MaSanPham"
                            )
                    );

                    item.setTenSanPham(
                            resultSet.getString(
                                    "TenSanPham"
                            )
                    );

                    item.setSoLuong(
                            resultSet.getInt(
                                    "SoLuong"
                            )
                    );

                    item.setDonGia(
                            resultSet.getBigDecimal(
                                    "DonGia"
                            )
                    );

                    list.add(item);
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được chi tiết hóa đơn.",
                    exception
            );
        }

        return list;
    }

    public List<VoucherKhachHang> getVoucherConHan() {
        List<VoucherKhachHang> list =
                new ArrayList<>();

        String updateSql = """
            UPDATE VoucherKhachHang
            SET TrangThai = N'Hết hạn'
            WHERE TrangThai = N'Chưa sử dụng'
              AND NgayHetHan < SYSDATETIME()
            """;

        String selectSql = """
            SELECT
                MaVoucher,
                MaCode,
                MaKH,
                MenhGia,
                SoDiemDaDoi,
                NgayDoi,
                NgayHetHan,
                TrangThai

            FROM VoucherKhachHang

            WHERE TrangThai = N'Chưa sử dụng'
              AND NgayHetHan >= SYSDATETIME()

            ORDER BY
                MaKH,
                MenhGia DESC,
                MaVoucher DESC
            """;

        try (
            Connection connection =
                    DBConnect.getConnection()
        ) {
            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                updateSql
                        )
            ) {
                statement.executeUpdate();
            }

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                selectSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                while (resultSet.next()) {
                    list.add(
                            mapVoucher(resultSet)
                    );
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được voucher.",
                    exception
            );
        }

        return list;
    }

    public VoucherKhachHang getVoucherCuaHoaDon(
            int maHD
    ) {
        String sql = """
            SELECT
                v.MaVoucher,
                v.MaCode,
                v.MaKH,
                v.MenhGia,
                v.SoDiemDaDoi,
                v.NgayDoi,
                v.NgayHetHan,
                v.TrangThai

            FROM HoaDon h

            INNER JOIN VoucherKhachHang v
                ON v.MaVoucher =
                   h.MaVoucher

            WHERE h.MaHD = ?
            """;

        try (
            Connection connection =
                    DBConnect.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                return resultSet.next()
                        ? mapVoucher(resultSet)
                        : null;
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được voucher của hóa đơn.",
                    exception
            );
        }
    }

    public void luuHoaDon(
            int maHD,
            String maKH,
            String tenKhachHang,
            String sdtKhachHang,
            List<ChiTietHoaDon> items
    ) {
        String maKhachDaChon =
                trimToNull(maKH);

        String tenKhachDaNhap =
                trimToNull(tenKhachHang);

        String sdtDaLamSach =
                chuanHoaSoDienThoai(
                        sdtKhachHang,
                        false
                );

        try (
            Connection connection =
                    DBConnect.getConnection()
        ) {
            connection.setAutoCommit(false);

            try {
                kiemTraHoaDonChuaKetThuc(
                        connection,
                        maHD
                );

                thayChiTiet(
                        connection,
                        maHD,
                        items
                );

                if (maKhachDaChon != null) {
                    tenKhachDaNhap =
                            layTenKhachHang(
                                    connection,
                                    maKhachDaChon
                            );

                    sdtDaLamSach =
                            laySoDienThoaiKhachHang(
                                    connection,
                                    maKhachDaChon
                            );
                }

                BigDecimal tamTinh =
                        layTamTinh(
                                connection,
                                maHD
                        );

                BigDecimal thue =
                        tinhVAT(tamTinh);

                BigDecimal tongTien =
                        tamTinh.add(thue);

                String sql = """
                    UPDATE HoaDon
                    SET
                        MaKH = ?,
                        TenKhachHang = ?,
                        SDTKhachHang = ?,
                        TamTinh = ?,
                        ThueVAT = ?,
                        GiamGia = 0,
                        MaVoucher = NULL,
                        TongTien = ?
                    WHERE MaHD = ?
                    """;

                try (
                    PreparedStatement statement =
                            connection.prepareStatement(sql)
                ) {
                    setNullableString(
                            statement,
                            1,
                            maKhachDaChon
                    );

                    setNullableString(
                            statement,
                            2,
                            tenKhachDaNhap
                    );

                    setNullableString(
                            statement,
                            3,
                            sdtDaLamSach
                    );

                    statement.setBigDecimal(
                            4,
                            tamTinh
                    );

                    statement.setBigDecimal(
                            5,
                            thue
                    );

                    statement.setBigDecimal(
                            6,
                            tongTien
                    );

                    statement.setInt(
                            7,
                            maHD
                    );

                    if (statement.executeUpdate() != 1) {
                        throw new IllegalStateException(
                                "Không cập nhật được hóa đơn."
                        );
                    }
                }

                connection.commit();

            } catch (Exception exception) {
                connection.rollback();

                throw new IllegalStateException(
                        exception.getMessage(),
                        exception
                );

            } finally {
                connection.setAutoCommit(true);
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không lưu được hóa đơn.",
                    exception
            );
        }
    }

    public void thanhToanHoaDon(
            int maHD,
            String maKH,
            String tenKhachHang,
            String sdtKhachHang,
            boolean luuKhachMoi,
            Integer maVoucher,
            List<ChiTietHoaDon> items
    ) {
        try (
            Connection connection =
                    DBConnect.getConnection()
        ) {
            connection.setAutoCommit(false);

            try {
                kiemTraHoaDonChuaKetThuc(
                        connection,
                        maHD
                );

                thayChiTiet(
                        connection,
                        maHD,
                        items
                );

                kiemTraSanPhamCoCongThuc(
                        connection,
                        maHD
                );

                kiemTraDuTonKho(
                        connection,
                        maHD
                );

                String maKhachThanhToan =
                        trimToNull(maKH);

                String tenKhachHienThi =
                        trimToNull(tenKhachHang);

                String sdtKhachHienThi =
                        chuanHoaSoDienThoai(
                                sdtKhachHang,
                                false
                        );

                if (maKhachThanhToan != null) {
                    tenKhachHienThi =
                            layTenKhachHang(
                                    connection,
                                    maKhachThanhToan
                            );

                    sdtKhachHienThi =
                            laySoDienThoaiKhachHang(
                                    connection,
                                    maKhachThanhToan
                            );

                } else if (luuKhachMoi) {
                    if (tenKhachHienThi == null) {
                        throw new IllegalArgumentException(
                                "Vui lòng nhập tên khách hàng mới."
                        );
                    }

                    sdtKhachHienThi =
                            chuanHoaSoDienThoai(
                                    sdtKhachHang,
                                    true
                            );

                    maKhachThanhToan =
                            taoKhachHangNhanh(
                                    connection,
                                    tenKhachHienThi,
                                    sdtKhachHienThi
                            );
                }

                if (tenKhachHienThi == null) {
                    tenKhachHienThi =
                            "Khách lẻ";
                }

                BigDecimal tamTinh =
                        layTamTinh(
                                connection,
                                maHD
                        );

                BigDecimal thue =
                        tinhVAT(tamTinh);

                BigDecimal tongTruocGiam =
                        tamTinh.add(thue);

                BigDecimal giamGia =
                        BigDecimal.ZERO;

                VoucherKhachHang voucher =
                        null;

                if (maVoucher != null) {
                    if (maKhachThanhToan == null) {
                        throw new IllegalArgumentException(
                                "Phải chọn khách hàng trước khi dùng voucher."
                        );
                    }

                    voucher =
                            layVoucherHopLe(
                                    connection,
                                    maVoucher,
                                    maKhachThanhToan
                            );

                    giamGia =
                            BigDecimal.valueOf(
                                    voucher.getMenhGia()
                            );

                    if (
                        giamGia.compareTo(
                                tongTruocGiam
                        ) > 0
                    ) {
                        throw new IllegalArgumentException(
                                "Mệnh giá voucher lớn hơn tổng giá trị hóa đơn."
                        );
                    }
                }

                BigDecimal tongThanhToan =
                        tongTruocGiam.subtract(
                                giamGia
                        );

                int diemCong =
                        maKhachThanhToan == null
                                ? 0
                                : tongThanhToan
                                        .divide(
                                                MONEY_PER_POINT,
                                                0,
                                                RoundingMode.DOWN
                                        )
                                        .intValue();

                truTonKho(
                        connection,
                        maHD
                );

                String sql = """
                    UPDATE HoaDon
                    SET
                        MaKH = ?,
                        TenKhachHang = ?,
                        SDTKhachHang = ?,
                        TamTinh = ?,
                        ThueVAT = ?,
                        MaVoucher = ?,
                        GiamGia = ?,
                        TongTien = ?,
                        DiemCong = ?,
                        TrangThai = N'Đã thanh toán',
                        PhuongThucThanhToan = N'Tiền mặt',
                        NgayThanhToan = SYSDATETIME(),
                        LyDoHuy = NULL
                    WHERE MaHD = ?
                    """;

                try (
                    PreparedStatement statement =
                            connection.prepareStatement(sql)
                ) {
                    setNullableString(
                            statement,
                            1,
                            maKhachThanhToan
                    );

                    statement.setString(
                            2,
                            tenKhachHienThi
                    );

                    setNullableString(
                            statement,
                            3,
                            sdtKhachHienThi
                    );

                    statement.setBigDecimal(
                            4,
                            tamTinh
                    );

                    statement.setBigDecimal(
                            5,
                            thue
                    );

                    if (maVoucher == null) {
                        statement.setNull(
                                6,
                                Types.INTEGER
                        );

                    } else {
                        statement.setInt(
                                6,
                                maVoucher
                        );
                    }

                    statement.setBigDecimal(
                            7,
                            giamGia
                    );

                    statement.setBigDecimal(
                            8,
                            tongThanhToan
                    );

                    statement.setInt(
                            9,
                            diemCong
                    );

                    statement.setInt(
                            10,
                            maHD
                    );

                    if (statement.executeUpdate() != 1) {
                        throw new IllegalStateException(
                                "Không cập nhật được hóa đơn."
                        );
                    }
                }

                if (voucher != null) {
                    danhDauVoucherDaSuDung(
                            connection,
                            voucher.getMaVoucher()
                    );
                }

                if (
                    diemCong > 0
                    && maKhachThanhToan != null
                ) {
                    String pointSql = """
                        UPDATE KhachHang
                        SET DiemTichLuy =
                            DiemTichLuy + ?
                        WHERE MaKH = ?
                        """;

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        pointSql
                                )
                    ) {
                        statement.setInt(
                                1,
                                diemCong
                        );

                        statement.setString(
                                2,
                                maKhachThanhToan
                        );

                        if (statement.executeUpdate() != 1) {
                            throw new IllegalStateException(
                                    "Không cộng được điểm khách hàng."
                            );
                        }
                    }
                }

                connection.commit();

            } catch (Exception exception) {
                connection.rollback();

                throw new IllegalStateException(
                        exception.getMessage(),
                        exception
                );

            } finally {
                connection.setAutoCommit(true);
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không thanh toán được hóa đơn.",
                    exception
            );
        }
    }

    public void huyHoaDon(
            int maHD,
            String lyDo
    ) {
        String reason =
                trimToNull(lyDo);

        if (reason == null) {
            throw new IllegalArgumentException(
                    "Vui lòng nhập lý do hủy."
            );
        }

        String sql = """
            UPDATE HoaDon
            SET
                TrangThai = N'Đã hủy',
                LyDoHuy = ?,
                PhuongThucThanhToan = NULL,
                NgayThanhToan = NULL,
                DiemCong = 0,
                MaVoucher = NULL,
                GiamGia = 0
            WHERE MaHD = ?
              AND TrangThai = N'Chờ thanh toán'
            """;

        try (
            Connection connection =
                    DBConnect.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    reason
            );

            statement.setInt(
                    2,
                    maHD
            );

            if (statement.executeUpdate() != 1) {
                throw new IllegalStateException(
                        "Hóa đơn đã kết thúc hoặc không tồn tại."
                );
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không hủy được hóa đơn.",
                    exception
            );
        }
    }

    private VoucherKhachHang layVoucherHopLe(
            Connection connection,
            int maVoucher,
            String maKH
    ) throws SQLException {
        String sql = """
            SELECT
                MaVoucher,
                MaCode,
                MaKH,
                MenhGia,
                SoDiemDaDoi,
                NgayDoi,
                NgayHetHan,
                TrangThai

            FROM VoucherKhachHang
                WITH (UPDLOCK, HOLDLOCK)

            WHERE MaVoucher = ?
              AND MaKH = ?
              AND TrangThai = N'Chưa sử dụng'
              AND NgayHetHan >= SYSDATETIME()
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maVoucher
            );

            statement.setString(
                    2,
                    maKH
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                if (!resultSet.next()) {
                    throw new IllegalArgumentException(
                            "Voucher không hợp lệ, đã sử dụng hoặc đã hết hạn."
                    );
                }

                return mapVoucher(resultSet);
            }
        }
    }

    private void danhDauVoucherDaSuDung(
            Connection connection,
            int maVoucher
    ) throws SQLException {
        String sql = """
            UPDATE VoucherKhachHang
            SET TrangThai = N'Đã sử dụng'
            WHERE MaVoucher = ?
              AND TrangThai = N'Chưa sử dụng'
              AND NgayHetHan >= SYSDATETIME()
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maVoucher
            );

            if (statement.executeUpdate() != 1) {
                throw new IllegalStateException(
                        "Không thể sử dụng voucher."
                );
            }
        }
    }

    private void thayChiTiet(
            Connection connection,
            int maHD,
            List<ChiTietHoaDon> items
    ) throws SQLException {
        if (
            items == null
            || items.isEmpty()
        ) {
            throw new IllegalArgumentException(
                    "Hóa đơn phải có ít nhất một sản phẩm."
            );
        }

        String deleteSql = """
            DELETE FROM ChiTietHoaDon
            WHERE MaHD = ?
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            deleteSql
                    )
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            statement.executeUpdate();
        }

        String productSql = """
            SELECT GiaBan
            FROM SanPham
            WHERE MaSanPham = ?
            """;

        String insertSql = """
            INSERT INTO ChiTietHoaDon (
                MaHD,
                MaSanPham,
                SoLuong,
                DonGia
            )
            VALUES (?, ?, ?, ?)
            """;

        try (
            PreparedStatement productStatement =
                    connection.prepareStatement(
                            productSql
                    );

            PreparedStatement insertStatement =
                    connection.prepareStatement(
                            insertSql
                    )
        ) {
            for (ChiTietHoaDon item : items) {
                if (
                    item.getMaSanPham() == null
                    || item.getMaSanPham().isBlank()
                    || item.getSoLuong() <= 0
                ) {
                    throw new IllegalArgumentException(
                            "Sản phẩm hoặc số lượng không hợp lệ."
                    );
                }

                productStatement.setString(
                        1,
                        item.getMaSanPham()
                );

                BigDecimal donGia;

                try (
                    ResultSet resultSet =
                            productStatement.executeQuery()
                ) {
                    if (!resultSet.next()) {
                        throw new IllegalArgumentException(
                                "Không tìm thấy sản phẩm "
                                + item.getMaSanPham()
                                + "."
                        );
                    }

                    donGia =
                            resultSet.getBigDecimal(
                                    "GiaBan"
                            );
                }

                insertStatement.setInt(
                        1,
                        maHD
                );

                insertStatement.setString(
                        2,
                        item.getMaSanPham()
                );

                insertStatement.setInt(
                        3,
                        item.getSoLuong()
                );

                insertStatement.setBigDecimal(
                        4,
                        donGia
                );

                insertStatement.addBatch();
            }

            insertStatement.executeBatch();
        }
    }

    private void kiemTraHoaDonChuaKetThuc(
            Connection connection,
            int maHD
    ) throws SQLException {
        String sql = """
            SELECT TrangThai
            FROM HoaDon
                WITH (UPDLOCK, HOLDLOCK)
            WHERE MaHD = ?
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                if (!resultSet.next()) {
                    throw new IllegalArgumentException(
                            "Không tìm thấy hóa đơn."
                    );
                }

                if (
                    !"Chờ thanh toán".equalsIgnoreCase(
                            resultSet.getString(
                                    "TrangThai"
                            )
                    )
                ) {
                    throw new IllegalArgumentException(
                            "Hóa đơn đã kết thúc."
                    );
                }
            }
        }
    }

    private void kiemTraSanPhamCoCongThuc(
            Connection connection,
            int maHD
    ) throws SQLException {
        String sql = """
            SELECT TOP 1
                sp.TenSanPham

            FROM ChiTietHoaDon ct

            INNER JOIN SanPham sp
                ON sp.MaSanPham =
                   ct.MaSanPham

            WHERE ct.MaHD = ?

              AND NOT EXISTS (
                  SELECT 1
                  FROM CongThucSanPham c
                  WHERE c.MaSanPham =
                        ct.MaSanPham
              )
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                if (resultSet.next()) {
                    throw new IllegalArgumentException(
                            "Sản phẩm chưa có công thức: "
                            + resultSet.getString(
                                    "TenSanPham"
                            )
                    );
                }
            }
        }
    }

    private void kiemTraDuTonKho(
            Connection connection,
            int maHD
    ) throws SQLException {
        String sql = """
            WITH CanDung AS (
                SELECT
                    ct.MaNguyenLieu,

                    SUM(
                        ct.SoLuongCan
                        * hd.SoLuong
                    ) AS SoLuongCan

                FROM ChiTietHoaDon hd

                INNER JOIN CongThucSanPham ct
                    ON ct.MaSanPham =
                       hd.MaSanPham

                WHERE hd.MaHD = ?

                GROUP BY ct.MaNguyenLieu
            )

            SELECT TOP 1
                nl.TenNguyenLieu,
                nl.SoLuongTon,
                nl.DonVi,
                cd.SoLuongCan

            FROM CanDung cd

            INNER JOIN NguyenLieu nl
                ON nl.MaNguyenLieu =
                   cd.MaNguyenLieu

            WHERE nl.TrangThai = 0
               OR nl.SoLuongTon
                  < cd.SoLuongCan

            ORDER BY nl.TenNguyenLieu
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                if (resultSet.next()) {
                    throw new IllegalArgumentException(
                            "Không đủ nguyên liệu: "
                            + resultSet.getString(
                                    "TenNguyenLieu"
                            )
                            + ". Tồn "
                            + resultSet.getInt(
                                    "SoLuongTon"
                            )
                            + " "
                            + resultSet.getString(
                                    "DonVi"
                            )
                            + ", cần "
                            + resultSet.getInt(
                                    "SoLuongCan"
                            )
                            + " "
                            + resultSet.getString(
                                    "DonVi"
                            )
                            + "."
                    );
                }
            }
        }
    }

    private void truTonKho(
            Connection connection,
            int maHD
    ) throws SQLException {
        String sql = """
            WITH CanDung AS (
                SELECT
                    ct.MaNguyenLieu,

                    SUM(
                        ct.SoLuongCan
                        * hd.SoLuong
                    ) AS SoLuongCan

                FROM ChiTietHoaDon hd

                INNER JOIN CongThucSanPham ct
                    ON ct.MaSanPham =
                       hd.MaSanPham

                WHERE hd.MaHD = ?

                GROUP BY ct.MaNguyenLieu
            )

            UPDATE nl

            SET nl.SoLuongTon =
                nl.SoLuongTon
                - cd.SoLuongCan

            FROM NguyenLieu nl

            INNER JOIN CanDung cd
                ON cd.MaNguyenLieu =
                   nl.MaNguyenLieu
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            statement.executeUpdate();
        }
    }

    private BigDecimal layTamTinh(
            Connection connection,
            int maHD
    ) throws SQLException {
        String sql = """
            SELECT
                CAST(
                    ISNULL(
                        SUM(
                            SoLuong * DonGia
                        ),
                        0
                    )
                    AS DECIMAL(18, 0)
                ) AS TamTinh

            FROM ChiTietHoaDon

            WHERE MaHD = ?
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    maHD
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                resultSet.next();

                return resultSet.getBigDecimal(
                        "TamTinh"
                );
            }
        }
    }

    private BigDecimal tinhVAT(
            BigDecimal tamTinh
    ) {
        return tamTinh
                .multiply(VAT_RATE)
                .setScale(
                        0,
                        RoundingMode.HALF_UP
                );
    }

    private String layTenKhachHang(
            Connection connection,
            String maKH
    ) throws SQLException {
        String sql = """
            SELECT HoTen
            FROM KhachHang
            WHERE MaKH = ?
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    maKH
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                if (!resultSet.next()) {
                    throw new IllegalArgumentException(
                            "Không tìm thấy khách hàng."
                    );
                }

                return resultSet.getString(
                        "HoTen"
                );
            }
        }
    }

    private String laySoDienThoaiKhachHang(
            Connection connection,
            String maKH
    ) throws SQLException {
        String sql = """
            SELECT SDT
            FROM KhachHang
            WHERE MaKH = ?
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    maKH
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                if (!resultSet.next()) {
                    throw new IllegalArgumentException(
                            "Không tìm thấy khách hàng."
                    );
                }

                return resultSet.getString(
                        "SDT"
                );
            }
        }
    }

    private String taoKhachHangNhanh(
            Connection connection,
            String hoTen,
            String soDienThoai
    ) throws SQLException {
        if (
            kiemTraTrungSoDienThoai(
                    connection,
                    soDienThoai
            )
        ) {
            throw new IllegalArgumentException(
                    "Số điện thoại đã thuộc về khách hàng khác."
            );
        }

        int sequenceValue;

        String sequenceSql = """
            SELECT NEXT VALUE FOR
                   dbo.Seq_KhachHang AS GiaTri
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            sequenceSql
                    );

            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            resultSet.next();

            sequenceValue =
                    resultSet.getInt(
                            "GiaTri"
                    );
        }

        String maKH =
                String.format(
                        "KH%03d",
                        sequenceValue
                );

        String insertSql = """
            INSERT INTO KhachHang (
                MaKH,
                HoTen,
                SDT,
                DiemTichLuy
            )
            VALUES (?, ?, ?, 0)
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(
                            insertSql
                    )
        ) {
            statement.setString(
                    1,
                    maKH
            );

            statement.setString(
                    2,
                    hoTen.trim()
            );

            statement.setString(
                    3,
                    soDienThoai
            );

            statement.executeUpdate();
        }

        return maKH;
    }

    private boolean kiemTraTrungSoDienThoai(
            Connection connection,
            String soDienThoai
    ) throws SQLException {
        String sql = """
            SELECT 1
            FROM KhachHang
            WHERE SDT = ?
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(
                    1,
                    soDienThoai
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                return resultSet.next();
            }
        }
    }

    private String chuanHoaSoDienThoai(
            String value,
            boolean batBuoc
    ) {
        String phone =
                trimToNull(value);

        if (phone == null) {
            if (batBuoc) {
                throw new IllegalArgumentException(
                        "Vui lòng nhập số điện thoại khách hàng."
                );
            }

            return null;
        }

        phone =
                phone.replaceAll(
                        "\\s+",
                        ""
                );

        if (!phone.matches("0\\d{8,10}")) {
            throw new IllegalArgumentException(
                    "Số điện thoại phải bắt đầu bằng 0 và có từ 9 đến 11 số."
            );
        }

        return phone;
    }

    private HoaDon mapRow(
            ResultSet resultSet
    ) throws SQLException {
        HoaDon hoaDon =
                new HoaDon();

        hoaDon.setMaHD(
                resultSet.getInt(
                        "MaHD"
                )
        );

        hoaDon.setMaTaiKhoan(
                resultSet.getString(
                        "MaTaiKhoan"
                )
        );

        hoaDon.setTenTaiKhoan(
                resultSet.getString(
                        "TenTaiKhoan"
                )
        );

        hoaDon.setMaKH(
                resultSet.getString(
                        "MaKH"
                )
        );

        hoaDon.setTenKhachHang(
                resultSet.getString(
                        "TenKhachHang"
                )
        );

        hoaDon.setSdtKhachHang(
                resultSet.getString(
                        "SDTKhachHang"
                )
        );

        hoaDon.setNgayTao(
                formatTimestamp(
                        resultSet.getTimestamp(
                                "NgayTao"
                        )
                )
        );

        hoaDon.setNgayThanhToan(
                formatTimestamp(
                        resultSet.getTimestamp(
                                "NgayThanhToan"
                        )
                )
        );

        hoaDon.setTamTinh(
                getMoney(
                        resultSet,
                        "TamTinh"
                )
        );

        hoaDon.setThueVAT(
                getMoney(
                        resultSet,
                        "ThueVAT"
                )
        );

        hoaDon.setTongTien(
                getMoney(
                        resultSet,
                        "TongTien"
                )
        );

        hoaDon.setDiemCong(
                resultSet.getInt(
                        "DiemCong"
                )
        );

        hoaDon.setTrangThai(
                resultSet.getString(
                        "TrangThai"
                )
        );

        hoaDon.setPhuongThucThanhToan(
                resultSet.getString(
                        "PhuongThucThanhToan"
                )
        );

        hoaDon.setLyDoHuy(
                resultSet.getString(
                        "LyDoHuy"
                )
        );

        return hoaDon;
    }

    private VoucherKhachHang mapVoucher(
            ResultSet resultSet
    ) throws SQLException {
        VoucherKhachHang voucher =
                new VoucherKhachHang();

        voucher.setMaVoucher(
                resultSet.getInt(
                        "MaVoucher"
                )
        );

        voucher.setMaCode(
                resultSet.getString(
                        "MaCode"
                )
        );

        voucher.setMaKH(
                resultSet.getString(
                        "MaKH"
                )
        );

        voucher.setMenhGia(
                resultSet.getInt(
                        "MenhGia"
                )
        );

        voucher.setSoDiemDaDoi(
                resultSet.getInt(
                        "SoDiemDaDoi"
                )
        );

        Timestamp ngayDoi =
                resultSet.getTimestamp(
                        "NgayDoi"
                );

        if (ngayDoi != null) {
            voucher.setNgayDoi(
                    ngayDoi.toLocalDateTime()
            );
        }

        Timestamp ngayHetHan =
                resultSet.getTimestamp(
                        "NgayHetHan"
                );

        if (ngayHetHan != null) {
            voucher.setNgayHetHan(
                    ngayHetHan.toLocalDateTime()
            );
        }

        voucher.setTrangThai(
                resultSet.getString(
                        "TrangThai"
                )
        );

        return voucher;
    }

    private BigDecimal getMoney(
            ResultSet resultSet,
            String column
    ) throws SQLException {
        BigDecimal value =
                resultSet.getBigDecimal(
                        column
                );

        return value == null
                ? BigDecimal.ZERO
                : value;
    }

    private String formatTimestamp(
            Timestamp value
    ) {
        if (value == null) {
            return "";
        }

        return value
                .toLocalDateTime()
                .format(DATE_FORMAT);
    }

    private void setNullableString(
            PreparedStatement statement,
            int index,
            String value
    ) throws SQLException {
        String cleaned =
                trimToNull(value);

        if (cleaned == null) {
            statement.setNull(
                    index,
                    Types.NVARCHAR
            );

        } else {
            statement.setString(
                    index,
                    cleaned
            );
        }
    }

    private String trimToNull(
            String value
    ) {
        return value == null
                || value.isBlank()
                ? null
                : value.trim();
    }
}