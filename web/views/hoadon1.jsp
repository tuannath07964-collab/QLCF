<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Hóa đơn — Quản lý quán Cafe</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/hoadon.css">
</head>

<body>

    <%-- Chuẩn hóa mã hóa đơn hiển thị --%>
    <c:set var="maHoaDonHienThi"
           value="Tự động khi lưu"/>

    <c:if test="${not empty hoadon.maHD}">
        <fmt:formatNumber var="maHDFormatted"
                          value="${hoadon.maHD}"
                          pattern="000000"/>

        <c:set var="maHoaDonHienThi"
               value="HD${maHDFormatted}"/>
    </c:if>

    <c:set var="daThanhToan"
           value="${hoadon.trangThai eq 'Đã thanh toán'}"/>

    <c:set var="daHuy"
           value="${hoadon.trangThai eq 'Đã hủy'}"/>

    <c:set var="daKetThuc"
           value="${daThanhToan or daHuy}"/>

    <c:set var="laMangVe"
           value="${hoadon.hinhThuc eq 'Mang về'}"/>

    <!-- ==================== SIDEBAR ==================== -->
    <aside class="sidebar">

        <div class="logo brand">
            <i class="fa-solid fa-mug-hot"></i>

            <span class="logo-text">
                QUẢN LÝ QUÁN CAFE
            </span>
        </div>

        <ul class="menu">

            <li onclick="location.href='${pageContext.request.contextPath}/views/homepage.jsp'">
                <i class="fa-solid fa-house"></i>
                <span>Trang chủ</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/nhanvien'">
                <i class="fa-solid fa-user"></i>
                <span>Nhân viên</span>
            </li>

            <li class="active"
                onclick="location.href='${pageContext.request.contextPath}/hoadon?action=list'">

                <i class="fa-solid fa-file-invoice-dollar"></i>
                <span>Hóa đơn</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/menu'">
                <i class="fa-solid fa-mug-saucer"></i>
                <span>Menu</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/ban'">
                <i class="fa-solid fa-chair"></i>
                <span>Bàn</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/KhoServlet'">
                <i class="fa-solid fa-box"></i>
                <span>Kho</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/khachhang'">
                <i class="fa-solid fa-users"></i>
                <span>Khách hàng</span>
            </li>

            <c:if test="${sessionScope.chucVu == 'Quản lý'}">
                <li onclick="location.href='${pageContext.request.contextPath}/ThongKeServlet'">
                    <i class="fa-solid fa-chart-column"></i>
                    <span>Thống kê</span>
                </li>
            </c:if>

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
                     onclick="location.href='${pageContext.request.contextPath}/hoadon?action=list'">

                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại danh sách hóa đơn
                </div>

                <h1>
                    Hóa đơn

                    <span id="invoiceCode"
                          style="color:var(--coffee-dark);">

                        ${maHoaDonHienThi}
                    </span>
                </h1>

            </div>

            <div class="user user-profile">

                <i class="fa-solid fa-user"></i>

                <span>
                    ${sessionScope.maNV}
                    -
                    ${sessionScope.tenNV}
                </span>

            </div>

        </div>

        <!-- ==================== FORM HÓA ĐƠN ==================== -->
        <form action="${pageContext.request.contextPath}/hoadon"
              method="post"
              class="content"
              id="invoiceForm">

            <input type="hidden"
                   id="formAction"
                   name="action"
                   value="update">

            <input type="hidden"
                   name="maHD"
                   value="${hoadon.maHD}">

            <input type="hidden"
                   name="maNV"
                   value="${empty hoadon.maNV
                            ? sessionScope.maNV
                            : hoadon.maNV}">

            <input type="hidden"
                   name="ngayTao"
                   value="${hoadon.ngayTao}">

            <input type="hidden"
                   name="trangThai"
                   value="${empty hoadon.trangThai
                            ? 'Đang phục vụ'
                            : hoadon.trangThai}">

            <input type="hidden"
                   name="hinhThuc"
                   value="${empty hoadon.hinhThuc
                            ? 'Tại bàn'
                            : hoadon.hinhThuc}">

            <input type="hidden"
                   id="inputTongTien"
                   name="tongTien"
                   value="${empty hoadon.tongTien
                            ? 0
                            : hoadon.tongTien}">

            <input type="hidden"
                   id="inputDanhSachMon"
                   name="danhSachMon"
                   value="">

            <!-- hoadon.js tạo itemMaMon và itemQty tại đây -->
            <div id="cartFields"></div>

            <!-- Dữ liệu giỏ hàng đã lưu -->
            <textarea id="oldCartData"
                      hidden><c:out value="${hoadon.danhSachMon}"/></textarea>

            <!-- THÔNG BÁO LƯU THÀNH CÔNG -->
            <c:if test="${param.success == 'save'}">

                <div style="
                     position:fixed;
                     top:85px;
                     left:50%;
                     transform:translateX(-50%);
                     z-index:9999;
                     min-width:320px;
                     max-width:600px;
                     padding:12px 16px;
                     border-radius:8px;
                     background:#d1e7dd;
                     color:#0f5132;
                     border:1px solid #badbcc;
                     box-shadow:0 4px 12px rgba(0,0,0,.15);
                     font-weight:600;">

                    <i class="fa-solid fa-circle-check"></i>
                    Lưu hóa đơn thành công.
                </div>

            </c:if>

            <!-- THÔNG BÁO LỖI -->
            <c:if test="${not empty errorMessage}">

                <div style="
                     position:fixed;
                     top:85px;
                     left:50%;
                     transform:translateX(-50%);
                     z-index:9999;
                     min-width:320px;
                     max-width:600px;
                     padding:12px 16px;
                     border-radius:8px;
                     background:#f8d7da;
                     color:#842029;
                     border:1px solid #f5c2c7;
                     box-shadow:0 4px 12px rgba(0,0,0,.15);
                     font-weight:600;">

                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${errorMessage}
                </div>

            </c:if>

            <!-- ==================== LEFT ==================== -->
            <div class="left">

                <!-- THÔNG TIN HÓA ĐƠN -->
                <div class="info-card">

                    <div class="info-field">

                        <label>Hình thức bán</label>

                        <input type="text"
                               value="${laMangVe
                                        ? 'Mang về'
                                        : 'Tại bàn'}"
                               readonly>

                    </div>

                    <div class="info-field">

                        <label for="tableSel">
                            Bàn phục vụ
                        </label>

                        <c:choose>

                            <c:when test="${laMangVe}">

                                <input type="text"
                                       value="Không dùng bàn"
                                       readonly>

                            </c:when>

                            <c:when test="${daKetThuc}">

                                <select id="tableSel"
                                        disabled>

                                    <option value="${hoadon.maBan}">
                                        Bàn ${hoadon.maBan}
                                    </option>

                                </select>

                                <input type="hidden"
                                       name="maBan"
                                       value="${hoadon.maBan}">

                            </c:when>

                            <c:otherwise>

                                <select id="tableSel"
                                        name="maBan"
                                        required>

                                    <option value="">
                                        -- Chọn bàn --
                                    </option>

                                    <c:forEach var="i"
                                               begin="1"
                                               end="20">

                                        <option value="${i}"
                                                ${hoadon.maBan == i
                                                    ? 'selected'
                                                    : ''}>

                                            Bàn
                                            <c:if test="${i < 10}">
                                                0
                                            </c:if>
                                            ${i}
                                        </option>

                                    </c:forEach>

                                </select>

                            </c:otherwise>

                        </c:choose>

                    </div>

                    <!-- KHÁCH HÀNG TÍCH ĐIỂM -->
                    <div class="info-field">

                        <label for="customerSel">
                            Khách hàng tích điểm
                        </label>

                        <c:choose>

                            <c:when test="${daKetThuc}">

                                <select id="customerSel"
                                        disabled>

                                    <option value="${hoadon.maKH}">
                                        <c:choose>

                                            <c:when test="${not empty hoadon.tenKhachHang}">
                                                ${hoadon.tenKhachHang}
                                            </c:when>

                                            <c:otherwise>
                                                Khách lẻ
                                            </c:otherwise>

                                        </c:choose>
                                    </option>

                                </select>

                                <input type="hidden"
                                       name="maKH"
                                       value="${hoadon.maKH}">

                            </c:when>

                            <c:otherwise>

                                <select id="customerSel"
                                        name="maKH">

                                    <option value="">
                                        Khách lẻ — không cộng điểm
                                    </option>

                                    <c:forEach var="kh"
                                               items="${khachHangList}">

                                        <option value="${kh.maKH}"
                                                ${hoadon.maKH == kh.maKH
                                                    ? 'selected'
                                                    : ''}>

                                            ${kh.maKH}
                                            — ${kh.hoTen}
                                            — ${empty kh.sdt
                                                ? 'Chưa có SĐT'
                                                : kh.sdt}
                                            — ${kh.diemTichLuy} điểm
                                        </option>

                                    </c:forEach>

                                </select>

                            </c:otherwise>

                        </c:choose>

                        <small style="
                               color:#6c757d;
                               line-height:1.4;">

                            Để trống là khách lẻ.
                            Khách lẻ không cần nhập thông tin.
                        </small>

                        <c:if test="${not daKetThuc}">

                            <label style="
                                   display:flex;
                                   align-items:center;
                                   gap:7px;
                                   margin-top:10px;
                                   font-size:13px;">

                                <input type="checkbox"
                                       id="saveNewCustomer"
                                       name="luuKhachMoi"
                                       value="1"
                                       style="width:auto;">

                                Lưu khách hàng mới khi thanh toán
                            </label>

                            <input type="text"
                                   id="newCustomerName"
                                   name="tenKhachMoi"
                                   maxlength="100"
                                   placeholder="Nhập họ tên khách hàng"
                                   disabled
                                   style="margin-top:7px;">

                            <small style="color:#6c757d;">
                                Không cần vào mục Khách hàng.
                                Hệ thống sẽ tự sinh mã khách hàng.
                            </small>

                        </c:if>

                    </div>

                    <div class="info-field">

                        <label>Nhân viên</label>

                        <input type="text"
                               value="${empty hoadon.maNV
                                        ? sessionScope.maNV
                                        : hoadon.maNV}"
                               readonly>

                    </div>

                    <div class="info-field">

                        <label>Mã hóa đơn</label>

                        <input type="text"
                               value="${maHoaDonHienThi}"
                               readonly>

                    </div>

                    <span class="status-pill">

                        <span class="dot"></span>

                        ${empty hoadon.trangThai
                            ? 'Đang phục vụ'
                            : hoadon.trangThai}
                    </span>

                </div>

                <!-- ==================== MENU HEADER ==================== -->
                <div class="menu-header">

                    <h2>Chọn món</h2>

                    <div class="tabs">

                        <div class="tab active"
                             data-cat="all">

                            Tất cả
                        </div>

                        <div class="tab"
                             data-cat="coffee">

                            Cà phê
                        </div>

                        <div class="tab"
                             data-cat="tea">

                            Trà
                        </div>

                        <div class="tab"
                             data-cat="juice">

                            Sinh tố & Ép
                        </div>

                        <div class="tab"
                             data-cat="snack">

                            Bánh & Ăn vặt
                        </div>

                    </div>

                </div>

                <!-- ==================== DANH SÁCH MÓN ==================== -->
                <div class="menu-grid"
                     id="menuGrid">

                    <c:choose>

                        <c:when test="${empty menuList}">

                            <div style="
                                 grid-column:1/-1;
                                 width:100%;
                                 padding:30px 20px;
                                 text-align:center;
                                 background:#fff;
                                 border-radius:12px;
                                 color:#e74c3c;
                                 font-weight:600;">

                                <i class="fa-solid fa-circle-exclamation"></i>
                                Không có món nào trong danh sách.

                                <div style="
                                     margin-top:8px;
                                     color:#7f8c8d;
                                     font-size:13px;
                                     font-weight:400;">

                                    Kiểm tra dữ liệu trong bảng Menu
                                    và CongThucMon.
                                </div>

                            </div>

                        </c:when>

                        <c:otherwise>

                            <c:forEach var="m"
                                       items="${menuList}">

                                <div class="menu-item
                                            ${not m.trangThai
                                                ? 'out-of-stock'
                                                : ''}"

                                     data-category="${m.loaiMon}"
                                     data-ma-mon="${m.maMon}"
                                     data-ten-mon="<c:out value='${m.tenMon}'/>"
                                     data-gia="${m.gia}"
                                     data-disabled="${daKetThuc or not m.trangThai}"

                                     onclick="handleMenuItemClick(this)"

                                     style="
                                     display:flex;
                                     flex-direction:column;
                                     justify-content:space-between;
                                     min-height:180px;
                                     opacity:${m.trangThai ? '1' : '.58'};
                                     cursor:${m.trangThai and not daKetThuc
                                                ? 'pointer'
                                                : 'not-allowed'};">

                                    <div>

                                        <div style="
                                             display:flex;
                                             justify-content:space-between;
                                             align-items:center;
                                             margin-bottom:8px;">

                                            <span style="
                                                  font-size:11px;
                                                  color:#7f8c8d;
                                                  font-weight:700;">

                                                ${m.maMon}
                                            </span>

                                            <c:choose>

                                                <c:when test="${m.trangThai}">

                                                    <span style="
                                                          font-size:10px;
                                                          padding:3px 7px;
                                                          border-radius:10px;
                                                          background:#d1e7dd;
                                                          color:#0f5132;
                                                          font-weight:700;">

                                                        Còn món
                                                    </span>

                                                </c:when>

                                                <c:otherwise>

                                                    <span style="
                                                          font-size:10px;
                                                          padding:3px 7px;
                                                          border-radius:10px;
                                                          background:#f8d7da;
                                                          color:#842029;
                                                          font-weight:700;">

                                                        Hết món
                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

                                        </div>

                                        <div class="item-name"
                                             style="
                                             font-size:15px;
                                             font-weight:700;
                                             margin-bottom:7px;">

                                            ${m.tenMon}
                                        </div>

                                        <div style="
                                             text-align:left;
                                             font-size:11px;
                                             line-height:1.45;
                                             color:#5f6b76;
                                             margin-bottom:8px;">

                                            <b>Nguyên liệu:</b>

                                            <br>

                                            ${empty m.nguyenLieuCan
                                                ? 'Chưa cấu hình công thức'
                                                : m.nguyenLieuCan}
                                        </div>

                                        <div style="
                                             text-align:left;
                                             font-size:11px;
                                             color:${m.trangThai
                                                ? '#198754'
                                                : '#dc3545'};
                                             font-weight:700;">

                                            <c:choose>

                                                <c:when test="${m.trangThai}">

                                                    Có thể pha khoảng
                                                    ${m.soPhanCoThePha} phần
                                                </c:when>

                                                <c:otherwise>

                                                    Không đủ nguyên liệu
                                                </c:otherwise>

                                            </c:choose>

                                        </div>

                                    </div>

                                    <div style="
                                         display:flex;
                                         justify-content:space-between;
                                         align-items:center;
                                         margin-top:12px;">

                                        <div class="item-price"
                                             style="font-weight:700;">

                                            <fmt:formatNumber
                                                value="${m.gia}"
                                                pattern="#,##0"/>

                                            đ
                                        </div>

                                        <c:if test="${m.trangThai
                                                      and not daKetThuc}">

                                            <div class="item-add"
                                                 style="
                                                 color:var(--coffee-dark);
                                                 font-size:16px;">

                                                <i class="fa-solid fa-plus"></i>
                                            </div>

                                        </c:if>

                                    </div>

                                </div>

                            </c:forEach>

                        </c:otherwise>

                    </c:choose>

                </div>

            </div>
            <!-- KẾT THÚC LEFT -->

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
                            ĐT: 0866158915
                        </div>

                    </div>

                    <!-- META -->
                    <div class="receipt-meta">

                        <span>
                            Số HĐ:

                            <b id="metaCode">
                                ${maHoaDonHienThi}
                            </b>
                        </span>

                        <span>
                            Bàn:

                            <b id="metaTable">

                                <c:choose>

                                    <c:when test="${laMangVe}">
                                        Mang về
                                    </c:when>

                                    <c:when test="${not empty hoadon.maBan}">
                                        Bàn ${hoadon.maBan}
                                    </c:when>

                                    <c:otherwise>
                                        —
                                    </c:otherwise>

                                </c:choose>

                            </b>
                        </span>

                    </div>

                    <!-- GIỎ HÀNG -->
                    <div class="receipt-items"
                         id="receiptItems">

                        <div class="empty-hint">
                            Chưa có món nào được chọn
                        </div>

                    </div>

                    <!-- TỔNG TIỀN -->
                    <div class="receipt-totals">

                        <div class="rt-row">

                            <span>Tạm tính</span>

                            <span id="subTotal">
                                0đ
                            </span>

                        </div>

                        <div class="rt-row">

                            <span>VAT (8%)</span>

                            <span id="vatAmt">
                                0đ
                            </span>

                        </div>

                        <div class="rt-row">

                            <span>Điểm dự kiến cộng</span>

                            <span id="pointPreview">
                                0 điểm
                            </span>

                        </div>

                        <div class="rt-row grand">

                            <span>Tổng cộng</span>

                            <span class="amt"
                                  id="grandTotal">

                                0đ
                            </span>

                        </div>

                    </div>

                    <!-- GIỮ TƯƠNG THÍCH JS CŨ -->
                    <div style="display:none;">

                        <span id="discLabel"></span>
                        <span id="discAmt"></span>
                        <div id="promoMsg"></div>

                    </div>

                    <!-- PHƯƠNG THỨC THANH TOÁN -->
                    <div class="pay-methods">

                        <c:choose>

                            <c:when test="${daKetThuc}">

                                <label>

                                    <input type="radio"
                                           name="pay"
                                           value="cash"
                                           checked
                                           disabled>

                                    <span>💵 Tiền mặt</span>
                                </label>

                            </c:when>

                            <c:otherwise>

                                <label>

                                    <input type="radio"
                                           name="pay"
                                           value="cash"
                                           checked>

                                    <span>💵 Tiền mặt</span>
                                </label>

                            </c:otherwise>

                        </c:choose>

                    </div>

                    <!-- CÁC NÚT -->
                    <div class="receipt-actions"
                         style="
                         display:flex;
                         flex-wrap:wrap;
                         gap:8px;">

                        <button type="button"
                                class="btn btn-outline"
                                style="
                                flex:1;
                                min-width:90px;
                                padding:10px 5px;
                                font-size:13px;"
                                onclick="window.print()">

                            <i class="fa-solid fa-print"></i>
                            In HĐ
                        </button>

                        <c:if test="${not daKetThuc}">

                            <button type="submit"
                                    class="btn btn-primary"
                                    style="
                                    flex:1;
                                    min-width:110px;"
                                    onclick="return prepareInvoiceSubmit('pay')">

                                <i class="fa-solid fa-credit-card"></i>
                                Thanh toán
                            </button>

                            <button type="submit"
                                    class="btn btn-primary"
                                    style="
                                    flex:1;
                                    min-width:90px;"
                                    onclick="return prepareInvoiceSubmit('update')">

                                <i class="fa-solid fa-check"></i>
                                Lưu lại
                            </button>

                            <button type="button"
                                    class="btn btn-outline"
                                    style="
                                    flex:1;
                                    min-width:90px;
                                    color:#842029;
                                    border-color:#dc3545;"
                                    onclick="cancelInvoice()">

                                <i class="fa-solid fa-ban"></i>
                                Hủy đơn
                            </button>

                        </c:if>

                        <c:if test="${daKetThuc}">

                            <div style="
                                 width:100%;
                                 padding:10px;
                                 border-radius:7px;
                                 text-align:center;
                                 background:${daHuy
                                    ? '#f8d7da'
                                    : '#d1e7dd'};
                                 color:${daHuy
                                    ? '#842029'
                                    : '#0f5132'};
                                 font-weight:700;">

                                <i class="fa-solid
                                   ${daHuy
                                     ? 'fa-circle-xmark'
                                     : 'fa-circle-check'}"></i>

                                ${daHuy
                                    ? 'Đơn hàng đã hủy'
                                    : 'Hóa đơn đã thanh toán'}
                            </div>

                        </c:if>

                    </div>

                    <!-- BARCODE -->
                    <div class="barcode">

                        <div class="bars">
                            ▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌▐▍▌▐▐▌▍▐▌▌
                        </div>

                        ${maHoaDonHienThi}
                        — CẢM ƠN QUÝ KHÁCH!
                    </div>

                </div>

            </div>
            <!-- KẾT THÚC RIGHT -->

        </form>

        <!-- FORM HỦY ĐƠN -->
        <form id="cancelInvoiceForm"
              action="${pageContext.request.contextPath}/hoadon"
              method="post"
              style="display:none;">

            <input type="hidden"
                   name="action"
                   value="cancel">

            <input type="hidden"
                   name="maHD"
                   value="${hoadon.maHD}">

            <input type="hidden"
                   name="lyDoHuy"
                   id="cancelReasonInput">

        </form>

    </div>

    <!-- ==================== JAVASCRIPT ==================== -->
    <script src="${pageContext.request.contextPath}/js/hoadon.js"></script>

    <script>
        function handleMenuItemClick(element) {
            if (!element) {
                return;
            }

            if (element.dataset.disabled === "true") {
                return;
            }

            if (typeof addToReceipt !== "function") {
                alert("Không tải được chức năng thêm món.");
                return;
            }

            addToReceipt(
                    element.dataset.maMon,
                    element.dataset.tenMon,
                    Number(element.dataset.gia)
            );
        }

        function updateReceiptTable() {
            const tableSelect =
                    document.getElementById("tableSel");

            const metaTable =
                    document.getElementById("metaTable");

            if (!tableSelect || !metaTable) {
                return;
            }

            const selectedOption =
                    tableSelect.options[
                        tableSelect.selectedIndex
                    ];

            if (!selectedOption
                    || !tableSelect.value) {

                metaTable.textContent = "—";
                return;
            }

            metaTable.textContent =
                    selectedOption.textContent.trim();
        }

        function updatePointPreview() {
            const totalText =
                    document.getElementById(
                            "grandTotal"
                    );

            const customerSelect =
                    document.getElementById(
                            "customerSel"
                    );

            const pointPreview =
                    document.getElementById(
                            "pointPreview"
                    );

            const saveNewCustomer =
                    document.getElementById(
                            "saveNewCustomer"
                    );

            if (!totalText || !pointPreview) {
                return;
            }

            const total =
                    Number(
                            totalText.textContent
                                    .replace(/[^\d]/g, "")
                    ) || 0;

            const hasCustomer =
                    (
                        customerSelect
                        && customerSelect.value
                    )
                    || (
                        saveNewCustomer
                        && saveNewCustomer.checked
                    );

            const points =
                    hasCustomer
                    ? Math.floor(total / 10000)
                    : 0;

            pointPreview.textContent =
                    points + " điểm";
        }

        function toggleNewCustomerForm() {
            const checkbox =
                    document.getElementById(
                            "saveNewCustomer"
                    );

            const nameInput =
                    document.getElementById(
                            "newCustomerName"
                    );

            const customerSelect =
                    document.getElementById(
                            "customerSel"
                    );

            if (!checkbox || !nameInput) {
                return;
            }

            const enabled =
                    checkbox.checked;

            nameInput.disabled =
                    !enabled;

            nameInput.required =
                    enabled;

            if (enabled && customerSelect) {
                customerSelect.value = "";
                nameInput.focus();
            }

            if (!enabled) {
                nameInput.value = "";
            }

            updatePointPreview();
        }

        function cancelInvoice() {
            const reason =
                    prompt(
                            "Nhập lý do hủy đơn:",
                            ""
                    );

            if (reason === null) {
                return;
            }

            if (!reason.trim()) {
                alert(
                        "Vui lòng nhập lý do hủy đơn."
                );

                return;
            }

            if (
                !confirm(
                    "Xác nhận hủy đơn hàng này?"
                )
            ) {
                return;
            }

            const reasonInput =
                    document.getElementById(
                            "cancelReasonInput"
                    );

            const cancelForm =
                    document.getElementById(
                            "cancelInvoiceForm"
                    );

            if (!reasonInput || !cancelForm) {
                alert(
                        "Không tìm thấy biểu mẫu hủy hóa đơn."
                );

                return;
            }

            reasonInput.value =
                    reason.trim();

            cancelForm.submit();
        }

        document.addEventListener(
                "DOMContentLoaded",
                function () {

                    const tableSelect =
                            document.getElementById(
                                    "tableSel"
                            );

                    if (tableSelect) {
                        tableSelect.addEventListener(
                                "change",
                                updateReceiptTable
                        );
                    }

                    const customerSelect =
                            document.getElementById(
                                    "customerSel"
                            );

                    const saveNewCustomer =
                            document.getElementById(
                                    "saveNewCustomer"
                            );

                    if (customerSelect) {
                        customerSelect.addEventListener(
                                "change",
                                function () {

                                    if (
                                        customerSelect.value
                                        && saveNewCustomer
                                        && saveNewCustomer.checked
                                    ) {
                                        saveNewCustomer.checked =
                                                false;

                                        toggleNewCustomerForm();
                                    }

                                    updatePointPreview();
                                }
                        );
                    }

                    if (saveNewCustomer) {
                        saveNewCustomer.addEventListener(
                                "change",
                                toggleNewCustomerForm
                        );

                        toggleNewCustomerForm();
                    }

                    updateReceiptTable();

                    /*
                     * Sau mỗi lần render giỏ hàng,
                     * cập nhật lại điểm dự kiến.
                     */
                    if (typeof renderCart === "function") {
                        const originalRenderCart =
                                renderCart;

                        renderCart = function () {
                            originalRenderCart();
                            updatePointPreview();
                        };
                    }

                    const oldCartData =
                            document.getElementById(
                                    "oldCartData"
                            );

                    if (
                        oldCartData
                        && oldCartData.value
                        && oldCartData.value.trim() !== ""
                        && typeof initCartFromSavedData
                            === "function"
                    ) {
                        initCartFromSavedData(
                                oldCartData.value
                        );

                    } else if (
                        typeof renderCart === "function"
                    ) {
                        renderCart();
                    }

                    updatePointPreview();
                }
        );
    </script>

</body>
</html>