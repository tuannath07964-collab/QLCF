<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Hóa đơn</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <!-- Dùng chung file CSS với Nhân viên để đồng bộ giao diện -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nhanvien.css">
    </head>
    <body>
        <aside class="sidebar">
            <div class="logo">
                <i class="fa-solid fa-mug-hot"></i> 
                <span class="logo-text">QUẢN LÝ QUÁN CAFE</span>
                <button id="toggleBtn" type="button"><i class="fa-solid fa-bars"></i></button>
            </div>
            <ul class="menu">
                <li onclick="location.href = '${pageContext.request.contextPath}/views/homepage.jsp'"><i class="fa-solid fa-house"></i> <span>Trang chủ</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/nhanvien'"><i class="fa-solid fa-user"></i> <span>Nhân viên</span></li>
                <li class="active" onclick="location.href = '${pageContext.request.contextPath}/hoadon'"><i class="fa-solid fa-file-invoice-dollar"></i> <span>Hóa đơn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/menu'"><i class="fa-solid fa-mug-saucer"></i> <span>Menu</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ban'"><i class="fa-solid fa-chair"></i> <span>Bàn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'"><i class="fa-solid fa-box"></i> <span>Kho</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/khachhang'"><i class="fa-solid fa-users"></i> <span>Khách hàng</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'"><i class="fa-solid fa-chart-column"></i> <span>Thống kê</span></li>
            </ul>
            <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span></a>
        </aside>

        <div class="main">
            <div class="header">
                <h2>Quản lý Hóa đơn</h2>
                <div class="user-profile">
                    <i class="fa-solid fa-user"></i> 
                    <span>${sessionScope.maNV} - ${sessionScope.tenNV}</span>
                </div>
            </div>
            <div class="content">
                <div class="card">
                    <div class="top">
                        <form class="search-form" action="${pageContext.request.contextPath}/hoadon" method="get">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" placeholder="Nhập mã hóa đơn...">
                            <button type="submit"><i class="fa-solid fa-search"></i></button>
                        </form>
                        <a class="btn-add" href="${pageContext.request.contextPath}/hoadon?action=new"><i class="fa-solid fa-plus"></i> Thêm hóa đơn</a>
                    </div>
                    <table>
                        <tr><th>Mã HĐ</th><th>Mã Bàn</th><th>Ngày tạo</th><th>Tổng tiền</th><th>Trạng thái</th><th>Thao tác</th></tr>
                        <c:forEach var="hd" items="${listHoaDon}">
                            <tr>
                                <td>${hd.maHD}</td>
                                <td>${hd.maBan}</td>
                                <td>${hd.ngayTao}</td>
                                <td>${hd.tongTien}</td>
                                <td>${hd.trangThai}</td>
                                <td>
                                    <a class="btn-edit" href="${pageContext.request.contextPath}/hoadon?action=edit&maHD=${hd.maHD}"><i class="fa-solid fa-pen"></i></a>
                                    <a class="btn-delete" href="${pageContext.request.contextPath}/hoadon?action=delete&maHD=${hd.maHD}" onclick="return confirm('Xóa hóa đơn này?');"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/js/nhanvien.js"></script>
    </body>
</html>