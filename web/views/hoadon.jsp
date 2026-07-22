<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Hóa đơn — Quản lý quán Cafe</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                display: flex;
            }
            h1, h2, h3 {
                font-family: 'Playfair Display', serif;
            }

            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 260px);
                box-sizing: border-box;
            }
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }
            .page-header h1 {
                font-size: 26px;
                color: #111;
                margin: 0;
            }

            .filter-bar {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
                align-items: center;
            }
            .filter-btn {
                padding: 8px 18px;
                border-radius: 20px;
                border: 1px solid #ddd;
                background: #fff;
                cursor: pointer;
                font-weight: 500;
                font-size: 14px;
                transition: all 0.2s;
            }
            .filter-btn.active, .filter-btn:hover {
                background: #2c3e50;
                color: #fff;
                border-color: #2c3e50;
            }

            .invoice-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
            .invoice-card {
                background: #fff;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.04);
                border-top: 4px solid #27ae60;
                position: relative;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }
            .invoice-card.pending {
                border-top-color: #e67e22;
            }
            .invoice-card.paid {
                border-top-color: #3498db;
            }

            .inv-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 12px;
            }
            .inv-code {
                font-size: 18px;
                font-weight: 700;
                color: #2c3e50;
            }
            .inv-table {
                font-size: 14px;
                color: #666;
                margin-bottom: 8px;
            }
            .inv-date {
                font-size: 13px;
                color: #888;
                margin-bottom: 15px;
            }
            .inv-total {
                font-size: 16px;
                font-weight: 700;
                color: #c0392b;
                margin-bottom: 15px;
            }

            .status-badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
            }
            .status-badge.served {
                background: #fdeed9;
                color: #d35400;
            }
            .status-badge.paid {
                background: #e8f8f5;
                color: #16a085;
            }

            .btn-action {
                display: block;
                width: 100%;
                text-align: center;
                padding: 10px;
                border-radius: 8px;
                background: #f8f9fa;
                color: #333;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                border: 1px solid #e0e0e0;
                transition: all 0.2s;
                box-sizing: border-box;
            }
            .btn-action:hover {
                background: #2c3e50;
                color: #fff;
                border-color: #2c3e50;
            }

            .add-new-btn {
                background: #27ae60;
                color: #fff;
                padding: 10px 20px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            .add-new-btn:hover {
                background: #219653;
            }
        </style>
    </head>
    <body>
        <!-- SIDEBAR -->
        <aside class="sidebar" style="width: 260px; height: 100vh; position: fixed; background: #2c3e50; color: #fff; left: 0; top: 0; display: flex; flex-direction: column; justify-content: space-between; padding: 20px 0;">
            <div>
                <div class="logo brand" style="padding: 0 20px 20px 20px; font-size: 18px; font-weight: bold; border-bottom: 1px solid rgba(255,255,255,0.1);">
                    <i class="fa-solid fa-mug-hot"></i> QUẢN LÝ CAFE
                </div>
                <ul class="menu" style="list-style: none; padding: 0; margin: 20px 0;">
                    <li onclick="location.href = '${pageContext.request.contextPath}/views/homepage.jsp'" style="padding: 12px 20px; cursor: pointer;"><i class="fa-solid fa-house"></i> Trang chủ</li>
                    <li onclick="location.href = '${pageContext.request.contextPath}/nhanvien'" style="padding: 12px 20px; cursor: pointer;"><i class="fa-solid fa-user"></i> Nhân viên</li>
                    <li onclick="location.href = '${pageContext.request.contextPath}/hoadon?action=list'" style="padding: 12px 20px; cursor: pointer; background: rgba(255,255,255,0.1);"><i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn</li>
                    <li onclick="location.href = '${pageContext.request.contextPath}/menu'" style="padding: 12px 20px; cursor: pointer;"><i class="fa-solid fa-mug-saucer"></i> Menu</li>
                    <li onclick="location.href = '${pageContext.request.contextPath}/ban'" style="padding: 12px 20px; cursor: pointer;"><i class="fa-solid fa-chair"></i> Bàn</li>
                    <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'" style="padding: 12px 20px; cursor: pointer;"><i class="fa-solid fa-box"></i> Kho</li>
                    <li onclick="location.href = '${pageContext.request.contextPath}/khachhang'" style="padding: 12px 20px; cursor: pointer;"><i class="fa-solid fa-users"></i> Khách hàng</li>
                    <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'" style="padding: 12px 20px; cursor: pointer;"><i class="fa-solid fa-chart-column"></i> Thống kê</li>
                </ul>
            </div>
            <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet" style="padding: 12px 20px; color: #ff6b6b; text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
        </aside>

        <!-- MAIN CONTENT -->
        <div class="main-content">
            <div class="page-header">
                <h1>Quản lý hóa đơn</h1>
                <!-- Chuyển hướng sang Servlet xử lý form lập hóa đơn mới (sẽ điều hướng sang hoadon1.jsp) -->
                <a href="hoadon?action=new" class="add-new-btn"><i class="fa-solid fa-plus"></i> Lập hóa đơn mới</a>
            </div>

            <!-- Thanh lọc trạng thái -->
            <div class="filter-bar">
                <button class="filter-btn active">Tất cả</button>
                <button class="filter-btn">Đang phục vụ</button>
                <button class="filter-btn">Đã thanh toán</button>
            </div>

            <!-- Lưới danh sách hóa đơn -->
            <div class="invoice-grid">
                <c:forEach var="hd" items="${listHoaDon}">
                    <div class="invoice-card ${hd.trangThai == 'Đã thanh toán' ? 'paid' : 'pending'}">
                        <div>
                            <div class="inv-header">
                                <span class="inv-code">HD${hd.maHD}</span>
                                <span class="status-badge ${hd.trangThai == 'Đã thanh toán' ? 'paid' : 'served'}">${hd.trangThai}</span>
                            </div>
                            <!-- Hiển thị đúng mã bàn vừa lưu -->
                            <div class="inv-table"><i class="fa-solid fa-chair"></i> Bàn: <b>${hd.maBan}</b></div>
                            <div class="inv-date"><i class="fa-regular fa-calendar"></i> ${hd.ngayTao}</div>
                            <!-- Hiển thị đúng tổng tiền đã lưu -->
                            <input type="hidden" name="tongTien" id="inputTongTien" value="0">
                        </div>
                        <a href="hoadon?action=edit&maHD=${hd.maHD}" class="btn-action">Xem / Chỉnh sửa</a>
                    </div>
                </c:forEach>
            </div>        </div>
    </body>
</html>