<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Hóa đơn — Quản lý quán Cafe</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">

        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap"
              rel="stylesheet">

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/hoadon.css">
    </head>

    <body>

        <!-- ==================== SIDEBAR ==================== -->
        <aside class="sidebar">
            <div class="logo brand">
                <i class="fa-solid fa-mug-hot"></i>
                <span class="logo-text">QUẢN LÝ QUÁN CAFE</span>
            </div>

            <ul class="menu">
                <li onclick="location.href = '${pageContext.request.contextPath}/views/homepage.jsp'">
                    <i class="fa-solid fa-house"></i>
                    <span>Trang chủ</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/nhanvien'">
                    <i class="fa-solid fa-user"></i>
                    <span>Nhân viên</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/hoadon?action=list'">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                    <span>Hóa đơn</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/menu'">
                    <i class="fa-solid fa-mug-saucer"></i>
                    <span>Menu</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/ban'">
                    <i class="fa-solid fa-chair"></i>
                    <span>Bàn</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'">
                    <i class="fa-solid fa-box"></i>
                    <span>Kho</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/khachhang'">
                    <i class="fa-solid fa-users"></i>
                    <span>Khách hàng</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'">
                    <i class="fa-solid fa-chart-column"></i>
                    <span>Thống kê</span>
                </li>
            </ul>

            <a class="logout"
               href="${pageContext.request.contextPath}/LogoutServlet">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Đăng xuất</span>
            </a>
        </aside>

        <!-- ==================== MAIN ==================== -->
        <div class="main">

            <!-- TOPBAR -->
            <div class="topbar header">
                <div>
                    <div class="back"
                         style="cursor:pointer;"
                         onclick="location.href = '${pageContext.request.contextPath}/hoadon?action=list'">

                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại danh sách hóa đơn
                    </div>

                    <h1>
                        Hóa đơn
                        <span id="invoiceCode"
                              style="color:var(--coffee-dark);">
                            ${hoadon.maHD}
                        </span>
                    </h1>
                </div>

                <div class="user user-profile">
                    <i class="fa-solid fa-user"></i>
                    <span>
                        ${sessionScope.maNV} - ${sessionScope.tenNV}
                    </span>
                </div>
            </div>

            <!-- ==================== FORM HÓA ĐƠN ==================== -->
            <form action="${pageContext.request.contextPath}/hoadon"
                  method="post"
                  class="content"
                  id="invoiceForm">

                <!-- Vì nhận bàn đã tạo hóa đơn trong DB nên dùng update -->
                <input type="hidden"
                       name="action"
                       value="${empty hoadon.maHD ? 'insert' : 'update'}">

                <!-- Chỉ giữ duy nhất một maHD -->
                <input type="hidden"
                       id="formAction"
                       name="action"
                       value="${empty hoadon.maHD
                                ? 'insert'
                                : 'update'}">

                <input type="hidden"
                       name="ngayTao"
                       value="${hoadon.ngayTao}">

                <input type="hidden"
                       name="trangThai"
                       value="Đang phục vụ">

                <input type="hidden"
                       name="tongTien"
                       id="inputTongTien"
                       value="${empty hoadon.tongTien ? 0 : hoadon.tongTien}">

                <input type="hidden"
                       name="danhSachMon"
                       id="inputDanhSachMon"
                       value="">

                <input type="hidden"
                       id="oldCartData"
                       <div id="cartFields"></div>
                value='${hoadon.danhSachMon}'>

                <!-- ==================== LEFT ==================== -->
                <div class="left">

                    <!-- THÔNG TIN HÓA ĐƠN -->
                    <div class="info-card">

                        <div class="info-field">
                            <label for="tableSel">Mã bàn</label>

                            <!-- Chỉ dùng select maBan, không tạo input maBan thứ hai -->
                            <select id="tableSel" name="maBan">
                                <c:choose>
                                    <c:when test="${not empty hoadon.maBan}">
                                        <option value="${hoadon.maBan}" selected>
                                            Bàn ${hoadon.maBan}
                                        </option>
                                    </c:when>

                                    <c:otherwise>
                                        <option value="">
                                            -- Chọn bàn --
                                        </option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </div>

                        <div class="info-field">
                            <label>Khách hàng</label>

                            <input type="text"
                                   name="tenKhachHang"
                                   placeholder="Khách lẻ"
                                   value="Nguyễn Văn A">
                        </div>

                        <div class="info-field">
                            <label>Nhân viên</label>

                            <input type="text"
                                   name="maNV"
                                   value="${sessionScope.maNV}"
                                   readonly>
                        </div>

                        <span class="status-pill">
                            <span class="dot"></span>
                            Đang phục vụ
                        </span>
                    </div>

                    <!-- ==================== MENU HEADER ==================== -->
                    <div class="menu-header">
                        <h2>Chọn món</h2>

                        <div class="tabs">
                            <div class="tab active" data-cat="all">
                                Tất cả
                            </div>

                            <div class="tab" data-cat="coffee">
                                Cà phê
                            </div>

                            <div class="tab" data-cat="tea">
                                Trà
                            </div>

                            <div class="tab" data-cat="juice">
                                Sinh tố & Ép
                            </div>

                            <div class="tab" data-cat="snack">
                                Bánh & Ăn vặt
                            </div>
                        </div>
                    </div>

                    <!-- ==================== DANH SÁCH MÓN ==================== -->
                    <div class="menu-grid" id="menuGrid">
                        <c:choose>
                            <c:when test="${empty menuList}">
                                <div style="
                                     grid-column: 1 / -1;
                                     width: 100%;
                                     padding: 30px 20px;
                                     text-align: center;
                                     background: #ffffff;
                                     border-radius: 12px;
                                     color: #e74c3c;
                                     font-weight: 600;
                                     ">

                                    <i class="fa-solid fa-circle-exclamation"
                                       style="margin-right: 6px;"></i>

                                    Không có món nào trong danh sách.

                                    <div style="
                                         margin-top: 8px;
                                         color: #7f8c8d;
                                         font-size: 13px;
                                         font-weight: 400;
                                         ">
                                        Kiểm tra dữ liệu trong bảng Menu.
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="m" items="${menuList}">
                                    <c:choose>
                                        <c:when test="${m.trangThai == false}">
                                            <div class="menu-item out-of-stock"
                                                 data-category="${m.loaiMon}"
                                                 style="opacity: 0.6; cursor: not-allowed;"
                                                 onclick="alert('Món hiện đang hết hàng!')">

                                                <div class="item-name">
                                                    ${m.tenMon}
                                                </div>

                                                <div class="item-price">
                                                    ${m.gia}đ
                                                </div>

                                                <span style="
                                                      color: #e74c3c;
                                                      font-size: 11px;
                                                      font-weight: bold;
                                                      margin-top: 5px;
                                                      display: inline-block;
                                                      ">
                                                    Hết món
                                                </span>
                                            </div>
                                        </c:when>

                                        <c:otherwise>
                                            <div class="menu-item"
                                                 data-category="${m.loaiMon}"
                                                 style="cursor: pointer;"
                                                 onclick="addToReceipt('${m.maMon}', '${m.tenMon}', ${m.gia})">

                                                <div class="item-name">
                                                    ${m.tenMon}
                                                </div>

                                                <div class="item-price">
                                                    ${m.gia}đ
                                                </div>

                                                <div class="item-add"
                                                     style="margin-top: 5px; color: var(--coffee-dark);">
                                                    <i class="fa-solid fa-plus"></i>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- ==================== RIGHT ==================== -->
                    <div class="right">
                        <div class="receipt">

                            <!-- RECEIPT HEADER -->
                            <div class="receipt-head">
                                <div class="cup">
                                    <i class="fa-solid fa-mug-hot"></i>
                                </div>

                                <div class="shop">
                                    QUÁN CAFE MINH MÚP
                                </div>

                                <div class="addr">
                                    <br>
                                    ĐT: 0866158915
                                </div>
                            </div>

                            <!-- META -->
                            <div class="receipt-meta">
                                <span>
                                    Số HĐ:
                                    <b id="metaCode">
                                        ${hoadon.maHD}
                                    </b>
                                </span>

                                <span>
                                    Bàn:
                                    <b id="metaTable">
                                        ${hoadon.maBan}
                                    </b>
                                </span>
                            </div>

                            <!-- CART -->
                            <div class="receipt-items" id="receiptItems">
                                <div class="empty-hint">
                                    Chưa có món nào được chọn
                                </div>
                            </div>

                            <!-- MÃ GIẢM GIÁ -->
                            <div class="promo-box"
                                 style="
                                 display:flex;
                                 gap:5px;
                                 align-items:center;
                                 ">

                                <select name="maGiamGia"
                                        id="promoSelect"
                                        class="form-select"
                                        onchange="applySelectedPromo()">

                                    <option value="">
                                        -- Chọn mã giảm giá --
                                    </option>

                                    <c:forEach var="d" items="${discountList}">
                                        <c:if test="${d.trangThai == 1}">
                                            <option value="${d.maCode}"
                                                    data-percent="${d.phanTramGiam}"
                                                    data-min="${d.dieuKienDonToiTieu}"
                                                    ${hoadon.maGiamGia == d.maCode ? 'selected' : ''}>

                                                ${d.maCode}
                                                (-${d.phanTramGiam}%,
                                                Đơn tối thiểu:
                                                ${d.dieuKienDonToiTieu}đ)
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="promo-msg"
                                 id="promoMsg"
                                 style="
                                 font-size:12px;
                                 margin-top:4px;
                                 ">
                            </div>

                            <!-- TOTALS -->
                            <div class="receipt-totals">

                                <div class="rt-row">
                                    <span>Tạm tính</span>
                                    <span id="subTotal">0đ</span>
                                </div>

                                <div class="rt-row">
                                    <span id="discLabel">Giảm giá</span>
                                    <span id="discAmt">−0đ</span>
                                </div>

                                <div class="rt-row">
                                    <span>VAT (8%)</span>
                                    <span id="vatAmt">0đ</span>
                                </div>

                                <div class="rt-row grand">
                                    <span>Tổng cộng</span>

                                    <span class="amt"
                                          id="grandTotal">
                                        0đ
                                    </span>
                                </div>
                            </div>

                            <!-- PAYMENT -->
                            <div class="pay-methods">
                                <label>
                                    <input type="radio"
                                           name="pay"
                                           value="cash"
                                           checked>

                                    <span>💵 Tiền mặt</span>
                                </label>
                            </div>

                            <!-- ACTION BUTTONS -->
                            <div class="receipt-actions"
                                 style="
                                 display:flex;
                                 gap:8px;
                                 ">

                                <button type="button"
                                        class="btn btn-outline"
                                        style="
                                        flex:1;
                                        padding:10px 5px;
                                        font-size:13px;
                                        "
                                        onclick="window.print()">

                                    <i class="fa-solid fa-print"></i>
                                    In HĐ
                                </button>

                                <button type="submit"
                                        class="btn btn-primary"
                                        onclick="return prepareInvoiceSubmit('pay')">

                                    <i class="fa-solid fa-credit-card"></i>
                                    Thanh toán
                                </button>

                                <button type="submit"
                                        class="btn btn-primary"
                                        onclick="return prepareInvoiceSubmit(
                                                        '${empty hoadon.maHD
                                           ? 'insert'
                                           : 'update'}'
                                                        )">

                                    <i class="fa-solid fa-check"></i>
                                    Lưu lại
                                </button>

                                <c:if test="${not empty errorMessage}">
                                    <div style="
                                         margin:0 24px 12px;
                                         padding:12px 14px;
                                         border-radius:8px;
                                         background:#f8d7da;
                                         color:#842029;
                                         font-weight:600;">

                                        ${errorMessage}
                                    </div>
                                </c:if>
                            </div>

                            <!-- BARCODE -->
                            <div class="barcode">
                                <div class="bars">
                                    ▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌
                                </div>

                                ${hoadon.maHD} — CẢM ƠN QUÝ KHÁCH!
                            </div>

                        </div>
                    </div>
            </form>
        </div>

        <!-- ==================== JAVASCRIPT ==================== -->
        <script src="${pageContext.request.contextPath}/js/hoadon.js"></script>

        <script>
                                            function updateReceiptTable() {
                                                const tableSelect = document.getElementById("tableSel");
                                                const metaTable = document.getElementById("metaTable");

                                                if (!tableSelect || !metaTable) {
                                                    return;
                                                }

                                                const selectedOption =
                                                        tableSelect.options[tableSelect.selectedIndex];

                                                if (!selectedOption || !tableSelect.value) {
                                                    metaTable.textContent = "";
                                                    return;
                                                }

                                                metaTable.textContent = tableSelect.value;
                                            }

                                            (function initInvoicePage() {
                                                updateReceiptTable();

                                                const oldCartData =
                                                        document.getElementById("oldCartData");

                                                if (!oldCartData) {
                                                    return;
                                                }

                                                const savedJson = oldCartData.value;

                                                if (!savedJson || savedJson.trim() === "") {
                                                    return;
                                                }

                                                try {
                                                    const savedCart = JSON.parse(savedJson);

                                                    if (Array.isArray(savedCart)
                                                            && savedCart.length > 0
                                                            && typeof cart !== "undefined") {

                                                        cart = savedCart;

                                                        if (typeof renderCart === "function") {
                                                            renderCart();
                                                        }
                                                    }
                                                } catch (error) {
                                                    console.error(
                                                            "Không parse được danhSachMon:",
                                                            error
                                                            );
                                                }
                                            })();
        </script>
    </body>
</html>