<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
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
                        <!-- Nút Thêm mới: Giữ nguyên cơ chế gọi form qua modal -->
                        <button type="button" class="btn-add" onclick="openModal('${pageContext.request.contextPath}/views/nhanvien1.jsp', 'Thêm nhân viên mới')">
                            <i class="fa-solid fa-plus"></i> Thêm nhân viên
                        </button>
                    </div>
                    <table>
                        <tr>
                            <th>Mã NV</th>
                            <th>Họ tên</th>
                            <th>Giới tính</th>
                            <th>Ngày sinh</th>
                            <th>SĐT</th>
                            <th>Chức vụ</th>
                            <th>Ca làm</th>
                            <th>Thời gian</th>
                            <th>Thao tác</th>
                        </tr>
                        <c:forEach var="nv" items="${listNV}">
                            <tr>
                                <td>${nv.maNV}</td>
                                <td>${nv.hoTen}</td>
                                <td>${nv.gioiTinh}</td>
                                <td>${nv.ngaySinh}</td>
                                <td>${nv.sdt}</td>
                                <td>${nv.chucVu}</td>
                                <td>
                                    <c:if test="${nv.caSang}">Sáng </c:if>
                                    <c:if test="${nv.caChieu}">Chiều </c:if>
                                    <c:if test="${nv.caToi}">Tối</c:if>
                                </td>
                                <td>${nv.gioBatDau} - ${nv.gioKetThuc}</td>
                                <td>
                                    <!-- Nút Sửa: Load form thông tin nhân viên -->
                                    <a href="javascript:void(0)" onclick="openModal('${pageContext.request.contextPath}/nhanvien?action=loadForm&maNV=${nv.maNV}', 'Sửa thông tin nhân viên')">
                                        <i class="fa-solid fa-pen" style="color: #ffc107;"></i>
                                    </a>
                                    <!-- Nút Phân ca làm -->
                                    <a href="javascript:void(0)" onclick="openCaModal('${nv.maNV}')">
                                        <i class="fa-solid fa-clock" style="color: #17a2b8; margin: 0 10px;"></i>
                                    </a>
                                    <!-- Nút Xóa -->
                                    <a href="nhanvien?action=delete&maNV=${nv.maNV}" 
                                       style="background:white; color:red; padding:5px 10px; border-radius:5px; text-decoration:none;">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
        </div> 

        <!-- Khung Modal dùng chung cho cả Thêm/Sửa (có tích hợp ô mật khẩu ẩn/hiện) -->
        <div id="myModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
            <div style="background:white; padding:25px; border-radius:12px; width:500px; box-shadow:0 4px 15px rgba(0,0,0,0.2); position:relative; max-height: 90vh; overflow-y: auto;">
                <span class="close-btn" onclick="closeModal()" style="position:absolute; right:20px; top:10px; font-size:28px; cursor:pointer; font-weight:bold; color:#333;">&times;</span>
                <h3 id="modalTitle" style="margin-top:0;">Tiêu đề</h3>
                <hr style="margin: 15px 0;">
                <div id="modalBody"></div>
            </div>
        </div>

        <script>
            var contextPath = "${pageContext.request.contextPath}";

            // Hàm dùng chung để load nội dung vào Modal (Thêm/Sửa/Phân ca)
            function openModal(url, title) {
                document.getElementById('modalTitle').innerText = title;
                fetch(url)
                    .then(response => response.text())
                    .then(html => {
                        document.getElementById('modalBody').innerHTML = html;
                        document.getElementById('myModal').style.display = 'flex';
                    })
                    .catch(error => console.error("Lỗi khi load dữ liệu:", error));
            }

            // Hàm mở Modal phân ca làm việc cho nhân viên
            function openCaModal(maNV) {
                openModal(contextPath + '/nhanvien?action=loadCa&maNV=' + maNV, 'Phân ca làm việc');
            }

            // Hàm ẩn/hiện mật khẩu (dùng chung cho form trong modal nếu có ô mật khẩu)
            function togglePasswordVisibility() {
                const passwordInput = document.getElementById('passwordInput');
                const toggleIcon = document.getElementById('togglePassword');
                if (!passwordInput || !toggleIcon) return;
                
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    passwordInput.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }

            function closeModal() {
                document.getElementById('myModal').style.display = 'none';
                document.getElementById('modalBody').innerHTML = "";
            }

            window.onclick = function (event) {
                var modal = document.getElementById("myModal");
                if (event.target == modal) {
                    closeModal();
                }
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/nhanvien.js"></script>
    </body>
</html>