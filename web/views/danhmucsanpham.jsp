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

        <title>Danh mục sản phẩm</title>

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
                       value="category"/>
        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">
                <jsp:param name="title"
                           value="Danh mục sản phẩm"/>

                <jsp:param name="subtitle"
                           value="Phân loại các nhóm sản phẩm của quán"/>
            </jsp:include>

            <div class="app-content">

                <c:if test="${param.success == 'save'}">

                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        Lưu danh mục thành công.
                    </div>

                </c:if>

                <c:if test="${param.success == 'toggle'}">

                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        Cập nhật trạng thái danh mục thành công.
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
                        <h2>Danh mục sản phẩm</h2>

                        <p>
                            Quản lý các nhóm như cà phê, trà,
                            nước ép và đồ ăn.
                        </p>
                    </div>

                    <div class="page-actions">

                        <a class="btn btn-primary"
                           href="${pageContext.request.contextPath}/danh-muc-san-pham?action=add">

                            <i class="fa-solid fa-plus"></i>
                            Thêm danh mục
                        </a>

                    </div>

                </div>

                <section class="card">

                    <div class="table-wrapper">

                        <table class="data-table">

                            <thead>
                                <tr>
                                    <th>Mã danh mục</th>
                                    <th>Tên danh mục</th>
                                    <th>Số sản phẩm</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>

                            <tbody>

                                <c:choose>

                                    <c:when test="${not empty danhMucList}">

                                        <c:forEach var="danhMuc"
                                                   items="${danhMucList}">

                                            <tr>

                                                <td>
                                                    <strong>
                                                        ${danhMuc.maDanhMuc}
                                                    </strong>
                                                </td>

                                                <td>
                                                    <c:out value="${danhMuc.tenDanhMuc}"/>
                                                </td>

                                                <td>
                                                    ${danhMuc.soLuongSanPham}
                                                </td>

                                                <td>

                                                    <span class="badge
                                                          ${danhMuc.trangThai
                                                            ? 'badge-success'
                                                            : 'badge-muted'}">

                                                        ${danhMuc.trangThai
                                                          ? 'Đang hoạt động'
                                                          : 'Đã tạm dừng'}
                                                    </span>

                                                </td>

                                                <td>

                                                    <div class="table-actions">

                                                        <a class="table-action"
                                                           href="${pageContext.request.contextPath}/danh-muc-san-pham?action=edit&id=${danhMuc.maDanhMuc}"
                                                           title="Sửa">

                                                            <i class="fa-solid fa-pen"></i>
                                                        </a>

                                                        <form action="${pageContext.request.contextPath}/danh-muc-san-pham"
                                                              method="post">

                                                            <input type="hidden"
                                                                   name="action"
                                                                   value="toggle">

                                                            <input type="hidden"
                                                                   name="id"
                                                                   value="${danhMuc.maDanhMuc}">

                                                            <button class="table-action"
                                                                    type="submit"
                                                                    title="Đổi trạng thái">

                                                                <i class="fa-solid fa-power-off"></i>
                                                            </button>

                                                        </form>

                                                    </div>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>
                                            <td colspan="5">

                                                <div class="empty-state">
                                                    <i class="fa-solid fa-layer-group"></i>

                                                    <strong>
                                                        Chưa có danh mục sản phẩm
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
             ${showDanhMucModal ? 'show' : ''}">

            <div class="modal-dialog">

                <div class="modal-header">

                    <h3>
                        ${empty danhMucEdit
                          ? 'Thêm danh mục'
                          : 'Cập nhật danh mục'}
                    </h3>

                    <a class="modal-close"
                       href="${pageContext.request.contextPath}/danh-muc-san-pham">

                        <i class="fa-solid fa-xmark"></i>
                    </a>

                </div>

                <div class="modal-body">

                    <form action="${pageContext.request.contextPath}/danh-muc-san-pham"
                          method="post">

                        <input type="hidden"
                               name="mode"
                               value="${empty danhMucEdit ? 'add' : 'edit'}">

                        <div class="form-grid">

                            <div class="form-group">

                                <label class="form-label">
                                    Mã danh mục
                                </label>

                                <input class="form-control"
                                       type="text"
                                       name="maDanhMuc"
                                       value="${danhMucEdit.maDanhMuc}"
                                       maxlength="20"
                                       placeholder="Ví dụ: DM05"
                                       ${not empty danhMucEdit
                                         ? 'readonly'
                                         : ''}
                                       required>
                            </div>

                            <div class="form-group">

                                <label class="form-label">
                                    Tên danh mục
                                </label>

                                <input class="form-control"
                                       type="text"
                                       name="tenDanhMuc"
                                       value="${danhMucEdit.tenDanhMuc}"
                                       maxlength="100"
                                       required>
                            </div>

                            <div class="form-group full">

                                <label class="checkbox-item">

                                    <input type="checkbox"
                                           name="trangThai"
                                           ${empty danhMucEdit
                                             or danhMucEdit.trangThai
                                             ? 'checked'
                                             : ''}>

                                    Cho phép sử dụng danh mục
                                </label>

                            </div>

                        </div>

                        <div class="form-actions">

                            <a class="btn btn-outline"
                               href="${pageContext.request.contextPath}/danh-muc-san-pham">

                                Hủy
                            </a>

                            <button class="btn btn-primary"
                                    type="submit">

                                <i class="fa-solid fa-floppy-disk"></i>
                                Lưu danh mục
                            </button>

                        </div>

                    </form>

                </div>

            </div>

        </div>

    </body>
</html>