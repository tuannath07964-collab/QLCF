package dao;

import model.NhanVien;
import util.DBConnect;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.util.ArrayList;

public class NhanVienDAO {

    private static final String SELECT_COLUMNS = """
        SELECT MaNV,
               HoTen,
               GioiTinh,
               NgaySinh,
               SDT,
               ChucVu,
               LuongCoBan,
               MatKhau,
               TrangThai,
               CaSang,
               CaChieu,
               CaToi,
               GioBatDau,
               GioKetThuc
        FROM NhanVien
        """;

    public ArrayList<NhanVien> getAllNhanVien() {
        ArrayList<NhanVien> list =
                new ArrayList<>();

        String sql =
                SELECT_COLUMNS
                + " ORDER BY MaNV";

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
                    "Không tải được danh sách nhân viên.",
                    e
            );
        }

        return list;
    }

    public NhanVien getNhanVienById(
            String maNV
    ) {
        String sql =
                SELECT_COLUMNS
                + " WHERE MaNV = ?";

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(1, maNV);

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
                    "Không tìm thấy nhân viên.",
                    e
            );
        }
    }

    public String insertNhanVien(
            NhanVien nv
    ) throws SQLException {

        String sql = """
            INSERT INTO NhanVien(
                MaNV,
                HoTen,
                ChucVu,
                SDT,
                LuongCoBan,
                GioiTinh,
                NgaySinh,
                MatKhau,
                TrangThai
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

        try (
            Connection conn =
                    DBConnect.getConnection()
        ) {
            conn.setAutoCommit(false);

            try {
                String maNVMoi =
                        taoMaNhanVien(conn);

                try (
                    PreparedStatement ps =
                            conn.prepareStatement(sql)
                ) {
                    ps.setString(
                            1,
                            maNVMoi
                    );

                    ps.setString(
                            2,
                            nv.getHoTen()
                    );

                    ps.setString(
                            3,
                            chuanHoaChucVu(
                                    nv.getChucVu()
                            )
                    );

                    ps.setString(
                            4,
                            nv.getSdt()
                    );

                    ps.setBigDecimal(
                            5,
                            nv.getLuongCoBan() == null
                                    ? BigDecimal.ZERO
                                    : nv.getLuongCoBan()
                    );

                    setNullableString(
                            ps,
                            6,
                            nv.getGioiTinh()
                    );

                    if (nv.getNgaySinh() == null) {
                        ps.setNull(
                                7,
                                Types.DATE
                        );
                    } else {
                        ps.setDate(
                                7,
                                nv.getNgaySinh()
                        );
                    }

                    ps.setString(
                            8,
                            nv.getMatKhau() == null
                            || nv.getMatKhau().isBlank()
                                    ? "123456"
                                    : nv.getMatKhau().trim()
                    );

                    ps.setString(
                            9,
                            chuanHoaTrangThai(
                                    nv.getTrangThai()
                            )
                    );

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException(
                                "Không thêm được nhân viên."
                        );
                    }
                }

                conn.commit();
                return maNVMoi;

            } catch (SQLException e) {
                conn.rollback();
                throw e;

            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public boolean updateNhanVien(
            NhanVien nv
    ) {
        String sql = """
            UPDATE NhanVien
            SET HoTen = ?,
                ChucVu = ?,
                SDT = ?,
                LuongCoBan = ?,
                GioiTinh = ?,
                NgaySinh = ?,
                TrangThai = ?
            WHERE MaNV = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    nv.getHoTen()
            );

            ps.setString(
                    2,
                    chuanHoaChucVu(
                            nv.getChucVu()
                    )
            );

            ps.setString(
                    3,
                    nv.getSdt()
            );

            ps.setBigDecimal(
                    4,
                    nv.getLuongCoBan() == null
                            ? BigDecimal.ZERO
                            : nv.getLuongCoBan()
            );

            setNullableString(
                    ps,
                    5,
                    nv.getGioiTinh()
            );

            if (nv.getNgaySinh() == null) {
                ps.setNull(
                        6,
                        Types.DATE
                );
            } else {
                ps.setDate(
                        6,
                        nv.getNgaySinh()
                );
            }

            ps.setString(
                    7,
                    chuanHoaTrangThai(
                            nv.getTrangThai()
                    )
            );

            ps.setString(
                    8,
                    nv.getMaNV()
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không cập nhật được nhân viên.",
                    e
            );
        }
    }

    public boolean updateMatKhau(
            String maNV,
            String matKhauMoi
    ) {
        if (
            matKhauMoi == null
            || matKhauMoi.isBlank()
        ) {
            return false;
        }

        String sql = """
            UPDATE NhanVien
            SET MatKhau = ?
            WHERE MaNV = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    matKhauMoi.trim()
            );

            ps.setString(
                    2,
                    maNV
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không đổi được mật khẩu.",
                    e
            );
        }
    }

    public boolean updateTrangThai(
            String maNV,
            String trangThai
    ) {
        String sql = """
            UPDATE NhanVien
            SET TrangThai = ?
            WHERE MaNV = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setString(
                    1,
                    chuanHoaTrangThai(trangThai)
            );

            ps.setString(
                    2,
                    maNV
            );

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không cập nhật được trạng thái nhân viên.",
                    e
            );
        }
    }

    public void updateCaLam(
            String maNV,
            boolean caSang,
            boolean caChieu,
            boolean caToi,
            String gioBatDau,
            String gioKetThuc
    ) throws SQLException {

        String sql = """
            UPDATE NhanVien
            SET CaSang = ?,
                CaChieu = ?,
                CaToi = ?,
                GioBatDau = ?,
                GioKetThuc = ?
            WHERE MaNV = ?
            """;

        try (
            Connection conn =
                    DBConnect.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql)
        ) {
            ps.setBoolean(1, caSang);
            ps.setBoolean(2, caChieu);
            ps.setBoolean(3, caToi);

            if (
                gioBatDau == null
                || gioBatDau.isBlank()
            ) {
                ps.setNull(
                        4,
                        Types.TIME
                );
            } else {
                ps.setTime(
                        4,
                        Time.valueOf(
                                chuanHoaGio(
                                        gioBatDau
                                )
                        )
                );
            }

            if (
                gioKetThuc == null
                || gioKetThuc.isBlank()
            ) {
                ps.setNull(
                        5,
                        Types.TIME
                );
            } else {
                ps.setTime(
                        5,
                        Time.valueOf(
                                chuanHoaGio(
                                        gioKetThuc
                                )
                        )
                );
            }

            ps.setString(
                    6,
                    maNV
            );

            if (ps.executeUpdate() != 1) {
                throw new SQLException(
                        "Không cập nhật được ca làm."
                );
            }
        }
    }

    public NhanVien checkLogin(
            String maNV,
            String matKhau
    ) {
        if (
            maNV == null
            || matKhau == null
        ) {
            return null;
        }

        String sql =
                SELECT_COLUMNS
                + """
                  WHERE UPPER(
                      LTRIM(RTRIM(MaNV))
                  ) = UPPER(?)
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
                    maNV.trim()
            );

            ps.setString(
                    2,
                    matKhau.trim()
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
                    "Không kiểm tra được đăng nhập.",
                    e
            );
        }
    }

    private String taoMaNhanVien(
            Connection conn
    ) throws SQLException {

        String sql = """
            SELECT N'NV'
                + RIGHT(
                    N'0000'
                    + CAST(
                        NEXT VALUE FOR
                        dbo.Seq_NhanVien
                        AS NVARCHAR(10)
                    ),
                    4
                )
            """;

        try (
            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getString(1);
            }
        }

        throw new SQLException(
                "Không tự sinh được mã nhân viên."
        );
    }

    private NhanVien mapRow(
            ResultSet rs
    ) throws SQLException {

        NhanVien nv =
                new NhanVien();

        nv.setMaNV(
                rs.getString("MaNV")
        );

        nv.setHoTen(
                rs.getString("HoTen")
        );

        nv.setChucVu(
                rs.getString("ChucVu")
        );

        nv.setSdt(
                rs.getString("SDT")
        );

        nv.setLuongCoBan(
                rs.getBigDecimal(
                        "LuongCoBan"
                )
        );

        nv.setGioiTinh(
                rs.getString("GioiTinh")
        );

        nv.setNgaySinh(
                rs.getDate("NgaySinh")
        );

        nv.setMatKhau(
                rs.getString("MatKhau")
        );

        nv.setTrangThai(
                rs.getString("TrangThai")
        );

        nv.setCaSang(
                rs.getBoolean("CaSang")
        );

        nv.setCaChieu(
                rs.getBoolean("CaChieu")
        );

        nv.setCaToi(
                rs.getBoolean("CaToi")
        );

        nv.setGioBatDau(
                rs.getString("GioBatDau")
        );

        nv.setGioKetThuc(
                rs.getString("GioKetThuc")
        );

        return nv;
    }

    private String chuanHoaChucVu(
            String chucVu
    ) {
        return "Quản lý".equalsIgnoreCase(
                chucVu
        )
                ? "Quản lý"
                : "Nhân viên";
    }

    private String chuanHoaTrangThai(
            String trangThai
    ) {
        if (
            "Nghỉ làm".equalsIgnoreCase(
                    trangThai
            )
        ) {
            return "Nghỉ làm";
        }

        if (
            "Tạm nghỉ".equalsIgnoreCase(
                    trangThai
            )
        ) {
            return "Tạm nghỉ";
        }

        return "Đang làm";
    }

    private String chuanHoaGio(
            String value
    ) {
        String gio = value.trim();

        return gio.length() == 5
                ? gio + ":00"
                : gio;
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