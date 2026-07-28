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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(
        urlPatterns = {
            "/ban",
            "/ban/nhanban",
            "/ban/traban"
        }
)
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

        if (!daDangNhap(request, response)) {
            return;
        }

        try {
            switch (request.getServletPath()) {
                case "/ban/nhanban" ->
                    nhanBan(
                            request,
                            response
                    );

                case "/ban/traban" ->
                    moHoaDonDeTraBan(
                            request,
                            response
                    );

                default ->
                    hienThiDanhSachBan(
                            request,
                            response
                    );
            }

        } catch (Exception e) {
            e.printStackTrace();

            throw new ServletException(
                    "Lỗi khi mở trang quản lý bàn.",
                    e
            );
        }
    }

    private void hienThiDanhSachBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        java.util.List<model.BanAn> danhSach
                = banDAO.getAllBan(
                        request.getParameter("khu")
                );

        System.out.println(
                "SỐ BÀN LẤY ĐƯỢC: "
                + danhSach.size()
        );

        request.setAttribute(
                "danhSachBan",
                danhSach
        );

        /*
     * Giữ tạm attribute cũ để tránh JSP cũ
     * hoặc thành phần khác vẫn dùng listBan.
         */
        request.setAttribute(
                "listBan",
                danhSach
        );

        request.getRequestDispatcher(
                "/views/ban.jsp"
        ).forward(request, response);
    }

    private void nhanBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("maNV")
                == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/LoginServlet"
            );
            return;
        }

        String id
                = request.getParameter("id");

        if (id == null
                || id.isBlank()) {
            throw new IllegalArgumentException(
                    "Thiếu mã bàn cần nhận."
            );
        }

        int maBan;

        try {
            maBan
                    = Integer.parseInt(id);

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Mã bàn không hợp lệ."
            );
        }

        String maNV
                = String.valueOf(
                        session.getAttribute(
                                "maNV"
                        )
                );

        int maHD
                = hoaDonDAO
                        .taoHoacLayHoaDonDangPhucVu(
                                maNV,
                                maBan
                        );

        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=edit"
                + "&maHD="
                + maHD
        );
    }

    private void moHoaDonDeTraBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String id
                = request.getParameter("id");

        if (id == null
                || id.isBlank()) {
            throw new IllegalArgumentException(
                    "Thiếu mã bàn cần trả."
            );
        }

        int maBan;

        try {
            maBan
                    = Integer.parseInt(id);

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Mã bàn không hợp lệ."
            );
        }

        Integer maHD
                = hoaDonDAO
                        .getMaHoaDonDangPhucVuTheoBan(
                                maBan
                        );

        if (maHD == null) {
            throw new IllegalStateException(
                    "Bàn chưa có hóa đơn đang "
                    + "phục vụ nên chưa thể trả bàn."
            );
        }

        /*
         * Không chuyển trạng thái bàn tại đây.
         * Khi bấm Trả bàn, hệ thống chỉ mở hóa đơn.
         * Bàn chỉ về Trống sau khi:
         * - Thanh toán thành công; hoặc
         * - Hủy hóa đơn thành công.
         */
        response.sendRedirect(
                request.getContextPath()
                + "/hoadon?action=edit"
                + "&maHD="
                + maHD
                + "&returnTable=1"
        );
    }

    private boolean daDangNhap(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("maNV")
                == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/LoginServlet"
            );

            return false;
        }

        return true;
    }
}
