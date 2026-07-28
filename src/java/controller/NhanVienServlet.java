package controller;

import dao.NhanVienDAO;
import model.NhanVien;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;

@WebServlet("/nhanvien")
public class NhanVienServlet
        extends HttpServlet {

    private NhanVienDAO dao;

    @Override
    public void init()
            throws ServletException {

        dao = new NhanVienDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!daDangNhap(request, response)) {
            return;
        }

        String action =
                trimToNull(
                        request.getParameter(
                                "action"
                        )
                );

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {

                case "loadForm" -> {
                    kiemTraQuanLy(request);

                    loadForm(
                            request,
                            response
                    );
                }

                case "loadCa" -> {
                    kiemTraQuanLy(request);

                    loadCaForm(
                            request,
                            response
                    );
                }

                default ->
                    listNhanVien(
                            request,
                            response
                    );
            }

        } catch (SecurityException e) {
            response.sendError(
                    HttpServletResponse
                        .SC_FORBIDDEN,
                    e.getMessage()
            );

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            listNhanVien(
                    request,
                    response
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!daDangNhap(request, response)) {
            return;
        }

        String action =
                trimToNull(
                        request.getParameter(
                                "action"
                        )
                );

        try {
            kiemTraQuanLy(request);

            switch (
                action == null
                ? ""
                : action
            ) {
                case "add" ->
                    insertNhanVien(
                            request,
                            response
                    );

                case "edit" ->
                    updateNhanVien(
                            request,
                            response
                    );

                case "updateCa" ->
                    updateCa(
                            request,
                            response
                    );

                case "updateStatus" ->
                    updateTrangThai(
                            request,
                            response
                    );

                default ->
                    response.sendRedirect(
                        request.getContextPath()
                        + "/nhanvien"
                    );
            }

        } catch (SecurityException e) {
            response.sendError(
                    HttpServletResponse
                        .SC_FORBIDDEN,
                    e.getMessage()
            );

        } catch (Exception e) {
            e.printStackTrace();

            String message =
                    e.getMessage() == null
                    ? "Có lỗi xảy ra."
                    : e.getMessage();

            response.sendRedirect(
                    request.getContextPath()
                    + "/nhanvien?error="
                    + URLEncoder.encode(
                            message,
                            StandardCharsets.UTF_8
                    )
            );
        }
    }

    private void listNhanVien(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "listNV",
                dao.getAllNhanVien()
        );

        request.getRequestDispatcher(
                "/views/nhanvien.jsp"
        ).forward(request, response);
    }

    private void loadForm(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String maNV =
                trimToNull(
                        request.getParameter(
                                "maNV"
                        )
                );

        if (maNV == null) {
            request.setAttribute(
                    "mode",
                    "add"
            );

        } else {
            NhanVien nv =
                    dao.getNhanVienById(maNV);

            if (nv == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy nhân viên."
                );
            }

            request.setAttribute(
                    "nv",
                    nv
            );

            request.setAttribute(
                    "mode",
                    "edit"
            );
        }

        request.getRequestDispatcher(
                "/views/nhanvien1.jsp"
        ).forward(request, response);
    }

    private void loadCaForm(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String maNV =
                trimToNull(
                        request.getParameter(
                                "maNV"
                        )
                );

        if (maNV == null) {
            throw new IllegalArgumentException(
                    "Thiếu mã nhân viên cần phân ca."
            );
        }

        NhanVien nv =
                dao.getNhanVienById(maNV);

        if (nv == null) {
            throw new IllegalArgumentException(
                    "Không tìm thấy nhân viên cần phân ca."
            );
        }

        request.setAttribute(
                "nv",
                nv
        );

        request.getRequestDispatcher(
                "/views/nhanvien2.jsp"
        ).forward(request, response);
    }

    private void insertNhanVien(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        NhanVien nv =
                buildNhanVienFromRequest(
                        request
                );

        String maNVMoi =
                dao.insertNhanVien(nv);

        response.sendRedirect(
                request.getContextPath()
                + "/nhanvien?success=add"
                + "&maNVMoi="
                + URLEncoder.encode(
                        maNVMoi,
                        StandardCharsets.UTF_8
                )
        );
    }

    private void updateNhanVien(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        NhanVien nv =
                buildNhanVienFromRequest(
                        request
                );

        if (nv.getMaNV() == null) {
            throw new IllegalArgumentException(
                    "Thiếu mã nhân viên cần cập nhật."
            );
        }

        if (!dao.updateNhanVien(nv)) {
            throw new IllegalStateException(
                    "Không cập nhật được nhân viên."
            );
        }

        /*
         * Chỉ quản lý mới vào được servlet này.
         * Để trống mật khẩu thì giữ mật khẩu cũ.
         */
        String matKhauMoi =
                trimToNull(
                        request.getParameter(
                                "matKhau"
                        )
                );

        if (matKhauMoi != null) {
            if (
                !dao.updateMatKhau(
                        nv.getMaNV(),
                        matKhauMoi
                )
            ) {
                throw new IllegalStateException(
                        "Không đổi được mật khẩu."
                );
            }
        }

        response.sendRedirect(
                request.getContextPath()
                + "/nhanvien?success=edit"
        );
    }

    private void updateCa(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        String maNV =
                trimToNull(
                        request.getParameter(
                                "maNV"
                        )
                );

        boolean caSang =
                request.getParameter(
                        "caSang"
                ) != null;

        boolean caChieu =
                request.getParameter(
                        "caChieu"
                ) != null;

        boolean caToi =
                request.getParameter(
                        "caToi"
                ) != null;

        String gioBatDau =
                trimToNull(
                        request.getParameter(
                                "gioBatDau"
                        )
                );

        String gioKetThuc =
                trimToNull(
                        request.getParameter(
                                "gioKetThuc"
                        )
                );

        if (maNV == null) {
            throw new IllegalArgumentException(
                    "Thiếu mã nhân viên cần phân ca."
            );
        }

        if (
            !caSang
            && !caChieu
            && !caToi
        ) {
            throw new IllegalArgumentException(
                    "Phải chọn ít nhất một ca làm."
            );
        }

        if (
            gioBatDau == null
            || gioKetThuc == null
        ) {
            throw new IllegalArgumentException(
                    "Phải nhập giờ bắt đầu "
                    + "và giờ kết thúc."
            );
        }

        if (gioBatDau.equals(gioKetThuc)) {
            throw new IllegalArgumentException(
                    "Giờ bắt đầu và kết thúc "
                    + "không được giống nhau."
            );
        }

        dao.updateCaLam(
                maNV,
                caSang,
                caChieu,
                caToi,
                gioBatDau,
                gioKetThuc
        );

        response.sendRedirect(
                request.getContextPath()
                + "/nhanvien?success=shift"
        );
    }

    private void updateTrangThai(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String maNV =
                trimToNull(
                        request.getParameter(
                                "maNV"
                        )
                );

        String trangThai =
                trimToNull(
                        request.getParameter(
                                "trangThai"
                        )
                );

        if (
            maNV == null
            || trangThai == null
        ) {
            throw new IllegalArgumentException(
                    "Thiếu trạng thái nhân viên."
            );
        }

        if (
            !dao.updateTrangThai(
                    maNV,
                    trangThai
            )
        ) {
            throw new IllegalStateException(
                    "Không cập nhật được trạng thái nhân viên."
            );
        }

        /*
         * Nếu quản lý chuyển chính mình sang nghỉ,
         * phiên hiện tại vẫn tồn tại.
         * Lần đăng nhập tiếp theo sẽ bị chặn.
         */
        response.sendRedirect(
                request.getContextPath()
                + "/nhanvien?success=status"
        );
    }

    private NhanVien buildNhanVienFromRequest(
            HttpServletRequest request
    ) {
        NhanVien nv =
                new NhanVien();

        nv.setMaNV(
                trimToNull(
                    request.getParameter(
                            "maNV"
                    )
                )
        );

        nv.setHoTen(
                trimToNull(
                    request.getParameter(
                            "hoTen"
                    )
                )
        );

        nv.setGioiTinh(
                trimToNull(
                    request.getParameter(
                            "gioiTinh"
                    )
                )
        );

        nv.setSdt(
                trimToNull(
                    request.getParameter(
                            "sdt"
                    )
                )
        );

        nv.setChucVu(
                "Quản lý".equals(
                    request.getParameter(
                            "chucVu"
                    )
                )
                    ? "Quản lý"
                    : "Nhân viên"
        );

        nv.setTrangThai(
                trimToNull(
                    request.getParameter(
                            "trangThai"
                    )
                )
        );

        nv.setMatKhau(
                trimToNull(
                    request.getParameter(
                            "matKhau"
                    )
                )
        );

        String ngaySinh =
                trimToNull(
                        request.getParameter(
                                "ngaySinh"
                        )
                );

        if (ngaySinh != null) {
            nv.setNgaySinh(
                    Date.valueOf(ngaySinh)
            );
        }

        String luong =
                trimToNull(
                        request.getParameter(
                                "luongCoBan"
                        )
                );

        try {
            nv.setLuongCoBan(
                    luong == null
                    ? BigDecimal.ZERO
                    : new BigDecimal(luong)
            );

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Lương cơ bản không hợp lệ."
            );
        }

        if (nv.getHoTen() == null) {
            throw new IllegalArgumentException(
                    "Họ tên là bắt buộc."
            );
        }

        if (nv.getSdt() == null) {
            throw new IllegalArgumentException(
                    "Số điện thoại là bắt buộc."
            );
        }

        return nv;
    }

    private boolean daDangNhap(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session =
                request.getSession(false);

        if (
            session == null
            || session.getAttribute("maNV")
                == null
        ) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/LoginServlet"
            );

            return false;
        }

        return true;
    }

    private void kiemTraQuanLy(
            HttpServletRequest request
    ) {
        HttpSession session =
                request.getSession(false);

        if (
            session == null
            || !"Quản lý".equals(
                session.getAttribute(
                        "chucVu"
                )
            )
        ) {
            throw new SecurityException(
                    "Chỉ quản lý được thay đổi "
                    + "thông tin nhân viên."
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