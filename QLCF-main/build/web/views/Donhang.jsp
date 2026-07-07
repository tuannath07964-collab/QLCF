<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.DonHang"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Hóa Đơn - Cafe</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #4a3b32;
            --sidebar-hover: #5d4a3f;
            --bg-color: #f4f6f9;
            --text-color: #333;
            --primary-color: #007bff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            display: flex;
            background-color: var(--bg-color);
            color: var(--text-color);
            height: 100vh;
            overflow: hidden;
        }

        /* SIDEBAR (Cột trái) */
        .sidebar {
            width: 250px;
            background-color: var(--sidebar-bg);
            color: #fff;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .sidebar-header {
            padding: 20px;
            font-size: 16px;
            font-weight: bold;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-menu {
            list-style: none;
            flex-grow: 1;
            padding-top: 10px;
        }

        .nav-menu li {
            padding: 12px 20px;
            cursor: pointer;
            transition: 0.3s;
        }

        .nav-menu li:hover, .nav-menu li.active {
            background-color: var(--sidebar-hover);
            border-left: 4px solid #fff;
        }

        .nav-menu a {
            color: #fff;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 15px;
        }

        .logout {
            margin-top: auto;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* MAIN CONTENT (Phần bên phải) */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        /* TOPBAR (Thanh trên cùng) */
        .topbar {
            background-color: #fff;
            height: 60px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 0 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 500;
            color: #555;
        }

        .notification {
            position: relative;
            cursor: pointer;
        }
        
        .notification .badge {
            position: absolute;
            top: -5px;
            right: -10px;
            background-color: red;
            color: white;
            font-size: 10px;
            padding: 2px 5px;
            border-radius: 50%;
        }

        /* NỘI DUNG CHÍNH (Bảng) */
        .content-body {
            padding: 30px;
        }

        .page-title {
            margin-bottom: 20px;
        }

        .page-title h2 {
            font-size: 24px;
            color: #222;
        }

        .page-title p {
            color: #777;
            font-size: 14px;
            margin-top: 5px;
        }

        .card {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            color: #888;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
        }

        td {
            font-size: 15px;
            color: #444;
        }

        tr:hover {
            background-color: #fcfcfc;
        }

        /* HIỆU ỨNG NÚT BẤM TRẠNG THÁI */
        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        /* Phóng to và mờ đi 1 chút khi di chuột vào để báo hiệu nút bấm */
        .status:hover {
            opacity: 0.8;
            transform: scale(1.05);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .status.dang-phuc-vu { background-color: #e3f2fd; color: #1976d2; border: 1px solid #bbdefb; }
        .status.cho-thanh-toan { background-color: #fff3e0; color: #f57c00; border: 1px solid #ffe0b2; }
        .status.da-thanh-toan { background-color: #e8f5e9; color: #388e3c; border: 1px solid #c8e6c9; }

        .btn-action {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }
        .btn-action:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-coffee"></i> QUẢN LÝ QUÁN CAFE
        </div>
        <ul class="nav-menu">
            <li><a href="#"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li><a href="#"><i class="fas fa-user-friends"></i> Nhân viên</a></li>
            <li class="active"><a href="donhang"><i class="fas fa-file-invoice-dollar"></i> Hóa đơn</a></li>
            <li><a href="#"><i class="fas fa-book-open"></i> Menu</a></li>
            <li><a href="#"><i class="fas fa-chair"></i> Bàn</a></li>
            <li><a href="#"><i class="fas fa-box-open"></i> Kho</a></li>
            <li><a href="#"><i class="fas fa-users"></i> Khách hàng</a></li>
            <li><a href="#"><i class="fas fa-chart-bar"></i> Thống kê doanh thu</a></li>
            <li><a href="#"><i class="fas fa-cog"></i> Cài đặt</a></li>
            <li class="logout"><a href="#"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="topbar">
            <div class="user-info">
                <i class="fas fa-user-circle fa-lg"></i>
                <span>TH08199 - Trịnh Bình Minh <i class="fas fa-chevron-down" style="font-size: 12px; margin-left: 5px;"></i></span>
                <div class="notification" style="margin-left: 15px;">
                    <i class="far fa-bell fa-lg"></i>
                    <span class="badge">3</span>
                </div>
            </div>
        </div>

        <div class="content-body">
            <div class="page-title">
                <h2>Quản lý hóa đơn</h2>
                <p>Xem, tạo và quản lý hóa đơn thanh toán (Bấm vào trạng thái để chuyển đổi)</p>
            </div>

            <div class="card">
                <table>
                    <thead>
                        <tr>
                            <th>Mã Đơn</th>
                            <th>Bàn</th>
                            <th>Nhân Viên</th>
                            <th>Thời Gian</th>
                            <th>Tổng Tiền</th>
                            <th style="text-align: center;">Trạng Thái</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            ArrayList<DonHang> danhSach = (ArrayList<DonHang>) request.getAttribute("dsDonHang");
                            
                            if (danhSach != null && !danhSach.isEmpty()) {
                                for (DonHang dh : danhSach) {
                                    String statusClass = "";
                                    if (dh.getTrangThai().equals("Đang phục vụ")) statusClass = "dang-phuc-vu";
                                    else if (dh.getTrangThai().equals("Chờ thanh toán")) statusClass = "cho-thanh-toan";
                                    else if (dh.getTrangThai().equals("Đã thanh toán")) statusClass = "da-thanh-toan";
                        %>
                        <tr>
                            <td><strong><%= dh.getMaDonHang() %></strong></td>
                            <td><%= dh.getMaBan() %></td>
                            <td><%= dh.getTenNhanVien() %></td>
                            <td><%= dh.getThoiGian() %></td>
                            <td style="font-weight: 600;"><%= String.format("%,.0f", dh.getTongTien()) %> đ</td>
                            
                            <td style="text-align: center;">
                                <a href="donhang?action=doiTrangThai&maDon=<%= dh.getMaDonHang() %>" style="text-decoration: none;">
                                    <span class="status <%= statusClass %>" title="Bấm để chuyển trạng thái">
                                        <%= dh.getTrangThai() %> 
                                        <i class="fas fa-sync-alt" style="font-size: 10px;"></i>
                                    </span>
                                </a>
                            </td>
                            
                            <td>
                                <a href="#" class="btn-action"><i class="far fa-eye"></i> Chi tiết</a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #999; padding: 30px;">Chưa có dữ liệu đơn hàng.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>