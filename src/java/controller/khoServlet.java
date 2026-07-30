package controller;

import dao.khoDAO;
import model.NguyenLieu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/KhoServlet")
public class khoServlet extends HttpServlet {

    private khoDAO dao;

    @Override
    public void init()
            throws ServletException {

        dao = new khoDAO();
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
            if ("form".equals(action)) {

                String id =
                        request.getParameter("id");

                if (
                    id != null
                    && !id.isBlank()
                ) {
                    request.setAttribute(
                            "nguyenLieuEdit",
                            dao.findById(id)
                    );
                }

                request.setAttribute(
                        "showKhoModal",
                        true
                );
            }

            loadPage(
                    request,
                    response
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
            );

            loadPage(
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
                request.getParameter("action");

        try {
            if ("restock".equals(action)) {

                dao.nhapKhoCoDinh(
                        request.getParameter("id")
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/KhoServlet?success=restock"
                );

                return;
            }

            NguyenLieu nguyenLieu =
                    new NguyenLieu();

            nguyenLieu.setMaNguyenLieu(
                    request.getParameter(
                            "maNguyenLieu"
                    )
            );

            nguyenLieu.setTenNguyenLieu(
                    request.getParameter(
                            "tenNguyenLieu"
                    )
            );

            nguyenLieu.setDonVi(
                    request.getParameter(
                            "donVi"
                    )
            );

            try {
                nguyenLieu.setSoLuongTon(
                        Integer.parseInt(
                                request.getParameter(
                                        "soLuongTon"
                                )
                        )
                );

                nguyenLieu.setMucNhapCoDinh(
                        Integer.parseInt(
                                request.getParameter(
                                        "mucNhapCoDinh"
                                )
                        )
                );

            } catch (NumberFormatException exception) {
                throw new IllegalArgumentException(
                        "Số lượng kho không hợp lệ."
                );
            }

            nguyenLieu.setTrangThai(
                    request.getParameter(
                            "trangThai"
                    ) != null
            );

            boolean edit =
                    "edit".equals(
                            request.getParameter(
                                    "mode"
                            )
                    );

            if (edit) {
                dao.update(nguyenLieu);

            } else {
                dao.insert(nguyenLieu);
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/KhoServlet?success=save"
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
            );

            request.setAttribute(
                    "showKhoModal",
                    true
            );

            loadPage(
                    request,
                    response
            );
        }
    }

    private void loadPage(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "nguyenLieuList",
                dao.getAll()
        );

        request.setAttribute(
                "donViList",
                dao.getDonViChoPhep()
        );

        request.getRequestDispatcher(
                "/views/kho.jsp"
        ).forward(
                request,
                response
        );
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