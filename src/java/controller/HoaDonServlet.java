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

@WebServlet(name = "HoaDonServlet", urlPatterns = {"/hoadon"})
public class HoaDonServlet extends HttpServlet {

    private HoaDonDAO hoaDonDAO;
    private SanPhamDAO sanPhamDAO;
    private KhachHangDAO khachHangDAO;

    @Override
    public void init()
            throws ServletException {

        hoaDonDAO
                = new HoaDonDAO();

        sanPhamDAO
                = new SanPhamDAO();

        khachHangDAO
                = new KhachHangDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!checkLogin(request, response)) {
            return;
        }

        String action
                = request.getParameter(
                        "action"
                );

        try {
            if ("create".equals(action)) {
                int maHD
                        = hoaDonDAO.taoHoaDon(
                                String.valueOf(
                                        request
                                                .getSession()
                                                .getAttribute(
                                                        "maNV"
                                                )
                                )
                        );

                response.sendRedirect(
                        request.getContextPath()
                        + "/hoadon?action=edit&id="
                        + maHD
                );

                return;
            }

            if ("edit".equals(action)) {
                int maHD
                        = parseId(
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

        request.setCharacterEncoding(
                "UTF-8"
        );

        if (!checkLogin(request, response)) {
            return;
        }

        String action
                = request.getParameter(
                        "action"
                );

        int maHD
                = parseId(
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
                        + "/hoadon"
                        + "?success=cancel"
                );

                return;
            }

            List<ChiTietHoaDon> items
                    = buildItems(request);

            if ("pay".equals(action)) {
                hoaDonDAO.thanhToanHoaDon(
                        maHD,
                        request.getParameter("maKH"),
                        request.getParameter("tenKhachHang"),
                        request.getParameter("luuKhachMoi") != null,
                        items
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/hoadon"
                        + "?success=paid"
                );

                return;
            }

            hoaDonDAO.luuHoaDon(
                    maHD,
                    request.getParameter(
                            "maKH"
                    ),
                    request.getParameter(
                            "tenKhachHang"
                    ),
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

        HoaDon hoaDon
                = hoaDonDAO.findById(maHD);

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
                hoaDonDAO.getChiTiet(maHD)
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
        String[] maSanPhams
                = request.getParameterValues(
                        "maSanPham"
                );

        String[] soLuongs
                = request.getParameterValues(
                        "soLuong"
                );

        if (maSanPhams == null
                || soLuongs == null
                || maSanPhams.length
                != soLuongs.length) {
            throw new IllegalArgumentException(
                    "Hóa đơn chưa có sản phẩm."
            );
        }

        List<ChiTietHoaDon> list
                = new ArrayList<>();

        for (int i = 0;
                i < maSanPhams.length;
                i++) {
            ChiTietHoaDon item
                    = new ChiTietHoaDon();

            item.setMaSanPham(
                    maSanPhams[i]
            );

            try {
                item.setSoLuong(
                        Integer.parseInt(
                                soLuongs[i]
                        )
                );

            } catch (Exception e) {
                throw new IllegalArgumentException(
                        "Số lượng sản phẩm không hợp lệ."
                );
            }

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

    private boolean checkLogin(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute(
                        "maNV"
                ) == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/LoginServlet"
            );

            return false;
        }

        return true;
    }
}
