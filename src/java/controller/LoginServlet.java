package controller;

import dao.TaiKhoanDAO;
import model.TaiKhoan;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(
        urlPatterns = {
            "/LoginServlet",
            "/login"
        }
)
public class LoginServlet
        extends HttpServlet {

    private TaiKhoanDAO dao;

    @Override
    public void init()
            throws ServletException {

        dao = new TaiKhoanDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher(
                "/views/loginform.jsp"
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

        request.setCharacterEncoding(
                "UTF-8"
        );

        String maTaiKhoan =
                request.getParameter(
                        "maNV"
                );

        String matKhau =
                request.getParameter(
                        "matKhau"
                );

        try {
            TaiKhoan taiKhoan =
                    dao.checkLogin(
                            maTaiKhoan,
                            matKhau
                    );

            if (taiKhoan == null) {
                showError(
                        request,
                        response,
                        "Sai mã tài khoản hoặc mật khẩu."
                );

                return;
            }

            if (!taiKhoan.isTrangThai()) {
                showError(
                        request,
                        response,
                        "Tài khoản đã bị khóa."
                );

                return;
            }

            HttpSession session =
                    request.getSession(true);

            session.setAttribute(
                    "acc",
                    taiKhoan
            );

            session.setAttribute(
                    "maNV",
                    taiKhoan.getMaTaiKhoan()
            );

            session.setAttribute(
                    "tenNV",
                    taiKhoan.getHoTen()
            );

            session.setAttribute(
                    "chucVu",
                    taiKhoan.getVaiTro()
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/homepage"
            );

        } catch (Exception e) {
            e.printStackTrace();

            showError(
                    request,
                    response,
                    "Không thể đăng nhập: "
                    + e.getMessage()
            );
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message
    ) throws ServletException, IOException {

        request.setAttribute(
                "error",
                message
        );

        request.getRequestDispatcher(
                "/views/loginform.jsp"
        ).forward(
                request,
                response
        );
    }
}