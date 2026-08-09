<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="customerModeValue"
       value="${requestScope.customerModeDaChon ne null
                ? requestScope.customerModeDaChon
                : (not empty hoaDon.maKH
                ? 'saved'
                : ((not empty hoaDon.tenKhachHang
                and hoaDon.tenKhachHang ne 'Khách lẻ')
                or not empty hoaDon.sdtKhachHang
                ? 'new'
                : 'guest'))}"/>

<c:set var="selectedCustomerCode"
       value="${requestScope.maKHDaChon ne null
                ? requestScope.maKHDaChon
                : hoaDon.maKH}"/>

<c:set var="newCustomerNameValue"
       value="${requestScope.tenKhachHangDaNhap ne null
                ? requestScope.tenKhachHangDaNhap
                : (customerModeValue == 'new'
                ? hoaDon.tenKhachHang
                : '')}"/>

<c:set var="newCustomerPhoneValue"
       value="${requestScope.sdtKhachHangDaNhap ne null
                ? requestScope.sdtKhachHangDaNhap
                : (customerModeValue == 'new'
                ? hoaDon.sdtKhachHang
                : '')}"/>

<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Chi tiết hóa đơn</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css?v=91">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=91">
    </head>

    <body>

        <jsp:include page="/views/components/sidebar.jsp">
            <jsp:param name="active" value="invoice"/>
        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">
                <jsp:param name="title" value="Chi tiết hóa đơn"/>
                <jsp:param name="subtitle"
                           value="Chọn sản phẩm và thực hiện thanh toán"/>
            </jsp:include>

            <div class="app-content">

                <c:if test="${param.success == 'save'}">
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        Lưu hóa đơn thành công.
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <c:out value="${errorMessage}"/>
                    </div>
                </c:if>

                <form id="invoiceForm"
                      action="${pageContext.request.contextPath}/hoadon"
                      method="post">

                    <input type="hidden"
                           name="maHD"
                           value="${hoaDon.maHD}">

                    <input type="hidden"
                           id="usedVoucherValue"
                           value="${empty voucherDaDung
                                    ? 0
                                    : voucherDaDung.menhGia}">

                    <section class="invoice-editor-layout">

                        <article class="card product-picker-panel">

                            <div class="card-header product-picker-header">

                                <div>
                                    <h3>Chọn sản phẩm</h3>
                                    <p>Nhấn vào sản phẩm để thêm vào hóa đơn</p>
                                </div>

                                <div class="search-box product-picker-search">

                                    <i class="fa-solid fa-magnifying-glass"></i>

                                    <input type="text"
                                           id="productPickerSearch"
                                           placeholder="Tìm sản phẩm..."
                                           autocomplete="off"
                                           ${hoaDon.daKetThuc
                                             ? 'disabled'
                                             : ''}>
                                </div>

                            </div>

                            <div class="card-body">

                                <div class="product-picker-grid">

                                    <c:forEach var="sanPham"
                                               items="${sanPhamList}">

                                        <button type="button"
                                                class="product-pick
                                                ${sanPham.coTheBan
                                                  ? ''
                                                  : 'disabled'}"
                                                data-code="${sanPham.maSanPham}"
                                                data-name="${sanPham.tenSanPham}"
                                                data-price="${sanPham.giaBan}"
                                                data-search="${sanPham.maSanPham}
                                                ${sanPham.tenSanPham}
                                                ${sanPham.tenDanhMuc}"
                                                ${not sanPham.coTheBan
                                                  or hoaDon.daKetThuc
                                                  ? 'disabled'
                                                  : ''}>

                                            <span class="product-pick-icon">
                                                <i class="fa-solid fa-mug-saucer"></i>
                                            </span>

                                            <span class="product-pick-content">

                                                <small>
                                                    <c:out value="${sanPham.tenDanhMuc}"/>
                                                </small>

                                                <strong>
                                                    <c:out value="${sanPham.tenSanPham}"/>
                                                </strong>

                                                <span>
                                                    <fmt:formatNumber
                                                        value="${sanPham.giaBan}"
                                                        pattern="#,##0"/>
                                                    đ
                                                </span>

                                                <em>
                                                    ${sanPham.coTheBan
                                                      ? sanPham.soLuongCoTheBan
                                                      : 0}
                                                    phần
                                                </em>

                                            </span>

                                        </button>

                                    </c:forEach>

                                </div>

                            </div>

                        </article>

                        <article class="card invoice-cart-panel">

                            <div class="card-header">

                                <div>
                                    <h3>Thông tin hóa đơn</h3>
                                    <p>${hoaDon.maHienThi}</p>
                                </div>

                            </div>

                            <div class="card-body">

                                <c:if test="${not hoaDon.daKetThuc}">

                                    <div class="form-group">

                                        <label class="form-label">
                                            Loại khách hàng
                                        </label>

                                        <div class="customer-mode-options">

                                            <label class="customer-mode-item">

                                                <input type="radio"
                                                       name="customerMode"
                                                       value="saved"
                                                       ${customerModeValue == 'saved'
                                                         ? 'checked'
                                                         : ''}>

                                                <span class="customer-mode-card">

                                                    <i class="fa-solid fa-user-check"></i>

                                                    <span>
                                                        <strong>
                                                            Khách hàng đã lưu
                                                        </strong>

                                                        <small>
                                                            Tìm theo mã, tên hoặc số điện thoại
                                                        </small>
                                                    </span>

                                                </span>

                                            </label>

                                            <label class="customer-mode-item">

                                                <input type="radio"
                                                       name="customerMode"
                                                       value="new"
                                                       ${customerModeValue == 'new'
                                                         ? 'checked'
                                                         : ''}>

                                                <span class="customer-mode-card">

                                                    <i class="fa-solid fa-user-plus"></i>

                                                    <span>
                                                        <strong>
                                                            Khách hàng mới
                                                        </strong>

                                                        <small>
                                                            Nhập thông tin và lưu khách hàng
                                                        </small>
                                                    </span>

                                                </span>

                                            </label>

                                            <label class="customer-mode-item">

                                                <input type="radio"
                                                       name="customerMode"
                                                       value="guest"
                                                       ${customerModeValue == 'guest'
                                                         ? 'checked'
                                                         : ''}>

                                                <span class="customer-mode-card">

                                                    <i class="fa-solid fa-user"></i>

                                                    <span>
                                                        <strong>
                                                            Khách lẻ
                                                        </strong>

                                                        <small>
                                                            Không lưu và không tích điểm
                                                        </small>
                                                    </span>

                                                </span>

                                            </label>

                                        </div>

                                    </div>

                                    <div id="savedCustomerSection"
                                         class="customer-detail-section
                                         ${customerModeValue == 'saved'
                                           ? ''
                                           : 'hidden'}">

                                        <input type="hidden"
                                               id="selectedCustomerCodeInput"
                                               name="maKH"
                                               value="${selectedCustomerCode}"
                                               ${customerModeValue == 'saved'
                                                 ? ''
                                                 : 'disabled'}>

                                        <div class="form-group">

                                            <label class="form-label">
                                                Tìm khách hàng đã lưu
                                            </label>

                                            <div class="customer-search-bar">

                                                <input class="form-control"
                                                       type="search"
                                                       id="customerSearchInput"
                                                       autocomplete="off"
                                                       placeholder="Nhập mã, tên hoặc số điện thoại">

                                                <button class="btn btn-primary"
                                                        type="button"
                                                        id="customerSearchButton">

                                                    <i class="fa-solid fa-magnifying-glass"></i>

                                                    Tìm kiếm

                                                </button>

                                            </div>

                                            <small class="form-help-text"
                                                   id="customerSearchHelp">

                                                Nhập mã, họ tên hoặc số điện thoại để tìm khách hàng.

                                            </small>

                                            <div class="customer-search-results hidden"
                                                 id="customerSearchResults">

                                                <c:forEach var="khachHang"
                                                           items="${khachHangList}">

                                                    <button type="button"
                                                            class="customer-search-item"
                                                            data-code="${khachHang.maKH}"
                                                            data-name="${khachHang.hoTen}"
                                                            data-phone="${khachHang.sdt}"
                                                            data-points="${khachHang.diemTichLuy}">

                                                        <span class="customer-search-icon">
                                                            <i class="fa-solid fa-user"></i>
                                                        </span>

                                                        <span class="customer-search-info">

                                                            <strong>
                                                                <c:out value="${khachHang.hoTen}"/>
                                                            </strong>

                                                            <small>

                                                                ${khachHang.maKH}

                                                                ·

                                                                ${empty khachHang.sdt
                                                                  ? 'Chưa có số điện thoại'
                                                                  : khachHang.sdt}

                                                            </small>

                                                        </span>

                                                        <span class="customer-search-points">
                                                            ${khachHang.diemTichLuy} điểm
                                                        </span>

                                                    </button>

                                                </c:forEach>

                                                <div id="customerSearchEmpty"
                                                     class="customer-search-empty hidden">

                                                    <i class="fa-solid fa-user-slash"></i>

                                                    Không tìm thấy khách hàng.

                                                </div>

                                            </div>

                                            <div id="selectedCustomerCard"
                                                 class="selected-customer-card hidden">

                                                <div class="selected-customer-main">

                                                    <span class="selected-customer-avatar">
                                                        <i class="fa-solid fa-user-check"></i>
                                                    </span>

                                                    <div>

                                                        <small>
                                                            Khách hàng đã chọn
                                                        </small>

                                                        <strong id="selectedCustomerName">
                                                            —
                                                        </strong>

                                                        <span id="selectedCustomerDetail">
                                                            —
                                                        </span>

                                                    </div>

                                                </div>

                                                <div class="selected-customer-actions">

                                                    <strong id="selectedCustomerPoints">
                                                        0 điểm
                                                    </strong>

                                                    <button type="button"
                                                            id="clearSelectedCustomerButton"
                                                            class="btn btn-light btn-sm">

                                                        <i class="fa-solid fa-xmark"></i>

                                                        Bỏ chọn

                                                    </button>

                                                </div>

                                            </div>

                                        </div>

                                    </div>

                                    <div id="newCustomerSection"
                                         class="customer-detail-section
                                         ${customerModeValue == 'new'
                                           ? ''
                                           : 'hidden'}">

                                        <div class="new-customer-box">

                                            <div class="new-customer-title">

                                                <i class="fa-solid fa-user-plus"></i>

                                                <div>
                                                    <strong>
                                                        Thông tin khách hàng mới
                                                    </strong>

                                                    <span>
                                                        Khách hàng sẽ được lưu khi thanh toán thành công
                                                    </span>
                                                </div>

                                            </div>

                                            <div class="new-customer-fields">

                                                <div class="form-group">

                                                    <label class="form-label"
                                                           for="newCustomerName">

                                                        Họ và tên

                                                        <span class="required-mark">
                                                            *
                                                        </span>

                                                    </label>

                                                    <input class="form-control"
                                                           type="text"
                                                           id="newCustomerName"
                                                           name="tenKhachHang"
                                                           maxlength="100"
                                                           autocomplete="name"
                                                           value="${newCustomerNameValue}"
                                                           placeholder="Nhập họ và tên khách hàng"
                                                           ${customerModeValue == 'new'
                                                             ? 'required'
                                                             : 'disabled'}>

                                                </div>

                                                <div class="form-group">

                                                    <label class="form-label"
                                                           for="newCustomerPhone">

                                                        Số điện thoại

                                                        <span class="required-mark">
                                                            *
                                                        </span>

                                                    </label>

                                                    <input class="form-control"
                                                           type="tel"
                                                           id="newCustomerPhone"
                                                           name="sdtKhachHang"
                                                           maxlength="11"
                                                           inputmode="numeric"
                                                           autocomplete="tel"
                                                           value="${newCustomerPhoneValue}"
                                                           placeholder="Ví dụ: 0988123456"
                                                           ${customerModeValue == 'new'
                                                             ? 'required'
                                                             : 'disabled'}>

                                                </div>

                                            </div>

                                            <small class="form-help-text">
                                                Số điện thoại bắt đầu bằng 0 và gồm từ 9 đến 11 chữ số.
                                                Sau khi thanh toán, khách hàng được lưu và cộng điểm.
                                            </small>

                                        </div>

                                    </div>

                                    <div id="guestCustomerSection"
                                         class="customer-detail-section
                                         ${customerModeValue == 'guest'
                                           ? ''
                                           : 'hidden'}">

                                        <div class="guest-customer-box">

                                            <span class="guest-customer-icon">
                                                <i class="fa-solid fa-circle-info"></i>
                                            </span>

                                            <div>

                                                <strong>
                                                    Thanh toán cho khách lẻ
                                                </strong>

                                                <p>
                                                    Không cần nhập tên hoặc số điện thoại.
                                                    Khách lẻ không được lưu vào danh sách khách hàng,
                                                    không tích điểm và không sử dụng voucher.
                                                </p>

                                            </div>

                                        </div>

                                    </div>

                                    <div id="voucherSection"
                                         class="form-group invoice-voucher-box
                                         ${customerModeValue == 'saved'
                                           ? ''
                                           : 'hidden'}">

                                        <label class="form-label">
                                            Voucher của khách hàng
                                        </label>

                                        <select class="form-control"
                                                id="voucherSelect"
                                                name="maVoucher">

                                            <option value=""
                                                    data-value="0"
                                                    data-code="">

                                                Không sử dụng voucher

                                            </option>

                                            <c:forEach var="voucher"
                                                       items="${voucherList}">

                                                <option value="${voucher.maVoucher}"
                                                        data-customer="${voucher.maKH}"
                                                        data-value="${voucher.menhGia}"
                                                        data-code="${voucher.maCode}"
                                                        ${maVoucherDaChon == voucher.maVoucher
                                                          ? 'selected'
                                                          : ''}>

                                                    ${voucher.maCode}

                                                    -

                                                    Giảm

                                                    <fmt:formatNumber
                                                        value="${voucher.menhGia}"
                                                        pattern="#,##0"/>

                                                    đ

                                                    -

                                                    Hạn ${voucher.ngayHetHanHienThi}

                                                </option>

                                            </c:forEach>

                                        </select>

                                        <small id="voucherHelpText"
                                               class="form-help-text">

                                            Chọn khách hàng đã lưu để sử dụng voucher.

                                        </small>

                                        <div id="selectedVoucherPreview"
                                             class="selected-voucher-preview hidden">

                                            <i class="fa-solid fa-ticket"></i>

                                            <div>

                                                <span>
                                                    Voucher đã chọn
                                                </span>

                                                <strong id="selectedVoucherCode">
                                                    —
                                                </strong>

                                            </div>

                                        </div>

                                    </div>

                                </c:if>

                                <c:if test="${hoaDon.daKetThuc}">

                                    <div class="form-group">

                                        <label class="form-label">
                                            Khách hàng
                                        </label>

                                        <input class="form-control"
                                               type="text"
                                               value="${empty hoaDon.tenKhachHang
                                                        ? 'Khách lẻ'
                                                        : hoaDon.tenKhachHang}"
                                               readonly>

                                    </div>

                                    <c:if test="${not empty hoaDon.sdtKhachHang}">

                                        <div class="form-group">

                                            <label class="form-label">
                                                Số điện thoại
                                            </label>

                                            <input class="form-control"
                                                   type="text"
                                                   value="${hoaDon.sdtKhachHang}"
                                                   readonly>

                                        </div>

                                    </c:if>

                                    <c:if test="${not empty voucherDaDung}">

                                        <div class="used-voucher-box">

                                            <i class="fa-solid fa-ticket"></i>

                                            <div>

                                                <span>
                                                    Voucher đã sử dụng
                                                </span>

                                                <strong>

                                                    ${voucherDaDung.maCode}

                                                    -

                                                    Giảm

                                                    <fmt:formatNumber
                                                        value="${voucherDaDung.menhGia}"
                                                        pattern="#,##0"/>

                                                    đ

                                                </strong>

                                            </div>

                                        </div>

                                    </c:if>

                                </c:if>

                                <div class="invoice-cart-table-wrapper">

                                    <table class="invoice-cart-table">

                                        <thead>
                                            <tr>
                                                <th>Sản phẩm</th>
                                                <th>SL</th>
                                                <th>Thành tiền</th>
                                                <th></th>
                                            </tr>
                                        </thead>

                                        <tbody id="cartTableBody">

                                            <c:forEach var="chiTiet"
                                                       items="${chiTietList}">

                                                <tr class="cart-row"
                                                    data-code="${chiTiet.maSanPham}"
                                                    data-name="${chiTiet.tenSanPham}"
                                                    data-price="${chiTiet.donGia}">

                                                    <td>

                                                        <strong>
                                                            <c:out value="${chiTiet.tenSanPham}"/>
                                                        </strong>

                                                        <small>

                                                            <fmt:formatNumber
                                                                value="${chiTiet.donGia}"
                                                                pattern="#,##0"/>

                                                            đ

                                                        </small>

                                                        <input type="hidden"
                                                               name="maSanPham"
                                                               value="${chiTiet.maSanPham}">

                                                    </td>

                                                    <td>

                                                        <input class="cart-quantity"
                                                               type="number"
                                                               name="soLuong"
                                                               value="${chiTiet.soLuong}"
                                                               min="1"
                                                               step="1"
                                                               ${hoaDon.daKetThuc
                                                                 ? 'readonly'
                                                                 : ''}>

                                                    </td>

                                                    <td class="cart-line-total">
                                                        0đ
                                                    </td>

                                                    <td>

                                                        <button class="cart-remove"
                                                                type="button"
                                                                ${hoaDon.daKetThuc
                                                                  ? 'disabled'
                                                                  : ''}>

                                                            <i class="fa-solid fa-xmark"></i>

                                                        </button>

                                                    </td>

                                                </tr>

                                            </c:forEach>

                                        </tbody>

                                    </table>

                                    <div id="emptyCart"
                                         class="empty-cart
                                         ${empty chiTietList
                                           ? ''
                                           : 'hidden'}">

                                        <i class="fa-solid fa-basket-shopping"></i>

                                        <span>
                                            Chưa có sản phẩm
                                        </span>

                                    </div>

                                </div>

                                <div class="invoice-total-box">

                                    <div>
                                        <span>Tạm tính</span>
                                        <strong id="subTotalValue">0đ</strong>
                                    </div>

                                    <div>
                                        <span>VAT 8%</span>
                                        <strong id="vatValue">0đ</strong>
                                    </div>

                                    <div class="voucher-discount-row">
                                        <span>Voucher</span>
                                        <strong id="voucherDiscountValue">-0đ</strong>
                                    </div>

                                    <div class="grand-total-row">
                                        <span>Tổng thanh toán</span>
                                        <strong id="grandTotalValue">0đ</strong>
                                    </div>

                                </div>

                                <c:if test="${not hoaDon.daKetThuc}">

                                    <div class="payment-default-notice">

                                        <i class="fa-solid fa-money-bill-wave"></i>

                                        <div>

                                            <strong>
                                                Thanh toán tại quầy
                                            </strong>

                                            <span>
                                                Hệ thống ghi nhận thanh toán bằng tiền mặt.
                                            </span>

                                        </div>

                                    </div>

                                    <div class="invoice-form-actions">

                                        <button class="btn btn-primary"
                                                type="submit"
                                                name="action"
                                                value="save">

                                            <i class="fa-solid fa-floppy-disk"></i>

                                            Lưu hóa đơn

                                        </button>

                                        <button class="btn btn-success"
                                                type="submit"
                                                name="action"
                                                value="pay">

                                            <i class="fa-solid fa-money-check-dollar"></i>

                                            Thanh toán

                                        </button>

                                        <button class="btn btn-danger"
                                                type="button"
                                                id="cancelInvoiceButton">

                                            <i class="fa-solid fa-ban"></i>

                                            Hủy hóa đơn

                                        </button>

                                    </div>

                                </c:if>

                                <c:if test="${hoaDon.daKetThuc}">

                                    <div class="readonly-notice">

                                        <i class="fa-solid fa-lock"></i>

                                        Hóa đơn đã kết thúc.
                                        Không thể thay đổi dữ liệu.

                                    </div>

                                </c:if>

                            </div>

                        </article>

                    </section>

                </form>

            </div>

        </main>

        <form id="cancelInvoiceForm"
              action="${pageContext.request.contextPath}/hoadon"
              method="post"
              class="hidden">

            <input type="hidden"
                   name="action"
                   value="cancel">

            <input type="hidden"
                   name="maHD"
                   value="${hoaDon.maHD}">

            <input type="hidden"
                   name="lyDoHuy"
                   id="cancelReasonInput">

        </form>

        <script src="${pageContext.request.contextPath}/js/hoadon.js?v=91"></script>

    </body>
</html>