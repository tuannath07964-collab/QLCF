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
    public void init()
            throws ServletException {

        hoaDonDAO =
                new HoaDonDAO();

        sanPhamDAO =
                new SanPhamDAO();

        khachHangDAO =
                new KhachHangDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!checkLogin(
                request,
                response
        )) {
            return;
        }

        String action =
                request.getParameter(
                        "action"
                );

        try {
            if ("create".equals(action)) {
                int maHD =
                        hoaDonDAO.taoHoaDon(
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

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
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

        if (!checkLogin(
                request,
                response
        )) {
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

            if ("pay".equals(action)) {
                Integer maVoucher =
                        parseNullableId(
                                request.getParameter(
                                        "maVoucher"
                                )
                        );

                hoaDonDAO.thanhToanHoaDon(
                        maHD,
                        request.getParameter(
                                "maKH"
                        ),
                        request.getParameter(
                                "tenKhachHang"
                        ),
                        request.getParameter(
                                "sdtKhachHang"
                        ),
                        "new".equals(
                                request.getParameter(
                                        "customerMode"
                                )
                        ),
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
                    request.getParameter(
                            "maKH"
                    ),
                    request.getParameter(
                            "tenKhachHang"
                    ),
                    request.getParameter(
                            "sdtKhachHang"
                    ),
                    items
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/hoadon?action=edit&id="
                    + maHD
                    + "&success=save"
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
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
            int index = 0;
            index < maSanPhams.length;
            index++
        ) {
            ChiTietHoaDon item =
                    new ChiTietHoaDon();

            item.setMaSanPham(
                    maSanPhams[index]
            );

            try {
                item.setSoLuong(
                        Integer.parseInt(
                                soLuongs[index]
                        )
                );

            } catch (Exception exception) {
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

        } catch (Exception exception) {
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

        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException(
                    "Mã voucher không hợp lệ."
            );
        }
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