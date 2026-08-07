package dao;

import model.VoucherKhachHang;
import util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class VoucherDAO {

    private static final int DIEM_TOI_THIEU = 50;

    public int getDiemKhachHang(
            String maKH
    ) {
        String sql = """
            SELECT DiemTichLuy
            FROM KhachHang
            WHERE MaKH = ?
            """;

        try (
            Connection connection =
                    openConnection();

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

                return resultSet.getInt(
                        "DiemTichLuy"
                );
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được điểm khách hàng: "
                    + exception.getMessage(),
                    exception
            );
        }
    }

    public String getTenKhachHang(
            String maKH
    ) {
        String sql = """
            SELECT HoTen
            FROM KhachHang
            WHERE MaKH = ?
            """;

        try (
            Connection connection =
                    openConnection();

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

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được thông tin khách hàng: "
                    + exception.getMessage(),
                    exception
            );
        }
    }

    public List<VoucherKhachHang> getVoucherByKhachHang(
            String maKH
    ) {
        capNhatVoucherHetHan();

        List<VoucherKhachHang> list =
                new ArrayList<>();

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
            WHERE MaKH = ?
            ORDER BY MaVoucher DESC
            """;

        try (
            Connection connection =
                    openConnection();

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
                while (resultSet.next()) {
                    list.add(
                            mapRow(resultSet)
                    );
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được danh sách voucher: "
                    + exception.getMessage(),
                    exception
            );
        }

        return list;
    }

    public void doiVoucher(
            String maKH,
            int soLuong10,
            int soLuong20,
            int soLuong30,
            int soLuong40,
            int soLuong50
    ) {
        validateSoLuong(
                soLuong10,
                soLuong20,
                soLuong30,
                soLuong40,
                soLuong50
        );

        int tongGiaTri =
                soLuong10 * 10000
                + soLuong20 * 20000
                + soLuong30 * 30000
                + soLuong40 * 40000
                + soLuong50 * 50000;

        int tongDiemCanDoi =
                tongGiaTri / 1000;

        if (tongGiaTri <= 0) {
            throw new IllegalArgumentException(
                    "Vui lòng chọn ít nhất một voucher."
            );
        }

        if (tongDiemCanDoi < DIEM_TOI_THIEU) {
            throw new IllegalArgumentException(
                    "Mỗi lần đổi phải có tổng giá trị "
                    + "voucher ít nhất 50.000đ."
            );
        }

        try (
            Connection connection =
                    openConnection()
        ) {
            connection.setAutoCommit(false);

            try {
                int diemHienTai =
                        getDiemCoKhoa(
                                connection,
                                maKH
                        );

                if (diemHienTai < DIEM_TOI_THIEU) {
                    throw new IllegalArgumentException(
                            "Khách hàng cần tối thiểu 50 điểm "
                            + "để đổi voucher."
                    );
                }

                if (tongDiemCanDoi > diemHienTai) {
                    throw new IllegalArgumentException(
                            "Điểm hiện tại không đủ. "
                            + "Cần "
                            + tongDiemCanDoi
                            + " điểm nhưng khách hàng chỉ có "
                            + diemHienTai
                            + " điểm."
                    );
                }

                truDiem(
                        connection,
                        maKH,
                        tongDiemCanDoi
                );

                themVoucher(
                        connection,
                        maKH,
                        10000,
                        soLuong10
                );

                themVoucher(
                        connection,
                        maKH,
                        20000,
                        soLuong20
                );

                themVoucher(
                        connection,
                        maKH,
                        30000,
                        soLuong30
                );

                themVoucher(
                        connection,
                        maKH,
                        40000,
                        soLuong40
                );

                themVoucher(
                        connection,
                        maKH,
                        50000,
                        soLuong50
                );

                connection.commit();

            } catch (Exception exception) {
                connection.rollback();

                if (
                    exception
                    instanceof IllegalArgumentException
                ) {
                    throw (IllegalArgumentException) exception;
                }

                throw new IllegalStateException(
                        "Không đổi được voucher: "
                        + exception.getMessage(),
                        exception
                );

            } finally {
                connection.setAutoCommit(true);
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không đổi được voucher: "
                    + exception.getMessage(),
                    exception
            );
        }
    }

    private int getDiemCoKhoa(
            Connection connection,
            String maKH
    ) throws SQLException {
        String sql = """
            SELECT DiemTichLuy
            FROM KhachHang
                WITH (UPDLOCK, HOLDLOCK)
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

                return resultSet.getInt(
                        "DiemTichLuy"
                );
            }
        }
    }

    private void truDiem(
            Connection connection,
            String maKH,
            int soDiem
    ) throws SQLException {
        String sql = """
            UPDATE KhachHang
            SET DiemTichLuy =
                DiemTichLuy - ?
            WHERE MaKH = ?
              AND DiemTichLuy >= ?
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(
                    1,
                    soDiem
            );

            statement.setString(
                    2,
                    maKH
            );

            statement.setInt(
                    3,
                    soDiem
            );

            if (statement.executeUpdate() != 1) {
                throw new IllegalStateException(
                        "Không thể trừ điểm khách hàng."
                );
            }
        }
    }

    private void themVoucher(
            Connection connection,
            String maKH,
            int menhGia,
            int soLuong
    ) throws SQLException {
        if (soLuong <= 0) {
            return;
        }

        String sql = """
            INSERT INTO VoucherKhachHang (
                MaCode,
                MaKH,
                MenhGia,
                SoDiemDaDoi,
                NgayDoi,
                NgayHetHan,
                TrangThai
            )
            VALUES (
                ?,
                ?,
                ?,
                ?,
                SYSDATETIME(),
                DATEADD(DAY, 30, SYSDATETIME()),
                N'Chưa sử dụng'
            )
            """;

        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            for (
                int i = 0;
                i < soLuong;
                i++
            ) {
                statement.setString(
                        1,
                        taoMaVoucher()
                );

                statement.setString(
                        2,
                        maKH
                );

                statement.setInt(
                        3,
                        menhGia
                );

                statement.setInt(
                        4,
                        menhGia / 1000
                );

                statement.addBatch();
            }

            statement.executeBatch();
        }
    }

    private void capNhatVoucherHetHan() {
        String sql = """
            UPDATE VoucherKhachHang
            SET TrangThai = N'Hết hạn'
            WHERE TrangThai = N'Chưa sử dụng'
              AND NgayHetHan < SYSDATETIME()
            """;

        try (
            Connection connection =
                    openConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.executeUpdate();

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không cập nhật được trạng thái voucher.",
                    exception
            );
        }
    }

    private VoucherKhachHang mapRow(
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

        voucher.setNgayDoi(
                resultSet
                        .getTimestamp("NgayDoi")
                        .toLocalDateTime()
        );

        voucher.setNgayHetHan(
                resultSet
                        .getTimestamp("NgayHetHan")
                        .toLocalDateTime()
        );

        voucher.setTrangThai(
                resultSet.getString(
                        "TrangThai"
                )
        );

        return voucher;
    }

    private void validateSoLuong(
            int... soLuongs
    ) {
        for (int soLuong : soLuongs) {
            if (
                soLuong < 0
                || soLuong > 50
            ) {
                throw new IllegalArgumentException(
                        "Số lượng voucher không hợp lệ."
                );
            }
        }
    }

    private String taoMaVoucher() {
        return "VC"
                + UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 12)
                        .toUpperCase();
    }

    private Connection openConnection()
            throws SQLException {
        Connection connection =
                DBConnect.getConnection();

        if (
            connection == null
            || connection.isClosed()
        ) {
            throw new SQLException(
                    "Không lấy được kết nối cơ sở dữ liệu."
            );
        }

        return connection;
    }
}