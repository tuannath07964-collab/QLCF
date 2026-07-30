package dao;

import model.CongThucSanPham;
import model.SanPham;
import util.DBConnect;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SanPhamDAO {

    public List<SanPham> getAll(
            String keyword,
            String maDanhMuc,
            boolean hienThiNgungBan
    ) {
        List<SanPham> list
                = new ArrayList<>();

        StringBuilder sql
                = new StringBuilder(
                        """
                        SELECT sp.MaSanPham,
                               sp.TenSanPham,
                               sp.MaDanhMuc,
                               dm.TenDanhMuc,
                               sp.GiaBan,
                               sp.TrangThai
                        FROM SanPham sp
                        JOIN DanhMucSanPham dm
                            ON dm.MaDanhMuc =
                               sp.MaDanhMuc
                        WHERE 1 = 1
                        """
                );

        List<Object> parameters
                = new ArrayList<>();

        if (keyword != null
                && !keyword.isBlank()) {
            sql.append(
                    """
                     AND (
                         sp.MaSanPham LIKE ?
                         OR sp.TenSanPham LIKE ?
                     )
                    """
            );

            String search
                    = "%"
                    + keyword.trim()
                    + "%";

            parameters.add(search);
            parameters.add(search);
        }

        if (maDanhMuc != null
                && !maDanhMuc.isBlank()
                && !"all".equalsIgnoreCase(
                        maDanhMuc
                )) {
            sql.append(
                    " AND sp.MaDanhMuc = ? "
            );

            parameters.add(
                    maDanhMuc
            );
        }

        if (!hienThiNgungBan) {
            sql.append(
                    """
                     AND sp.TrangThai = 1
                     AND dm.TrangThai = 1
                    """
            );
        }

        sql.append(
                " ORDER BY sp.MaSanPham "
        );

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(
                        sql.toString()
                )) {
            for (int i = 0;
                    i < parameters.size();
                    i++) {
                ps.setObject(
                        i + 1,
                        parameters.get(i)
                );
            }

            try (
                    ResultSet rs
                    = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

            boSungCongThuc(
                    conn,
                    list
            );

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không tải được danh sách sản phẩm.",
                    e
            );
        }

        return list;
    }

    public SanPham findById(
            String maSanPham
    ) {
        List<SanPham> list
                = getAll(
                        maSanPham,
                        null,
                        true
                );

        for (SanPham sanPham : list) {
            if (sanPham.getMaSanPham()
                    .equalsIgnoreCase(
                            maSanPham
                    )) {
                return sanPham;
            }
        }

        return null;
    }

    public void insert(
            SanPham sanPham
    ) {
        validate(sanPham);

        String sql = """
            INSERT INTO SanPham(
                MaSanPham,
                TenSanPham,
                MaDanhMuc,
                GiaBan,
                TrangThai
            )
            VALUES (?, ?, ?, ?, ?)
            """;

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setString(
                    1,
                    sanPham
                            .getMaSanPham()
                            .trim()
            );

            ps.setString(
                    2,
                    sanPham
                            .getTenSanPham()
                            .trim()
            );

            ps.setString(
                    3,
                    sanPham
                            .getMaDanhMuc()
                            .trim()
            );

            ps.setBigDecimal(
                    4,
                    sanPham.getGiaBan()
            );

            ps.setBoolean(
                    5,
                    sanPham.isTrangThai()
            );

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không thêm được sản phẩm. "
                    + "Kiểm tra mã sản phẩm.",
                    e
            );
        }
    }

    public void update(
            SanPham sanPham
    ) {
        validate(sanPham);

        String sql = """
            UPDATE SanPham
            SET TenSanPham = ?,
                MaDanhMuc = ?,
                GiaBan = ?,
                TrangThai = ?
            WHERE MaSanPham = ?
            """;

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setString(
                    1,
                    sanPham
                            .getTenSanPham()
                            .trim()
            );

            ps.setString(
                    2,
                    sanPham
                            .getMaDanhMuc()
                            .trim()
            );

            ps.setBigDecimal(
                    3,
                    sanPham.getGiaBan()
            );

            ps.setBoolean(
                    4,
                    sanPham.isTrangThai()
            );

            ps.setString(
                    5,
                    sanPham
                            .getMaSanPham()
                            .trim()
            );

            if (ps.executeUpdate() != 1) {
                throw new IllegalStateException(
                        "Không tìm thấy sản phẩm cần sửa."
                );
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không cập nhật được sản phẩm.",
                    e
            );
        }
    }

    public void toggleStatus(
            String maSanPham
    ) {
        String sql = """
            UPDATE SanPham
            SET TrangThai =
                CASE
                    WHEN TrangThai = 1
                    THEN 0
                    ELSE 1
                END
            WHERE MaSanPham = ?
            """;

        try (
                Connection conn
                = DBConnect.getConnection(); PreparedStatement ps
                = conn.prepareStatement(sql)) {
            ps.setString(
                    1,
                    maSanPham
            );

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không đổi được trạng thái sản phẩm.",
                    e
            );
        }
    }

    public List<CongThucSanPham> getCongThuc(
            String maSanPham
    ) {
        List<CongThucSanPham> list
                = new ArrayList<>();

        String sql = """
        SELECT
            ct.MaSanPham,
            ct.MaNguyenLieu,
            nl.TenNguyenLieu,
            ct.SoLuongCan,
            nl.SoLuongTon,
            nl.DonVi
        FROM CongThucSanPham ct
        INNER JOIN NguyenLieu nl
            ON nl.MaNguyenLieu = ct.MaNguyenLieu
        WHERE ct.MaSanPham = ?
        ORDER BY nl.TenNguyenLieu
        """;

        try (
                Connection connection
                = DBConnect.getConnection(); PreparedStatement statement
                = connection.prepareStatement(sql)) {
            statement.setString(
                    1,
                    maSanPham
            );

            try (
                    ResultSet resultSet
                    = statement.executeQuery()) {
                while (resultSet.next()) {

                    CongThucSanPham item
                            = new CongThucSanPham();

                    item.setMaSanPham(
                            resultSet.getString(
                                    "MaSanPham"
                            )
                    );

                    item.setMaNguyenLieu(
                            resultSet.getString(
                                    "MaNguyenLieu"
                            )
                    );

                    item.setTenNguyenLieu(
                            resultSet.getString(
                                    "TenNguyenLieu"
                            )
                    );

                    item.setSoLuongCan(
                            resultSet.getInt(
                                    "SoLuongCan"
                            )
                    );

                    item.setSoLuongTon(
                            resultSet.getInt(
                                    "SoLuongTon"
                            )
                    );

                    item.setDonVi(
                            resultSet.getString(
                                    "DonVi"
                            )
                    );

                    list.add(item);
                }
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Không tải được công thức sản phẩm: "
                    + exception.getMessage(),
                    exception
            );
        }

        return list;
    }

    public Map<String, Integer>
            getCongThucMap(
                    String maSanPham
            ) {

        Map<String, Integer> map
                = new LinkedHashMap<>();

        for (CongThucSanPham item
                : getCongThuc(maSanPham)) {
            map.put(
                    item.getMaNguyenLieu(),
                    item.getSoLuongCan()
            );
        }

        return map;
    }

    public void saveCongThuc(
            String maSanPham,
            String[] maNguyenLieus,
            String[] soLuongCans
    ) {
        if (maNguyenLieus == null
                || soLuongCans == null
                || maNguyenLieus.length
                != soLuongCans.length) {
            throw new IllegalArgumentException(
                    "Dữ liệu công thức không hợp lệ."
            );
        }

        try (
                Connection conn
                = DBConnect.getConnection()) {
            conn.setAutoCommit(false);

            try {
                try (
                        PreparedStatement ps
                        = conn.prepareStatement(
                                """
                            DELETE FROM CongThucSanPham
                            WHERE MaSanPham = ?
                            """
                        )) {
                            ps.setString(
                                    1,
                                    maSanPham
                            );

                            ps.executeUpdate();
                        }

                        int soNguyenLieu
                                = 0;

                        String insertSql = """
                    INSERT INTO CongThucSanPham(
                        MaSanPham,
                        MaNguyenLieu,
                        SoLuongCan
                    )
                    VALUES (?, ?, ?)
                    """;

                        try (
                                PreparedStatement ps
                                = conn.prepareStatement(
                                        insertSql
                                )) {
                                    for (int i = 0;
                                            i < maNguyenLieus.length;
                                            i++) {
                                        int soLuong;

                                        try {
                                            soLuong
                                                    = Integer.parseInt(
                                                            soLuongCans[i]
                                                    );

                                        } catch (NumberFormatException e) {
                                            soLuong = 0;
                                        }

                                        if (soLuong <= 0) {
                                            continue;
                                        }

                                        ps.setString(
                                                1,
                                                maSanPham
                                        );

                                        ps.setString(
                                                2,
                                                maNguyenLieus[i]
                                        );

                                        ps.setInt(
                                                3,
                                                soLuong
                                        );

                                        ps.addBatch();
                                        soNguyenLieu++;
                                    }

                                    if (soNguyenLieu == 0) {
                                        throw new IllegalArgumentException(
                                                "Sản phẩm phải có ít nhất "
                                                + "một nguyên liệu."
                                        );
                                    }

                                    ps.executeBatch();
                                }

                                conn.commit();

            } catch (Exception e) {
                conn.rollback();

                if (e instanceof IllegalArgumentException) {
                    throw (IllegalArgumentException) e;
                }

                throw new IllegalStateException(
                        "Không lưu được công thức.",
                        e
                );

            } finally {
                conn.setAutoCommit(true);
            }

        } catch (SQLException e) {
            throw new IllegalStateException(
                    "Không lưu được công thức.",
                    e
            );
        }
    }

    private void boSungCongThuc(
            Connection connection,
            List<SanPham> sanPhamList
    ) throws SQLException {

        String sql = """
        SELECT
            nl.TenNguyenLieu,
            nl.SoLuongTon,
            nl.DonVi,
            ct.SoLuongCan
        FROM CongThucSanPham ct
        INNER JOIN NguyenLieu nl
            ON nl.MaNguyenLieu = ct.MaNguyenLieu
        WHERE ct.MaSanPham = ?
        ORDER BY nl.TenNguyenLieu
        """;

        try (
                PreparedStatement statement
                = connection.prepareStatement(sql)) {
            for (SanPham sanPham : sanPhamList) {

                statement.setString(
                        1,
                        sanPham.getMaSanPham()
                );

                int soLuongCoTheBan
                        = Integer.MAX_VALUE;

                int soNguyenLieu
                        = 0;

                StringBuilder congThucText
                        = new StringBuilder();

                try (
                        ResultSet resultSet
                        = statement.executeQuery()) {
                    while (resultSet.next()) {

                        soNguyenLieu++;

                        int soLuongTon
                                = resultSet.getInt(
                                        "SoLuongTon"
                                );

                        int soLuongCan
                                = resultSet.getInt(
                                        "SoLuongCan"
                                );

                        String donVi
                                = resultSet.getString(
                                        "DonVi"
                                );

                        int soPhanCoTheBan
                                = soLuongCan <= 0
                                        ? 0
                                        : soLuongTon / soLuongCan;

                        soLuongCoTheBan
                                = Math.min(
                                        soLuongCoTheBan,
                                        soPhanCoTheBan
                                );

                        if (congThucText.length() > 0) {
                            congThucText.append(" • ");
                        }

                        congThucText
                                .append(
                                        resultSet.getString(
                                                "TenNguyenLieu"
                                        )
                                )
                                .append(": ")
                                .append(soLuongCan)
                                .append(" ")
                                .append(
                                        donVi == null
                                        || donVi.isBlank()
                                        ? ""
                                        : donVi
                                );
                    }
                }

                if (soNguyenLieu == 0) {

                    sanPham.setSoLuongCoTheBan(0);

                    sanPham.setCongThucText(
                            "Chưa cấu hình công thức"
                    );

                } else {

                    sanPham.setSoLuongCoTheBan(
                            Math.max(
                                    0,
                                    soLuongCoTheBan
                            )
                    );

                    sanPham.setCongThucText(
                            congThucText.toString()
                    );
                }
            }
        }
    }

    private SanPham mapRow(
            ResultSet rs
    ) throws SQLException {

        SanPham sanPham
                = new SanPham();

        sanPham.setMaSanPham(
                rs.getString(
                        "MaSanPham"
                )
        );

        sanPham.setTenSanPham(
                rs.getString(
                        "TenSanPham"
                )
        );

        sanPham.setMaDanhMuc(
                rs.getString(
                        "MaDanhMuc"
                )
        );

        sanPham.setTenDanhMuc(
                rs.getString(
                        "TenDanhMuc"
                )
        );

        sanPham.setGiaBan(
                rs.getBigDecimal(
                        "GiaBan"
                )
        );

        sanPham.setTrangThai(
                rs.getBoolean(
                        "TrangThai"
                )
        );

        return sanPham;
    }

    private void validate(
            SanPham sanPham
    ) {
        if (sanPham == null
                || sanPham.getMaSanPham() == null
                || sanPham.getMaSanPham().isBlank()) {
            throw new IllegalArgumentException(
                    "Mã sản phẩm là bắt buộc."
            );
        }

        if (sanPham.getTenSanPham() == null
                || sanPham.getTenSanPham().isBlank()) {
            throw new IllegalArgumentException(
                    "Tên sản phẩm là bắt buộc."
            );
        }

        if (sanPham.getMaDanhMuc() == null
                || sanPham.getMaDanhMuc().isBlank()) {
            throw new IllegalArgumentException(
                    "Danh mục là bắt buộc."
            );
        }

        BigDecimal gia
                = sanPham.getGiaBan();

        if (gia == null
                || gia.compareTo(
                        BigDecimal.ZERO
                ) < 0) {
            throw new IllegalArgumentException(
                    "Giá sản phẩm không hợp lệ."
            );
        }
    }
}
