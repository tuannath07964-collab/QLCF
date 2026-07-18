<%-- 
    Document   : UI
    Created on : 26 thg 6, 2026, 20:31:29
    Author     : trung
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String maNV = (String) session.getAttribute("maNV");
    String tenNV = (String) session.getAttribute("tenNV");

    if (maNV == null) {
        response.sendRedirect(request.getContextPath() + "/loginform.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Quán Cafe</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homepage.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <aside class="sidebar">
            <div class="logo">
                <i class="fa-solid fa-mug-hot"></i> 
                <span class="logo-text">QUẢN LÝ QUÁN CAFE</span>
                <button id="toggleBtn"><i class="fa-solid fa-bars"></i></button>
            </div>
            <ul class="menu">
                <li class="active" onclick="location.href = '${pageContext.request.contextPath}/UI.jsp'"><i class="fa-solid fa-house"></i> <span>Trang chủ</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/nhanvien'"><i class="fa-solid fa-user"></i> <span>Nhân viên</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/hoadon'"><i class="fa-solid fa-file-invoice-dollar"></i> <span>Hóa đơn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/menu'"><i class="fa-solid fa-mug-saucer"></i> <span>Menu</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ban'"><i class="fa-solid fa-chair"></i> <span>Bàn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'"><i class="fa-solid fa-box"></i> <span>Kho</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/khachhang'"><i class="fa-solid fa-users"></i> <span>Khách hàng</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'"><i class="fa-solid fa-chart-column"></i> <span>Thống kê</span></li>
            </ul>
            <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span></a>
        </aside>

        <div class="content">
            <!-- Đã sửa: Xóa thẻ topbar lồng nhau, giữ lại 1 thẻ duy nhất -->
            <div class="topbar">
                <div class="user"><i class="fa-solid fa-circle-user"></i> <%= maNV %> - <%= tenNV %></div>
            </div>

            <div class="container">
                <h1>Xin chào, <%= tenNV %></h1>
                <div class="stats-row">
                    <div class="stat-card"><h3>Doanh thu hôm nay</h3><p>5.200.000đ</p></div>
                    <div class="stat-card"><h3>Doanh thu tháng</h3><p>125.000.000đ</p></div>
                    <div class="stat-card"><h3>Doanh thu năm</h3><p>1.200.000.000đ</p></div>
                    <div class="stat-card"><h3>Đơn hôm nay</h3><p>45</p></div>
                </div>

                <div class="stats-row">
                    <div class="stat-card"><h3>Bàn đang dùng</h3><p>12/20</p></div>
                    <div class="stat-card"><h3>Đơn chờ pha</h3><p>5</p></div>
                    <div class="stat-card"><h3>Nhân viên online</h3><p>8</p></div>
                    <div class="stat-card alert"><h3>Nguyên liệu sắp hết</h3><p>3 loại</p></div>
                </div>

                <div class="dashboard-grid">
                    <div class="chart-container">
                        <h3>Biểu đồ doanh thu</h3>
                        <canvas id="revenueChart"></canvas>
                    </div>
                    <div class="top-drinks">
                        <h3>Top 5 đồ uống bán chạy</h3>
                        <ul>
                            <li>1. Cafe Sữa đá</li>
                            <li>2. Trà đào cam sả</li>
                            <li>3. Matcha Latte</li>
                            <li>4. Bạc xỉu</li>
                            <li>5. Cacao nóng</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/js/homepage.js"></script>
    </body>
</html>