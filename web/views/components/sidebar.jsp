<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<aside class="app-sidebar">

    <div class="sidebar-brand">
        <i class="fa-solid fa-mug-hot"></i>
        <span>QUẢN LÝ QUÁN CAFE</span>
    </div>

    <ul class="sidebar-menu">

        <li>
            <a class="sidebar-link ${param.active == 'home' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/homepage">

                <i class="fa-solid fa-house"></i>
                <span>Trang chủ</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link ${param.active == 'employee' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/nhanvien">

                <i class="fa-solid fa-user-tie"></i>
                <span>Nhân viên</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link ${param.active == 'invoice' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/hoadon">

                <i class="fa-solid fa-file-invoice-dollar"></i>
                <span>Hóa đơn</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link ${param.active == 'menu' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/menu">

                <i class="fa-solid fa-mug-saucer"></i>
                <span>Menu</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link ${param.active == 'table' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/ban">

                <i class="fa-solid fa-chair"></i>
                <span>Bàn</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link ${param.active == 'warehouse' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/KhoServlet">

                <i class="fa-solid fa-box"></i>
                <span>Kho</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link ${param.active == 'customer' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/khachhang">

                <i class="fa-solid fa-users"></i>
                <span>Khách hàng</span>
            </a>
        </li>

        <c:if test="${sessionScope.chucVu == 'Quản lý'}">

            <li>
                <a class="sidebar-link ${param.active == 'statistics' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/ThongKeServlet">

                    <i class="fa-solid fa-chart-column"></i>
                    <span>Thống kê</span>
                </a>
            </li>

        </c:if>

    </ul>

    <div class="sidebar-logout">

        <a class="sidebar-link"
           href="${pageContext.request.contextPath}/LogoutServlet">

            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Đăng xuất</span>
        </a>

    </div>

</aside>