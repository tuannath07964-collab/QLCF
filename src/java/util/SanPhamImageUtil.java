package util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import model.SanPham;

import java.awt.image.BufferedImage;

import java.io.IOException;
import java.io.InputStream;

import java.net.URISyntaxException;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

import java.util.List;

import javax.imageio.ImageIO;

public class SanPhamImageUtil {

    private static final long MAX_IMAGE_SIZE =
            5L * 1024L * 1024L;

    private final ServletContext servletContext;

    public SanPhamImageUtil(
            ServletContext servletContext
    ) {
        this.servletContext = servletContext;
    }

    public BufferedImage readImage(
            Part imagePart
    ) throws IOException {

        if (
                imagePart == null
                || imagePart.getSize() == 0
        ) {
            return null;
        }

        if (imagePart.getSize() > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException(
                    "Ảnh sản phẩm không được lớn hơn 5 MB."
            );
        }

        String contentType =
                imagePart.getContentType();

        if (
                !"image/jpeg".equalsIgnoreCase(
                        contentType
                )
                && !"image/png".equalsIgnoreCase(
                        contentType
                )
        ) {
            throw new IllegalArgumentException(
                    "Chỉ được chọn ảnh JPG, JPEG hoặc PNG."
            );
        }

        try (
                InputStream inputStream =
                        imagePart.getInputStream()
        ) {
            BufferedImage image =
                    ImageIO.read(inputStream);

            if (image == null) {
                throw new IllegalArgumentException(
                        "File đã chọn không phải ảnh hợp lệ."
                );
            }

            if (
                    image.getWidth() > 5000
                    || image.getHeight() > 5000
            ) {
                throw new IllegalArgumentException(
                        "Kích thước ảnh tối đa là 5000 x 5000 pixel."
                );
            }

            return image;
        }
    }

    public void saveImage(
            String maSanPham,
            BufferedImage image
    ) throws IOException {

        if (image == null) {
            return;
        }

        Path sourceDirectory =
                getSourceDirectory();

        Path deployedDirectory =
                getDeployedDirectory();

        Files.createDirectories(
                sourceDirectory
        );

        Files.createDirectories(
                deployedDirectory
        );

        String fileName =
                getFileName(maSanPham);

        Path sourceFile =
                sourceDirectory.resolve(
                        fileName
                );

        boolean saved =
                ImageIO.write(
                        image,
                        "png",
                        sourceFile.toFile()
                );

        if (!saved) {
            throw new IOException(
                    "Không ghi được ảnh sản phẩm."
            );
        }

        Path deployedFile =
                deployedDirectory.resolve(
                        fileName
                );

        if (!sourceFile.equals(deployedFile)) {
            Files.copy(
                    sourceFile,
                    deployedFile,
                    StandardCopyOption.REPLACE_EXISTING
            );
        }
    }

    public void deleteImage(
            String maSanPham
    ) throws IOException {

        if (
                maSanPham == null
                || maSanPham.isBlank()
        ) {
            return;
        }

        String fileName =
                getFileName(maSanPham);

        Path sourceFile =
                getSourceDirectory()
                        .resolve(fileName);

        Path deployedFile =
                getDeployedDirectory()
                        .resolve(fileName);

        Files.deleteIfExists(
                sourceFile
        );

        if (!sourceFile.equals(deployedFile)) {
            Files.deleteIfExists(
                    deployedFile
            );
        }
    }

    public void applyImageInfo(
            List<SanPham> sanPhamList
    ) {
        if (sanPhamList == null) {
            return;
        }

        for (SanPham sanPham : sanPhamList) {
            applyImageInfo(sanPham);
        }
    }

    public void applyImageInfo(
            SanPham sanPham
    ) {
        if (
                sanPham == null
                || sanPham.getMaSanPham() == null
                || sanPham.getMaSanPham().isBlank()
        ) {
            return;
        }

        String fileName =
                getFileName(
                        sanPham.getMaSanPham()
                );

        Path imageFile =
                getSourceDirectory()
                        .resolve(fileName);

        if (!Files.isRegularFile(imageFile)) {
            imageFile =
                    getDeployedDirectory()
                            .resolve(fileName);
        }

        boolean exists =
                Files.isRegularFile(
                        imageFile
                );

        sanPham.setCoHinhAnh(
                exists
        );

        if (!exists) {
            sanPham.setHinhAnhVersion(
                    0L
            );

            return;
        }

        try {
            sanPham.setHinhAnhVersion(
                    Files.getLastModifiedTime(
                            imageFile
                    ).toMillis()
            );

        } catch (IOException exception) {
            sanPham.setHinhAnhVersion(
                    System.currentTimeMillis()
            );
        }
    }

    private String getFileName(
            String maSanPham
    ) {
        if (
                maSanPham == null
                || !maSanPham.matches(
                        "[A-Za-z0-9_-]+"
                )
        ) {
            throw new IllegalArgumentException(
                    "Mã sản phẩm không hợp lệ."
            );
        }

        return maSanPham + ".png";
    }

    private Path getDeployedDirectory() {
        String realPath =
                servletContext.getRealPath(
                        "/image/products"
                );

        if (realPath == null) {
            throw new IllegalStateException(
                    "Không xác định được thư mục ảnh sản phẩm."
            );
        }

        return Path.of(realPath)
                .toAbsolutePath()
                .normalize();
    }

    private Path getSourceDirectory() {
        String configuredProjectDirectory =
                System.getProperty(
                        "qlcf.project.dir"
                );

        if (
                configuredProjectDirectory != null
                && !configuredProjectDirectory.isBlank()
        ) {
            Path configuredRoot =
                    Path.of(
                            configuredProjectDirectory
                    )
                            .toAbsolutePath()
                            .normalize();

            if (isProjectRoot(configuredRoot)) {
                return configuredRoot
                        .resolve("web")
                        .resolve("image")
                        .resolve("products");
            }
        }

        Path projectRoot =
                findProjectRoot(
                        getDeployedDirectory()
                );

        if (projectRoot == null) {
            projectRoot =
                    findProjectRoot(
                            Path.of(
                                    System.getProperty(
                                            "user.dir",
                                            "."
                                    )
                            )
                    );
        }

        if (projectRoot == null) {
            projectRoot =
                    findProjectRootFromClassLocation();
        }

        if (projectRoot != null) {
            return projectRoot
                    .resolve("web")
                    .resolve("image")
                    .resolve("products")
                    .toAbsolutePath()
                    .normalize();
        }

        return getDeployedDirectory();
    }

    private Path findProjectRootFromClassLocation() {
        try {
            Path classLocation =
                    Path.of(
                            SanPhamImageUtil.class
                                    .getProtectionDomain()
                                    .getCodeSource()
                                    .getLocation()
                                    .toURI()
                    );

            return findProjectRoot(
                    classLocation
            );

        } catch (
                URISyntaxException
                | NullPointerException exception
        ) {
            return null;
        }
    }

    private Path findProjectRoot(
            Path start
    ) {
        if (start == null) {
            return null;
        }

        Path current =
                start.toAbsolutePath()
                        .normalize();

        if (Files.isRegularFile(current)) {
            current = current.getParent();
        }

        for (
                int index = 0;
                current != null && index < 12;
                index++
        ) {
            if (isProjectRoot(current)) {
                return current;
            }

            current = current.getParent();
        }

        return null;
    }

    private boolean isProjectRoot(
            Path directory
    ) {
        return directory != null
                && Files.isDirectory(
                        directory.resolve("web")
                )
                && Files.exists(
                        directory.resolve("build.xml")
                );
    }
}