package controller;

import dao.HoaDonDAO;
import dao.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.HoaDon;
import model.MaGiamGia;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "HoaDonServlet", urlPatterns = {"/hoadon"})
public class HoaDonServlet extends HttpServlet {

    private HoaDonDAO hoaDonDAO;
    private MenuDAO menuDAO;

    @Override
    public void init() throws ServletException {
        hoaDonDAO = new HoaDonDAO();
        menuDAO = new MenuDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");

        if (action == null || action.isBlank()) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    hienThiDanhSachHoaDon(request, response);
                    break;

                case "new":
                    hienThiFormThemMoi(request, response);
                    break;

                case "edit":
                    hienThiFormChinhSua(request, response);
                    break;

                case "delete":
                    xoaHoaDon(request, response);
                    break;

                default:
                    response.sendRedirect(
                            request.getContextPath()
                            + "/hoadon?action=list"
                    );
                    break;
            }

        } catch (Exception ex) {
            ex.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Không thể xử lý hóa đơn: " + ex.getMessage()
            );

            hienThiDanhSachHoaDon(request, response);
        }
    }

    /**
     * Hiển thị danh sách hóa đơn.
     */
    private void hienThiDanhSachHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "listHoaDon",
                hoaDonDAO.getAll()
        );

        request.setAttribute(
                "discountList",
                hoaDonDAO.getAllMaGiamGia()
        );

        request.getRequestDispatcher("/views/hoadon.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị form tạo hóa đơn mới.
     *
     * Nếu mở từ trang quản lý hóa đơn: /hoadon?action=new
     *
     * Nếu mở từ trang bàn: /hoadon?action=new&maBan=1
     */
    private void hienThiFormThemMoi(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("maNV") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/LoginServlet"
            );
            return;
        }

        String maBan = request.getParameter("maBan");

        HoaDon hoaDonMoi = new HoaDon();

        hoaDonMoi.setNgayTao(
                new SimpleDateFormat("yyyy-MM-dd")
                        .format(new Date())
        );

        hoaDonMoi.setTrangThai("Đang phục vụ");
        hoaDonMoi.setTongTien(0);

        Object maNVSession = session.getAttribute("maNV");

        hoaDonMoi.setMaNV(
                String.valueOf(maNVSession)
        );

        /*
         * Chỉ gán mã bàn nếu người dùng đi từ trang Bàn.
         * Nếu tạo hóa đơn từ trang Hóa đơn thì mã bàn để trống.
         */
        if (maBan != null && !maBan.isBlank()) {
            hoaDonMoi.setMaBan(maBan.trim());
        }

        request.setAttribute("hoadon", hoaDonMoi);

        request.setAttribute(
                "menuList",
                menuDAO.getAllMenu()
        );

        request.setAttribute(
                "discountList",
                hoaDonDAO.getMaGiamGiaConHieuLuc()
        );

        request.getRequestDispatcher("/views/hoadon1.jsp")
                .forward(request, response);
    }

    /**
     * Hiển thị form sửa hóa đơn.
     */
    private void hienThiFormChinhSua(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String maHD = request.getParameter("maHD");

        if (maHD == null || maHD.isBlank()) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?action=list"
            );
            return;
        }

        HoaDon hoaDon = hoaDonDAO.findById(maHD.trim());

        if (hoaDon == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?action=list&error=notFound"
            );
            return;
        }

        request.setAttribute("hoadon", hoaDon);

        request.setAttribute(
                "menuList",
                menuDAO.getAllMenu()
        );

        request.setAttribute(
                "discountList",
                hoaDonDAO.getAllMaGiamGia()
        );

        request.getRequestDispatcher("/views/hoadon1.jsp")
                .forward(request, response);
    }

    /**
     * Xóa hóa đơn.
     */
    private void xoaHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String maHD = request.getParameter("maHD");

        if (maHD != null && !maHD.isBlank()) {
            hoaDonDAO.delete(maHD.trim());
        }

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=list"
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");

        try {
            if ("addMaGiamGia".equals(action)) {
                themMaGiamGia(request, response);
                return;
            }

            if ("updateMaGiamGia".equals(action)) {
                capNhatMaGiamGia(request, response);
                return;
            }

            if ("insert".equals(action)) {
                themHoaDon(request, response);
                return;
            }

            if ("update".equals(action)) {
                capNhatHoaDon(request, response);
                return;
            }

            if ("pay".equals(action)) {
                thanhToanHoaDon(request, response);
                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?action=list"
            );

        } catch (Exception ex) {
            ex.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Không thể lưu dữ liệu: " + ex.getMessage()
            );

            if ("insert".equals(action)
                    || "update".equals(action)) {

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

    /**
     * Thêm hóa đơn.
     */
    private void themHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HoaDon hoaDon = taoHoaDonTuRequest(request);

        if (hoaDon.getMaBan() == null
                || hoaDon.getMaBan().isBlank()) {

            request.setAttribute(
                    "errorMessage",
                    "Vui lòng chọn bàn."
            );

            hienThiLaiFormHoaDonKhiLoi(
                    request,
                    response
            );
            return;
        }

        if (hoaDon.getMaNV() == null
                || hoaDon.getMaNV().isBlank()) {

            request.setAttribute(
                    "errorMessage",
                    "Không xác định được nhân viên."
            );

            hienThiLaiFormHoaDonKhiLoi(
                    request,
                    response
            );
            return;
        }

        hoaDonDAO.insertHoaDon(hoaDon);

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=list&success=insert"
        );
    }

    /**
     * Cập nhật hóa đơn.
     */
    private void capNhatHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HoaDon hoaDon
                = taoHoaDonTuRequest(request);

        if (hoaDon.getMaHD() == null) {
            throw new IllegalArgumentException(
                    "Thiếu mã hóa đơn."
            );
        }

        hoaDonDAO.luuDonHang(
                hoaDon,
                request.getParameterValues(
                        "itemMaMon"
                ),
                request.getParameterValues(
                        "itemQty"
                )
        );

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=edit&maHD="
                + hoaDon.getMaHD()
                + "&success=save"
        );
    }

    private void thanhToanHoaDon(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HoaDon hoaDon
                = taoHoaDonTuRequest(request);

        if (hoaDon.getMaHD() == null) {
            throw new IllegalArgumentException(
                    "Thiếu mã hóa đơn."
            );
        }

        /* Lưu món mới nhất trước */
        hoaDonDAO.luuDonHang(
                hoaDon,
                request.getParameterValues(
                        "itemMaMon"
                ),
                request.getParameterValues(
                        "itemQty"
                )
        );

        String pay
                = request.getParameter("pay");

        String phuongThuc
                = "cash".equals(pay)
                ? "Tiền mặt"
                : "Khác";

        hoaDonDAO.thanhToanHoaDon(
                Integer.parseInt(
                        hoaDon.getMaHD()
                ),
                hoaDon.getMaGiamGia(),
                phuongThuc
        );

        response.sendRedirect(
                request.getContextPath()
                + "/ban?success=paid"
        );
    }

    /**
     * Tạo đối tượng HoaDon từ dữ liệu form.
     */
    private HoaDon taoHoaDonTuRequest(
            HttpServletRequest request
    ) {

        String maHD = trimToNull(
                request.getParameter("maHD")
        );

        String maBan = trimToNull(
                request.getParameter("maBan")
        );

        String ngayTao = trimToNull(
                request.getParameter("ngayTao")
        );

        String trangThai = trimToNull(
                request.getParameter("trangThai")
        );

        String danhSachMon = trimToNull(
                request.getParameter("danhSachMon")
        );

        String maGiamGia = trimToNull(
                request.getParameter("maGiamGia")
        );

        String maNV = trimToNull(
                request.getParameter("maNV")
        );

        /*
         * Nếu form không gửi maNV thì lấy từ session.
         */
        if (maNV == null) {
            HttpSession session = request.getSession(false);

            if (session != null
                    && session.getAttribute("maNV") != null) {

                maNV = String.valueOf(
                        session.getAttribute("maNV")
                );
            }
        }

        if (ngayTao == null) {
            ngayTao = new SimpleDateFormat("yyyy-MM-dd")
                    .format(new Date());
        }

        if (trangThai == null) {
            trangThai = "Đang phục vụ";
        }

        double tongTien = parseDouble(
                request.getParameter("tongTien")
        );

        HoaDon hoaDon = new HoaDon();

        hoaDon.setMaHD(maHD);
        hoaDon.setMaNV(maNV);
        hoaDon.setMaBan(maBan);
        hoaDon.setNgayTao(ngayTao);
        hoaDon.setTrangThai(trangThai);
        hoaDon.setTongTien(tongTien);
        hoaDon.setDanhSachMon(danhSachMon);
        hoaDon.setMaGiamGia(
                trimToNull(
                        request.getParameter(
                                "maGiamGia"
                        )
                )
        );

        return hoaDon;
    }

    /**
     * Khi lưu hóa đơn lỗi thì giữ lại dữ liệu đã nhập và mở lại form thay vì
     * chuyển về danh sách.
     */
    private void hienThiLaiFormHoaDonKhiLoi(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HoaDon hoaDon = taoHoaDonTuRequest(request);

        request.setAttribute("hoadon", hoaDon);

        request.setAttribute(
                "menuList",
                menuDAO.getAllMenu()
        );

        request.setAttribute(
                "discountList",
                hoaDonDAO.getAllMaGiamGia()
        );

        request.getRequestDispatcher("/views/hoadon1.jsp")
                .forward(request, response);
    }

    /**
     * Thêm mã giảm giá.
     */
    private void themMaGiamGia(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        MaGiamGia maGiamGia = new MaGiamGia();

        maGiamGia.setMaCode(
                request.getParameter("code")
        );

        maGiamGia.setPhanTramGiam(
                parseDouble(
                        request.getParameter("percent")
                )
        );

        maGiamGia.setDieuKienDonToiTieu(
                parseDouble(
                        request.getParameter("minAmount")
                )
        );

        maGiamGia.setNgayHetHan(
                request.getParameter("endDate")
        );

        maGiamGia.setTrangThai(
                parseInteger(
                        request.getParameter("status")
                )
        );

        hoaDonDAO.insertMaGiamGia(maGiamGia);

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=list&success=discountInsert"
        );
    }

    /**
     * Cập nhật mã giảm giá.
     */
    private void capNhatMaGiamGia(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        MaGiamGia maGiamGia = new MaGiamGia();

        maGiamGia.setIDGiamGia(
                parseInteger(
                        request.getParameter("id")
                )
        );

        maGiamGia.setMaCode(
                request.getParameter("code")
        );

        maGiamGia.setPhanTramGiam(
                parseDouble(
                        request.getParameter("percent")
                )
        );

        maGiamGia.setDieuKienDonToiTieu(
                parseDouble(
                        request.getParameter("minAmount")
                )
        );

        maGiamGia.setNgayHetHan(
                request.getParameter("endDate")
        );

        maGiamGia.setTrangThai(
                parseInteger(
                        request.getParameter("status")
                )
        );

        hoaDonDAO.updateMaGiamGia(maGiamGia);

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=list&success=discountUpdate"
        );
    }

    private String trimToNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }

        return value.trim();
    }

    private double parseDouble(String value) {
        if (value == null || value.isBlank()) {
            return 0;
        }

        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    private int parseInteger(String value) {
        if (value == null || value.isBlank()) {
            return 0;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return 0;
        }
    }
}
