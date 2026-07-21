<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    String maNV = (String) session.getAttribute("maNV");
    String tenNV = (String) session.getAttribute("tenNV");
    if(maNV == null){
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
        <style>
            /* CSS Reset & Cơ bản */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            body {
                display: flex;
                height: 100vh;
                background-color: #fcf9f5; /* Màu nền be sáng */
                color: #333;
            }

            /* --- SIDEBAR --- */
            .sidebar {
                width: 250px;
                background-color: #4a3b32; /* Màu nâu đậm */
                color: #fff;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }
            .sidebar-header {
                padding: 20px;
                font-size: 16px;
                font-weight: bold;
                display: flex;
                align-items: center;
                gap: 10px;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                white-space: nowrap;
            }
            .menu-list {
                list-style: none;
                flex-grow: 1;
                padding-top: 10px;
                overflow-y: auto;
            }
            .menu-item {
                padding: 15px 20px;
                display: flex;
                align-items: center;
                gap: 15px;
                cursor: pointer;
                transition: 0.3s;
                color: #d1c9c4;
            }
            .menu-item:hover, .menu-item.active {
                background-color: #6a574b;
                color: #fff;
            }
            .menu-item.active {
                border-left: 4px solid #fff;
            }
            .menu-item i {
                width: 20px;
                text-align: center;
            }
            .logout-btn {
                padding: 20px;
                display: flex;
                align-items: center;
                gap: 15px;
                cursor: pointer;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
                color: #d1c9c4;
                text-decoration: none;
            }
            .logout-btn:hover {
                color: #fff;
            }

            /* --- MAIN CONTENT --- */
            .main-content {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                overflow-y: auto;
            }

            /* Topbar */
            .topbar {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                padding: 15px 30px;
                background-color: #fcf9f5;
                border-bottom: 1px solid #eae5df;
            }
            .user-info {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-right: 20px;
                font-weight: 500;
            }
            .user-info i {
                font-size: 20px;
                color: #4a3b32;
            }
            .notification {
                position: relative;
                cursor: pointer;
            }
            .notification i {
                font-size: 20px;
                color: #4a3b32;
            }
            .badge {
                position: absolute;
                top: -5px;
                right: -8px;
                background-color: #e74c3c;
                color: white;
                font-size: 10px;
                padding: 2px 6px;
                border-radius: 50%;
            }

            /* Welcome Section */
            .welcome-section {
                padding: 30px;
            }
            .welcome-section h1 {
                font-size: 24px;
                color: #333;
                margin-bottom: 5px;
            }
            .welcome-section p {
                color: #666;
            }

            /* Cards Grid */
            .cards-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                gap: 20px;
                padding: 0 30px 30px 30px;
            }
            .card {
                background-color: #fff;
                padding: 30px 20px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                text-align: center;
                cursor: pointer;
                transition: transform 0.2s, box-shadow 0.2s;
                border: 1px solid #f0ebe4;
            }
            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            }
            .card-icon {
                width: 70px;
                height: 70px;
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 0 auto 15px auto;
                font-size: 30px;
            }
            .card h3 {
                font-size: 16px;
                margin-bottom: 10px;
                color: #222;
            }
            .card p {
                font-size: 13px;
                color: #777;
                line-height: 1.4;
            }

            /* Màu sắc riêng cho từng Icon nền */
            .bg-blue {
                background-color: #eef2fa;
                color: #4b7bec;
            }
            .bg-green {
                background-color: #ebf5ee;
                color: #20bf6b;
            }
            .bg-orange {
                background-color: #fdf3e8;
                color: #fa8231;
            }
            .bg-purple {
                background-color: #f4f0fa;
                color: #8854d0;
            }
            .bg-brown {
                background-color: #f7f1eb;
                color: #a55eea;
            } /* Dùng màu tím nhạt thay thế nếu cần */
            .bg-teal {
                background-color: #ebf7f6;
                color: #0fb9b1;
            }
            .bg-pink {
                background-color: #faedf0;
                color: #fc5c65;
            }

        </style>
    </head>
    <body>

        <aside class="sidebar">
            <div>
                <div class="sidebar-header">
                    <i class="fa-solid fa-mug-hot"></i> QUẢN LÝ QUÁN CAFE
                </div>
                <ul class="menu-list">
                    <li class="menu-item active"><i class="fa-solid fa-house"></i> Trang chủ</li>
                    <li class="menu-item"><i class="fa-solid fa-user"></i> Nhân viên</li>
                    <li class="menu-item"
                        onclick="location.href='${pageContext.request.contextPath}/donhang'">
                        <i class="fa-solid fa-chair"></i> Bàn
                    </li>
                    <li class="menu-item"><i class="fa-solid fa-mug-saucer"></i> Menu</li>
                    <li class="menu-item"
                        onclick="location.href='${pageContext.request.contextPath}/ban'">
                        <i class="fa-solid fa-chair"></i> Bàn
                    </li>
                    <li class="menu-item"
                        onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'">
                        <i class="fa-solid fa-box"></i> Kho
                    </li>
                    <li class="menu-item"><i class="fa-solid fa-users"></i> Khách hàng</li>
                    <li class="menu-item"><i class="fa-solid fa-chart-column"></i> Thống kê doanh thu</li>
                    <li class="menu-item"><i class="fa-solid fa-gear"></i> Cài đặt</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
            </a>
        </aside>

        <main class="main-content">
            <header class="topbar">
                <div class="user-info">
                    <i class="fa-solid fa-circle-user"></i>
                    <%= maNV %> - <%= tenNV %> <i class="fa-solid fa-chevron-down" style="font-size: 12px;"></i>
                </div>
                <div class="notification">
                    <i class="fa-regular fa-bell"></i>
                    <span class="badge">3</span>
                </div>
            </header>

            <div class="welcome-section">
                <h1>Xin chào, <%= tenNV %>!</h1>
                <p>Chào mừng bạn đến với hệ thống quản lý quán cafe</p>
            </div>

            <div class="cards-grid">
                <div class="card">
                    <div class="card-icon bg-blue"><i class="fa-solid fa-user-group"></i></div>
                    <h3>Quản lý nhân viên</h3>
                    <p>Thêm, sửa, xóa và quản lý thông tin nhân viên</p>
                </div>

                <div class="card"
                    onclick="location.href='${pageContext.request.contextPath}/donhang'">
                    <div class="card-icon bg-purple">
                        <i class="fa-solid fa-chair"></i>
                    </div>
                    <h3>Quản lý Hoá Đơn</h3>
                    <p>Quản lý Hóa Đơn, trạng thái Hóa Đơn</p>
                </div>

                <div class="card">
                    <div class="card-icon bg-orange"><i class="fa-solid fa-mug-hot"></i></div>
                    <h3>Quản lý menu</h3>
                    <p>Quản lý danh mục đồ uống và món ăn</p>
                </div>

                <div class="card"
                    onclick="location.href='${pageContext.request.contextPath}/ban'">
                    <div class="card-icon bg-purple">
                        <i class="fa-solid fa-chair"></i>
                    </div>
                    <h3>Quản lý bàn</h3>
                    <p>Quản lý bàn, trạng thái và khu vực</p>
                </div>

                <div class="card"
                     onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'">
                    <div class="card-icon bg-brown">
                        <i class="fa-solid fa-box"></i>
                    </div>
                    <h3>Quản lý kho</h3>
                    <p>Quản lý nguyên liệu, nhập xuất kho</p>
                </div>

                <div class="card">
                    <div class="card-icon bg-teal"><i class="fa-solid fa-chart-simple"></i></div>
                    <h3>Thống kê doanh thu</h3>
                    <p>Xem báo cáo doanh thu, thống kê bán hàng</p>
                </div>

                <div class="card">
                    <div class="card-icon bg-pink"><i class="fa-solid fa-users"></i></div>
                    <h3>Quản lý khách hàng</h3>
                    <p>Quản lý thông tin khách hàng và lịch sử mua hàng</p>
                </div>
            </div>
        </main>

    </body>
</html>
