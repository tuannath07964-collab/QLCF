<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hóa đơn — Quản lý quán Cafe</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hoadon.css">
    </head>
    <body>
        <!-- SIDEBAR CỐ ĐỊNH BÊN TRÁI -->
        <aside class="sidebar">
            <div class="logo brand">
                <i class="fa-solid fa-mug-hot"></i> 
                <span class="logo-text">QUẢN LÝ QUÁN CAFE</span>
            </div>
            <ul class="menu">
                <li onclick="location.href = '${pageContext.request.contextPath}/views/homepage.jsp'"><i class="fa-solid fa-house"></i> <span>Trang chủ</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/nhanvien'"><i class="fa-solid fa-user"></i> <span>Nhân viên</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/hoadon?action=new'"><i class="fa-solid fa-file-invoice-dollar"></i> <span>Hóa đơn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/menu'"><i class="fa-solid fa-mug-saucer"></i> <span>Menu</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ban'"><i class="fa-solid fa-chair"></i> <span>Bàn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'"><i class="fa-solid fa-box"></i> <span>Kho</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/khachhang'"><i class="fa-solid fa-users"></i> <span>Khách hàng</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'"><i class="fa-solid fa-chart-column"></i> <span>Thống kê</span></li>
            </ul>
            <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span></a>
        </aside>

        <!-- MAIN CONTENT BÊN PHẢI -->
        <div class="main">
            <div class="topbar header">
                <div>
                    <div class="back" style="cursor: pointer;" onclick="history.back()"><i class="fa-solid fa-arrow-left"></i> Quay lại danh sách hóa đơn</div>
                    <h1>Hóa đơn <span id="invoiceCode" style="color:var(--coffee-dark)">${hoadon.maHD}</span></h1> 
                </div>
                <div class="user user-profile">
                    <i class="fa-solid fa-user"></i>
                    <span>${sessionScope.maNV} - ${sessionScope.tenNV}</span>
                </div>
            </div>

            <!-- FORM GỬI DỮ LIỆU HÓA ĐƠN VỀ SERVLET (Bọc toàn bộ phần nội dung bên dưới) -->
            <form action="${pageContext.request.contextPath}/hoadon" method="POST" class="content">
                
                <!-- Tự động nhận diện: Nếu có mã hóa đơn rồi thì update, chưa có thì insert -->
                <input type="hidden" name="action" value="${empty hoadon.maHD || hoadon.maHD == '' ? 'insert' : 'update'}">
                <input type="hidden" name="maHD" value="${hoadon.maHD}">
                <input type="hidden" name="ngayTao" value="${hoadon.ngayTao}">
                <input type="hidden" name="trangThai" value="Đang phục vụ">
                <input type="hidden" name="tongTien" id="inputTongTien" value="0">

                <!-- LEFT -->
                <div class="left">
                    <div class="info-card">
                        <div class="info-field">
                            <label>Mã bàn</label>
                            <select id="tableSel" name="maBan">
                                <option value="1" ${hoadon.maBan == '1' ? 'selected' : ''}>Bàn 01</option>
                                <option value="2" ${hoadon.maBan == '2' ? 'selected' : ''}>Bàn 02</option>
                                <option value="5" ${empty hoadon.maBan || hoadon.maBan == '5' ? 'selected' : ''}>Bàn 05</option>
                                <option value="7" ${hoadon.maBan == '7' ? 'selected' : ''}>Bàn 07</option>
                                <option value="Mang về" ${hoadon.maBan == 'Mang về' ? 'selected' : ''}>Mang về</option>
                            </select>
                        </div>
                        <div class="info-field">
                            <label>Khách hàng</label>
                            <input type="text" placeholder="Khách lẻ" value="Nguyễn Văn A">
                        </div>
                        <div class="info-field">
                            <label>Nhân viên</label>
                            <input type="text" name="maNV" value="${sessionScope.maNV}" readonly>
                        </div>
                        <div class="info-field">
                            <label>Ngày tạo</label>
                            <input type="hidden" name="ngayTao" value="${hoadon.ngayTao}">
                        </div>
                        <span class="status-pill"><span class="dot"></span>Đang phục vụ</span>
                    </div>

                    <div class="menu-header">
                        <h2>Chọn món</h2>
                        <div class="tabs">
                            <div class="tab active" data-cat="all">Tất cả</div>
                            <div class="tab" data-cat="coffee">Cà phê</div>
                            <div class="tab" data-cat="tea">Trà</div>
                            <div class="tab" data-cat="juice">Sinh tố & Ép</div>
                            <div class="tab" data-cat="snack">Bánh & Ăn vặt</div>
                        </div>
                    </div>

                    <!-- DANH SÁCH MÓN ĂN LẤY TỪ DATABASE QUA JSTL -->
                    <div class="menu-grid" id="menuGrid">
                        <c:forEach var="m" items="${menuList}">
                            <c:choose>
                                <c:when test="${m.trangThai == false}">
                                    <div class="menu-item out-of-stock" data-category="${m.loaiMon}" style="opacity: 0.6; cursor: not-allowed;" onclick="alert('Món ${m.tenMon} hiện đang hết hàng!')">
                                        <div class="item-name">${m.tenMon}</div>
                                        <div class="item-price">${m.gia}đ</div>
                                        <span style="color: #e74c3c; font-size: 11px; font-weight: bold; margin-top: 5px; display: inline-block;">Hết món</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="menu-item" data-category="${m.loaiMon}" onclick="addToReceipt('${m.maMon}', '${m.tenMon}', ${m.gia})" style="cursor: pointer;">
                                        <div class="item-name">${m.tenMon}</div>
                                        <div class="item-price">${m.gia}đ</div>
                                        <div class="item-add" style="margin-top: 5px; color: var(--coffee-dark);"><i class="fa-solid fa-plus"></i></div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>

                <!-- RIGHT: RECEIPT -->
                <div class="right">
                    <div class="receipt">
                        <div class="receipt-head">
                            <div class="cup"><i class="fa-solid fa-mug-hot"></i></div>
                            <div class="shop">QUÁN CAFE MINH MÚP</div>
                            <div class="addr"><br>ĐT: 0866158915</div>
                        </div>
                        <div class="receipt-meta">
                            <span>Số HĐ: <b id="metaCode">${hoadon.maHD}</b></span>
                            <span>Bàn: <b id="metaTable">${hoadon.maBan}</b></span>
                        </div>
                        <div class="receipt-items" id="receiptItems">
                            <div class="empty-hint">Chưa có món nào được chọn</div>
                        </div>

                        <div class="promo-box">
                            <input type="text" id="promoInput" placeholder="Nhập mã giảm giá" autocomplete="off">
                            <button type="button" onclick="applyPromo()">Áp dụng</button>
                        </div>
                        <div class="promo-msg" id="promoMsg"></div>

                        <div class="receipt-totals">
                            <div class="rt-row"><span>Tạm tính</span><span id="subTotal">0đ</span></div>
                            <div class="rt-row"><span id="discLabel">Giảm giá</span><span id="discAmt">−0đ</span></div>
                            <div class="rt-row"><span>VAT (8%)</span><span id="vatAmt">0đ</span></div>
                            <div class="rt-row grand"><span>Tổng cộng</span><span class="amt" id="grandTotal">0đ</span></div>
                        </div>

                        <div class="pay-methods">
                            <label><input type="radio" name="pay" checked><span>💵 Tiền mặt</span></label>
                        </div>

                        <div class="receipt-actions" style="display: flex; gap: 8px;">
                            <button type="button" class="btn btn-outline" style="flex: 1; padding: 10px 5px; font-size: 13px;" onclick="window.print()">
                                <i class="fa-solid fa-print"></i> In HĐ
                            </button>
                            <button type="button" class="btn btn-primary" style="flex: 1; padding: 10px 5px; font-size: 13px; background-color: #3498db;" onclick="alert('Chức năng thanh toán')">
                                <i class="fa-solid fa-credit-card"></i> Thanh toán
                            </button>
                            <button type="submit" class="btn btn-primary" style="flex: 1; padding: 10px 5px; font-size: 13px; background-color: #27ae60;">
                                <i class="fa-solid fa-check"></i> Lưu lại
                            </button>
                        </div>

                        <div class="barcode">
                            <div class="bars">▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌</div>
                            ${hoadon.maHD} — CẢM ƠN QUÝ KHÁCH!
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <script src="${pageContext.request.contextPath}/js/hoadon.js"></script>
    </body>
</html>