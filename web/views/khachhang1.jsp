<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${action == 'edit' ? 'Sửa thông tin khách hàng' : 'Thêm khách hàng mới'}</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            /* CSS đồng bộ với trang danh sách */
            * {
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family: 'Segoe UI', Arial, sans-serif;
            }
            body {
                display:flex;
                background:#f4f6f9;
            }
            .sidebar {
                width:250px;
                height:100vh;
                background:#2d221d;
                color:white;
                position:fixed;
            }
            .logo {
                padding:25px;
                text-align:center;
                font-size: 18px;
                font-weight: bold;
            }
            .menu {
                margin-top:20px;
            }
            .menu a {
                display:block;
                padding:15px 25px;
                color:#bbb;
                text-decoration:none;
                transition:.3s;
            }
            .menu a:hover, .menu a.active {
                background:#423630;
                color:white;
            }
            .main {
                margin-left:250px;
                width:calc(100% - 250px);
            }
            .header {
                height: 60px;
                background: white;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 30px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            .user-info {
                display: flex;
                align-items: center;
                gap: 15px;
                font-weight: 500;
                font-size: 14px;
            }
            .content {
                padding: 30px;
            }
            .card {
                background: white;
                border-radius: 10px;
                padding: 25px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                max-width: 500px;
                margin: 0 auto;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
            .btn-submit {
                background: #28a745;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                width: 100%;
                font-size: 16px;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>

        <div class="sidebar">
            <div class="logo">QUẢN LÝ QUÁN CAFE</div>
            <div class="menu">
                <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-house"></i> Trang chủ</a>
                <a href="ban"><i class="fa-solid fa-chair"></i> Quản lý bàn</a>
                <a href="${pageContext.request.contextPath}/views/menu.jsp"><i class="fa-solid fa-utensils"></i> Thực đơn</a>
                <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-receipt"></i> Hóa đơn</a>
                <a href="khachhang" class="active"><i class="fa-solid fa-users"></i> Khách hàng</a>
                <a href="${pageContext.request.contextPath}/views/kho.jsp"><i class="fa-solid fa-box"></i> Kho</a>
                <a href="${pageContext.request.contextPath}/views/ThongKeDoanhThu.jsp"><i class="fa-solid fa-chart-line"></i> Thống kê</a>
            </div>
            <div style="position: absolute; bottom: 0; width: 100%;">
                <a href="${pageContext.request.contextPath}/LoginServlet" style="display:block; padding:20px 25px; color:white; text-decoration:none; border-top:1px solid #423630;">
                    <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                </a>
            </div>
        </div>

        <div class="main">
            <div class="header">
                <h3>${action == 'edit' ? 'Cập nhật thông tin khách hàng' : 'Thêm khách hàng mới'}</h3>
                <div class="user-info">
                    <span>TH08495 - Trần Dương Phương Hiếu</span>
                    <i class="fa-solid fa-bell"></i>
                </div>
            </div>

            <div class="content">
                <div class="card">
                    <form action="khachhang" method="post">
                        <input type="hidden" name="action" value="${action == 'edit' ? 'update' : 'insert'}">

                        <div class="form-group">
                            <label>Mã KH:</label>
                            <input type="text" name="maKH" value="${kh.maKH}" ${action == 'edit' ? 'readonly' : ''} required>
                        </div>
                        <div class="form-group">
                            <label>Tên khách hàng:</label>
                            <input type="text" name="tenKH" value="${kh.tenKH}" required>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại:</label>
                            <input type="text" name="sdt" value="${kh.sdt}" required>
                        </div>

                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-floppy-disk"></i> ${action == 'edit' ? 'Cập nhật' : 'Lưu thông tin'}
                        </button>
                    </form>
                </div>
            </div>
        </div>

    </body>
</html>