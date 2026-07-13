package controller;

import dao.BanAnDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.BanAn;

@WebServlet(name = "BanAnServlet", urlPatterns = {"/ban"})
public class banServlet extends HttpServlet {

    private BanAnDAO dao = new BanAnDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                request.getRequestDispatcher("/views/ban2.jsp").forward(request, response);
                break;

            case "edit":
                String maBanEdit = request.getParameter("maBan");
                BanAn ban = dao.findById(maBanEdit);
                request.setAttribute("ban", ban);
                request.getRequestDispatcher("/views/ban2.jsp").forward(request, response);
                break;

            case "delete":
                String maBanDelete = request.getParameter("maBan");
                dao.delete(maBanDelete);
                response.sendRedirect("ban");
                break;

            default:
                ArrayList<BanAn> list = dao.getAll();
                request.setAttribute("listBan", list);
                request.getRequestDispatcher("/views/ban1.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        String maBan = request.getParameter("maBan");
        String tenBan = request.getParameter("tenBan");
        String trangThai = request.getParameter("trangThai");

        if ("insert".equals(action)) {
            BanAn ban = new BanAn(maBan, tenBan, trangThai);
            dao.insert(ban);
        } 
        
        else if ("update".equals(action)) {
            BanAn ban = new BanAn(maBan, tenBan, trangThai);
            dao.update(ban);
        } 
        
        else if ("updateStatus".equals(action)) {
            dao.updateStatus(maBan, trangThai);
        }

        response.sendRedirect("ban");
    }
}