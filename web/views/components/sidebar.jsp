<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<aside class="app-sidebar">

    <div class="sidebar-brand">

        <img class="sidebar-brand-logo"
             src="${pageContext.request.contextPath}/image/logo-cafe-manager-icon.png?v=101"
             width="44"
             height="44"
             alt="">

        <div class="sidebar-brand-text">

            <strong>Cafe Manager</strong>

            <span>Quản lý quán Cafe</span>

        </div>

    </div>

    <ul class="sidebar-menu">

        <li>
            <a class="sidebar-link
               ${param.active == 'home' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/homepage">

                <i class="fa-solid fa-house"></i>
                <span>Trang chủ</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link
               ${param.active == 'invoice' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/hoadon">

                <i class="fa-solid fa-file-invoice-dollar"></i>
                <span>Hóa đơn bán hàng</span>
            </a>
        </li>

        <li class="sidebar-section-title">
            SẢN PHẨM
        </li>

        <li>
            <a class="sidebar-link
               ${param.active == 'productManage' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/san-pham/quan-ly">

                <i class="fa-solid fa-pen-to-square"></i>
                <span>Quản lý sản phẩm</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link
               ${param.active == 'category' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/danh-muc-san-pham">

                <i class="fa-solid fa-layer-group"></i>
                <span>Danh mục sản phẩm</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link
               ${param.active == 'productList' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/san-pham/danh-sach">

                <i class="fa-solid fa-list"></i>
                <span>Danh sách sản phẩm</span>
            </a>
        </li>

        <li class="sidebar-section-title">
            QUẢN LÝ
        </li>

        <li>
            <a class="sidebar-link
               ${param.active == 'warehouse' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/KhoServlet">

                <i class="fa-solid fa-boxes-stacked"></i>
                <span>Kho nguyên liệu</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link
               ${param.active == 'customer' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/khachhang">

                <i class="fa-solid fa-users"></i>
                <span>Khách hàng</span>
            </a>
        </li>

        <li>
            <a class="sidebar-link
               ${param.active == 'statistics' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/ThongKeServlet">

                <i class="fa-solid fa-chart-column"></i>
                <span>Thống kê</span>
            </a>
        </li>

    </ul>

    <div class="sidebar-logout">

        <a class="sidebar-link"
           href="${pageContext.request.contextPath}/LogoutServlet">

            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Đăng xuất</span>
        </a>

    </div>

</aside>