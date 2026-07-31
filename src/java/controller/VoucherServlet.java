package controller;

import dao.VoucherDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/khachhang/voucher")
public class VoucherServlet extends HttpServlet {

    private VoucherDAO voucherDAO;

    @Override
    public void init()
            throws ServletException {
        voucherDAO =
                new VoucherDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {
        if (!checkLogin(request, response)) {
            return;
        }

        String maKH =
                request.getParameter("maKH");

        if (
            maKH == null
            || maKH.isBlank()
        ) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/khachhang"
            );

            return;
        }

        try {
            loadPage(
                    request,
                    response,
                    maKH
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
            );

            request.getRequestDispatcher(
                    "/views/doivoucher.jsp"
            ).forward(
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

        String maKH =
                request.getParameter("maKH");

        try {
            voucherDAO.doiVoucher(
                    maKH,
                    parseQuantity(
                            request.getParameter(
                                    "soLuong10"
                            )
                    ),
                    parseQuantity(
                            request.getParameter(
                                    "soLuong20"
                            )
                    ),
                    parseQuantity(
                            request.getParameter(
                                    "soLuong30"
                            )
                    ),
                    parseQuantity(
                            request.getParameter(
                                    "soLuong40"
                            )
                    ),
                    parseQuantity(
                            request.getParameter(
                                    "soLuong50"
                            )
                    )
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/khachhang/voucher"
                    + "?maKH="
                    + maKH
                    + "&success=exchange"
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
            );

            loadPage(
                    request,
                    response,
                    maKH
            );
        }
    }

    private void loadPage(
            HttpServletRequest request,
            HttpServletResponse response,
            String maKH
    ) throws ServletException, IOException {
        request.setAttribute(
                "maKH",
                maKH
        );

        request.setAttribute(
                "tenKhachHang",
                voucherDAO.getTenKhachHang(
                        maKH
                )
        );

        request.setAttribute(
                "diemHienTai",
                voucherDAO.getDiemKhachHang(
                        maKH
                )
        );

        request.setAttribute(
                "voucherList",
                voucherDAO
                        .getVoucherByKhachHang(
                                maKH
                        )
        );

        request.getRequestDispatcher(
                "/views/doivoucher.jsp"
        ).forward(
                request,
                response
        );
    }

    private int parseQuantity(
            String value
    ) {
        if (
            value == null
            || value.isBlank()
        ) {
            return 0;
        }

        try {
            return Integer.parseInt(value);

        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException(
                    "Số lượng voucher không hợp lệ."
            );
        }
    }

    private boolean checkLogin(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        HttpSession session =
                request.getSession(false);

        if (
            session == null
            || session.getAttribute("maNV") == null
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