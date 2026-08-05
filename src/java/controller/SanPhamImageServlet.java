package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;

import java.nio.file.Files;
import java.nio.file.Path;

import java.util.Locale;

@WebServlet(
        urlPatterns = "/product-image/*"
)
public class SanPhamImageServlet
        extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String pathInfo =
                request.getPathInfo();

        if (
                pathInfo == null
                || pathInfo.isBlank()
                || "/".equals(pathInfo)
        ) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND
            );

            return;
        }

        String fileName =
                pathInfo.substring(1);

        if (
                fileName.contains("/")
                || fileName.contains("\\")
                || fileName.contains("..")
        ) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            return;
        }

        Path uploadDirectory =
                Path.of(
                        System.getProperty(
                                "user.home"
                        ),
                        "QLCF_uploads",
                        "sanpham"
                )
                        .toAbsolutePath()
                        .normalize();

        Path imageFile =
                uploadDirectory
                        .resolve(fileName)
                        .normalize();

        if (
                !imageFile.startsWith(
                        uploadDirectory
                )
                || !Files.isRegularFile(
                        imageFile
                )
        ) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND
            );

            return;
        }

        response.setContentType(
                getContentType(fileName)
        );

        response.setContentLengthLong(
                Files.size(imageFile)
        );

        response.setHeader(
                "Cache-Control",
                "public, max-age=86400"
        );

        try (
                OutputStream outputStream =
                        response.getOutputStream()
        ) {
            Files.copy(
                    imageFile,
                    outputStream
            );
        }
    }

    private String getContentType(
            String fileName
    ) {
        String lowerName =
                fileName.toLowerCase(
                        Locale.ROOT
                );

        if (
                lowerName.endsWith(".jpg")
                || lowerName.endsWith(".jpeg")
        ) {
            return "image/jpeg";
        }

        if (lowerName.endsWith(".png")) {
            return "image/png";
        }

        if (lowerName.endsWith(".webp")) {
            return "image/webp";
        }

        return "application/octet-stream";
    }
}