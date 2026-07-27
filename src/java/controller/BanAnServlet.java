package controller;

import dao.BanAnDAO;
import dao.HoaDonDAO;
import model.BanAn;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/ban",
    "/ban/nhanban",
    "/ban/traban",
    "/ban/them"
})
public class BanAnServlet extends HttpServlet {

    private BanAnDAO banDAO;
    private HoaDonDAO hoaDonDAO;

    @Override
    public void init() throws ServletException {
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

        String action = request.getServletPath();

        try {
            switch (action) {
                case "/ban/nhanban":
                    nhanBan(request, response);
                    break;

                case "/ban/traban":
                    traBan(request, response);
                    break;

                case "/ban":
                default:
                    hienThiDanhSachBan(request, response);
                    break;
            }
        } catch (NumberFormatException ex) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Mã bàn không hợp lệ."
            );
        } catch (Exception ex) {
            ex.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Không thể xử lý bàn: " + ex.getMessage()
            );

            hienThiDanhSachBan(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getServletPath();

        try {
            if ("/ban/them".equals(action)) {
                themBan(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/ban");
            }
        } catch (NumberFormatException ex) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Số chỗ ngồi không hợp lệ."
            );
        } catch (Exception ex) {
            ex.printStackTrace();

            response.sendRedirect(
                    request.getContextPath() + "/ban?error=1"
            );
        }
    }

    private void hienThiDanhSachBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String khuVuc = request.getParameter("khu");

        List<BanAn> danhSachBan = banDAO.getAllBan(khuVuc);

        request.setAttribute("danhSachBan", danhSachBan);

        request.getRequestDispatcher("/views/ban.jsp")
                .forward(request, response);
    }

private void nhanBan(
        HttpServletRequest request,
        HttpServletResponse response
) throws Exception {

    HttpSession session = request.getSession(false);

    if (session == null
            || session.getAttribute("maNV") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/LoginServlet"
        );
        return;
    }

    String id = request.getParameter("id");

    if (id == null || id.isBlank()) {
        throw new IllegalArgumentException(
                "Thiếu mã bàn."
        );
    }

    int maBan = Integer.parseInt(id);

    String maNV = String.valueOf(
            session.getAttribute("maNV")
    );

    int maHD =
            hoaDonDAO.taoHoacLayHoaDonDangPhucVu(
                    maNV,
                    maBan
            );

    response.sendRedirect(
            request.getContextPath()
            + "/hoadon?action=edit&maHD="
            + maHD
    );
}

    private void themBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String tenBan = request.getParameter("tenBan");
        String soChoStr = request.getParameter("soCho");
        String khuVuc = request.getParameter("khuVuc");

        if (tenBan == null || tenBan.isBlank()
                || soChoStr == null || soChoStr.isBlank()
                || khuVuc == null || khuVuc.isBlank()) {

            response.sendRedirect(
                    request.getContextPath() + "/ban?error=missing"
            );
            return;
        }

        int soCho = Integer.parseInt(soChoStr);

        if (soCho <= 0) {
            response.sendRedirect(
                    request.getContextPath() + "/ban?error=soCho"
            );
            return;
        }

        BanAn banMoi = new BanAn(
                0,
                tenBan.trim(),
                soCho,
                khuVuc.trim(),
                0,
                null
        );

        banDAO.insertBan(banMoi);

        response.sendRedirect(request.getContextPath() + "/ban");
    }

    private void traBan(
        HttpServletRequest request,
        HttpServletResponse response
) throws IOException {

    String maBanStr = request.getParameter("id");

    if (maBanStr == null || maBanStr.isBlank()) {
        response.sendRedirect(
                request.getContextPath() + "/ban?error=missing"
        );
        return;
    }

    try {
        int maBan = Integer.parseInt(maBanStr);

        boolean updated = banDAO.traBan(maBan);

        if (!updated) {
            response.sendRedirect(
                    request.getContextPath() + "/ban?error=update"
            );
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/ban"
        );

    } catch (NumberFormatException ex) {
        response.sendRedirect(
                request.getContextPath() + "/ban?error=invalid"
        );
    }
}
    private void doiTrangThaiBan(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String maBanStr = request.getParameter("id");
        String trangThaiStr = request.getParameter("trangThai");

        if (maBanStr == null || maBanStr.isBlank()
                || trangThaiStr == null || trangThaiStr.isBlank()) {

            response.sendRedirect(
                    request.getContextPath() + "/ban"
            );
            return;
        }

        try {
            int maBan = Integer.parseInt(maBanStr);
            int trangThaiHienTai = Integer.parseInt(trangThaiStr);

            /*
         * Nếu bàn đang trống thì chuyển thành đang phục vụ.
             */
            if (trangThaiHienTai == 0) {

                boolean thanhCong = banDAO.capNhatTrangThai(
                        maBan,
                        1
                );

                if (!thanhCong) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/ban?error=update"
                    );
                    return;
                }

                /*
             * Sau khi nhận bàn thì chuyển sang trang hóa đơn.
                 */
                response.sendRedirect(
                        request.getContextPath() + "/hoadon"
                );
                return;
            }

            /*
         * Nếu bàn đang phục vụ thì trả bàn về trạng thái trống.
             */
            boolean thanhCong = banDAO.traBan(maBan);

            if (!thanhCong) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/ban?error=update"
                );
                return;
            }

            response.sendRedirect(
                    request.getContextPath() + "/ban"
            );

        } catch (NumberFormatException ex) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/ban?error=invalid"
            );
        }
    }
}
