document.addEventListener(
    "DOMContentLoaded",
    function () {
        const invoiceForm =
                document.getElementById("invoiceForm");

        const cartTableBody =
                document.getElementById("cartTableBody");

        const emptyCart =
                document.getElementById("emptyCart");

        const subTotalValue =
                document.getElementById("subTotalValue");

        const vatValue =
                document.getElementById("vatValue");

        const grandTotalValue =
                document.getElementById("grandTotalValue");

        const productSearch =
                document.getElementById("productPickerSearch");

        const customerSelect =
                document.getElementById("customerSelect");

        const newCustomerName =
                document.getElementById("newCustomerName");

        const saveCustomerCheckbox =
                document.getElementById("saveCustomerCheckbox");

        const cancelInvoiceButton =
                document.getElementById("cancelInvoiceButton");

        const cancelInvoiceForm =
                document.getElementById("cancelInvoiceForm");

        const cancelReasonInput =
                document.getElementById("cancelReasonInput");

        function normalizeText(value) {
            return (value || "")
                    .toLowerCase()
                    .normalize("NFD")
                    .replace(
                        /[\u0300-\u036f]/g,
                        ""
                    );
        }

        function formatMoney(value) {
            return Number(value || 0)
                    .toLocaleString("vi-VN")
                    + "đ";
        }

        function getCartRows() {
            return Array.from(
                cartTableBody.querySelectorAll(
                    ".cart-row"
                )
            );
        }

        function updateTotals() {
            let subTotal =
                    0;

            getCartRows().forEach(
                function (row) {
                    const price =
                            Number(
                                row.dataset.price
                            ) || 0;

                    const quantityInput =
                            row.querySelector(
                                ".cart-quantity"
                            );

                    let quantity =
                            Number(
                                quantityInput.value
                            ) || 1;

                    if (quantity < 1) {
                        quantity = 1;
                        quantityInput.value = 1;
                    }

                    const lineTotal =
                            price * quantity;

                    subTotal +=
                            lineTotal;

                    row.querySelector(
                        ".cart-line-total"
                    ).textContent =
                            formatMoney(lineTotal);
                }
            );

            const vat =
                    Math.round(
                        subTotal * 0.08
                    );

            const grandTotal =
                    subTotal + vat;

            subTotalValue.textContent =
                    formatMoney(subTotal);

            vatValue.textContent =
                    formatMoney(vat);

            grandTotalValue.textContent =
                    formatMoney(grandTotal);

            emptyCart.classList.toggle(
                "hidden",
                getCartRows().length > 0
            );
        }

        function createCartRow(
                code,
                name,
                price
        ) {
            const row =
                    document.createElement("tr");

            row.className =
                    "cart-row";

            row.dataset.code =
                    code;

            row.dataset.name =
                    name;

            row.dataset.price =
                    String(price);

            const productCell =
                    document.createElement("td");

            const productName =
                    document.createElement("strong");

            productName.textContent =
                    name;

            const productPrice =
                    document.createElement("small");

            productPrice.textContent =
                    formatMoney(price);

            const productCode =
                    document.createElement("input");

            productCode.type =
                    "hidden";

            productCode.name =
                    "maSanPham";

            productCode.value =
                    code;

            productCell.appendChild(
                productName
            );

            productCell.appendChild(
                productPrice
            );

            productCell.appendChild(
                productCode
            );

            const quantityCell =
                    document.createElement("td");

            const quantityInput =
                    document.createElement("input");

            quantityInput.type =
                    "number";

            quantityInput.name =
                    "soLuong";

            quantityInput.value =
                    "1";

            quantityInput.min =
                    "1";

            quantityInput.step =
                    "1";

            quantityInput.className =
                    "cart-quantity";

            quantityCell.appendChild(
                quantityInput
            );

            const totalCell =
                    document.createElement("td");

            totalCell.className =
                    "cart-line-total";

            totalCell.textContent =
                    formatMoney(price);

            const removeCell =
                    document.createElement("td");

            const removeButton =
                    document.createElement("button");

            removeButton.type =
                    "button";

            removeButton.className =
                    "cart-remove";

            removeButton.innerHTML =
                    '<i class="fa-solid fa-xmark"></i>';

            removeCell.appendChild(
                removeButton
            );

            row.appendChild(
                productCell
            );

            row.appendChild(
                quantityCell
            );

            row.appendChild(
                totalCell
            );

            row.appendChild(
                removeCell
            );

            return row;
        }

        function addProduct(
                code,
                name,
                price
        ) {
            const existingRow =
                    getCartRows().find(
                        function (row) {
                            return row.dataset.code
                                    === code;
                        }
                    );

            if (existingRow) {
                const quantityInput =
                        existingRow.querySelector(
                            ".cart-quantity"
                        );

                quantityInput.value =
                        Number(
                            quantityInput.value
                        ) + 1;

            } else {
                cartTableBody.appendChild(
                    createCartRow(
                        code,
                        name,
                        price
                    )
                );
            }

            updateTotals();
        }

        document.querySelectorAll(
            ".product-pick"
        ).forEach(
            function (button) {
                button.addEventListener(
                    "click",
                    function () {
                        if (
                            button.disabled
                            || button.classList.contains(
                                "disabled"
                            )
                        ) {
                            return;
                        }

                        addProduct(
                            button.dataset.code,
                            button.dataset.name,
                            Number(
                                button.dataset.price
                            )
                        );
                    }
                );
            }
        );

        cartTableBody.addEventListener(
            "input",
            function (event) {
                if (
                    event.target.classList.contains(
                        "cart-quantity"
                    )
                ) {
                    updateTotals();
                }
            }
        );

        cartTableBody.addEventListener(
            "click",
            function (event) {
                const removeButton =
                        event.target.closest(
                            ".cart-remove"
                        );

                if (
                    !removeButton
                    || removeButton.disabled
                ) {
                    return;
                }

                const row =
                        removeButton.closest(
                            ".cart-row"
                        );

                if (row) {
                    row.remove();
                    updateTotals();
                }
            }
        );

        if (productSearch) {
            productSearch.addEventListener(
                "input",
                function () {
                    const keyword =
                            normalizeText(
                                productSearch.value
                            );

                    document.querySelectorAll(
                        ".product-pick"
                    ).forEach(
                        function (button) {
                            const searchText =
                                    normalizeText(
                                        button.dataset.search
                                    );

                            button.style.display =
                                    searchText.includes(
                                        keyword
                                    )
                                            ? ""
                                            : "none";
                        }
                    );
                }
            );
        }

        if (
            customerSelect
            && newCustomerName
        ) {
            customerSelect.addEventListener(
                "change",
                function () {
                    const selected =
                            customerSelect.value
                            !== "";

                    newCustomerName.disabled =
                            selected;

                    if (selected) {
                        newCustomerName.value =
                                "";

                        if (saveCustomerCheckbox) {
                            saveCustomerCheckbox.checked =
                                    false;
                        }
                    }
                }
            );

            customerSelect.dispatchEvent(
                new Event("change")
            );
        }

        if (
            saveCustomerCheckbox
            && newCustomerName
        ) {
            saveCustomerCheckbox.addEventListener(
                "change",
                function () {
                    if (
                        saveCustomerCheckbox.checked
                        && !newCustomerName.value.trim()
                    ) {
                        newCustomerName.focus();
                    }
                }
            );
        }

        if (invoiceForm) {
            invoiceForm.addEventListener(
                "submit",
                function (event) {
                    if (
                        getCartRows().length === 0
                    ) {
                        event.preventDefault();

                        alert(
                            "Hóa đơn phải có ít nhất một sản phẩm."
                        );

                        return;
                    }

                    const submitter =
                            event.submitter;

                    if (
                        submitter
                        && submitter.value === "pay"
                        && saveCustomerCheckbox
                        && saveCustomerCheckbox.checked
                        && !newCustomerName.value.trim()
                    ) {
                        event.preventDefault();

                        alert(
                            "Vui lòng nhập tên khách hàng cần lưu."
                        );

                        newCustomerName.focus();
                    }
                }
            );
        }

        if (
            cancelInvoiceButton
            && cancelInvoiceForm
        ) {
            cancelInvoiceButton.addEventListener(
                "click",
                function () {
                    const reason =
                            window.prompt(
                                "Nhập lý do hủy hóa đơn:"
                            );

                    if (reason === null) {
                        return;
                    }

                    if (!reason.trim()) {
                        alert(
                            "Lý do hủy không được để trống."
                        );

                        return;
                    }

                    if (
                        !window.confirm(
                            "Xác nhận hủy hóa đơn này?"
                        )
                    ) {
                        return;
                    }

                    cancelReasonInput.value =
                            reason.trim();

                    cancelInvoiceForm.submit();
                }
            );
        }

        updateTotals();
    }
);