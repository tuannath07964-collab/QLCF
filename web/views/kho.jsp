<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fn"
           uri="jakarta.tags.functions" %>

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
          href="${pageContext.request.contextPath}/css/kho.css">

    <style>
        .message {
            margin-bottom: 18px;
            padding: 12px 15px;
            border-radius: 8px;
            font-weight: 600;
        }

        .message.success {
            border: 1px solid #badbcc;
            background: #d1e7dd;
            color: #0f5132;
        }

        .message.error {
            border: 1px solid #f5c2c7;
            background: #f8d7da;
            color: #842029;
        }

        .inventory-status {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .inventory-status.available {
            background: #d1e7dd;
            color: #0f5132;
        }

        .inventory-status.warning {
            background: #fff3cd;
            color: #664d03;
        }

        .inventory-status.empty {
            background: #f8d7da;
            color: #842029;
        }

        .recipe-cell {
            max-width: 430px;
            white-space: normal;
            line-height: 1.5;
            color: #52606d;
        }

        .edit-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 35px;
            height: 35px;
            border-radius: 7px;
            background: #fff3cd;
            color: #856404;
            text-decoration: none;
        }

        .edit-link:hover {
            background: #ffe69c;
        }

        .modal-overlay {
            position: fixed;
            inset: 0;
            z-index: 1000;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 15px;
            background: rgba(0, 0, 0, .5);
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal-content {
            position: relative;
            width: 100%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 30px;
            border-radius: 12px;
            background: white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, .3);
        }

        .modal-close {
            position: absolute;
            top: 11px;
            right: 15px;
            border: 0;
            background: transparent;
            color: #5f6b76;
            cursor: pointer;
            font-size: 25px;
        }

        .form-field {
            margin-bottom: 15px;
        }

        .form-field label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
        }

        .form-field input {
            width: 100%;
            padding: 10px;
            border: 1px solid #dcdde1;
            border-radius: 6px;
            outline: none;
        }

        .form-field input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, .12);
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 23px;
        }

        .modal-actions button,
        .modal-actions a {
            padding: 10px 18px;
            border: 0;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
        }

        .btn-save {
            background: #27ae60;
            color: white;
        }

        .btn-cancel {
            background: #95a5a6;
            color: white;
        }
    </style>
</head>

<body>

    <div class="wrapper">

        <!-- ==================== SIDEBAR ==================== -->
        <aside class="sidebar">

            <div class="menu">

                <div class="logo">
                    <i class="fa-solid fa-mug-hot"></i>
                    <span>Quản lý quán cafe</span>
                </div>

                <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                    <i class="fa-solid fa-house"></i>
                    Trang chủ
                </a>

                <a href="${pageContext.request.contextPath}/nhanvien">
                    <i class="fa-solid fa-user"></i>
                    Nhân viên
                </a>

                <a href="${pageContext.request.contextPath}/hoadon">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                    Hóa đơn
                </a>

                <a href="${pageContext.request.contextPath}/menu">
                    <i class="fa-solid fa-mug-hot"></i>
                    Menu
                </a>

                <a href="${pageContext.request.contextPath}/ban">
                    <i class="fa-solid fa-chair"></i>
                    Bàn
                </a>

                <a href="${pageContext.request.contextPath}/KhoServlet"
                   class="active">

                    <i class="fa-solid fa-box"></i>
                    Kho
                </a>

                <a href="${pageContext.request.contextPath}/khachhang">
                    <i class="fa-solid fa-users"></i>
                    Khách hàng
                </a>

                <c:if test="${sessionScope.chucVu == 'Quản lý'}">

                    <a href="${pageContext.request.contextPath}/ThongKeServlet">
                        <i class="fa-solid fa-chart-simple"></i>
                        Thống kê doanh thu
                    </a>

                </c:if>

            </div>

            <div class="logout-btn">

                <a href="${pageContext.request.contextPath}/LogoutServlet">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    Đăng xuất
                </a>

            </div>

        </aside>

        <!-- ==================== MAIN ==================== -->
        <main class="main">

            <header class="topbar">

                <div class="user-info">
                    <i class="fa-solid fa-circle-user"></i>

                    <span>
                        ${sessionScope.maNV}
                        -
                        ${sessionScope.tenNV}
                    </span>
                </div>

            </header>

            <div class="content">

                <section class="title-section">

                    <div>
                        <h1 class="title">
                            Quản lý kho
                        </h1>

                        <p class="sub">
                            Theo dõi tồn kho và công thức sử dụng nguyên liệu
                        </p>
                    </div>

                    <a href="${pageContext.request.contextPath}/views/homepage.jsp"
                       class="back-btn">

                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại Trang chủ
                    </a>

                </section>

                <!-- THÔNG BÁO -->
                <c:if test="${param.success == 'add'}">

                    <div class="message success">
                        <i class="fa-solid fa-circle-check"></i>
                        Thêm nguyên liệu thành công.
                    </div>

                </c:if>

                <c:if test="${param.success == 'edit'}">

                    <div class="message success">
                        <i class="fa-solid fa-circle-check"></i>
                        Cập nhật nguyên liệu thành công.
                    </div>

                </c:if>

                <c:if test="${not empty errorMessage}">

                    <div class="message error">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        ${errorMessage}
                    </div>

                </c:if>

                <!-- TÍNH THỐNG KÊ -->
                <c:set var="tongSoLuong"
                       value="0"/>

                <c:set var="sapHetHang"
                       value="0"/>

                <c:set var="hetHang"
                       value="0"/>

                <c:forEach var="nl"
                           items="${dsKho}">

                    <c:set var="tongSoLuong"
                           value="${tongSoLuong + nl.soLuong}"/>

                    <c:if test="${nl.soLuong > 0
                                  and nl.soLuong <= 10}">

                        <c:set var="sapHetHang"
                               value="${sapHetHang + 1}"/>
                    </c:if>

                    <c:if test="${nl.soLuong <= 0}">

                        <c:set var="hetHang"
                               value="${hetHang + 1}"/>
                    </c:if>

                </c:forEach>

                <!-- THẺ THỐNG KÊ -->
                <div class="summary-grid">

                    <div class="stat-box">

                        <div class="icon-wrapper bg-blue">
                            <i class="fa-solid fa-box"></i>
                        </div>

                        <div class="stat-info">
                            <h3>Tổng nguyên liệu</h3>

                            <p>
                                ${fn:length(dsKho)}
                            </p>

                            <span>Loại nguyên liệu</span>
                        </div>

                    </div>

                    <div class="stat-box">

                        <div class="icon-wrapper bg-green">
                            <i class="fa-solid fa-basket-shopping"></i>
                        </div>

                        <div class="stat-info">
                            <h3>Tổng số lượng</h3>

                            <p>
                                <fmt:formatNumber
                                    value="${tongSoLuong}"
                                    pattern="#,##0.##"/>
                            </p>

                            <span>Tổng tồn kho</span>
                        </div>

                    </div>

                    <div class="stat-box">

                        <div class="icon-wrapper bg-orange">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>

                        <div class="stat-info">
                            <h3>Sắp hết hàng</h3>

                            <p>
                                ${sapHetHang}
                            </p>

                            <span>Số lượng từ 0 đến 10</span>
                        </div>

                    </div>

                    <div class="stat-box">

                        <div class="icon-wrapper bg-red">
                            <i class="fa-solid fa-circle-xmark"></i>
                        </div>

                        <div class="stat-info">
                            <h3>Hết hàng</h3>

                            <p>
                                ${hetHang}
                            </p>

                            <span>Số lượng bằng 0</span>
                        </div>

                    </div>

                </div>

                <!-- TOOLBAR -->
                <div class="toolbar">

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="text"
                               id="inventorySearch"
                               autocomplete="off"
                               placeholder="Tìm mã hoặc tên nguyên liệu...">
                    </div>

                    <a href="${pageContext.request.contextPath}/KhoServlet?action=loadForm"
                       class="add-btn">

                        <i class="fa-solid fa-plus"></i>
                        Thêm nguyên liệu
                    </a>

                </div>

                <!-- BẢNG KHO -->
                <div class="card-table">

                    <div class="table-responsive">

                        <table>

                            <thead>
                                <tr>
                                    <th>Mã nguyên liệu</th>
                                    <th>Tên nguyên liệu</th>
                                    <th>Số lượng</th>
                                    <th>Đơn vị</th>
                                    <th>Trạng thái</th>
                                    <th>Dùng để pha/chế biến</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>

                            <tbody id="inventoryRows">

                                <c:choose>

                                    <c:when test="${not empty dsKho}">

                                        <c:forEach var="nl"
                                                   items="${dsKho}">

                                            <tr data-search="${fn:toLowerCase(nl.maNL)} ${fn:toLowerCase(nl.tenNL)} ${fn:toLowerCase(nl.donVi)}">

                                                <td class="txt-bold">
                                                    ${nl.maNL}
                                                </td>

                                                <td>
                                                    ${nl.tenNL}
                                                </td>

                                                <td>
                                                    <fmt:formatNumber
                                                        value="${nl.soLuong}"
                                                        pattern="#,##0.##"/>
                                                </td>

                                                <td>
                                                    ${nl.donVi}
                                                </td>

                                                <td>

                                                    <c:choose>

                                                        <c:when test="${nl.soLuong <= 0}">

                                                            <span class="inventory-status empty">
                                                                <i class="fa-solid fa-circle-xmark"></i>
                                                                Hết hàng
                                                            </span>

                                                        </c:when>

                                                        <c:when test="${nl.soLuong <= 10}">

                                                            <span class="inventory-status warning">
                                                                <i class="fa-solid fa-triangle-exclamation"></i>
                                                                Sắp hết
                                                            </span>

                                                        </c:when>

                                                        <c:otherwise>

                                                            <span class="inventory-status available">
                                                                <i class="fa-solid fa-circle-check"></i>
                                                                Còn hàng
                                                            </span>

                                                        </c:otherwise>

                                                    </c:choose>

                                                </td>

                                                <td class="recipe-cell">

                                                    <c:choose>

                                                        <c:when test="${empty nl.congThucSuDung}">
                                                            Chưa dùng trong công thức nào
                                                        </c:when>

                                                        <c:otherwise>
                                                            ${nl.congThucSuDung}
                                                        </c:otherwise>

                                                    </c:choose>

                                                </td>

                                                <td>

                                                    <!-- CHỈ CÒN NÚT SỬA -->
                                                    <a href="${pageContext.request.contextPath}/KhoServlet?action=loadForm&maNL=${nl.maNL}"
                                                       class="edit-link"
                                                       title="Cập nhật nguyên liệu">

                                                        <i class="fa-solid fa-pen"></i>
                                                    </a>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>
                                            <td colspan="7"
                                                style="text-align:center;padding:30px;">

                                                Không có nguyên liệu nào trong kho.
                                            </td>
                                        </tr>

                                    </c:otherwise>

                                </c:choose>

                            </tbody>
                        </table>

                    </div>

                    <div class="table-footer">

                        <div class="table-info">
                            Có ${fn:length(dsKho)} nguyên liệu
                        </div>

                    </div>

                </div>

            </div>

        </main>

    </div>

    <!-- MODAL THÊM/SỬA -->
    <div id="khoModal"
         class="modal-overlay ${not empty showModal ? 'show' : ''}">

        <div class="modal-content">

            <a href="${pageContext.request.contextPath}/KhoServlet"
               class="modal-close"
               title="Đóng">

                <i class="fa-solid fa-xmark"></i>
            </a>

            <h2 style="
                margin:0 0 20px;
                color:#2c3e50;">

                ${mode == 'edit'
                    ? 'Cập nhật nguyên liệu'
                    : 'Thêm nguyên liệu mới'}
            </h2>

            <form action="${pageContext.request.contextPath}/KhoServlet"
                  method="post">

                <input type="hidden"
                       name="action"
                       value="${mode == 'edit'
                                ? 'edit'
                                : 'add'}">

                <div class="form-field">

                    <label for="maNL">
                        Mã nguyên liệu
                    </label>

                    <c:choose>

                        <c:when test="${mode == 'edit'}">

                            <input type="text"
                                   id="maNL"
                                   name="maNL"
                                   value="${nl.maNL}"
                                   readonly
                                   style="background:#e9ecef;">

                        </c:when>

                        <c:otherwise>

                            <input type="text"
                                   id="maNL"
                                   name="maNL"
                                   value="${nl.maNL}"
                                   maxlength="20"
                                   placeholder="Ví dụ: NL31"
                                   required>

                        </c:otherwise>

                    </c:choose>

                </div>

                <div class="form-field">

                    <label for="tenNL">
                        Tên nguyên liệu
                    </label>

                    <input type="text"
                           id="tenNL"
                           name="tenNL"
                           value="${nl.tenNL}"
                           maxlength="150"
                           required>

                </div>

                <div class="form-field">

                    <label for="soLuong">
                        Số lượng
                    </label>

                    <input type="number"
                           id="soLuong"
                           name="soLuong"
                           value="${empty nl.soLuong
                                    ? 0
                                    : nl.soLuong}"
                           min="0"
                           step="0.01"
                           required>

                </div>

                <div class="form-field">

                    <label for="donVi">
                        Đơn vị tính
                    </label>

                    <input type="text"
                           id="donVi"
                           name="donVi"
                           value="${nl.donVi}"
                           maxlength="30"
                           placeholder="g, ml, kg, hộp..."
                           required>

                </div>

                <div class="modal-actions">

                    <a href="${pageContext.request.contextPath}/KhoServlet"
                       class="btn-cancel">

                        Hủy
                    </a>

                    <button type="submit"
                            class="btn-save">

                        <i class="fa-solid fa-check"></i>
                        Lưu thông tin
                    </button>

                </div>

            </form>

        </div>

    </div>

    <script>
        document.addEventListener(
            "DOMContentLoaded",
            function () {
                const searchInput =
                    document.getElementById(
                        "inventorySearch"
                    );

                if (!searchInput) {
                    return;
                }

                searchInput.addEventListener(
                    "input",
                    function () {
                        const keyword =
                            this.value
                                .trim()
                                .toLowerCase();

                        document.querySelectorAll(
                            "#inventoryRows tr[data-search]"
                        ).forEach(function (row) {
                            row.style.display =
                                row.dataset.search
                                    .includes(keyword)
                                ? ""
                                : "none";
                        });
                    }
                );
            }
        );
    </script>

</body>
</html>