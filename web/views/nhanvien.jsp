<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý nhân viên</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
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
                <li class="active" onclick="location.href = '${pageContext.request.contextPath}/nhanvien'"><i class="fa-solid fa-user"></i> <span>Nhân viên</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/hoadon'"><i class="fa-solid fa-file-invoice-dollar"></i> <span>Hóa đơn</span></li>
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
                <h2>Quản lý nhân viên</h2>
                <div class="user-profile">
                    <i class="fa-solid fa-user"></i> 
                    <span>${sessionScope.maNV} - ${sessionScope.tenNV}</span>
                </div>
            </div>
            <div class="content">
                <div class="card">
                    <div class="top">
                        <form class="search-form" action="${pageContext.request.contextPath}/nhanvien" method="get">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" placeholder="Nhập mã hoặc tên...">
                            <button type="submit"><i class="fa-solid fa-search"></i></button>
                        </form>
                        <a class="btn-add" href="${pageContext.request.contextPath}/views/themNhanVien.jsp"><i class="fa-solid fa-plus"></i> Thêm nhân viên</a>
                    </div>
                    <table>
                        <tr><th>Mã NV</th><th>Họ tên</th><th>Giới tính</th><th>Ngày sinh</th><th>SĐT</th><th>Chức vụ</th><th>Thao tác</th></tr>
                        <c:forEach var="nv" items="${listNV}">
                            <tr>
                                <td>${nv.maNV}</td><td>${nv.hoTen}</td><td>${nv.gioiTinh}</td><td>${nv.ngaySinh}</td><td>${nv.sdt}</td><td>${nv.chucVu}</td>
                                <td>
                                    <a class="btn-edit" href="${pageContext.request.contextPath}/views/suaNhanVien.jsp?maNV=${nv.maNV}"><i class="fa-solid fa-pen"></i></a>
                                    <a class="btn-delete" href="${pageContext.request.contextPath}/nhanvien?action=delete&maNV=${nv.maNV}" onclick="return confirm('Xóa thật không?');"><i class="fa-solid fa-trash"></i></a>
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