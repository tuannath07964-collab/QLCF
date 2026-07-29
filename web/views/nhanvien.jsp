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

    <title>Quản lý nhân viên</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">
</head>

<body>

    <jsp:include page="/views/components/sidebar.jsp">
        <jsp:param name="active"
                   value="employee"/>
    </jsp:include>

    <main class="app-main">

        <jsp:include page="/views/components/topbar.jsp">
            <jsp:param name="title"
                       value="Nhân viên"/>

            <jsp:param name="subtitle"
                       value="Quản lý thông tin, trạng thái và ca làm"/>
        </jsp:include>

        <div class="app-content">

            <c:if test="${param.success == 'add'}">

                <div class="alert alert-success">

                    <i class="fa-solid fa-circle-check"></i>

                    Đã thêm nhân viên mới.
                    Mã tài khoản:
                    <strong>${param.maNVMoi}</strong>
                </div>

            </c:if>

            <c:if test="${param.success == 'edit'}">

                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Cập nhật nhân viên thành công.
                </div>

            </c:if>

            <c:if test="${param.success == 'shift'}">

                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Phân ca làm thành công.
                </div>

            </c:if>

            <c:if test="${param.success == 'status'}">

                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Cập nhật trạng thái thành công.
                </div>

            </c:if>

            <c:if test="${not empty param.error}">

                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${param.error}
                </div>

            </c:if>

            <c:if test="${not empty errorMessage}">

                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${errorMessage}
                </div>

            </c:if>

            <div class="page-header">

                <div>
                    <h2>Danh sách nhân viên</h2>

                    <p>
                        Không xóa nhân viên, chỉ thay đổi trạng thái làm việc.
                    </p>
                </div>

                <c:if test="${sessionScope.chucVu == 'Quản lý'}">

                    <div class="page-actions">

                        <button type="button"
                                class="btn btn-primary"
                                onclick="openModal(
                                    '${pageContext.request.contextPath}/nhanvien?action=loadForm',
                                    'Thêm nhân viên'
                                )">

                            <i class="fa-solid fa-plus"></i>
                            Thêm nhân viên
                        </button>

                    </div>

                </c:if>

            </div>

            <div class="toolbar">

                <div class="toolbar-left">

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="text"
                               id="employeeSearch"
                               placeholder="Tìm mã, họ tên, số điện thoại..."
                               autocomplete="off">
                    </div>

                </div>

                <div class="toolbar-right">

                    <span class="badge badge-muted">

                        Tổng:
                        ${empty listNV ? 0 : listNV.size()}
                        nhân viên
                    </span>

                </div>

            </div>

            <section class="card">

                <div class="table-wrapper">

                    <table class="data-table">

                        <thead>
                            <tr>
                                <th>Mã NV</th>
                                <th>Nhân viên</th>
                                <th>Liên hệ</th>
                                <th>Chức vụ</th>
                                <th>Lương cơ bản</th>
                                <th>Ca làm</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>

                        <tbody id="employeeRows">

                            <c:choose>

                                <c:when test="${not empty listNV}">

                                    <c:forEach var="nv"
                                               items="${listNV}">

                                        <tr class="employee-row"
                                            data-search="${nv.maNV}
                                                         ${nv.hoTen}
                                                         ${nv.sdt}
                                                         ${nv.chucVu}
                                                         ${nv.trangThai}">

                                            <td>
                                                <strong>${nv.maNV}</strong>
                                            </td>

                                            <td class="employee-name">

                                                <strong>${nv.hoTen}</strong>

                                                <span>

                                                    ${empty nv.gioiTinh
                                                        ? 'Chưa cập nhật giới tính'
                                                        : nv.gioiTinh}

                                                    <c:if test="${not empty nv.ngaySinh}">
                                                        ·

                                                        <fmt:formatDate
                                                            value="${nv.ngaySinh}"
                                                            pattern="dd/MM/yyyy"/>
                                                    </c:if>

                                                </span>
                                            </td>

                                            <td>
                                                ${empty nv.sdt ? '—' : nv.sdt}
                                            </td>

                                            <td>

                                                <span class="badge ${nv.chucVu == 'Quản lý'
                                                    ? 'badge-purple'
                                                    : 'badge-blue'}">

                                                    ${nv.chucVu}
                                                </span>
                                            </td>

                                            <td>

                                                <fmt:formatNumber
                                                    value="${nv.luongCoBan}"
                                                    pattern="#,##0"/>

                                                đ
                                            </td>

                                            <td>

                                                <div class="shift-badges">

                                                    <c:if test="${nv.caSang}">
                                                        <span class="badge badge-muted">
                                                            Sáng
                                                        </span>
                                                    </c:if>

                                                    <c:if test="${nv.caChieu}">
                                                        <span class="badge badge-muted">
                                                            Chiều
                                                        </span>
                                                    </c:if>

                                                    <c:if test="${nv.caToi}">
                                                        <span class="badge badge-muted">
                                                            Tối
                                                        </span>
                                                    </c:if>

                                                    <c:if test="${not nv.caSang
                                                                  and not nv.caChieu
                                                                  and not nv.caToi}">

                                                        <span class="badge badge-warning">
                                                            Chưa phân ca
                                                        </span>
                                                    </c:if>

                                                </div>

                                                <c:if test="${not empty nv.gioBatDau
                                                              and not empty nv.gioKetThuc}">

                                                    <small>
                                                        ${nv.gioBatDau}
                                                        -
                                                        ${nv.gioKetThuc}
                                                    </small>
                                                </c:if>

                                            </td>

                                            <td>

                                                <c:choose>

                                                    <c:when test="${sessionScope.chucVu == 'Quản lý'}">

                                                        <form action="${pageContext.request.contextPath}/nhanvien"
                                                              method="post">

                                                            <input type="hidden"
                                                                   name="action"
                                                                   value="updateStatus">

                                                            <input type="hidden"
                                                                   name="maNV"
                                                                   value="${nv.maNV}">

                                                            <select class="status-select"
                                                                    name="trangThai"
                                                                    onchange="this.form.submit()">

                                                                <option value="Đang làm"
                                                                        ${nv.trangThai == 'Đang làm'
                                                                            ? 'selected'
                                                                            : ''}>

                                                                    Đang làm
                                                                </option>

                                                                <option value="Tạm nghỉ"
                                                                        ${nv.trangThai == 'Tạm nghỉ'
                                                                            ? 'selected'
                                                                            : ''}>

                                                                    Tạm nghỉ
                                                                </option>

                                                                <option value="Nghỉ làm"
                                                                        ${nv.trangThai == 'Nghỉ làm'
                                                                            ? 'selected'
                                                                            : ''}>

                                                                    Nghỉ làm
                                                                </option>

                                                            </select>

                                                        </form>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="badge
                                                              ${nv.trangThai == 'Đang làm'
                                                                ? 'badge-success'
                                                                : nv.trangThai == 'Tạm nghỉ'
                                                                    ? 'badge-warning'
                                                                    : 'badge-danger'}">

                                                            ${nv.trangThai}
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </td>

                                            <td>

                                                <c:choose>

                                                    <c:when test="${sessionScope.chucVu == 'Quản lý'}">

                                                        <div class="table-actions">

                                                            <button type="button"
                                                                    class="table-action"
                                                                    title="Sửa nhân viên"
                                                                    onclick="openModal(
                                                                        '${pageContext.request.contextPath}/nhanvien?action=loadForm&maNV=${nv.maNV}',
                                                                        'Cập nhật nhân viên'
                                                                    )">

                                                                <i class="fa-solid fa-pen"></i>
                                                            </button>

                                                            <button type="button"
                                                                    class="table-action"
                                                                    title="Phân ca"
                                                                    onclick="openModal(
                                                                        '${pageContext.request.contextPath}/nhanvien?action=loadCa&maNV=${nv.maNV}',
                                                                        'Phân ca làm'
                                                                    )">

                                                                <i class="fa-regular fa-clock"></i>
                                                            </button>

                                                        </div>

                                                    </c:when>

                                                    <c:otherwise>
                                                        —
                                                    </c:otherwise>

                                                </c:choose>

                                            </td>

                                        </tr>

                                    </c:forEach>

                                </c:when>

                                <c:otherwise>

                                    <tr>
                                        <td colspan="8">

                                            <div class="empty-state">

                                                <i class="fa-solid fa-user-group"></i>

                                                <strong>
                                                    Chưa có nhân viên
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

    <div class="modal-overlay"
         id="myModal">

        <div class="modal-dialog large">

            <div class="modal-header">

                <h3 id="modalTitle">
                    Thông tin nhân viên
                </h3>

                <button type="button"
                        class="modal-close"
                        onclick="closeModal()">

                    <i class="fa-solid fa-xmark"></i>
                </button>

            </div>

            <div class="modal-body"
                 id="modalBody"></div>

        </div>

    </div>

    <script>
        const employeeModal =
                document.getElementById("myModal");

        function openModal(url, title) {
            document.getElementById("modalTitle")
                    .textContent = title;

            document.getElementById("modalBody")
                    .innerHTML =
                    '<div class="loading-state">Đang tải...</div>';

            employeeModal.classList.add("show");

            fetch(url)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error("Không tải được biểu mẫu.");
                        }

                        return response.text();
                    })
                    .then(html => {
                        document.getElementById("modalBody")
                                .innerHTML = html;
                    })
                    .catch(error => {
                        document.getElementById("modalBody")
                                .innerHTML =
                                '<div class="alert alert-danger">'
                                + error.message
                                + '</div>';
                    });
        }

        function closeModal() {
            employeeModal.classList.remove("show");
        }

        function toggleModalPassword() {
            const input =
                    document.getElementById("passwordInput");

            const icon =
                    document.getElementById("passwordToggleIcon");

            if (!input || !icon) {
                return;
            }

            input.type =
                    input.type === "password"
                    ? "text"
                    : "password";

            icon.classList.toggle("fa-eye");
            icon.classList.toggle("fa-eye-slash");
        }

        employeeModal.addEventListener(
                "click",
                function (event) {
                    if (event.target === employeeModal) {
                        closeModal();
                    }
                }
        );

        document.getElementById("employeeSearch")
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

                            document.querySelectorAll(".employee-row")
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