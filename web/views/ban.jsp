<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, model.BanAn"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý bàn</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ban.css">
        <style>
            .card-container { display: flex; flex-wrap: wrap; gap: 20px; padding: 20px 0; }
            .ban-card { background: white; width: 220px; padding: 20px; border-radius: 12px; border-top: 5px solid #ccc; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
            .ban-card.trang { border-top-color: #2ecc71; }
            .ban-card.phucvu { border-top-color: #e74c3c; }
            .btn-small { padding: 6px 12px; cursor: pointer; border: 1px solid #ddd; border-radius: 4px; background: #f9f9f9; }

            /* Modal Styles */
            #modalXem { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; justify-content:center; align-items:center; }
            .modal-content { background:white; padding:25px; border-radius:12px; width:450px; position:relative; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        </style>
    </head>
    <body>
        <aside class="sidebar">
            <div>
                <div class="logo"><i class="fa-solid fa-mug-hot"></i> QUẢN LÝ CAFE</div>
                <ul class="menu">
                    <li onclick="location.href = 'UI.jsp'"><i class="fa-solid fa-house"></i> Trang chủ</li>
                    <li onclick="location.href = 'nhanvien'"><i class="fa-solid fa-user"></i> Nhân viên</li>
                    <li onclick="location.href = 'hoadon'"><i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn</li>
                    <li onclick="location.href = 'menu'"><i class="fa-solid fa-mug-saucer"></i> Menu</li>
                    <li class="active" onclick="location.href = 'ban'"><i class="fa-solid fa-chair"></i> Bàn</li>
                    <li onclick="location.href = 'KhoServlet'"><i class="fa-solid fa-box"></i> Kho</li>
                    <li onclick="location.href = 'khachhang'"><i class="fa-solid fa-users"></i> Khách hàng</li>
                    <li onclick="location.href = 'ThongKeServlet'"><i class="fa-solid fa-chart-column"></i> Thống kê</li>
                </ul>
            </div>
            <a class="logout" href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
        </aside>

        <div class="main">
            <div class="header">
                <h3>Quản lý bàn</h3>
                <div class="user-info">TH08495 - Trần Dương Phương Hiếu <i class="fa-solid fa-bell"></i></div>
            </div>

            <div class="content">
                <div class="card-container">
                    <%
    try {
        // Lấy list bàn từ request attribute (được truyền từ BanServlet)
        ArrayList<BanAn> list = (ArrayList<BanAn>) request.getAttribute("listBan");
        
        if (list != null && !list.isEmpty()) {
            for (BanAn ban : list) {
                // Xác định class CSS dựa trên trạng thái
                String statusClass = ban.getTrangThai().equals("Trống") ? "trang" : "phucvu";
%>
                <div class="ban-card <%= statusClass %>">
                    <div class="ban-title" style="font-weight:bold; font-size:1.1em;"><%= ban.getTenBan() %></div>
                    <p>Trạng thái: <%= ban.getTrangThai() %></p>
                    
                    <div class="actions">
                        <!-- Nút Xem: Gọi modal -->
                        <button class="btn-small" onclick="xemHoaDon('<%= ban.getMaBan() %>')">Xem</button>
                        
                        <!-- Nút Thanh toán: Chỉ hiện khi bàn đang phục vụ -->
                        <% if ("Đang phục vụ".equals(ban.getTrangThai())) { %>
                            <button class="btn-small" 
                                    style="background: #e67e22; color: white; border: none;" 
                                    onclick="location.href='hoadon?action=list'">
                                Thanh toán
                            </button>
                        <% } %>
                    </div>
                </div>
<% 
            }
        } else {
            out.println("<p>Không có dữ liệu bàn</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Lỗi hiển thị bàn: " + e.getMessage() + "</p>");
    }
%>
                </div>
            </div>
        </div>

        <!-- Khung Modal -->
        <div id="modalXem">
            <div class="modal-content">
                <div id="modalContent">Đang tải dữ liệu...</div>
            </div>
        </div>

        <script>
            function xemHoaDon(maBan) {
                document.getElementById('modalXem').style.display = 'flex';
                document.getElementById('modalContent').innerHTML = "Đang tải dữ liệu...";

                fetch('ban?action=getDetail&maBan=' + maBan)
                    .then(response => response.text())
                    .then(data => {
                        document.getElementById('modalContent').innerHTML = data;
                    })
                    .catch(error => {
                        document.getElementById('modalContent').innerHTML = "Có lỗi xảy ra khi tải dữ liệu.";
                    });
            }

            function closeModal() {
                document.getElementById('modalXem').style.display = 'none';
            }
        </script>
    </body>
</html>