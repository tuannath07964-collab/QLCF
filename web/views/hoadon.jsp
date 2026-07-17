<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <style>
        .styled-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            font-size: 15px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .styled-table thead tr {
            background-color: #2c3e50;
            color: #ffffff;
            text-align: left;
        }
        .styled-table th, .styled-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #dddddd;
        }
        .btn-edit {
            background: #f39c12;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-delete {
            background: #e74c3c;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
        }
        .btn-pay {
            background: #27ae60;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Hóa đơn</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nhanvien.css">
    </head>
    <body>
        <aside class="sidebar">
            <div class="logo">
                <i class="fa-solid fa-mug-hot"></i> 
                <span class="logo-text">QUẢN LÝ QUÁN CAFE</span>
            </div>
            <ul class="menu">
                <li onclick="location.href = '${pageContext.request.contextPath}/views/homepage.jsp'"><i class="fa-solid fa-house"></i> <span>Trang chủ</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/nhanvien'"><i class="fa-solid fa-user"></i> <span>Nhân viên</span></li>
                <li class="active"><i class="fa-solid fa-file-invoice-dollar"></i> <span>Hóa đơn</span></li>
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
                    <i class="fa-solid fa-user"></i> <span>${sessionScope.maNV} - ${sessionScope.tenNV}</span>
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
                        <button type="button" class="btn-add" onclick="openHoaDonModal('${pageContext.request.contextPath}/hoadon?action=new', 'Thêm Hóa Đơn')">
                            <i class="fa-solid fa-plus"></i> Thêm hóa đơn
                        </button>
                    </div>
                    <table class="styled-table">
                        <thead>
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Mã Bàn</th>
                                <th>Ngày tạo</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="hd" items="${listHoaDon}">
                                <tr>
                                    <td><strong>${hd.maHD}</strong></td>
                                    <td>Bàn ${hd.maBan}</td>
                                    <td>${fn:substring(hd.ngayTao, 0, 16)}</td>
                                    <td>${String.format("%,.0f", hd.tongTien)} đ</td>
                                    <td>
                                        <span style="color: ${hd.trangThai == '0' ? '#f39c12' : '#27ae60'}; font-weight: bold;">
                                            ${hd.trangThai == '0' ? 'Chưa thanh toán' : 'Đã thanh toán'}
                                        </span>
                                    </td>
                                    <td>
                                        <!-- Nút Sửa -->
                                        <button type="button" class="btn-action btn-edit" onclick="openHoaDonModal('${pageContext.request.contextPath}/hoadon?action=edit&maHD=${hd.maHD}', 'Sửa Hóa Đơn')">
                                            <i class="fa-solid fa-pen"></i>
                                        </button>

                                        <!-- Nút Xóa -->
                                        <a class="btn-action btn-delete" href="${pageContext.request.contextPath}/hoadon?action=delete&maHD=${hd.maHD}" onclick="return confirm('Xóa hóa đơn này?');">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>

                                        <!-- Nút Thanh toán -->
                                        <c:if test="${hd.trangThai == '0'}">
                                            <form action="hoadon" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="maHD" value="${hd.maHD}">
                                                <input type="hidden" name="trangThai" value="1">
                                                <button type="submit" class="btn-action btn-pay" title="Thanh toán">
                                                    <i class="fa-solid fa-check-to-slot"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>                
                </div>
            </div>
        </div>

        <!-- Khung Modal -->
        <div id="hoadonModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; justify-content:center; align-items:center;">
            <div style="background:white; padding:25px; border-radius:12px; width:500px; box-shadow:0 4px 15px rgba(0,0,0,0.2);">
                <h3 id="modalTitle" style="margin-top:0;">Tiêu đề</h3>
                <hr>
                <div id="modalBody"></div>
            </div>
        </div>

        <script>
            function openHoaDonModal(url, title) {
                document.getElementById('modalTitle').innerText = title;
                fetch(url)
                        .then(response => response.text())
                        .then(html => {
                            document.getElementById('modalBody').innerHTML = html;
                            document.getElementById('hoadonModal').style.display = 'flex';
                        });
            }
            function closeHoaDonModal() {
                document.getElementById('hoadonModal').style.display = 'none';
            }
        </script>
    </body>
</html>