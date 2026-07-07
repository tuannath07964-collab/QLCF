package controller;

import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.KhachHang;

@WebServlet("/khachhang")
public class khachhangServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Giả lập dữ liệu (Sau này bạn thay bằng kết nối DB)
        ArrayList<KhachHang> dsKH = new ArrayList<>();
        dsKH.add(new KhachHang("KH01", "Nguyễn Văn A", "0901234567"));
        dsKH.add(new KhachHang("KH02", "Trần Thị B", "0987654321"));

        request.setAttribute("listKH", dsKH);
        request.getRequestDispatcher("/views/khachhang.jsp").forward(request, response);
    }
}