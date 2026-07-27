package controller;

import dao.BanAnDAO;
import dao.HoaDonDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {
    "/ban",
    "/ban/nhanban",
    "/ban/traban"
})
public class BanAnServlet
        extends HttpServlet {

    private BanAnDAO banDAO;
    private HoaDonDAO hoaDonDAO;

    @Override
    public void init()
            throws ServletException {

        banDAO = new BanAnDAO();
        hoaDonDAO = new HoaDonDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            switch (request.getServletPath()) {
                case "/ban/nhanban" ->
                    nhanBan(request, response);

                case "/ban/traban" ->
                    traBan(request, response);

                default ->
                    hienThiDanhSachBan(
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

            hienThiDanhSachBan(
                    request,
                    response
            );
        }
    }

    private void hienThiDanhSachBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "danhSachBan",
                banDAO.getAllBan(
                        request.getParameter("khu")
                )
        );

        request.getRequestDispatcher(
                "/views/ban.jsp"
        ).forward(request, response);
    }

    private void nhanBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

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

        int maBan = Integer.parseInt(
                request.getParameter("id")
        );

        String maNV = String.valueOf(
                session.getAttribute("maNV")
        );

        int maHD =
                hoaDonDAO
                    .taoHoacLayHoaDonDangPhucVu(
                            maNV,
                            maBan
                    );

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=edit&maHD="
                + maHD
        );
    }

    private void traBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        int maBan = Integer.parseInt(
                request.getParameter("id")
        );

        banDAO.traBan(maBan);

        response.sendRedirect(
                request.getContextPath()
                + "/ban"
        );
    }
}