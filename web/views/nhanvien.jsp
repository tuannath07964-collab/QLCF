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

    <title>Quản lý nhân viên</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/nhanvien.css">

    <style>
        .status-form {
            display: flex;
            gap: 6px;
            align-items: center;
            margin-top: 6px;
        }

        .status-form select {
            padding: 6px 8px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .status-form button {
            border: 0;
            border-radius: 6px;
            padding: 7px 9px;
            cursor: pointer;
            background: #4a372c;
            color: #fff;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
        }

        .status-working {
            background: #d1e7dd;
            color: #0f5132;
        }

        .status-break {
            background: #fff3cd;
            color: #664d03;
        }

        .status-left {
            background: #f8d7da;
            color: #842029;
        }

        .notice {
            margin: 0 0 14px;
            padding: 10px 14px;
            border-radius: 8px;
            background: #d1e7dd;
            color: #0f5132;
        }

        .notice.error {
            background: #f8d7da;
            color: #842029;
        }

        .action-link {
            display: inline-flex;
            width: 34px;
            height: 34px;
            align-items: center;
            justify-content: center;
            border-radius: 7px;
            text-decoration: none;
            margin-right: 5px;
            background: #f3f4f6;
        }

        .action-link:hover {
            background: #e5e7eb;
        }

        .no-shift {
            color: #dc3545;
            font-weight: 600;
            font-size: 13px;
        }

        .shift-time {
            white-space: nowrap;
        }
    </style>
</head>

<body>

    <aside class="sidebar">

        <div class="logo">
            <i class="fa-solid fa-mug-hot"></i>

            <span class="logo-text">
                QUẢN LÝ QUÁN CAFE
            </span>

            <button id="toggleBtn"
                    type="button">

                <i class="fa-solid fa-bars"></i>
            </button>
        </div>

        <ul class="menu">

            <li onclick="location.href='${pageContext.request.contextPath}/views/homepage.jsp'">
                <i class="fa-solid fa-house"></i>
                <span>Trang chủ</span>
            </li>

            <li class="active"
                onclick="location.href='${pageContext.request.contextPath}/nhanvien'">

                <i class="fa-solid fa-user"></i>
                <span>Nhân viên</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/hoadon'">
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

    <div class="main">

        <div class="header">

            <h2>Quản lý nhân viên</h2>

            <div class="user-profile">
                <i class="fa-solid fa-user"></i>

                <span>
                    ${sessionScope.maNV}
                    -
                    ${sessionScope.tenNV}
                </span>
            </div>

        </div>

        <div class="content">

            <c:if test="${not empty param.success}">
                <div class="notice">

                    <c:choose>

                        <c:when test="${param.success == 'add'}">
                            Đã tạo nhân viên thành công.
                            Mã đăng nhập:

                            <b>
                                ${param.maNVMoi}
                            </b>
                        </c:when>

                        <c:when test="${param.success == 'edit'}">
                            Đã cập nhật thông tin nhân viên.
                        </c:when>

                        <c:when test="${param.success == 'shift'}">
                            Đã phân ca làm việc.
                        </c:when>

                        <c:when test="${param.success == 'status'}">
                            Đã thay đổi trạng thái nhân viên.
                        </c:when>

                    </c:choose>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="notice error">
                    ${param.error}
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="notice error">
                    ${errorMessage}
                </div>
            </c:if>

            <div class="card">

                <div class="top">

                    <form class="search-form"
                          onsubmit="return false;">

                        <input type="text"
                               id="employeeSearch"
                               placeholder="Nhập mã hoặc tên nhân viên...">

                        <button type="button">
                            <i class="fa-solid fa-search"></i>
                        </button>
                    </form>

                    <c:if test="${sessionScope.chucVu == 'Quản lý'}">

                        <button type="button"
                                class="btn-add"
                                onclick="openModal(
                                    '${pageContext.request.contextPath}/nhanvien?action=loadForm',
                                    'Thêm nhân viên mới'
                                )">

                            <i class="fa-solid fa-plus"></i>
                            Thêm nhân viên
                        </button>

                    </c:if>

                </div>

                <table>

                    <thead>
                        <tr>
                            <th>Mã NV</th>
                            <th>Họ tên</th>
                            <th>SĐT</th>
                            <th>Vai trò</th>
                            <th>Ca làm</th>
                            <th>Thời gian</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>

                    <tbody id="employeeRows">

                        <c:choose>

                            <c:when test="${not empty listNV}">

                                <c:forEach var="nv"
                                           items="${listNV}">

                                    <tr data-search="${fn:toLowerCase(nv.maNV)} ${fn:toLowerCase(nv.hoTen)} ${fn:toLowerCase(nv.sdt)}">

                                        <td>
                                            ${nv.maNV}
                                        </td>

                                        <td>
                                            ${nv.hoTen}
                                        </td>

                                        <td>
                                            ${nv.sdt}
                                        </td>

                                        <td>
                                            <c:choose>

                                                <c:when test="${nv.chucVu == 'Quản lý'}">
                                                    Quản lý
                                                </c:when>

                                                <c:otherwise>
                                                    Nhân viên
                                                </c:otherwise>

                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>

                                                <c:when test="${nv.caSang or nv.caChieu or nv.caToi}">

                                                    <c:if test="${nv.caSang}">
                                                        Sáng
                                                    </c:if>

                                                    <c:if test="${nv.caChieu}">
                                                        Chiều
                                                    </c:if>

                                                    <c:if test="${nv.caToi}">
                                                        Tối
                                                    </c:if>

                                                </c:when>

                                                <c:otherwise>
                                                    <span class="no-shift">
                                                        Chưa phân ca
                                                    </span>
                                                </c:otherwise>

                                            </c:choose>
                                        </td>

                                        <td class="shift-time">

                                            <c:choose>

                                                <c:when test="${not empty nv.gioBatDau and not empty nv.gioKetThuc}">

                                                    ${fn:substring(nv.gioBatDau, 0, 5)}
                                                    -
                                                    ${fn:substring(nv.gioKetThuc, 0, 5)}

                                                </c:when>

                                                <c:otherwise>
                                                    --:--
                                                </c:otherwise>

                                            </c:choose>
                                        </td>

                                        <td>

                                            <span class="status-badge
                                                  ${nv.trangThai == 'Đang làm'
                                                    ? 'status-working'
                                                    : (nv.trangThai == 'Tạm nghỉ'
                                                        ? 'status-break'
                                                        : 'status-left')}">

                                                ${empty nv.trangThai
                                                    ? 'Đang làm'
                                                    : nv.trangThai}
                                            </span>

                                            <c:if test="${sessionScope.chucVu == 'Quản lý'}">

                                                <form class="status-form"
                                                      action="${pageContext.request.contextPath}/nhanvien"
                                                      method="post">

                                                    <input type="hidden"
                                                           name="action"
                                                           value="updateStatus">

                                                    <input type="hidden"
                                                           name="maNV"
                                                           value="${nv.maNV}">

                                                    <select name="trangThai">

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

                                                    <button type="submit"
                                                            title="Lưu trạng thái">

                                                        <i class="fa-solid fa-check"></i>
                                                    </button>

                                                </form>

                                            </c:if>

                                        </td>

                                        <td>

                                            <c:if test="${sessionScope.chucVu == 'Quản lý'}">

                                                <a class="action-link"
                                                   href="javascript:void(0)"
                                                   title="Sửa nhân viên"
                                                   onclick="openModal(
                                                       '${pageContext.request.contextPath}/nhanvien?action=loadForm&maNV=${nv.maNV}',
                                                       'Sửa thông tin nhân viên'
                                                   )">

                                                    <i class="fa-solid fa-pen"
                                                       style="color:#d39e00;"></i>
                                                </a>

                                                <a class="action-link"
                                                   href="javascript:void(0)"
                                                   title="Phân ca"
                                                   onclick="openCaModal('${nv.maNV}')">

                                                    <i class="fa-solid fa-clock"
                                                       style="color:#0d6efd;"></i>
                                                </a>

                                            </c:if>

                                            <c:if test="${sessionScope.chucVu != 'Quản lý'}">
                                                Chỉ xem
                                            </c:if>

                                        </td>

                                    </tr>

                                </c:forEach>

                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="8"
                                        style="text-align:center;padding:30px;">

                                        Chưa có nhân viên nào.
                                    </td>
                                </tr>
                            </c:otherwise>

                        </c:choose>

                    </tbody>
                </table>

            </div>
        </div>
    </div>

    <div id="myModal"
         style="
         display:none;
         position:fixed;
         inset:0;
         background:rgba(0,0,0,.5);
         z-index:9999;
         justify-content:center;
         align-items:center;">

        <div style="
             background:white;
             padding:25px;
             border-radius:12px;
             width:500px;
             max-width:calc(100% - 30px);
             box-shadow:0 4px 15px rgba(0,0,0,.2);
             position:relative;
             max-height:90vh;
             overflow-y:auto;">

            <span onclick="closeModal()"
                  style="
                  position:absolute;
                  right:20px;
                  top:10px;
                  font-size:28px;
                  cursor:pointer;
                  font-weight:bold;">

                &times;
            </span>

            <h3 id="modalTitle"
                style="margin-top:0;"></h3>

            <hr>

            <div id="modalBody"></div>
        </div>
    </div>

    <script>
        const contextPath =
                "${pageContext.request.contextPath}";

        function openModal(url, title) {
            document.getElementById(
                    "modalTitle"
            ).innerText = title;

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
                                "modalBody"
                        ).innerHTML = html;

                        document.getElementById(
                                "myModal"
                        ).style.display = "flex";
                    })
                    .catch(function (error) {
                        alert(error.message);
                    });
        }

        function openCaModal(maNV) {
            openModal(
                    contextPath
                    + "/nhanvien?action=loadCa&maNV="
                    + encodeURIComponent(maNV),
                    "Phân ca làm việc"
            );
        }

        function closeModal() {
            document.getElementById(
                    "myModal"
            ).style.display = "none";

            document.getElementById(
                    "modalBody"
            ).innerHTML = "";
        }

        function togglePasswordVisibility() {
            const input =
                    document.getElementById(
                            "passwordInput"
                    );

            const icon =
                    document.getElementById(
                            "togglePassword"
                    );

            if (!input || !icon) {
                return;
            }

            input.type =
                    input.type === "password"
                    ? "text"
                    : "password";

            icon.classList.toggle(
                    "fa-eye"
            );

            icon.classList.toggle(
                    "fa-eye-slash"
            );
        }

        document.getElementById(
                "employeeSearch"
        )?.addEventListener(
                "input",
                function () {
                    const keyword =
                            this.value
                                    .trim()
                                    .toLowerCase();

                    document.querySelectorAll(
                            "#employeeRows tr[data-search]"
                    ).forEach(function (row) {
                        row.style.display =
                                row.dataset.search
                                        .includes(keyword)
                                ? ""
                                : "none";
                    });
                }
        );

        document.getElementById(
                "myModal"
        )?.addEventListener(
                "click",
                function (event) {
                    if (event.target === this) {
                        closeModal();
                    }
                }
        );
    </script>

    <script src="${pageContext.request.contextPath}/js/nhanvien.js"></script>

</body>
</html>