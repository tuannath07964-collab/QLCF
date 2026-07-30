<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<header class="app-topbar">

    <div class="topbar-title">

        <h1>
            <c:out value="${param.title}"/>
        </h1>

        <c:if test="${not empty param.subtitle}">
            <p>
                <c:out value="${param.subtitle}"/>
            </p>
        </c:if>

    </div>

    <div class="topbar-user">

        <div class="topbar-avatar">
            <i class="fa-solid fa-user"></i>
        </div>

        <div class="topbar-user-info">

            <strong>
                <c:out value="${sessionScope.tenNV}"/>
            </strong>

            <span>
                <c:out value="${sessionScope.chucVu}"/>
            </span>

        </div>

    </div>

</header>