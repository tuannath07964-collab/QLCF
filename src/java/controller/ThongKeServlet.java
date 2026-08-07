package controller;

import dao.ThongKeDAO;

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
public class ThongKeServlet extends HttpServlet {

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

            return;
        }

        LocalDate denNgay =
                LocalDate.now();

        LocalDate tuNgay =
                denNgay.minusDays(6);

        try {
            String tuNgayParam =
                    request.getParameter("tuNgay");

            String denNgayParam =
                    request.getParameter("denNgay");

            if (
                tuNgayParam != null
                && !tuNgayParam.isBlank()
            ) {
                tuNgay =
                        LocalDate.parse(
                                tuNgayParam
                        );
            }

            if (
                denNgayParam != null
                && !denNgayParam.isBlank()
            ) {
                denNgay =
                        LocalDate.parse(
                                denNgayParam
                        );
            }

            if (tuNgay.isAfter(denNgay)) {
                throw new IllegalArgumentException(
                        "Ngày bắt đầu không được sau ngày kết thúc."
                );
            }

            request.setAttribute(
                    "tongQuan",
                    thongKeDAO.getTongQuan(
                            tuNgay,
                            denNgay
                    )
            );

            request.setAttribute(
                    "doanhThuNgayList",
                    thongKeDAO.getDoanhThuTheoNgay(
                            tuNgay,
                            denNgay
                    )
            );

            request.setAttribute(
                    "topSanPhamList",
                    thongKeDAO.getTopSanPham(
                            tuNgay,
                            denNgay
                    )
            );

            request.setAttribute(
                    "hoaDonThongKeList",
                    thongKeDAO.getDanhSachHoaDon(
                            tuNgay,
                            denNgay
                    )
            );

        } catch (
            DateTimeParseException
            | IllegalArgumentException exception
        ) {
            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Không tải được dữ liệu thống kê: "
                    + exception.getMessage()
            );
        }

        request.setAttribute(
                "tuNgay",
                tuNgay.toString()
        );

        request.setAttribute(
                "denNgay",
                denNgay.toString()
        );

        request.getRequestDispatcher(
                "/views/ThongKeDoanhThu.jsp"
        ).forward(
                request,
                response
        );
    }
}