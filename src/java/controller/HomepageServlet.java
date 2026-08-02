package controller;

import dao.HomepageDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/homepage")
public class HomepageServlet
        extends HttpServlet {

    private HomepageDAO homepageDAO;

    @Override
    public void init()
            throws ServletException {

        homepageDAO =
                new HomepageDAO();
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

        try {
            request.setAttribute(
                    "tongQuan",
                    homepageDAO.getSummary()
            );

            request.setAttribute(
                    "hoaDonHomNay",
                    homepageDAO.getHoaDonHomNay()
            );

            request.setAttribute(
                    "bieuDoHoaDonHomNay",
                    homepageDAO
                            .getBieuDoHoaDonHomNay()
            );

            request.setAttribute(
                    "donChoThanhToan",
                    homepageDAO
                            .getDonChoThanhToan()
            );

            request.setAttribute(
                    "nguyenLieuCanNhap",
                    homepageDAO
                            .getNguyenLieuCanNhap()
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
            );
        }

        request.getRequestDispatcher(
                "/views/homepage.jsp"
        ).forward(
                request,
                response
        );
    }
}