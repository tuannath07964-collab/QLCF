package controller;

import dao.BanAnDAO;
import model.BanAn;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/ban", "/ban/nhanban", "/ban/them"})
public class BanAnServlet extends HttpServlet {

    private BanAnDAO banDAO;

    @Override
    public void init() throws ServletException {
        banDAO = new BanAnDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        try {
            switch (action) {
                case "/ban/nhanban":
                    nhanBan(request, response);
                    break;
                case "/ban":
                default:
                    hienThiDanhSachBan(request, response);
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getServletPath();

        if ("/ban/them".equals(action)) {
            themBan(request, response);
        }
    }

    // --- CÁC HÀM XỬ LÝ (CHỈ NHẬN REQUEST VÀ GỌI DAO) ---

    private void hienThiDanhSachBan(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String khuVuc = request.getParameter("khu");
        List<BanAn> danhSachBan = banDAO.getAllBan(khuVuc);
        request.setAttribute("danhSachBan", danhSachBan);
        request.getRequestDispatcher("/views/ban.jsp").forward(request, response);
    }

    // Hàm này xử lý chức năng Nhận Bàn từ request của JSP
    private void nhanBan(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String maBanStr = request.getParameter("id");
        
        if (maBanStr != null && !maBanStr.isEmpty()) {
            int maBan = Integer.parseInt(maBanStr);
            // Tạo mã hóa đơn giả lập
            String maDonHangMoi = "HD" + (System.currentTimeMillis() % 10000);
            
            // Gọi DAO để update CSDL
            banDAO.nhanBan(maBan, maDonHangMoi);
        }
        // Load lại trang Bàn
        response.sendRedirect(request.getContextPath() + "/ban");
    }

    // Hàm này xử lý chức năng Thêm Bàn từ request của Form Modal
    private void themBan(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String tenBan = request.getParameter("tenBan");
        String soChoStr = request.getParameter("soCho");
        String khuVuc = request.getParameter("khuVuc");

        if (tenBan != null && soChoStr != null && khuVuc != null) {
            int soCho = Integer.parseInt(soChoStr);
            BanAn banMoi = new BanAn(0, tenBan, soCho, khuVuc, 0, null);
            
            // Gọi DAO để insert vào CSDL
            banDAO.insertBan(banMoi);
        }
        // Load lại trang Bàn
        response.sendRedirect(request.getContextPath() + "/ban");
    }
}