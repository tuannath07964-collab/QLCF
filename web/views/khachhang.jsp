<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý khách hàng</title>
        <!-- Thêm Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nhanvien.css">
        <style>
            /* Tùy chỉnh nhẹ để khớp với sidebar của bạn */
            .card-header-custom {
                background-color: #0d6efd;
                color: white;
                padding: 15px;
                border-radius: 8px 8px 0 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .table thead {
                background-color: #f8f9fa;
            }
        </style>
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
                <li onclick="location.href = '${pageContext.request.contextPath}/hoadon'"><i class="fa-solid fa-file-invoice-dollar"></i> <span>Hóa đơn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/menu'"><i class="fa-solid fa-mug-saucer"></i> <span>Menu</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ban'"><i class="fa-solid fa-chair"></i> <span>Bàn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'"><i class="fa-solid fa-box"></i> <span>Kho</span></li>
                <li class="active" onclick="location.href = '${pageContext.request.contextPath}/khachhang'"><i class="fa-solid fa-users"></i> <span>Khách hàng</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'"><i class="fa-solid fa-chart-column"></i> <span>Thống kê</span></li>
            </ul>
            <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span></a>
        </aside>

        <div class="main">
            <div class="header">
                <h2>Quản lý khách hàng</h2>
                <div class="user-profile">
                    <i class="fa-solid fa-user"></i> 
                    <span>${sessionScope.maNV} - ${sessionScope.tenNV}</span>
                </div>
            </div>

            <div class="content">
                <div class="card">
                    <div class="card-header-custom">
                        <h4 style="margin:0;">Danh sách khách hàng</h4>
                        <button type="button" onclick="openModal('${pageContext.request.contextPath}/khachhang?action=loadForm', 'Thêm khách hàng mới')">
                            <i class="fa-solid fa-plus"></i> Thêm khách
                        </button>
                    </div>

                    <div style="padding: 20px;">
                        <form class="search-form" action="${pageContext.request.contextPath}/khachhang" method="get" style="margin-bottom: 20px;">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" placeholder="Nhập mã, tên hoặc SĐT..." style="padding: 8px; width: 300px;">
                            <button type="submit" style="padding: 8px 15px;"><i class="fa-solid fa-search"></i> Tìm kiếm</button>
                        </form>

                        <table class="table table-hover align-middle border">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã KH</th>
                                    <th>Tên khách hàng</th>
                                    <th>SĐT</th>
                                    <th>Mã giảm giá</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    java.util.ArrayList<model.KhachHang> list = (java.util.ArrayList<model.KhachHang>) request.getAttribute("listKH");
                                    if (list != null) {
                                        for (model.KhachHang kh : list) {
                                %>
                                <tr>
                                    <td><%= kh.getMaKH() %></td>
                                    <td><%= kh.getHoTen() %></td>
                                    <td><%= kh.getSdt() %></td>
                                    <td><span class="badge bg-info text-dark"><%= kh.getMaGiamGia() != null ? kh.getMaGiamGia() : "" %></span></td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-outline-warning" 
                                                onclick="openModal('${pageContext.request.contextPath}/khachhang?action=loadForm&maKH=<%= kh.getMaKH() %>', 'Cập nhật khách hàng')">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/khachhang?action=delete&maKH=<%= kh.getMaKH() %>" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng <%= kh.getHoTen() %> không?')" 
                                           class="btn btn-sm btn-outline-danger">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="myModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
            <div style="background:white; padding:25px; border-radius:12px; width:500px; box-shadow:0 4px 15px rgba(0,0,0,0.2); position:relative;">
                <div class="modal-header" style="display:flex; justify-content:space-between;">
                    <h5 id="modalTitle">Tiêu đề</h5>
                    <button type="button" class="btn-close" onclick="closeModal()"></button>
                </div>
                <div id="modalBody">
                    <!-- Form load vào đây -->
                </div>
            </div>
        </div>

        <script>
            function openModal(url, title) {
                document.getElementById('modalTitle').innerText = title;
                fetch(url).then(res => res.text()).then(html => {
                    document.getElementById('modalBody').innerHTML = html;
                    document.getElementById('myModal').style.display = 'flex';
                });
            }
            function closeModal() {
                document.getElementById('myModal').style.display = 'none';
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>