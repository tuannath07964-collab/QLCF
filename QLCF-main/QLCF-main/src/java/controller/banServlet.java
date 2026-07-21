package controller;

import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.BanAn;

@WebServlet("/ban")
public class banServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<BanAn> ds = new ArrayList<>();

        ds.add(new BanAn("B01", "Bàn 1", "Đang phục vụ"));
        ds.add(new BanAn("B02", "Bàn 2", "Đã phục vụ"));
        ds.add(new BanAn("B03", "Bàn 3", "Trống"));
        ds.add(new BanAn("B04", "Bàn 4", "Đang phục vụ"));

        request.setAttribute("listBan", ds);

        request.getRequestDispatcher("/views/ban1.jsp")
                .forward(request,response);

    }

}