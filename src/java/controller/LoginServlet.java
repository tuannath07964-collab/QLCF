package controller;

import dao.NhanVienDAO;
import model.NhanVien;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

@WebServlet(
        name = "LoginServlet",
        urlPatterns = {
            "/LoginServlet",
            "/login"
        }
)
public class LoginServlet extends HttpServlet {

    private NhanVienDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new NhanVienDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher(
                "/views/loginform.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String maNV =
                request.getParameter("maNV");

        String matKhau =
                request.getParameter("matKhau");

        try {
            NhanVien nv =
                    dao.checkLogin(
                            maNV,
                            matKhau
                    );

            if (nv == null) {
                hienThiLoi(
                        request,
                        response,
                        "Sai mã nhân viên hoặc mật khẩu!"
                );
                return;
            }

            if (!nv.isDangLam()) {
                hienThiLoi(
                        request,
                        response,
                        "Tài khoản đang ở trạng thái \""
                        + nv.getTrangThai()
                        + "\", không thể đăng nhập."
                );
                return;
            }

            /*
             * Quản lý được đăng nhập bất kỳ thời điểm nào.
             * Nhân viên bắt buộc phải có ca và đăng nhập
             * trong đúng giờ làm.
             */
            if (!nv.isQuanLy()) {

                if (!nv.isCoCaLam()) {
                    hienThiLoi(
                            request,
                            response,
                            "Bạn chưa được phân ca nên "
                            + "chưa thể đăng nhập."
                    );
                    return;
                }

                if (!dangTrongGioLam(nv)) {
                    hienThiLoi(
                            request,
                            response,
                            "Chưa đến giờ làm. Ca của bạn: "
                            + rutGonGio(
                                nv.getGioBatDau()
                            )
                            + " - "
                            + rutGonGio(
                                nv.getGioKetThuc()
                            )
                    );
                    return;
                }
            }

            HttpSession session =
                    request.getSession(true);

            session.setAttribute(
                    "acc",
                    nv
            );

            session.setAttribute(
                    "maNV",
                    nv.getMaNV()
            );

            session.setAttribute(
                    "tenNV",
                    nv.getHoTen()
            );

            session.setAttribute(
                    "chucVu",
                    nv.getChucVu()
            );

            session.setAttribute(
                    "trangThaiNV",
                    nv.getTrangThai()
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/views/homepage.jsp"
            );

        } catch (Exception e) {
            e.printStackTrace();

            hienThiLoi(
                    request,
                    response,
                    "Không thể đăng nhập: "
                    + e.getMessage()
            );
        }
    }

    private boolean dangTrongGioLam(
            NhanVien nv
    ) {
        try {
            LocalTime batDau =
                    LocalTime.parse(
                            nv.getGioBatDau()
                    );

            LocalTime ketThuc =
                    LocalTime.parse(
                            nv.getGioKetThuc()
                    );

            LocalTime hienTai =
                    LocalTime.now();

            if (batDau.equals(ketThuc)) {
                return false;
            }

            /*
             * Ca trong cùng một ngày,
             * ví dụ 08:00 - 17:00.
             */
            if (ketThuc.isAfter(batDau)) {
                return !hienTai.isBefore(batDau)
                        && !hienTai.isAfter(ketThuc);
            }

            /*
             * Ca qua nửa đêm,
             * ví dụ 22:00 - 06:00.
             */
            return !hienTai.isBefore(batDau)
                    || !hienTai.isAfter(ketThuc);

        } catch (DateTimeParseException e) {
            return false;
        }
    }

    private String rutGonGio(
            String value
    ) {
        if (
            value == null
            || value.length() < 5
        ) {
            return "--:--";
        }

        return value.substring(0, 5);
    }

    private void hienThiLoi(
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
        ).forward(request, response);
    }
}