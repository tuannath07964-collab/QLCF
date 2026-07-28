package controller;

import dao.HoaDonDAO;
import dao.KhachHangDAO;
import dao.MenuDAO;
import model.HoaDon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(
        name = "HoaDonServlet",
        urlPatterns = {"/hoadon"}
)
public class HoaDonServlet extends HttpServlet {

    private HoaDonDAO hoaDonDAO;
    private MenuDAO menuDAO;
    private KhachHangDAO khachHangDAO;

    @Override
    public void init() throws ServletException {
        hoaDonDAO = new HoaDonDAO();
        menuDAO = new MenuDAO();
        khachHangDAO = new KhachHangDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType(
                "text/html; charset=UTF-8"
        );

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

                case "takeaway" ->
                    taoDonMangVe(
                            request,
                            response
                    );

                case "edit" ->
                    hienThiFormChinhSua(
                            request,
                            response
                    );

                default ->
                    hienThiDanhSachHoaDon(
                            request,
                            response
                    );
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            hienThiDanhSachHoaDon(
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
        response.setContentType(
                "text/html; charset=UTF-8"
        );

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
            switch (
                action == null
                        ? ""
                        : action
            ) {
                case "update" ->
                    capNhatHoaDon(
                            request,
                            response
                    );

                case "pay" ->
                    thanhToanHoaDon(
                            request,
                            response
                    );

                case "cancel" ->
                    huyHoaDon(
                            request,
                            response
                    );

                default ->
                    response.sendRedirect(
                            request.getContextPath()
                            + "/hoadon"
                    );
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            if (
                "update".equals(action)
                || "pay".equals(action)
            ) {
                hienThiLaiFormHoaDonKhiLoi(
                        request,
                        response
                );
            } else {
                hienThiDanhSachHoaDon(
                        request,
                        response
                );
            }
        }
    }

    private void hienThiDanhSachHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "listHoaDon",
                hoaDonDAO.getAll()
        );

        request.getRequestDispatcher(
                "/views/hoadon.jsp"
        ).forward(request, response);
    }

    private void taoDonMangVe(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HttpSession session =
                request.getSession(false);

        String maNV =
                String.valueOf(
                        session.getAttribute(
                                "maNV"
                        )
                );

        int maHD =
                hoaDonDAO.taoHoaDonMangVe(
                        maNV
                );

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=edit"
                + "&maHD="
                + maHD
        );
    }

    private void hienThiFormChinhSua(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String maHD =
                trimToNull(
                        request.getParameter(
                                "maHD"
                        )
                );

        if (maHD == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon"
            );
            return;
        }

        HoaDon hd =
                hoaDonDAO.findById(maHD);

        if (hd == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?error=notFound"
            );
            return;
        }

        request.setAttribute(
                "hoadon",
                hd
        );

        napDuLieuForm(request);

        request.getRequestDispatcher(
                "/views/hoadon1.jsp"
        ).forward(request, response);
    }

    private void napDuLieuForm(
            HttpServletRequest request
    ) {
        request.setAttribute(
                "menuList",
                menuDAO.getAllMenu()
        );

        request.setAttribute(
                "khachHangList",
                khachHangDAO
                        .getAllKhachHang()
        );
    }

    private void capNhatHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HoaDon hd =
                taoHoaDonTuRequest(request);

        validateHoaDon(hd);

        if (hd.getMaHD() == null) {
            throw new IllegalArgumentException(
                    "Thiếu mã hóa đơn."
            );
        }

        hoaDonDAO.luuDonHang(
                hd,
                request.getParameterValues(
                        "itemMaMon"
                ),
                request.getParameterValues(
                        "itemQty"
                )
        );

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=edit"
                + "&maHD="
                + hd.getMaHD()
                + "&success=save"
        );
    }

    private void thanhToanHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HoaDon hd =
                taoHoaDonTuRequest(request);

        validateHoaDon(hd);

        if (hd.getMaHD() == null) {
            throw new IllegalArgumentException(
                    "Thiếu mã hóa đơn."
            );
        }

        /*
         * Luôn lưu danh sách món mới nhất
         * trước khi thực hiện thanh toán.
         */
        hoaDonDAO.luuDonHang(
                hd,
                request.getParameterValues(
                        "itemMaMon"
                ),
                request.getParameterValues(
                        "itemQty"
                )
        );

        boolean luuKhachMoi =
                request.getParameter(
                        "luuKhachMoi"
                ) != null;

        String tenKhachMoi =
                trimToNull(
                        request.getParameter(
                                "tenKhachMoi"
                        )
                );

        String phuongThuc =
                "cash".equals(
                        request.getParameter(
                                "pay"
                        )
                )
                        ? "Tiền mặt"
                        : "Khác";

        hoaDonDAO.thanhToanHoaDon(
                Integer.parseInt(
                        hd.getMaHD()
                ),
                hd.getMaKH(),
                tenKhachMoi,
                luuKhachMoi,
                phuongThuc
        );

        if (hd.isMangVe()) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?success=paid"
            );
        } else {
            response.sendRedirect(
                    request.getContextPath()
                    + "/ban?success=paid"
            );
        }
    }

    private void huyHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        String maHD =
                trimToNull(
                        request.getParameter(
                                "maHD"
                        )
                );

        String lyDo =
                trimToNull(
                        request.getParameter(
                                "lyDoHuy"
                        )
                );

        if (maHD == null) {
            throw new IllegalArgumentException(
                    "Thiếu mã hóa đơn cần hủy."
            );
        }

        if (lyDo == null) {
            throw new IllegalArgumentException(
                    "Vui lòng nhập lý do hủy hóa đơn."
            );
        }

        hoaDonDAO.huyHoaDon(
                Integer.parseInt(maHD),
                lyDo
        );

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?success=cancel"
        );
    }

    private HoaDon taoHoaDonTuRequest(
            HttpServletRequest request
    ) {
        HoaDon hd = new HoaDon();

        hd.setMaHD(
                trimToNull(
                        request.getParameter(
                                "maHD"
                        )
                )
        );

        hd.setMaBan(
                trimToNull(
                        request.getParameter(
                                "maBan"
                        )
                )
        );

        hd.setMaKH(
                trimToNull(
                        request.getParameter(
                                "maKH"
                        )
                )
        );

        hd.setDanhSachMon(
                trimToNull(
                        request.getParameter(
                                "danhSachMon"
                        )
                )
        );

        hd.setNgayTao(
                trimToNull(
                        request.getParameter(
                                "ngayTao"
                        )
                )
        );

        hd.setTrangThai(
                trimToNull(
                        request.getParameter(
                                "trangThai"
                        )
                )
        );

        hd.setHinhThuc(
                trimToNull(
                        request.getParameter(
                                "hinhThuc"
                        )
                )
        );

        String maNV =
                trimToNull(
                        request.getParameter(
                                "maNV"
                        )
                );

        if (maNV == null) {
            HttpSession session =
                    request.getSession(false);

            if (
                session != null
                && session.getAttribute(
                        "maNV"
                ) != null
            ) {
                maNV =
                        String.valueOf(
                                session.getAttribute(
                                        "maNV"
                                )
                        );
            }
        }

        hd.setMaNV(maNV);

        return hd;
    }

    private void validateHoaDon(
            HoaDon hd
    ) {
        if (hd.getMaNV() == null) {
            throw new IllegalArgumentException(
                    "Không xác định được nhân viên đăng nhập."
            );
        }

        boolean mangVe =
                "Mang về".equalsIgnoreCase(
                        hd.getHinhThuc()
                );

        if (
            !mangVe
            && hd.getMaBan() == null
        ) {
            throw new IllegalArgumentException(
                    "Hóa đơn tại bàn phải có bàn phục vụ."
            );
        }
    }

    private void hienThiLaiFormHoaDonKhiLoi(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "hoadon",
                taoHoaDonTuRequest(request)
        );

        napDuLieuForm(request);

        request.getRequestDispatcher(
                "/views/hoadon1.jsp"
        ).forward(request, response);
    }

    private boolean daDangNhap(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session =
                request.getSession(false);

        if (
            session == null
            || session.getAttribute(
                    "maNV"
            ) == null
        ) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/LoginServlet"
            );

            return false;
        }

        return true;
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