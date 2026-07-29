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

    <title>Quản lý kho</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">
</head>

<body>

    <jsp:include page="/views/components/sidebar.jsp">
        <jsp:param name="active"
                   value="warehouse"/>
    </jsp:include>

    <main class="app-main">

        <jsp:include page="/views/components/topbar.jsp">
            <jsp:param name="title"
                       value="Kho nguyên liệu"/>

            <jsp:param name="subtitle"
                       value="Theo dõi số lượng nguyên liệu hiện có"/>
        </jsp:include>

        <div class="app-content">

            <c:if test="${param.success == 'add'}">

                <div class="alert alert-success">

                    <i class="fa-solid fa-circle-check"></i>
                    Thêm nguyên liệu thành công.
                </div>

            </c:if>

            <c:if test="${param.success == 'edit'}">

                <div class="alert alert-success">

                    <i class="fa-solid fa-circle-check"></i>
                    Cập nhật nguyên liệu thành công.
                </div>

            </c:if>

            <c:if test="${not empty errorMessage}">

                <div class="alert alert-danger">

                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${errorMessage}
                </div>

            </c:if>

            <c:set var="tongNguyenLieu"
                   value="0"/>

            <c:set var="sapHet"
                   value="0"/>

            <c:set var="hetHang"
                   value="0"/>

            <c:forEach var="item"
                       items="${dsKho}">

                <c:set var="tongNguyenLieu"
                       value="${tongNguyenLieu + 1}"/>

                <c:if test="${item.sapHetHang}">
                    <c:set var="sapHet"
                           value="${sapHet + 1}"/>
                </c:if>

                <c:if test="${item.hetHang}">
                    <c:set var="hetHang"
                           value="${hetHang + 1}"/>
                </c:if>

            </c:forEach>

            <section class="summary-grid">

                <div class="summary-card">

                    <div class="summary-icon blue">
                        <i class="fa-solid fa-boxes-stacked"></i>
                    </div>

                    <div class="summary-content">
                        <span>Tổng nguyên liệu</span>
                        <strong>${tongNguyenLieu}</strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon orange">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>

                    <div class="summary-content">
                        <span>Sắp hết</span>
                        <strong>${sapHet}</strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon red">
                        <i class="fa-solid fa-circle-xmark"></i>
                    </div>

                    <div class="summary-content">
                        <span>Hết hàng</span>
                        <strong>${hetHang}</strong>
                    </div>

                </div>

            </section>

            <div class="page-header">

                <div>
                    <h2>Danh sách nguyên liệu</h2>

                    <p>
                        Kho không hỗ trợ xóa, chỉ thêm hoặc cập nhật số lượng.
                    </p>
                </div>

                <div class="page-actions">

                    <a class="btn btn-primary"
                       href="${pageContext.request.contextPath}/KhoServlet?action=loadForm">

                        <i class="fa-solid fa-plus"></i>
                        Thêm nguyên liệu
                    </a>

                </div>

            </div>

            <div class="toolbar">

                <div class="search-box">

                    <i class="fa-solid fa-magnifying-glass"></i>

                    <input type="text"
                           id="inventorySearch"
                           placeholder="Tìm mã hoặc tên nguyên liệu..."
                           autocomplete="off">
                </div>

            </div>

            <section class="card">

                <div class="table-wrapper">

                    <table class="data-table">

                        <thead>
                            <tr>
                                <th>Mã NL</th>
                                <th>Nguyên liệu</th>
                                <th>Số lượng</th>
                                <th>Đơn vị</th>
                                <th>Trạng thái</th>
                                <th>Công thức sử dụng</th>
                                <th></th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:choose>

                                <c:when test="${not empty dsKho}">

                                    <c:forEach var="item"
                                               items="${dsKho}">

                                        <tr class="inventory-row"
                                            data-search="${item.maNL}
                                                         ${item.tenNL}
                                                         ${item.donVi}
                                                         ${item.trangThaiKho}">

                                            <td>
                                                <strong>${item.maNL}</strong>
                                            </td>

                                            <td class="inventory-name">

                                                <strong>${item.tenNL}</strong>

                                                <span>
                                                    Nguyên liệu kho
                                                </span>
                                            </td>

                                            <td>

                                                <span class="stock-number
                                                      ${item.hetHang
                                                        ? 'empty'
                                                        : item.sapHetHang
                                                            ? 'low'
                                                            : ''}">

                                                    <fmt:formatNumber
                                                        value="${item.soLuong}"
                                                        pattern="#,##0.##"/>
                                                </span>

                                            </td>

                                            <td>${item.donVi}</td>

                                            <td>

                                                <span class="badge
                                                      ${item.hetHang
                                                        ? 'badge-danger'
                                                        : item.sapHetHang
                                                            ? 'badge-warning'
                                                            : 'badge-success'}">

                                                    ${item.trangThaiKho}
                                                </span>
                                            </td>

                                            <td>
                                                ${empty item.congThucSuDung
                                                    ? 'Chưa được sử dụng trong công thức'
                                                    : item.congThucSuDung}
                                            </td>

                                            <td>

                                                <a class="table-action"
                                                   href="${pageContext.request.contextPath}/KhoServlet?action=loadForm&maNL=${item.maNL}"
                                                   title="Cập nhật">

                                                    <i class="fa-solid fa-pen"></i>
                                                </a>
                                            </td>

                                        </tr>

                                    </c:forEach>

                                </c:when>

                                <c:otherwise>

                                    <tr>
                                        <td colspan="7">

                                            <div class="empty-state">

                                                <i class="fa-solid fa-box-open"></i>

                                                <strong>
                                                    Chưa có nguyên liệu
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

    <div class="modal-overlay ${showModal ? 'show' : ''}"
         id="inventoryModal">

        <div class="modal-dialog">

            <div class="modal-header">

                <h3>
                    ${mode == 'edit'
                        ? 'Cập nhật nguyên liệu'
                        : 'Thêm nguyên liệu'}
                </h3>

                <a class="modal-close"
                   href="${pageContext.request.contextPath}/KhoServlet">

                    <i class="fa-solid fa-xmark"></i>
                </a>

            </div>

            <div class="modal-body">

                <c:if test="${not empty errorMessage}">

                    <div class="alert alert-danger">

                        <i class="fa-solid fa-circle-exclamation"></i>
                        ${errorMessage}
                    </div>

                </c:if>

                <form action="${pageContext.request.contextPath}/KhoServlet"
                      method="post">

                    <input type="hidden"
                           name="action"
                           value="${mode == 'edit' ? 'edit' : 'add'}">

                    <div class="form-grid">

                        <div class="form-group">

                            <label class="form-label">
                                Mã nguyên liệu
                            </label>

                            <c:choose>

                                <c:when test="${mode == 'edit'}">

                                    <input type="hidden"
                                           name="maNL"
                                           value="${nl.maNL}">

                                    <input class="form-control"
                                           type="text"
                                           value="${nl.maNL}"
                                           readonly>
                                </c:when>

                                <c:otherwise>

                                    <input class="form-control"
                                           type="text"
                                           name="maNL"
                                           maxlength="20"
                                           required>
                                </c:otherwise>

                            </c:choose>

                        </div>

                        <div class="form-group">

                            <label class="form-label">
                                Tên nguyên liệu
                            </label>

                            <input class="form-control"
                                   type="text"
                                   name="tenNL"
                                   value="${nl.tenNL}"
                                   maxlength="100"
                                   required>
                        </div>

                        <div class="form-group">

                            <label class="form-label">
                                Số lượng
                            </label>

                            <input class="form-control"
                                   type="number"
                                   name="soLuong"
                                   value="${empty nl.soLuong ? 0 : nl.soLuong}"
                                   min="0"
                                   step="0.01"
                                   required>
                        </div>

                        <div class="form-group">

                            <label class="form-label">
                                Đơn vị
                            </label>

                            <input class="form-control"
                                   type="text"
                                   name="donVi"
                                   value="${nl.donVi}"
                                   maxlength="30"
                                   placeholder="kg, hộp, chai..."
                                   required>
                        </div>

                    </div>

                    <div class="form-actions">

                        <a class="btn btn-outline"
                           href="${pageContext.request.contextPath}/KhoServlet">

                            Hủy
                        </a>

                        <button type="submit"
                                class="btn btn-primary">

                            <i class="fa-solid fa-floppy-disk"></i>
                            Lưu nguyên liệu
                        </button>

                    </div>

                </form>

            </div>

        </div>

    </div>

    <script>
        document.getElementById("inventorySearch")
                .addEventListener(
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

                            document.querySelectorAll(".inventory-row")
                                    .forEach(row => {
                                        const text =
                                                row.dataset.search
                                                        .toLowerCase()
                                                        .normalize("NFD")
                                                        .replace(
                                                                /[\u0300-\u036f]/g,
                                                                ""
                                                        );

                                        row.style.display =
                                                text.includes(keyword)
                                                ? ""
                                                : "none";
                                    });
                        }
                );
    </script>

</body>
</html>