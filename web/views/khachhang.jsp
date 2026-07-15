<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý khách hàng</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family: Arial, sans-serif; }
    body { display:flex; height:100vh; background:#f7f5f2; }

    /* Sidebar */
    .sidebar { width: 250px; background: #4b3a2f; color: #fff; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
    .logo { padding: 22px; font-size: 20px; font-weight: bold; text-align: center; border-bottom: 1px solid rgba(255,255,255,.1); }
    .menu { margin-top: 20px; list-style: none; }
    .menu a { display: flex; align-items: center; gap: 15px; padding: 16px 25px; color: white; text-decoration: none; transition: .3s; }
    .menu a:hover, .menu a.active { background: #6b5648; }
    .logout-section { padding: 20px 25px; border-top: 1px solid #423630; }
    .logout-section a { color: white; text-decoration: none; display: flex; align-items: center; gap: 15px; }

    /* Main Content */
    .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .header { height: 70px; background: white; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
    .user-info { display: flex; align-items: center; gap: 15px; font-weight: 600; font-size: 14px; }
    .content { padding: 30px; overflow-y: auto; }
    .card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }

    /* Table */
    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
    th { color: #555; background: #fcfcfc; }
    
    /* Buttons */
    .btn-add { background: #1b9c5a; color: white; padding: 8px 15px; text-decoration: none; border-radius: 6px; display: inline-block; }
    .btn-edit { color: #1976d2; text-decoration: none; margin-right: 15px; font-weight: bold; }
    .btn-delete { color: #d81b60; text-decoration: none; font-weight: bold; }
</style>
</head>
<body>

<div class="sidebar">
    <div>
        <div class="logo"><i class="fa-solid fa-mug-hot"></i> QUẢN LÝ CAFE</div>
        <div class="menu">
            <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-house"></i> Trang chủ</a>
            <a href="ban"><i class="fa-solid fa-chair"></i> Quản lý bàn</a>
            <a href="${pageContext.request.contextPath}/views/menu.jsp"><i class="fa-solid fa-utensils"></i> Thực đơn</a>
            <a href="${pageContext.request.contextPath}/views/homepage.jsp"><i class="fa-solid fa-receipt"></i> Hóa đơn</a>
            <a href="${pageContext.request.contextPath}/views/nhanvien.jsp"><i class="fa-solid fa-users"></i> Nhân viên</a>
            <a href="${pageContext.request.contextPath}/views/kho.jsp"><i class="fa-solid fa-box"></i> Kho</a>
            <a class="active" href="khachhang"><i class="fa-solid fa-users"></i> Khách hàng</a>
            <a href="${pageContext.request.contextPath}/views/ThongKeDoanhThu.jsp"><i class="fa-solid fa-chart-line"></i> Thống kê</a>
        </div>
    </div>

    <div class="logout-section">
        <a href="${pageContext.request.contextPath}/LoginServlet">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>

<div class="main">
    <div class="header">
        <h3>Quản lý khách hàng</h3>
        <div class="user-info">
            <span>TH08495 - Trần Dương Phương Hiếu</span>
            <i class="fa-solid fa-bell"></i>
        </div>
    </div>

    <div class="content">
        <div class="card">
            <div class="top">
                <h3>Danh sách khách hàng</h3>
                <a class="btn-add" href="khachhang?action=new"><i class="fa-solid fa-plus"></i> Thêm khách hàng</a>
            </div>

            <table>
                <tr>
                    <th>Mã KH</th>
                    <th>Tên khách hàng</th>
                    <th>Số điện thoại</th>
                    <th>Thao tác</th>
                </tr>
                <c:forEach var="kh" items="${listKH}">
                <tr>
                    <td>${kh.maKH}</td>
                    <td>${kh.tenKH}</td>
                    <td>${kh.sdt}</td>
                    <td>
                        <a class="btn-edit" href="khachhang?action=edit&maKH=${kh.maKH}"><i class="fa-solid fa-pen-to-square"></i> Sửa</a>
                        <a class="btn-delete" href="khachhang?action=delete&maKH=${kh.maKH}" onclick="return confirm('Xóa khách hàng này?')"><i class="fa-solid fa-trash"></i> Xóa</a>
                    </td>
                </tr>
                </c:forEach>
            </table>
        </div>
    </div>
</div>

</body>
</html>