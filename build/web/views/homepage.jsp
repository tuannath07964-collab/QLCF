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

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        body {
            display: flex;
            height: 100vh;
            background: #f7f5f2;
        }

        /*================ SIDEBAR ================*/
        .sidebar {
            width: 250px;
            background: #4b3a2f;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .logo {
            padding: 22px;
            font-size: 20px;
            font-weight: bold;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, .1);
        }

        .menu {
            list-style: none;
        }

        .menu li {
            padding: 16px 22px;
            cursor: pointer;
            transition: .3s;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .menu li:hover {
            background: #6b5648;
        }

        .menu li.active {
            background: #6b5648;
            border-left: 5px solid white;
        }

        .menu li i {
            width: 22px;
        }

        .logout {
            padding: 18px 22px;
            color: white;
            text-decoration: none;
            border-top: 1px solid rgba(255, 255, 255, .1);
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .logout:hover {
            background: #6b5648;
        }

        /*================ CONTENT ================*/
        .content {
            flex: 1;
            overflow: auto;
        }

        .topbar {
            height: 70px;
            background: white;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 0 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, .08);
        }

        .user {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: bold;
        }

        .user i {
            font-size: 24px;
            color: #4b3a2f;
        }

        .container {
            padding: 30px;
        }

        .container h1 {
            margin-bottom: 8px;
            color: #333;
        }

        .container p {
            color: #666;
        }

        /*================ CARDS ================*/
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 20px;
            margin-top: 25px;
        }

        .card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            cursor: pointer;
            transition: .3s;
            box-shadow: 0 2px 8px rgba(0, 0, 0, .08);
        }

        .card:hover {
            transform: translateY(-6px);
        }

        .icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 28px;
            margin-bottom: 15px;
        }

        .blue {
            background: #e9f1ff;
            color: #1976d2;
        }

        .green {
            background: #eaf8ef;
            color: #1b9c5a;
        }

        .orange {
            background: #fff3e8;
            color: #f57c00;
        }

        .purple {
            background: #efe8ff;
            color: #7b4dd8;
        }

        .pink {
            background: #ffeef2;
            color: #d81b60;
        }

        .card h3 {
            margin-bottom: 10px;
        }

        .card p {
            color: #666;
            line-height: 22px;
        }
    </style>
</head>

<body>
    <aside class="sidebar">
        <div>
            <div class="logo">
                <i class="fa-solid fa-mug-hot"></i>
                QUẢN LÝ QUÁN CAFE
            </div>

            <ul class="menu">
                <li class="active" onclick="location.href='${pageContext.request.contextPath}/UI.jsp'">
                    <i class="fa-solid fa-house"></i>
                    Trang chủ
                </li>

                <!-- Đã khôi phục về: nhanvien -->
                <li onclick="location.href='${pageContext.request.contextPath}/nhanvien'">
                    <i class="fa-solid fa-user"></i>
                    Nhân viên
                </li>

                <!-- Đã sửa: HoaDonServlet hoặc hoadon tùy thuộc vào backend của bạn -->
                <li onclick="location.href='${pageContext.request.contextPath}/hoadon'">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                    Hóa đơn
                </li>

                <!-- Đã khôi phục về: menu -->
                <li onclick="location.href='${pageContext.request.contextPath}/menu'">
                    <i class="fa-solid fa-mug-saucer"></i>
                    Menu
                </li>

                <!-- Đã khôi phục về: ban -->
                <li onclick="location.href='${pageContext.request.contextPath}/ban'">
                    <i class="fa-solid fa-chair"></i>
                    Bàn
                </li>

                <!-- Đã khôi phục về: KhoServlet (chữ K viết hoa) -->
                <li onclick="location.href='${pageContext.request.contextPath}/KhoServlet'">
                    <i class="fa-solid fa-box"></i>
                    Kho
                </li>

                <!-- Đã khôi phục về: khachhang -->
                <li onclick="location.href='${pageContext.request.contextPath}/khachhang'">
                    <i class="fa-solid fa-users"></i>
                    Khách hàng
                </li>

                <!-- Thống kê doanh thu -->
                <li onclick="location.href='${pageContext.request.contextPath}/ThongKeServlet'">
                    <i class="fa-solid fa-chart-column"></i>
                    Thống kê
                </li>

                <li>
                    <i class="fa-solid fa-gear"></i>
                    Cài đặt
                </li>
            </ul>
        </div>

        <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet">
            <i class="fa-solid fa-right-from-bracket"></i>
            Đăng xuất
        </a>
    </aside>

    <div class="content">
        <div class="topbar">
            <div class="user">
                <i class="fa-solid fa-circle-user"></i>
                <%= maNV %> - <%= tenNV %>
            </div>
        </div>

        <div class="container">
            <h1>Xin chào, <%= tenNV %></h1>
            <p>Chào mừng bạn đến với hệ thống quản lý quán cafe</p>

            <div class="cards">
                <!-- Card 1: Nhân viên -->
                <div class="card" onclick="location.href='${pageContext.request.contextPath}/nhanvien'">
                    <div class="icon blue">
                        <i class="fa-solid fa-user-group"></i>
                    </div>
                    <h3>Quản lý nhân viên</h3>
                    <p>Thêm, sửa, xóa và quản lý thông tin nhân viên.</p>
                </div>

                <!-- Card 2: Hóa đơn -->
                <div class="card" onclick="location.href='${pageContext.request.contextPath}/hoadon'">
                    <div class="icon green">
                        <i class="fa-solid fa-file-lines"></i>
                    </div>
                    <h3>Quản lý hóa đơn</h3>
                    <p>Theo dõi hóa đơn và thanh toán.</p>
                </div>

                <!-- Card 3: Menu -->
                <div class="card" onclick="location.href='${pageContext.request.contextPath}/menu'">
                    <div class="icon orange">
                        <i class="fa-solid fa-mug-hot"></i>
                    </div>
                    <h3>Quản lý Menu</h3>
                    <p>Quản lý đồ uống và món ăn.</p>
                </div>

                <!-- Card 4: Bàn -->
                <div class="card" onclick="location.href='${pageContext.request.contextPath}/ban'">
                    <div class="icon purple">
                        <i class="fa-solid fa-chair"></i>
                    </div>
                    <h3>Quản lý bàn</h3>
                    <p>Quản lý trạng thái bàn và khu vực phục vụ.</p>
                </div>

                <!-- Card 5: Kho (Sửa thành KhoServlet) -->
                <div class="card" onclick="location.href='${pageContext.request.contextPath}/KhoServlet'">
                    <div class="icon green">
                        <i class="fa-solid fa-box"></i>
                    </div>
                    <h3>Quản lý kho</h3>
                    <p>Quản lý nhập, xuất và tồn kho nguyên liệu.</p>
                </div>

                <!-- Card 6: Thống kê doanh thu -->
                <div class="card" onclick="location.href='${pageContext.request.contextPath}/ThongKeServlet'">
                    <div class="icon orange">
                        <i class="fa-solid fa-chart-line"></i>
                    </div>
                    <h3>Thống kê doanh thu</h3>
                    <p>Xem báo cáo doanh thu theo ngày, tháng, năm.</p>
                </div>

                <!-- Card 7: Khách hàng -->
                <div class="card" onclick="location.href='${pageContext.request.contextPath}/khachhang'">
                    <div class="icon pink">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <h3>Quản lý khách hàng</h3>
                    <p>Theo dõi thông tin và lịch sử mua hàng.</p>
                </div>
            </div>
        </div>
    </div>
</body>

</html>