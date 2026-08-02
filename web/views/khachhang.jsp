<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Quản lý khách hàng</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css?v=90">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=90">

    </head>

    <body>

        <jsp:include page="/views/components/sidebar.jsp">

            <jsp:param name="active"
                       value="customer"/>

        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">

                <jsp:param name="title"
                           value="Khách hàng"/>

                <jsp:param name="subtitle"
                           value="Quản lý thông tin và điểm tích lũy"/>

            </jsp:include>

            <div class="app-content">

                <c:if test="${param.success == 'edit'}">

                    <div class="alert alert-success">

                        <i class="fa-solid fa-circle-check"></i>

                        Cập nhật khách hàng thành công.

                    </div>

                </c:if>

                <c:if test="${param.success == 'delete'}">

                    <div class="alert alert-success">

                        <i class="fa-solid fa-circle-check"></i>

                        Xóa khách hàng thành công.

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

                        <h2>Danh sách khách hàng</h2>

                        <p>
                            Khách hàng mới được tạo trong quá trình thanh toán hóa đơn.
                        </p>

                    </div>

                </div>

                <div class="toolbar">

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="text"
                               id="customerSearch"
                               placeholder="Tìm mã, tên hoặc số điện thoại..."
                               autocomplete="off">

                    </div>

                </div>

                <section class="card">

                    <div class="table-wrapper">

                        <table class="data-table">

                            <thead>

                                <tr>

                                    <th>Mã khách hàng</th>
                                    <th>Họ và tên</th>
                                    <th>Số điện thoại</th>
                                    <th>Điểm tích lũy</th>
                                    <th>Thao tác</th>

                                </tr>

                            </thead>

                            <tbody>

                                <c:choose>

                                    <c:when test="${not empty listKH}">

                                        <c:forEach var="kh"
                                                   items="${listKH}">

                                            <tr class="customer-row"
                                                data-search="${kh.maKH}
                                                             ${kh.hoTen}
                                                             ${kh.sdt}">

                                                <td>

                                                    <strong>

                                                        <c:out value="${kh.maKH}"/>

                                                    </strong>

                                                </td>

                                                <td>

                                                    <c:out value="${kh.hoTen}"/>

                                                </td>

                                                <td>

                                                    <c:choose>

                                                        <c:when test="${not empty kh.sdt}">

                                                            <c:out value="${kh.sdt}"/>

                                                        </c:when>

                                                        <c:otherwise>
                                                            —
                                                        </c:otherwise>

                                                    </c:choose>

                                                </td>

                                                <td>

                                                    <div class="customer-point-cell">

                                                        <span class="badge badge-warning">

                                                            <i class="fa-solid fa-star"></i>

                                                            ${kh.diemTichLuy} điểm

                                                        </span>

                                                        <c:if test="${kh.diemTichLuy >= 50}">

                                                            <span class="badge badge-success">

                                                                Có thể đổi voucher

                                                            </span>

                                                        </c:if>

                                                    </div>

                                                </td>

                                                <td>

                                                    <div class="table-actions">

                                                        <button type="button"
                                                                class="table-action"
                                                                title="Cập nhật"
                                                                onclick="openCustomerModal(
                                                                    '${pageContext.request.contextPath}/khachhang?action=loadForm&maKH=${kh.maKH}',
                                                                    'Cập nhật khách hàng'
                                                                )">

                                                            <i class="fa-solid fa-pen"></i>

                                                        </button>

                                                        <a class="table-action"
                                                           href="${pageContext.request.contextPath}/khachhang/voucher?maKH=${kh.maKH}"
                                                           title="Đổi voucher">

                                                            <i class="fa-solid fa-gift"></i>

                                                        </a>

                                                        <a class="table-action"
                                                           href="${pageContext.request.contextPath}/khachhang?action=delete&maKH=${kh.maKH}"
                                                           title="Xóa"
                                                           onclick="return confirm(
                                                               'Xác nhận xóa khách hàng này?'
                                                           )">

                                                            <i class="fa-solid fa-trash-can"></i>

                                                        </a>

                                                    </div>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>

                                            <td colspan="5">

                                                <div class="empty-state">

                                                    <i class="fa-solid fa-users"></i>

                                                    <strong>
                                                        Chưa có khách hàng
                                                    </strong>

                                                    <span>
                                                        Khách hàng mới được tạo khi thanh toán.
                                                    </span>

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

        <div class="modal-overlay"
             id="customerModal">

            <div class="modal-dialog">

                <div class="modal-header">

                    <h3 id="customerModalTitle">
                        Thông tin khách hàng
                    </h3>

                    <button type="button"
                            class="modal-close"
                            onclick="closeCustomerModal()">

                        <i class="fa-solid fa-xmark"></i>

                    </button>

                </div>

                <div class="modal-body"
                     id="customerModalBody">

                </div>

            </div>

        </div>

        <script>

            const customerModal =
                    document.getElementById(
                            "customerModal"
                    );

            function openCustomerModal(
                    url,
                    title
            ) {
                document.getElementById(
                        "customerModalTitle"
                ).textContent = title;

                document.getElementById(
                        "customerModalBody"
                ).innerHTML =
                        '<div class="loading-state">Đang tải...</div>';

                customerModal.classList.add(
                        "show"
                );

                fetch(url)
                        .then(function (response) {
                            if (!response.ok) {
                                throw new Error(
                                        "Không tải được biểu mẫu."
                                );
                            }

                            return response.text();
                        })
                        .then(function (html) {
                            document.getElementById(
                                    "customerModalBody"
                            ).innerHTML = html;
                        })
                        .catch(function (error) {
                            document.getElementById(
                                    "customerModalBody"
                            ).innerHTML =
                                    '<div class="alert alert-danger">'
                                    + error.message
                                    + '</div>';
                        });
            }

            function closeCustomerModal() {
                customerModal.classList.remove(
                        "show"
                );
            }

            customerModal.addEventListener(
                    "click",
                    function (event) {
                        if (
                            event.target
                            === customerModal
                        ) {
                            closeCustomerModal();
                        }
                    }
            );

            document.getElementById(
                    "customerSearch"
            ).addEventListener(
                    "input",
                    function () {
                        const keyword =
                                this.value
                                        .toLowerCase()
                                        .normalize("NFD")
                                        .replace(
                                                /[\u0300-\u036f]/g,
                                                ""
                                        );

                        document.querySelectorAll(
                                ".customer-row"
                        ).forEach(
                                function (row) {
                                    const text =
                                            row.dataset.search
                                                    .toLowerCase()
                                                    .normalize("NFD")
                                                    .replace(
                                                            /[\u0300-\u036f]/g,
                                                            ""
                                                    );

                                    row.style.display =
                                            text.includes(
                                                    keyword
                                            )
                                            ? ""
                                            : "none";
                                }
                        );
                    }
            );

        </script>

    </body>

</html>