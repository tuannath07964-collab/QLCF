document.addEventListener("DOMContentLoaded", function () {
    const invoiceForm =
            document.getElementById("invoiceForm");

    const productSearch =
            document.getElementById("productPickerSearch");

    const cartTableBody =
            document.getElementById("cartTableBody");

    const emptyCart =
            document.getElementById("emptyCart");

    const customerSelect =
            document.getElementById("customerSelect");

    const newCustomerName =
            document.getElementById("newCustomerName");

    const saveCustomerCheckbox =
            document.getElementById("saveCustomerCheckbox");

    const voucherSelect =
            document.getElementById("voucherSelect");

    const voucherHelpText =
            document.getElementById("voucherHelpText");

    const voucherPreview =
            document.getElementById("selectedVoucherPreview");

    const voucherCodeElement =
            document.getElementById("selectedVoucherCode");

    const usedVoucherValue =
            document.getElementById("usedVoucherValue");

    const subTotalValue =
            document.getElementById("subTotalValue");

    const vatValue =
            document.getElementById("vatValue");

    const voucherDiscountValue =
            document.getElementById("voucherDiscountValue");

    const grandTotalValue =
            document.getElementById("grandTotalValue");

    const cancelInvoiceButton =
            document.getElementById("cancelInvoiceButton");

    const cancelInvoiceForm =
            document.getElementById("cancelInvoiceForm");

    const cancelReasonInput =
            document.getElementById("cancelReasonInput");

    const voucherOptions =
            voucherSelect
                    ? Array.from(
                            voucherSelect.querySelectorAll(
                                    "option[data-customer]"
                            )
                    )
                    : [];

    function formatMoney(value) {
        const number =
                Number(value) || 0;

        return number.toLocaleString("vi-VN") + "đ";
    }

    function getCartRows() {
        if (!cartTableBody) {
            return [];
        }

        return Array.from(
                cartTableBody.querySelectorAll(".cart-row")
        );
    }

    function findCartRow(productCode) {
        return getCartRows().find(
                function (row) {
                    return row.dataset.code === productCode;
                }
        );
    }

    function updateEmptyCart() {
        if (!emptyCart) {
            return;
        }

        const hasProduct =
                getCartRows().length > 0;

        emptyCart.classList.toggle(
                "hidden",
                hasProduct
        );
    }

    function getVoucherValue() {
        if (voucherSelect) {
            const selectedOption =
                    voucherSelect.options[
                            voucherSelect.selectedIndex
                    ];

            if (selectedOption) {
                return Number(
                        selectedOption.dataset.value
                ) || 0;
            }
        }

        if (usedVoucherValue) {
            return Number(
                    usedVoucherValue.value
            ) || 0;
        }

        return 0;
    }

    function updateVoucherPreview() {
        if (
                !voucherSelect
                || !voucherPreview
                || !voucherCodeElement
        ) {
            return;
        }

        const selectedOption =
                voucherSelect.options[
                        voucherSelect.selectedIndex
                ];

        const voucherCode =
                selectedOption
                        ? selectedOption.dataset.code
                        : "";

        if (voucherCode) {
            voucherCodeElement.textContent =
                    voucherCode;

            voucherPreview.classList.remove(
                    "hidden"
            );

        } else {
            voucherCodeElement.textContent = "—";

            voucherPreview.classList.add(
                    "hidden"
            );
        }
    }

    function calculateSubTotal() {
        let subTotal = 0;

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
                            quantityInput
                                    ? Number(
                                            quantityInput.value
                                    ) || 1
                                    : 1;

                    if (quantity < 1) {
                        quantity = 1;

                        if (quantityInput) {
                            quantityInput.value = "1";
                        }
                    }

                    const lineTotal =
                            price * quantity;

                    subTotal += lineTotal;

                    const lineTotalElement =
                            row.querySelector(
                                    ".cart-line-total"
                            );

                    if (lineTotalElement) {
                        lineTotalElement.textContent =
                                formatMoney(lineTotal);
                    }
                }
        );

        return subTotal;
    }

    function updateInvoiceTotal() {
        const subTotal =
                calculateSubTotal();

        const vat =
                Math.round(
                        subTotal * 0.08
                );

        const totalBeforeDiscount =
                subTotal + vat;

        const voucherValue =
                getVoucherValue();

        const grandTotal =
                Math.max(
                        0,
                        totalBeforeDiscount - voucherValue
                );

        if (subTotalValue) {
            subTotalValue.textContent =
                    formatMoney(subTotal);
        }

        if (vatValue) {
            vatValue.textContent =
                    formatMoney(vat);
        }

        if (voucherDiscountValue) {
            voucherDiscountValue.textContent =
                    "-" + formatMoney(voucherValue);

            voucherDiscountValue.classList.toggle(
                    "text-danger",
                    voucherValue > totalBeforeDiscount
            );
        }

        if (grandTotalValue) {
            grandTotalValue.textContent =
                    formatMoney(grandTotal);
        }

        updateVoucherPreview();
        updateEmptyCart();
    }

    function createProductCell(
            productCode,
            productName,
            productPrice
    ) {
        const cell =
                document.createElement("td");

        const nameElement =
                document.createElement("strong");

        nameElement.textContent =
                productName;

        const priceElement =
                document.createElement("small");

        priceElement.textContent =
                formatMoney(productPrice);

        const hiddenInput =
                document.createElement("input");

        hiddenInput.type = "hidden";
        hiddenInput.name = "maSanPham";
        hiddenInput.value = productCode;

        cell.appendChild(nameElement);
        cell.appendChild(priceElement);
        cell.appendChild(hiddenInput);

        return cell;
    }

    function createQuantityCell() {
        const cell =
                document.createElement("td");

        const input =
                document.createElement("input");

        input.className = "cart-quantity";
        input.type = "number";
        input.name = "soLuong";
        input.value = "1";
        input.min = "1";
        input.step = "1";

        cell.appendChild(input);

        return cell;
    }

    function createLineTotalCell(
            productPrice
    ) {
        const cell =
                document.createElement("td");

        cell.className =
                "cart-line-total";

        cell.textContent =
                formatMoney(productPrice);

        return cell;
    }

    function createRemoveCell() {
        const cell =
                document.createElement("td");

        const button =
                document.createElement("button");

        button.className = "cart-remove";
        button.type = "button";
        button.title = "Xóa sản phẩm";

        const icon =
                document.createElement("i");

        icon.className =
                "fa-solid fa-xmark";

        button.appendChild(icon);
        cell.appendChild(button);

        return cell;
    }

    function addProductToCart(
            productButton
    ) {
        if (
                !productButton
                || productButton.disabled
                || productButton.classList.contains(
                        "disabled"
                )
        ) {
            return;
        }

        if (!cartTableBody) {
            return;
        }

        const productCode =
                productButton.dataset.code;

        const productName =
                productButton.dataset.name;

        const productPrice =
                Number(
                        productButton.dataset.price
                ) || 0;

        if (
                !productCode
                || !productName
                || productPrice <= 0
        ) {
            alert(
                    "Thông tin sản phẩm không hợp lệ."
            );

            return;
        }

        const existingRow =
                findCartRow(productCode);

        if (existingRow) {
            const quantityInput =
                    existingRow.querySelector(
                            ".cart-quantity"
                    );

            if (quantityInput) {
                const currentQuantity =
                        Number(
                                quantityInput.value
                        ) || 1;

                quantityInput.value =
                        String(currentQuantity + 1);
            }

            updateInvoiceTotal();

            return;
        }

        const row =
                document.createElement("tr");

        row.className = "cart-row";
        row.dataset.code = productCode;
        row.dataset.name = productName;
        row.dataset.price =
                String(productPrice);

        row.appendChild(
                createProductCell(
                        productCode,
                        productName,
                        productPrice
                )
        );

        row.appendChild(
                createQuantityCell()
        );

        row.appendChild(
                createLineTotalCell(
                        productPrice
                )
        );

        row.appendChild(
                createRemoveCell()
        );

        cartTableBody.appendChild(row);

        updateInvoiceTotal();
    }

    function filterProducts() {
        if (!productSearch) {
            return;
        }

        const keyword =
                productSearch.value
                        .trim()
                        .toLowerCase()
                        .normalize("NFD")
                        .replace(
                                /[\u0300-\u036f]/g,
                                ""
                        );

        document.querySelectorAll(
                ".product-pick"
        ).forEach(
                function (button) {
                    const searchText =
                            (
                                    button.dataset.search
                                    || ""
                            )
                                    .toLowerCase()
                                    .normalize("NFD")
                                    .replace(
                                            /[\u0300-\u036f]/g,
                                            ""
                                    );

                    button.style.display =
                            searchText.includes(keyword)
                                    ? ""
                                    : "none";
                }
        );
    }

    function syncCustomerFields() {
        if (!customerSelect) {
            return;
        }

        const hasSavedCustomer =
                customerSelect.value !== "";

        if (newCustomerName) {
            newCustomerName.disabled =
                    hasSavedCustomer;

            if (hasSavedCustomer) {
                newCustomerName.value = "";
            }
        }

        if (saveCustomerCheckbox) {
            saveCustomerCheckbox.disabled =
                    hasSavedCustomer;

            if (hasSavedCustomer) {
                saveCustomerCheckbox.checked =
                        false;
            }
        }
    }

    function filterVouchers(
            resetSelectedVoucher
    ) {
        if (
                !customerSelect
                || !voucherSelect
        ) {
            return;
        }

        const customerCode =
                customerSelect.value;

        let voucherCount = 0;

        voucherOptions.forEach(
                function (option) {
                    const belongsToCustomer =
                            customerCode !== ""
                            && option.dataset.customer
                            === customerCode;

                    option.hidden =
                            !belongsToCustomer;

                    option.disabled =
                            !belongsToCustomer;

                    if (belongsToCustomer) {
                        voucherCount++;
                    }
                }
        );

        const selectedOption =
                voucherSelect.options[
                        voucherSelect.selectedIndex
                ];

        const selectedBelongsToCustomer =
                selectedOption
                && selectedOption.dataset.customer
                && selectedOption.dataset.customer
                === customerCode;

        if (
                resetSelectedVoucher
                || (
                        selectedOption
                        && selectedOption.dataset.customer
                        && !selectedBelongsToCustomer
                )
        ) {
            voucherSelect.value = "";
        }

        voucherSelect.disabled =
                customerCode === "";

        if (voucherHelpText) {
            if (customerCode === "") {
                voucherHelpText.textContent =
                        "Khách lẻ không thể sử dụng voucher.";

            } else if (voucherCount === 0) {
                voucherHelpText.textContent =
                        "Khách hàng này không có voucher còn hiệu lực.";

            } else {
                voucherHelpText.textContent =
                        "Khách hàng có "
                        + voucherCount
                        + " voucher còn hiệu lực.";
            }
        }

        syncCustomerFields();
        updateInvoiceTotal();
    }

    document.addEventListener(
            "click",
            function (event) {
                const productButton =
                        event.target.closest(
                                ".product-pick"
                        );

                if (productButton) {
                    event.preventDefault();

                    addProductToCart(
                            productButton
                    );

                    return;
                }

                const removeButton =
                        event.target.closest(
                                ".cart-remove"
                        );

                if (removeButton) {
                    event.preventDefault();

                    const row =
                            removeButton.closest(
                                    ".cart-row"
                            );

                    if (row) {
                        row.remove();
                        updateInvoiceTotal();
                    }
                }
            }
    );

    if (cartTableBody) {
        cartTableBody.addEventListener(
                "input",
                function (event) {
                    if (
                            event.target.classList.contains(
                                    "cart-quantity"
                            )
                    ) {
                        updateInvoiceTotal();
                    }
                }
        );

        cartTableBody.addEventListener(
                "change",
                function (event) {
                    if (
                            event.target.classList.contains(
                                    "cart-quantity"
                            )
                    ) {
                        let quantity =
                                Number(
                                        event.target.value
                                ) || 1;

                        if (quantity < 1) {
                            quantity = 1;
                        }

                        event.target.value =
                                String(quantity);

                        updateInvoiceTotal();
                    }
                }
        );
    }

    if (productSearch) {
        productSearch.addEventListener(
                "input",
                filterProducts
        );
    }

    if (customerSelect) {
        customerSelect.addEventListener(
                "change",
                function () {
                    filterVouchers(true);
                }
        );
    }

    if (voucherSelect) {
        voucherSelect.addEventListener(
                "change",
                updateInvoiceTotal
        );
    }

    if (
            cancelInvoiceButton
            && cancelInvoiceForm
            && cancelReasonInput
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

                    if (reason.trim() === "") {
                        alert(
                                "Vui lòng nhập lý do hủy."
                        );

                        return;
                    }

                    const confirmed =
                            window.confirm(
                                    "Xác nhận hủy hóa đơn?"
                            );

                    if (!confirmed) {
                        return;
                    }

                    cancelReasonInput.value =
                            reason.trim();

                    cancelInvoiceForm.submit();
                }
        );
    }

    if (invoiceForm) {
        invoiceForm.addEventListener(
                "submit",
                function (event) {
                    const submitButton =
                            event.submitter;

                    const action =
                            submitButton
                                    ? submitButton.value
                                    : "";

                    if (
                            action !== "save"
                            && action !== "pay"
                    ) {
                        return;
                    }

                    if (getCartRows().length === 0) {
                        event.preventDefault();

                        alert(
                                "Hóa đơn phải có ít nhất một sản phẩm."
                        );

                        return;
                    }

                    if (action !== "pay") {
                        return;
                    }

                    const voucherValue =
                            getVoucherValue();

                    if (
                            voucherValue > 0
                            && (
                                    !customerSelect
                                    || customerSelect.value === ""
                            )
                    ) {
                        event.preventDefault();

                        alert(
                                "Phải chọn khách hàng trước khi sử dụng voucher."
                        );

                        return;
                    }

                    const subTotal =
                            calculateSubTotal();

                    const vat =
                            Math.round(
                                    subTotal * 0.08
                            );

                    const totalBeforeDiscount =
                            subTotal + vat;

                    if (
                            voucherValue
                            > totalBeforeDiscount
                    ) {
                        event.preventDefault();

                        alert(
                                "Mệnh giá voucher lớn hơn tổng giá trị hóa đơn."
                        );

                        return;
                    }

                    if (
                            voucherValue > 0
                            && voucherSelect
                    ) {
                        const selectedOption =
                                voucherSelect.options[
                                        voucherSelect.selectedIndex
                                ];

                        const selectedCode =
                                selectedOption
                                        ? selectedOption.dataset.code
                                        : "";

                        const confirmed =
                                window.confirm(
                                        "Xác nhận dùng voucher "
                                        + selectedCode
                                        + " giảm "
                                        + formatMoney(
                                                voucherValue
                                        )
                                        + "?"
                                );

                        if (!confirmed) {
                            event.preventDefault();
                        }
                    }
                }
        );
    }

    if (voucherSelect) {
        filterVouchers(false);

    } else {
        syncCustomerFields();
        updateInvoiceTotal();
    }
});