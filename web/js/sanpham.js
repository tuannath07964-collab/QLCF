document.addEventListener(
    "DOMContentLoaded",
    function () {
        const imageInput =
            document.getElementById(
                "productImageInput"
            );

        const previewContainer =
            document.getElementById(
                "productImagePreview"
            );

        const previewPlaceholder =
            document.getElementById(
                "productImagePreviewPlaceholder"
            );

        const removeImageCheckbox =
            document.getElementById(
                "removeProductImage"
            );

        function getPreviewImage() {
            return document.getElementById(
                "productImagePreviewElement"
            );
        }

        function showPlaceholder() {
            const previewImage =
                getPreviewImage();

            if (previewImage) {
                previewImage.classList.add(
                    "hidden"
                );
            }

            if (previewPlaceholder) {
                previewPlaceholder.classList.remove(
                    "hidden"
                );
            }
        }

        function showImage(source) {
            if (!previewContainer) {
                return;
            }

            let previewImage =
                getPreviewImage();

            if (!previewImage) {
                previewImage =
                    document.createElement(
                        "img"
                    );

                previewImage.id =
                    "productImagePreviewElement";

                previewImage.alt =
                    "Ảnh sản phẩm";

                previewContainer.prepend(
                    previewImage
                );
            }

            previewImage.src =
                source;

            previewImage.classList.remove(
                "hidden"
            );

            if (previewPlaceholder) {
                previewPlaceholder.classList.add(
                    "hidden"
                );
            }
        }

        if (imageInput) {
            imageInput.addEventListener(
                "change",
                function () {
                    const file =
                        imageInput.files
                        && imageInput.files.length > 0
                            ? imageInput.files[0]
                            : null;

                    if (!file) {
                        return;
                    }

                    const allowedTypes = [
                        "image/jpeg",
                        "image/png"
                    ];

                    if (
                        !allowedTypes.includes(
                            file.type
                        )
                    ) {
                        alert(
                            "Chỉ được chọn ảnh JPG, JPEG hoặc PNG."
                        );

                        imageInput.value = "";

                        return;
                    }

                    if (
                        file.size
                        > 5 * 1024 * 1024
                    ) {
                        alert(
                            "Ảnh sản phẩm không được lớn hơn 5 MB."
                        );

                        imageInput.value = "";

                        return;
                    }

                    if (removeImageCheckbox) {
                        removeImageCheckbox.checked =
                            false;
                    }

                    const reader =
                        new FileReader();

                    reader.addEventListener(
                        "load",
                        function () {
                            showImage(
                                reader.result
                            );
                        }
                    );

                    reader.readAsDataURL(
                        file
                    );
                }
            );
        }

        if (removeImageCheckbox) {
            removeImageCheckbox.addEventListener(
                "change",
                function () {
                    const previewImage =
                        getPreviewImage();

                    if (
                        removeImageCheckbox.checked
                    ) {
                        if (imageInput) {
                            imageInput.value = "";
                        }

                        showPlaceholder();

                        return;
                    }

                    if (
                        previewImage
                        && previewImage.dataset.originalSrc
                    ) {
                        showImage(
                            previewImage.dataset.originalSrc
                        );
                    }
                }
            );
        }

        document
            .querySelectorAll(
                "[data-product-image]"
            )
            .forEach(
                function (image) {
                    image.addEventListener(
                        "error",
                        function () {
                            image.classList.add(
                                "hidden"
                            );

                            const parent =
                                image.parentElement;

                            if (!parent) {
                                return;
                            }

                            const fallback =
                                parent.querySelector(
                                    ".product-image-fallback, "
                                    + ".product-display-image-fallback"
                                );

                            if (fallback) {
                                fallback.classList.remove(
                                    "hidden"
                                );
                            }
                        }
                    );
                }
            );
    }
);