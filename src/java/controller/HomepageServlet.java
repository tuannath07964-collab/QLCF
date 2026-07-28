package controller;

import dao.HomepageDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import java.util.Collections;

@WebServlet(
        name = "HomepageServlet",
        urlPatterns = {
            "/homepage"
        }
)
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

        request.setCharacterEncoding(
                "UTF-8"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

        response.setContentType(
                "text/html; charset=UTF-8"
        );

        response.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate"
        );

        response.setHeader(
                "Pragma",
                "no-cache"
        );

        response.setDateHeader(
                "Expires",
                0
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

        /*
         * Dùng để homepage.jsp biết rằng
         * trang đã được đi qua servlet.
         */
        request.setAttribute(
                "homepageLoaded",
                true
        );

        String maNV =
                String.valueOf(
                    session.getAttribute(
                            "maNV"
                    )
                );

        try {
            request.setAttribute(
                    "tongQuan",
                    homepageDAO
                        .getTongQuan()
            );

            request.setAttribute(
                    "danhSachBanTrangChu",
                    homepageDAO
                        .getDanhSachBan()
            );

            request.setAttribute(
                    "donDangXuLy",
                    homepageDAO
                        .getDonDangXuLy()
            );

            request.setAttribute(
                    "canhBaoKho",
                    homepageDAO
                        .getCanhBaoKho()
            );

            request.setAttribute(
                    "caLamHienTai",
                    homepageDAO
                        .getCaLamHienTai(
                            maNV
                        )
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",

                    "Không tải được đầy đủ dữ liệu trang chủ: "
                    + (
                        e.getMessage() == null
                        ? "Lỗi không xác định."
                        : e.getMessage()
                    )
            );

            request.setAttribute(
                    "tongQuan",
                    new HomepageDAO
                        .TongQuan()
            );

            request.setAttribute(
                    "danhSachBanTrangChu",
                    Collections.emptyList()
            );

            request.setAttribute(
                    "donDangXuLy",
                    Collections.emptyList()
            );

            request.setAttribute(
                    "canhBaoKho",
                    Collections.emptyList()
            );

            request.setAttribute(
                    "caLamHienTai",
                    new HomepageDAO
                        .CaLamHienTai()
            );
        }

        request.getRequestDispatcher(
                "/views/homepage.jsp"
        ).forward(
                request,
                response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        doGet(
                request,
                response
        );
    }
}