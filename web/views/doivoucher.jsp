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

        <title>Đổi voucher khách hàng</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css?v=70">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=70">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/cafe-theme.css?v=2">
    </head>

    <body>

        <jsp:include page="/views/components/sidebar.jsp">
            <jsp:param name="active"
                       value="customer"/>
        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">
                <jsp:param name="title"
                           value="Đổi voucher"/>

                <jsp:param name="subtitle"
                           value="Sử dụng điểm tích lũy để đổi voucher"/>
            </jsp:include>

            <div class="app-content">

                <c:if test="${param.success == 'exchange'}">

                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        Đổi voucher thành công.
                    </div>

                </c:if>

                <c:if test="${not empty errorMessage}">

                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <c:out value="${errorMessage}"/>
                    </div>

                </c:if>

                <div class="page-header">

                    <div>

                        <a class="section-link"
                           href="${pageContext.request.contextPath}/khachhang">

                            <i class="fa-solid fa-arrow-left"></i>
                            Quay lại khách hàng
                        </a>

                        <h2>
                            <c:out value="${tenKhachHang}"/>
                        </h2>

                        <p>
                            Mã khách hàng:
                            <strong>${maKH}</strong>
                        </p>

                    </div>

                </div>

                <section class="voucher-summary">

                    <article class="voucher-point-card">

                        <span class="voucher-point-icon">
                            <i class="fa-solid fa-star"></i>
                        </span>

                        <div>
                            <span>Điểm hiện tại</span>
                            <strong>${diemHienTai} điểm</strong>
                        </div>

                    </article>

                    <article class="voucher-rule-card">

                        <i class="fa-solid fa-circle-info"></i>

                        <div>
                            <strong>Quy tắc đổi voucher</strong>

                            <span>
                                1 điểm = 1.000đ. Mỗi lần đổi tối thiểu
                                50 điểm, tương đương tổng voucher 50.000đ.
                            </span>
                        </div>

                    </article>

                </section>

                <section class="card">

                    <div class="card-header">

                        <div>
                            <h3>Chọn voucher cần đổi</h3>

                            <p>
                                Có thể chọn nhiều voucher,
                                tổng giá trị tối thiểu 50.000đ.
                            </p>
                        </div>

                    </div>

                    <div class="card-body">

                        <c:choose>

                            <c:when test="${diemHienTai >= 50}">

                                <form action="${pageContext.request.contextPath}/khachhang/voucher"
                                      method="post"
                                      id="voucherExchangeForm">

                                    <input type="hidden"
                                           name="maKH"
                                           value="${maKH}">

                                    <div class="voucher-option-grid">

                                        <div class="voucher-option">

                                            <div class="voucher-value">
                                                10.000đ
                                            </div>

                                            <span>10 điểm/voucher</span>

                                            <input class="form-control voucher-quantity"
                                                   type="number"
                                                   name="soLuong10"
                                                   value="0"
                                                   min="0"
                                                   max="50"
                                                   data-value="10000">
                                        </div>

                                        <div class="voucher-option">

                                            <div class="voucher-value">
                                                20.000đ
                                            </div>

                                            <span>20 điểm/voucher</span>

                                            <input class="form-control voucher-quantity"
                                                   type="number"
                                                   name="soLuong20"
                                                   value="0"
                                                   min="0"
                                                   max="50"
                                                   data-value="20000">
                                        </div>

                                        <div class="voucher-option">

                                            <div class="voucher-value">
                                                30.000đ
                                            </div>

                                            <span>30 điểm/voucher</span>

                                            <input class="form-control voucher-quantity"
                                                   type="number"
                                                   name="soLuong30"
                                                   value="0"
                                                   min="0"
                                                   max="50"
                                                   data-value="30000">
                                        </div>

                                        <div class="voucher-option">

                                            <div class="voucher-value">
                                                40.000đ
                                            </div>

                                            <span>40 điểm/voucher</span>

                                            <input class="form-control voucher-quantity"
                                                   type="number"
                                                   name="soLuong40"
                                                   value="0"
                                                   min="0"
                                                   max="50"
                                                   data-value="40000">
                                        </div>

                                        <div class="voucher-option">

                                            <div class="voucher-value">
                                                50.000đ
                                            </div>

                                            <span>50 điểm/voucher</span>

                                            <input class="form-control voucher-quantity"
                                                   type="number"
                                                   name="soLuong50"
                                                   value="0"
                                                   min="0"
                                                   max="50"
                                                   data-value="50000">
                                        </div>

                                    </div>

                                    <div class="voucher-exchange-summary">

                                        <div>
                                            <span>Tổng giá trị voucher</span>
                                            <strong id="voucherTotalValue">
                                                0đ
                                            </strong>
                                        </div>

                                        <div>
                                            <span>Số điểm sử dụng</span>
                                            <strong id="voucherTotalPoint">
                                                0 điểm
                                            </strong>
                                        </div>

                                        <div>
                                            <span>Điểm còn lại</span>
                                            <strong id="voucherRemainingPoint">
                                                ${diemHienTai} điểm
                                            </strong>
                                        </div>

                                    </div>

                                    <div class="form-actions">

                                        <button class="btn btn-primary"
                                                type="submit"
                                                id="exchangeVoucherButton"
                                                disabled>

                                            <i class="fa-solid fa-gift"></i>
                                            Xác nhận đổi voucher
                                        </button>

                                    </div>

                                </form>

                            </c:when>

                            <c:otherwise>

                                <div class="empty-state">

                                    <i class="fa-solid fa-star"></i>

                                    <strong>
                                        Chưa đủ điểm đổi voucher
                                    </strong>

                                    <span>
                                        Khách hàng cần tối thiểu 50 điểm.
                                        Hiện còn thiếu ${50 - diemHienTai} điểm.
                                    </span>
                                </div>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </section>

                <section class="card">

                    <div class="card-header">

                        <div>
                            <h3>Voucher của khách hàng</h3>

                            <p>
                                Voucher có thời hạn sử dụng 30 ngày.
                            </p>
                        </div>

                    </div>

                    <div class="table-wrapper">

                        <table class="data-table">

                            <thead>
                                <tr>
                                    <th>Mã voucher</th>
                                    <th>Mệnh giá</th>
                                    <th>Điểm đã đổi</th>
                                    <th>Ngày đổi</th>
                                    <th>Hạn sử dụng</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>

                            <tbody>

                                <c:choose>

                                    <c:when test="${not empty voucherList}">

                                        <c:forEach var="voucher"
                                                   items="${voucherList}">

                                            <tr>

                                                <td>
                                                    <strong>
                                                        ${voucher.maCode}
                                                    </strong>
                                                </td>

                                                <td>
                                                    <strong>
                                                        ${voucher.menhGiaHienThi}
                                                    </strong>
                                                </td>

                                                <td>
                                                    ${voucher.soDiemDaDoi}
                                                    điểm
                                                </td>

                                                <td>
                                                    ${voucher.ngayDoiHienThi}
                                                </td>

                                                <td>
                                                    ${voucher.ngayHetHanHienThi}
                                                </td>

                                                <td>

                                                    <span class="badge
                                                          ${voucher.trangThai
                                                            == 'Chưa sử dụng'
                                                            ? 'badge-success'
                                                            : voucher.trangThai
                                                            == 'Đã sử dụng'
                                                            ? 'badge-blue'
                                                            : 'badge-muted'}">

                                                        ${voucher.trangThai}
                                                    </span>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>
                                            <td colspan="6">

                                                <div class="empty-state">

                                                    <i class="fa-solid fa-ticket"></i>

                                                    <strong>
                                                        Khách hàng chưa có voucher
                                                    </strong>
                                                </div>

                                            </td>
                                        </tr>

                                    </c:otherwise>

                                </c:choose>

                            </tbody>

                        </table>

                    </div>

                </section>

            </div>

        </main>

        <script>
        const currentPoint = Number("${diemHienTai}") || 0;

        const quantityInputs =
                document.querySelectorAll(
                        ".voucher-quantity"
                        );

        const totalValueElement =
                document.getElementById(
                        "voucherTotalValue"
                        );

        const totalPointElement =
                document.getElementById(
                        "voucherTotalPoint"
                        );

        const remainingPointElement =
                document.getElementById(
                        "voucherRemainingPoint"
                        );

        const exchangeButton =
                document.getElementById(
                        "exchangeVoucherButton"
                        );

        function formatMoney(value) {
            return Number(value)
                    .toLocaleString("vi-VN")
                    + "đ";
        }

        function updateVoucherSummary() {
            let totalValue = 0;

            quantityInputs.forEach(
                    function (input) {
                        let quantity =
                                Number(input.value) || 0;

                        if (quantity < 0) {
                            quantity = 0;
                            input.value = "0";
                        }

                        totalValue +=
                                quantity
                                * Number(input.dataset.value);
                    }
            );

            const totalPoint =
                    totalValue / 1000;

            const remainingPoint =
                    currentPoint - totalPoint;

            totalValueElement.textContent =
                    formatMoney(totalValue);

            totalPointElement.textContent =
                    totalPoint + " điểm";

            remainingPointElement.textContent =
                    remainingPoint + " điểm";

            remainingPointElement.classList.toggle(
                    "text-danger",
                    remainingPoint < 0
                    );

            exchangeButton.disabled =
                    totalPoint < 50
                    || totalPoint > currentPoint;
        }

        quantityInputs.forEach(
                function (input) {
                    input.addEventListener(
                            "input",
                            updateVoucherSummary
                            );
                }
        );

        document.getElementById(
                "voucherExchangeForm"
                )?.addEventListener(
                "submit",
                function (event) {
                    const totalPoint =
                            Array.from(quantityInputs)
                            .reduce(
                                    function (total, input) {
                                        return total
                                                + (
                                                        Number(input.value)
                                                        || 0
                                                        )
                                                * Number(
                                                        input.dataset.value
                                                        )
                                                / 1000;
                                    },
                                    0
                                    );

                    if (totalPoint < 50) {
                        event.preventDefault();

                        alert(
                                "Tổng voucher tối thiểu phải là 50.000đ."
                                );

                        return;
                    }

                    if (totalPoint > currentPoint) {
                        event.preventDefault();

                        alert(
                                "Khách hàng không đủ điểm để đổi."
                                );

                        return;
                    }

                    if (
                            !window.confirm(
                                    "Xác nhận sử dụng "
                                    + totalPoint
                                    + " điểm để đổi voucher?"
                                    )
                            ) {
                        event.preventDefault();
                    }
                }
        );

        updateVoucherSummary();
        </script>

    </body>
</html>