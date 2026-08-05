<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fn"
           uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Kho nguyên liệu</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css?v=50">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=50">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/cafe-theme.css?v=2">
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
                           value="Toàn bộ nguyên liệu sử dụng chung đơn vị thống nhất"/>
            </jsp:include>

            <div class="app-content">

                <c:if test="${param.success == 'save'}">

                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        Lưu nguyên liệu thành công.
                    </div>

                </c:if>

                <c:if test="${param.success == 'restock'}">

                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        Nhập kho theo mức cố định thành công.
                    </div>

                </c:if>

                <c:if test="${not empty errorMessage}">

                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <c:out value="${errorMessage}"/>
                    </div>

                </c:if>

                <c:set var="soLuongSapHet"
                       value="0"/>

                <c:set var="soLuongHet"
                       value="0"/>

                <c:forEach var="nguyenLieu"
                           items="${nguyenLieuList}">

                    <c:if test="${nguyenLieu.sapHet}">
                        <c:set var="soLuongSapHet"
                               value="${soLuongSapHet + 1}"/>
                    </c:if>

                    <c:if test="${nguyenLieu.hetHang}">
                        <c:set var="soLuongHet"
                               value="${soLuongHet + 1}"/>
                    </c:if>

                </c:forEach>

                <section class="summary-grid">

                    <article class="summary-card">

                        <div class="summary-icon blue">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>

                        <div class="summary-content">
                            <span>Tổng nguyên liệu</span>
                            <strong>${fn:length(nguyenLieuList)}</strong>
                        </div>

                    </article>

                    <article class="summary-card">

                        <div class="summary-icon orange">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>

                        <div class="summary-content">
                            <span>Sắp hết</span>
                            <strong>${soLuongSapHet}</strong>
                        </div>

                    </article>

                    <article class="summary-card">

                        <div class="summary-icon red">
                            <i class="fa-solid fa-circle-xmark"></i>
                        </div>

                        <div class="summary-content">
                            <span>Hết hàng</span>
                            <strong>${soLuongHet}</strong>
                        </div>

                    </article>

                </section>

                <div class="page-header">

                    <div>
                        <h2>Danh sách nguyên liệu</h2>

                        <p>
                            Nhấn nhập kho để cộng đúng mức nhập
                            đã được cấu hình cho nguyên liệu.
                        </p>
                    </div>

                    <div class="page-actions">

                        <a class="btn btn-primary"
                           href="${pageContext.request.contextPath}/KhoServlet?action=form">

                            <i class="fa-solid fa-plus"></i>
                            Thêm nguyên liệu
                        </a>

                    </div>

                </div>

                <div class="toolbar">

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="text"
                               id="warehouseSearch"
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
                                    <th>Tồn kho</th>
                                    <th>Mức nhập cố định</th>
                                    <th>Trạng thái</th>
                                    <th>Sản phẩm sử dụng</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>

                            <tbody>

                                <c:choose>

                                    <c:when test="${not empty nguyenLieuList}">

                                        <c:forEach var="nguyenLieu"
                                                   items="${nguyenLieuList}">

                                            <tr class="warehouse-row"
                                                data-search="${nguyenLieu.maNguyenLieu}
                                                ${nguyenLieu.tenNguyenLieu}
                                                ${nguyenLieu.sanPhamSuDung}">

                                                <td>
                                                    <strong>
                                                        ${nguyenLieu.maNguyenLieu}
                                                    </strong>
                                                </td>

                                                <td>
                                                    <strong>
                                                        <c:out value="${nguyenLieu.tenNguyenLieu}"/>
                                                    </strong>
                                                </td>

                                                <td>

                                                    <span class="stock-value
                                                          ${nguyenLieu.hetHang
                                                            ? 'empty'
                                                            : nguyenLieu.sapHet
                                                            ? 'low'
                                                            : ''}">

                                                        ${nguyenLieu.soLuongTon}
                                                        ${nguyenLieu.donVi}
                                                    </span>

                                                </td>

                                                <td>
                                                    +${nguyenLieu.mucNhapCoDinh}
                                                    ${nguyenLieu.donVi}
                                                </td>

                                                <td>

                                                    <span class="badge
                                                          ${nguyenLieu.hetHang
                                                            ? 'badge-danger'
                                                            : nguyenLieu.sapHet
                                                            ? 'badge-warning'
                                                            : nguyenLieu.trangThai
                                                            ? 'badge-success'
                                                            : 'badge-muted'}">

                                                        ${nguyenLieu.trangThaiKho}
                                                    </span>

                                                </td>

                                                <td class="recipe-text">

                                                    <c:choose>

                                                        <c:when test="${not empty nguyenLieu.sanPhamSuDung}">
                                                            <c:out value="${nguyenLieu.sanPhamSuDung}"/>
                                                        </c:when>

                                                        <c:otherwise>
                                                            Chưa có sản phẩm sử dụng
                                                        </c:otherwise>

                                                    </c:choose>

                                                </td>

                                                <td>

                                                    <div class="table-actions">

                                                        <form action="${pageContext.request.contextPath}/KhoServlet"
                                                              method="post">

                                                            <input type="hidden"
                                                                   name="action"
                                                                   value="restock">

                                                            <input type="hidden"
                                                                   name="id"
                                                                   value="${nguyenLieu.maNguyenLieu}">

                                                            <button class="table-action stock-action"
                                                                    type="submit"
                                                                    title="Nhập kho">

                                                                <i class="fa-solid fa-box-open"></i>
                                                            </button>

                                                        </form>

                                                        <a class="table-action"
                                                           href="${pageContext.request.contextPath}/KhoServlet?action=form&id=${nguyenLieu.maNguyenLieu}"
                                                           title="Cập nhật">

                                                            <i class="fa-solid fa-pen"></i>
                                                        </a>

                                                    </div>

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

        <div class="modal-overlay
             ${showKhoModal ? 'show' : ''}">

            <div class="modal-dialog">

                <div class="modal-header">

                    <h3>
                        ${empty nguyenLieuEdit
                          ? 'Thêm nguyên liệu'
                          : 'Cập nhật nguyên liệu'}
                    </h3>

                    <a class="modal-close"
                       href="${pageContext.request.contextPath}/KhoServlet">

                        <i class="fa-solid fa-xmark"></i>
                    </a>

                </div>

                <div class="modal-body">

                    <form action="${pageContext.request.contextPath}/KhoServlet"
                          method="post">

                        <input type="hidden"
                               name="mode"
                               value="${empty nguyenLieuEdit ? 'add' : 'edit'}">

                        <div class="form-grid">

                            <div class="form-group">

                                <label class="form-label">
                                    Mã nguyên liệu
                                </label>

                                <input class="form-control"
                                       type="text"
                                       name="maNguyenLieu"
                                       value="${nguyenLieuEdit.maNguyenLieu}"
                                       maxlength="20"
                                       placeholder="Ví dụ: NL31"
                                       ${not empty nguyenLieuEdit
                                         ? 'readonly'
                                         : ''}
                                       required>
                            </div>

                            <div class="form-group">

                                <label class="form-label">
                                    Tên nguyên liệu
                                </label>

                                <input class="form-control"
                                       type="text"
                                       name="tenNguyenLieu"
                                       value="${nguyenLieuEdit.tenNguyenLieu}"
                                       maxlength="100"
                                       required>
                            </div>

                            <div class="form-group">

                                <label class="form-label">
                                    Tồn kho ban đầu
                                </label>

                                <input class="form-control"
                                       type="number"
                                       name="soLuongTon"
                                       value="${empty nguyenLieuEdit
                                                ? 0
                                                : nguyenLieuEdit.soLuongTon}"
                                       min="0"
                                       step="1"
                                       ${not empty nguyenLieuEdit
                                         ? 'readonly'
                                         : ''}
                                       required>

                                <span class="form-hint">
                                    Sau khi tạo, tồn kho chỉ thay đổi bằng
                                    nhập kho hoặc thanh toán hóa đơn.
                                </span>
                            </div>

                            <div class="form-group">

                                <label class="form-label">
                                    Mức nhập cố định
                                </label>

                                <input class="form-control"
                                       type="number"
                                       name="mucNhapCoDinh"
                                       value="${empty nguyenLieuEdit
                                                ? 100
                                                : nguyenLieuEdit.mucNhapCoDinh}"
                                       min="1"
                                       step="1"
                                       required>

                                <span class="form-hint">
                                    Mỗi lần nhập sẽ cộng đúng số lượng này.
                                </span>
                            </div>

                            <div class="form-group">

                                <label class="form-label">
                                    Đơn vị
                                </label>

                                <select class="form-control"
                                        name="donVi"
                                        required>

                                    <c:forEach var="donVi"
                                               items="${donViList}">

                                        <option value="${donVi}"
                                                ${empty nguyenLieuEdit
                                                  ? donVi == 'g' ? 'selected' : ''
                                                  : nguyenLieuEdit.donVi == donVi
                                                  ? 'selected'
                                                  : ''}>

                                            ${donVi}
                                        </option>

                                    </c:forEach>

                                </select>

                                <span class="form-hint">
                                    Công thức sản phẩm sẽ trừ kho theo đơn vị này.
                                </span>

                            </div>

                            <div class="form-group">

                                <label class="checkbox-item">

                                    <input type="checkbox"
                                           name="trangThai"
                                           ${empty nguyenLieuEdit
                                             or nguyenLieuEdit.trangThai
                                             ? 'checked'
                                             : ''}>

                                    Đang sử dụng
                                </label>

                            </div>

                        </div>

                        <div class="form-actions">

                            <a class="btn btn-outline"
                               href="${pageContext.request.contextPath}/KhoServlet">

                                Hủy
                            </a>

                            <button class="btn btn-primary"
                                    type="submit">

                                <i class="fa-solid fa-floppy-disk"></i>
                                Lưu nguyên liệu
                            </button>

                        </div>

                    </form>

                </div>

            </div>

        </div>

        <script>
            const warehouseSearch =
                    document.getElementById("warehouseSearch");

            function normalizeText(value) {
                return (value || "")
                        .toLowerCase()
                        .normalize("NFD")
                        .replace(/[\u0300-\u036f]/g, "");
            }

            warehouseSearch.addEventListener(
                    "input",
                    function () {
                        const keyword =
                                normalizeText(this.value);

                        document.querySelectorAll(".warehouse-row")
                                .forEach(function (row) {
                                    const text =
                                            normalizeText(
                                                    row.dataset.search
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