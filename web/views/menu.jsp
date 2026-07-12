```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Quản lý Menu</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body>

<div class="container mt-4">

    <h2 class="text-center mb-4">
        QUẢN LÝ MENU
    </h2>

    <div class="mb-3">

        <a href="${pageContext.request.contextPath}/themMenu"
           class="btn btn-success">
            Thêm món
        </a>

    </div>

    <table class="table table-bordered table-hover text-center">

        <thead class="table-dark">

        <tr>

            <th>Mã</th>
            <th>Tên món</th>
            <th>Loại</th>
            <th>Giá</th>
            <th>Trạng thái</th>
            <th>Hình ảnh</th>
            <th>Thao tác</th>

        </tr>

        </thead>

        <tbody>

        <c:forEach items="${list}" var="m">

            <tr>

                <td>${m.maMon}</td>

                <td>${m.tenMon}</td>

                <td>${m.loai}</td>

                <td>${m.gia}</td>

                <td>

                    <span class="badge bg-success">

                        ${m.trangThai}

                    </span>

                </td>

                <td>

                    <img src="${pageContext.request.contextPath}/images/${m.hinhAnh}"
                         width="80"
                         height="80">

                </td>

                <td>

                    <a href="${pageContext.request.contextPath}/suaMenu?id=${m.maMon}"
                       class="btn btn-warning btn-sm">

                        Sửa

                    </a>

                    <a href="${pageContext.request.contextPath}/xoaMenu?id=${m.maMon}"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Bạn có chắc muốn xóa?')">

                        Xóa

                    </a>

                </td>

            </tr>

        </c:forEach>

        </tbody>

    </table>

</div>

</body>
</html>
```
