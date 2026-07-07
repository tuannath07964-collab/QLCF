package controller;

import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.NguyenLieu;

@WebServlet("/KhoServlet")
public class khoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<NguyenLieu> ds = new ArrayList<>();

        ds.add(new NguyenLieu("NL01","Cà phê",30,"Kg"));
        ds.add(new NguyenLieu("NL02","Sữa",20,"Hộp"));
        ds.add(new NguyenLieu("NL03","Đường",15,"Kg"));
        ds.add(new NguyenLieu("NL04","Trà",12,"Kg"));

        request.setAttribute("dsKho", ds);

        request.getRequestDispatcher("/views/kho.jsp")
                .forward(request,response);

    }

}