package controller;

import dao.ThongKeDAO;
import dao.ThongKeDAO.TongQuanDoanhThu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/ThongKeServlet")
public class ThongKeServlet
        extends HttpServlet {

    private ThongKeDAO thongKeDAO;

    @Override
    public void init()
            throws ServletException {

        thongKeDAO =
                new ThongKeDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding(
                "UTF-8"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

        response.setContentType(
                "text/html; charset=UTF-8"
        );

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

            return;
        }

        if (
            !"Quản lý".equals(
                    session.getAttribute(
                            "chucVu"
                    )
            )
        ) {
            response.sendError(
                    HttpServletResponse
                        .SC_FORBIDDEN,
                    "Chỉ quản lý được xem "
                    + "thống kê doanh thu."
            );

            return;
        }

        try {
            LocalDate homNay =
                    LocalDate.now();

            LocalDate tuNgay =
                    parseDate(
                        request.getParameter(
                                "tuNgay"
                        ),
                        homNay.withDayOfMonth(1)
                    );

            LocalDate denNgay =
                    parseDate(
                        request.getParameter(
                                "denNgay"
                        ),
                        homNay
                    );

            if (tuNgay.isAfter(denNgay)) {
                throw new IllegalArgumentException(
                        "Ngày bắt đầu không được "
                        + "lớn hơn ngày kết thúc."
                );
            }

            /*
             * Giới hạn tối đa 1 năm để tránh
             * tải quá nhiều dữ liệu lên giao diện.
             */
            if (
                tuNgay.plusYears(1)
                    .isBefore(denNgay)
            ) {
                throw new IllegalArgumentException(
                        "Khoảng thời gian thống kê "
                        + "không được vượt quá 1 năm."
                );
            }

            TongQuanDoanhThu tongQuan =
                    thongKeDAO.getTongQuan(
                            tuNgay,
                            denNgay
                    );

            request.setAttribute(
                    "tuNgay",
                    tuNgay.toString()
            );

            request.setAttribute(
                    "denNgay",
                    denNgay.toString()
            );

            request.setAttribute(
                    "dsThongKe",
                    thongKeDAO
                        .getHoaDonDaThanhToan(
                            tuNgay,
                            denNgay
                        )
            );

            request.setAttribute(
                    "dsDoanhThuNgay",
                    thongKeDAO
                        .getDoanhThuTheoNgay(
                            tuNgay,
                            denNgay
                        )
            );

            request.setAttribute(
                    "soHoaDon",
                    tongQuan.getSoHoaDon()
            );

            request.setAttribute(
                    "tongDoanhThu",
                    tongQuan.getTongDoanhThu()
            );

            request.setAttribute(
                    "doanhThuTienMat",
                    tongQuan
                        .getDoanhThuTienMat()
            );

            request.setAttribute(
                    "doanhThuKhac",
                    tongQuan.getDoanhThuKhac()
            );

            request.setAttribute(
                    "doanhThuMangVe",
                    tongQuan
                        .getDoanhThuMangVe()
            );

            request.setAttribute(
                    "doanhThuTaiBan",
                    tongQuan
                        .getDoanhThuTaiBan()
            );

        } catch (
            IllegalArgumentException
            | DateTimeParseException e
        ) {
            request.setAttribute(
                    "errorMessage",
                    e.getMessage() == null
                    ? "Khoảng ngày không hợp lệ."
                    : e.getMessage()
            );

            ganDuLieuRong(request);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Không tải được thống kê: "
                    + e.getMessage()
            );

            ganDuLieuRong(request);
        }

        request.getRequestDispatcher(
                "/views/ThongKeDoanhThu.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        doGet(request, response);
    }

    private LocalDate parseDate(
            String value,
            LocalDate defaultValue
    ) {
        if (
            value == null
            || value.isBlank()
        ) {
            return defaultValue;
        }

        return LocalDate.parse(
                value.trim()
        );
    }

    private void ganDuLieuRong(
            HttpServletRequest request
    ) {
        request.setAttribute(
                "dsThongKe",
                java.util.Collections
                    .emptyList()
        );

        request.setAttribute(
                "dsDoanhThuNgay",
                java.util.Collections
                    .emptyList()
        );

        request.setAttribute(
                "soHoaDon",
                0
        );

        request.setAttribute(
                "tongDoanhThu",
                java.math.BigDecimal.ZERO
        );

        request.setAttribute(
                "doanhThuTienMat",
                java.math.BigDecimal.ZERO
        );

        request.setAttribute(
                "doanhThuKhac",
                java.math.BigDecimal.ZERO
        );

        request.setAttribute(
                "doanhThuMangVe",
                java.math.BigDecimal.ZERO
        );

        request.setAttribute(
                "doanhThuTaiBan",
                java.math.BigDecimal.ZERO
        );
    }
}