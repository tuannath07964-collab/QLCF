<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Menu</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body>

<div class="container mt-4">

    <h2 class="text-center text-primary mb-4">
        QUẢN LÝ MENU
    </h2>

    <div class="mb-3">

        <a href="menu?action=add" class="btn btn-success">
            ➕ Thêm món
        </a>

    </div>

    <table class="table table-bordered table-hover text-center align-middle">

        <thead class="table-dark">

        <tr>

            <th>Mã</th>

            <th>Tên món</th>

            <th>Loại</th>

            <th>Giá</th>

            <th>Trạng thái</th>

            <th>Hình ảnh</th>

            <th width="180">Thao tác</th>

        </tr>

        </thead>

        <tbody>

        <c:forEach items="${listMenu}" var="m">

            <tr>

                <td>${m.maMon}</td>

                <td>${m.tenMon}</td>

                <td>${m.loai}</td>

                <td>${m.gia}</td>

                <td>${m.trangThai}</td>

                <td>

                    <img src="images/${m.hinhAnh}"
                         width="80"
                         height="80">

                </td>

                <td>

                    <a href="menu?action=edit&id=${m.maMon}"
                       class="btn btn-warning btn-sm">

                        Sửa

                    </a>

                    <a href="menu?action=delete&id=${m.maMon}"
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
