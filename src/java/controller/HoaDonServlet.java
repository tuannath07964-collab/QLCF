package controller;

import dao.HoaDonDAO;
import dao.KhachHangDAO;
import dao.SanPhamDAO;

import model.ChiTietHoaDon;
import model.HoaDon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(
        name = "HoaDonServlet",
        urlPatterns = {"/hoadon"}
)
public class HoaDonServlet extends HttpServlet {

    private HoaDonDAO hoaDonDAO;
    private SanPhamDAO sanPhamDAO;
    private KhachHangDAO khachHangDAO;

    @Override
    public void init() throws ServletException {

        hoaDonDAO = new HoaDonDAO();
        sanPhamDAO = new SanPhamDAO();
        khachHangDAO = new KhachHangDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!checkLogin(request, response)) {
            return;
        }

        String action =
                request.getParameter("action");

        try {

            if ("create".equals(action)) {

                String maTaiKhoan =
                        String.valueOf(
                                request
                                        .getSession()
                                        .getAttribute(
                                                "maNV"
                                        )
                        );

                int maHD =
                        hoaDonDAO.taoHoaDon(
                                maTaiKhoan
                        );

                response.sendRedirect(
                        request.getContextPath()
                        + "/hoadon?action=edit&id="
                        + maHD
                );

                return;
            }

            if ("edit".equals(action)) {

                int maHD =
                        parseId(
                                request.getParameter(
                                        "id"
                                )
                        );

                loadEditor(
                        request,
                        response,
                        maHD
                );

                return;
            }

            loadList(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            loadList(
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

        if (!checkLogin(request, response)) {
            return;
        }

        String action =
                request.getParameter(
                        "action"
                );

        int maHD =
                parseId(
                        request.getParameter(
                                "maHD"
                        )
                );

        try {

            if ("cancel".equals(action)) {

                hoaDonDAO.huyHoaDon(
                        maHD,
                        request.getParameter(
                                "lyDoHuy"
                        )
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/hoadon?success=cancel"
                );

                return;
            }

            List<ChiTietHoaDon> items =
                    buildItems(request);

            String customerMode =
                    request.getParameter(
                            "customerMode"
                    );

            if (
                    customerMode == null
                    || customerMode.isBlank()
            ) {
                customerMode = "guest";
            }

            String maKH = null;
            String tenKhachHang = null;
            String sdtKhachHang = null;

            boolean luuKhachMoi = false;

            switch (customerMode) {

                case "saved":

                    maKH =
                            trimToNull(
                                    request.getParameter(
                                            "maKH"
                                    )
                            );

                    if (maKH == null) {

                        throw new IllegalArgumentException(
                                "Vui lòng chọn khách hàng đã lưu."
                        );
                    }

                    break;

                case "new":

                    tenKhachHang =
                            trimToNull(
                                    request.getParameter(
                                            "tenKhachHang"
                                    )
                            );

                    sdtKhachHang =
                            trimToNull(
                                    request.getParameter(
                                            "sdtKhachHang"
                                    )
                            );

                    if (tenKhachHang == null) {

                        throw new IllegalArgumentException(
                                "Vui lòng nhập họ tên khách hàng mới."
                        );
                    }

                    if (sdtKhachHang == null) {

                        throw new IllegalArgumentException(
                                "Vui lòng nhập số điện thoại khách hàng mới."
                        );
                    }

                    if (
                            !sdtKhachHang.matches(
                                    "^0\\d{8,10}$"
                            )
                    ) {

                        throw new IllegalArgumentException(
                                "Số điện thoại phải bắt đầu bằng 0 và có từ 9 đến 11 chữ số."
                        );
                    }

                    luuKhachMoi = true;

                    break;

                case "guest":

                    maKH = null;
                    tenKhachHang = null;
                    sdtKhachHang = null;
                    luuKhachMoi = false;

                    break;

                default:

                    throw new IllegalArgumentException(
                            "Loại khách hàng không hợp lệ."
                    );
            }

            if ("pay".equals(action)) {

                Integer maVoucher = null;

                if ("saved".equals(customerMode)) {

                    maVoucher =
                            parseNullableId(
                                    request.getParameter(
                                            "maVoucher"
                                    )
                            );
                }

                hoaDonDAO.thanhToanHoaDon(
                        maHD,
                        maKH,
                        tenKhachHang,
                        sdtKhachHang,
                        luuKhachMoi,
                        maVoucher,
                        items
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/hoadon?success=paid"
                );

                return;
            }

            hoaDonDAO.luuHoaDon(
                    maHD,
                    maKH,
                    tenKhachHang,
                    sdtKhachHang,
                    items
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?action=edit&id="
                    + maHD
                    + "&success=save"
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            request.setAttribute(
                    "customerModeDaChon",
                    request.getParameter(
                            "customerMode"
                    )
            );

            request.setAttribute(
                    "maKHDaChon",
                    request.getParameter(
                            "maKH"
                    )
            );

            request.setAttribute(
                    "tenKhachHangDaNhap",
                    request.getParameter(
                            "tenKhachHang"
                    )
            );

            request.setAttribute(
                    "sdtKhachHangDaNhap",
                    request.getParameter(
                            "sdtKhachHang"
                    )
            );

            request.setAttribute(
                    "maVoucherDaChon",
                    request.getParameter(
                            "maVoucher"
                    )
            );

            loadEditor(
                    request,
                    response,
                    maHD
            );
        }
    }

    private void loadList(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "hoaDonList",
                hoaDonDAO.getAll()
        );

        request.getRequestDispatcher(
                "/views/hoadon.jsp"
        ).forward(
                request,
                response
        );
    }

    private void loadEditor(
            HttpServletRequest request,
            HttpServletResponse response,
            int maHD
    ) throws ServletException, IOException {

        HoaDon hoaDon =
                hoaDonDAO.findById(
                        maHD
                );

        if (hoaDon == null) {

            throw new IllegalArgumentException(
                    "Không tìm thấy hóa đơn."
            );
        }

        request.setAttribute(
                "hoaDon",
                hoaDon
        );

        request.setAttribute(
                "chiTietList",
                hoaDonDAO.getChiTiet(
                        maHD
                )
        );

        request.setAttribute(
                "sanPhamList",
                sanPhamDAO.getAll(
                        null,
                        null,
                        false
                )
        );

        request.setAttribute(
                "khachHangList",
                khachHangDAO
                        .getAllKhachHang()
        );

        request.setAttribute(
                "voucherList",
                hoaDonDAO
                        .getVoucherConHan()
        );

        request.setAttribute(
                "voucherDaDung",
                hoaDonDAO
                        .getVoucherCuaHoaDon(
                                maHD
                        )
        );

        request.getRequestDispatcher(
                "/views/hoadon1.jsp"
        ).forward(
                request,
                response
        );
    }

    private List<ChiTietHoaDon> buildItems(
            HttpServletRequest request
    ) {

        String[] maSanPhams =
                request.getParameterValues(
                        "maSanPham"
                );

        String[] soLuongs =
                request.getParameterValues(
                        "soLuong"
                );

        if (
                maSanPhams == null
                || soLuongs == null
                || maSanPhams.length
                != soLuongs.length
        ) {

            throw new IllegalArgumentException(
                    "Hóa đơn chưa có sản phẩm."
            );
        }

        List<ChiTietHoaDon> list =
                new ArrayList<>();

        for (
                int i = 0;
                i < maSanPhams.length;
                i++
        ) {

            ChiTietHoaDon item =
                    new ChiTietHoaDon();

            item.setMaSanPham(
                    maSanPhams[i]
            );

            int soLuong;

            try {

                soLuong =
                        Integer.parseInt(
                                soLuongs[i]
                        );

            } catch (NumberFormatException e) {

                throw new IllegalArgumentException(
                        "Số lượng sản phẩm không hợp lệ."
                );
            }

            if (soLuong <= 0) {

                throw new IllegalArgumentException(
                        "Số lượng sản phẩm phải lớn hơn 0."
                );
            }

            item.setSoLuong(
                    soLuong
            );

            list.add(item);
        }

        return list;
    }

    private int parseId(
            String value
    ) {

        try {

            return Integer.parseInt(
                    value
            );

        } catch (Exception e) {

            throw new IllegalArgumentException(
                    "Mã hóa đơn không hợp lệ."
            );
        }
    }

    private Integer parseNullableId(
            String value
    ) {

        if (
                value == null
                || value.isBlank()
        ) {
            return null;
        }

        try {

            return Integer.valueOf(
                    value
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Mã voucher không hợp lệ."
            );
        }
    }

    private String trimToNull(
            String value
    ) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }

    private boolean checkLogin(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session =
                request.getSession(
                        false
                );

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
}