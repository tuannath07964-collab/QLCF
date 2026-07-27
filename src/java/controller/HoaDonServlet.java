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
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(
    name = "HoaDonServlet",
    urlPatterns = {"/hoadon"}
)
public class HoaDonServlet
        extends HttpServlet {

    private HoaDonDAO hoaDonDAO;
    private MenuDAO menuDAO;
    private KhachHangDAO khachHangDAO;

    @Override
    public void init()
            throws ServletException {

        hoaDonDAO = new HoaDonDAO();
        menuDAO = new MenuDAO();
        khachHangDAO =
                new KhachHangDAO();
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

        String action =
                request.getParameter("action");

        if (action == null
                || action.isBlank()) {
            action = "list";
        }

        try {
            switch (action) {
                case "new" ->
                    hienThiFormThemMoi(
                            request,
                            response
                    );

                case "edit" ->
                    hienThiFormChinhSua(
                            request,
                            response
                    );

                case "delete" ->
                    xoaHoaDon(
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

        String action =
                request.getParameter("action");

        try {
            switch (
                action == null
                ? ""
                : action
            ) {
                case "insert" ->
                    themHoaDon(
                            request,
                            response
                    );

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

                default ->
                    response.sendRedirect(
                        request.getContextPath()
                        + "/hoadon?action=list"
                    );
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            if (
                "insert".equals(action)
                || "update".equals(action)
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

    private void hienThiFormThemMoi(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute(
                        "maNV"
                ) == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/LoginServlet"
            );
            return;
        }

        HoaDon hd = new HoaDon();

        hd.setMaNV(
                String.valueOf(
                    session.getAttribute(
                            "maNV"
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

        hd.setNgayTao(
                new SimpleDateFormat(
                        "yyyy-MM-dd"
                ).format(new Date())
        );

        hd.setTrangThai(
                "Đang phục vụ"
        );

        request.setAttribute(
                "hoadon",
                hd
        );

        napDuLieuForm(request);

        request.getRequestDispatcher(
                "/views/hoadon1.jsp"
        ).forward(request, response);
    }

    private void hienThiFormChinhSua(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String maHD = trimToNull(
                request.getParameter("maHD")
        );

        if (maHD == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?action=list"
            );
            return;
        }

        HoaDon hd =
                hoaDonDAO.findById(maHD);

        if (hd == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?action=list"
                    + "&error=notFound"
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

    private void themHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HoaDon hd =
                taoHoaDonTuRequest(request);

        validateHoaDon(hd);

        int maHD =
            hoaDonDAO
                .taoHoacLayHoaDonDangPhucVu(
                    hd.getMaNV(),
                    Integer.parseInt(
                        hd.getMaBan()
                    )
                );

        hd.setMaHD(
                String.valueOf(maHD)
        );

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
                + maHD
                + "&success=insert"
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
            int maHD =
                hoaDonDAO
                    .taoHoacLayHoaDonDangPhucVu(
                        hd.getMaNV(),
                        Integer.parseInt(
                            hd.getMaBan()
                        )
                    );

            hd.setMaHD(
                    String.valueOf(maHD)
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

        String phuongThuc =
                "cash".equals(
                    request.getParameter("pay")
                )
                ? "Tiền mặt"
                : "Khác";

        hoaDonDAO.thanhToanHoaDon(
                Integer.parseInt(
                        hd.getMaHD()
                ),
                hd.getMaKH(),
                phuongThuc
        );

        response.sendRedirect(
                request.getContextPath()
                + "/ban?success=paid"
        );
    }

    private void xoaHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String maHD = trimToNull(
                request.getParameter("maHD")
        );

        if (maHD != null) {
            hoaDonDAO.delete(maHD);
        }

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=list"
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

        String maNV = trimToNull(
                request.getParameter("maNV")
        );

        if (maNV == null) {
            HttpSession session =
                    request.getSession(false);

            if (session != null
                    && session.getAttribute(
                            "maNV"
                    ) != null) {

                maNV = String.valueOf(
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
        if (hd.getMaBan() == null) {
            throw new IllegalArgumentException(
                    "Vui lòng chọn bàn."
            );
        }

        if (hd.getMaNV() == null) {
            throw new IllegalArgumentException(
                    "Không xác định được "
                    + "nhân viên đăng nhập."
            );
        }
    }

    private void
            hienThiLaiFormHoaDonKhiLoi(
                    HttpServletRequest request,
                    HttpServletResponse response
            )
            throws ServletException,
                   IOException {

        request.setAttribute(
                "hoadon",
                taoHoaDonTuRequest(request)
        );

        napDuLieuForm(request);

        request.getRequestDispatcher(
                "/views/hoadon1.jsp"
        ).forward(request, response);
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