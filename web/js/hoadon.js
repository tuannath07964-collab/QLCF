document.addEventListener("DOMContentLoaded", function () {
    const invoiceForm = document.getElementById("invoiceForm");
    const productSearch = document.getElementById("productPickerSearch");
    const cartTableBody = document.getElementById("cartTableBody");
    const emptyCart = document.getElementById("emptyCart");

    const customerModeRadios = Array.from(
            document.querySelectorAll('input[name="customerMode"]')
            );

    const savedCustomerSection = document.getElementById(
            "savedCustomerSection"
            );

    const guestCustomerSection = document.getElementById(
            "guestCustomerSection"
            );

    const customerSearchInput = document.getElementById(
            "customerSearchInput"
            );

    const customerSearchButton = document.getElementById(
            "customerSearchButton"
            );

    const customerSearchResults = document.getElementById(
            "customerSearchResults"
            );

    const customerSearchEmpty = document.getElementById(
            "customerSearchEmpty"
            );

    const customerSearchHelp = document.getElementById(
            "customerSearchHelp"
            );

    const selectedCustomerCodeInput = document.getElementById(
            "selectedCustomerCodeInput"
            );

    const selectedCustomerCard = document.getElementById(
            "selectedCustomerCard"
            );

    const selectedCustomerName = document.getElementById(
            "selectedCustomerName"
            );

    const selectedCustomerDetail = document.getElementById(
            "selectedCustomerDetail"
            );

    const selectedCustomerPoints = document.getElementById(
            "selectedCustomerPoints"
            );

    const clearSelectedCustomerButton = document.getElementById(
            "clearSelectedCustomerButton"
            );

    const customerSearchItems = Array.from(
            document.querySelectorAll(".customer-search-item")
            );

    const newCustomerName = document.getElementById(
            "newCustomerName"
            );

    const newCustomerPhone = document.getElementById(
            "newCustomerPhone"
            );

    const saveCustomerCheckbox =
            document.getElementById(
                    "saveCustomerCheckbox"
                    );

    const saveCustomerHiddenInput =
            document.getElementById(
                    "saveCustomerHiddenInput"
                    );

    const voucherSection = document.getElementById(
            "voucherSection"
            );

    const voucherSelect = document.getElementById(
            "voucherSelect"
            );

    const voucherHelpText = document.getElementById(
            "voucherHelpText"
            );

    const voucherPreview = document.getElementById(
            "selectedVoucherPreview"
            );

    const voucherCodeElement = document.getElementById(
            "selectedVoucherCode"
            );

    const usedVoucherValue = document.getElementById(
            "usedVoucherValue"
            );

    const subTotalValue = document.getElementById(
            "subTotalValue"
            );

    const vatValue = document.getElementById(
            "vatValue"
            );

    const voucherDiscountValue = document.getElementById(
            "voucherDiscountValue"
            );

    const grandTotalValue = document.getElementById(
            "grandTotalValue"
            );

    const cancelInvoiceButton = document.getElementById(
            "cancelInvoiceButton"
            );

    const cancelInvoiceForm = document.getElementById(
            "cancelInvoiceForm"
            );

    const cancelReasonInput = document.getElementById(
            "cancelReasonInput"
            );

    const voucherOptions = voucherSelect
            ? Array.from(
                    voucherSelect.querySelectorAll(
                            "option[data-customer]"
                            )
                    )
            : [];

    function formatMoney(value) {
        return (Number(value) || 0)
                .toLocaleString("vi-VN") + "đ";
    }

    function normalizeText(value) {
        return String(value || "")
                .toLowerCase()
                .normalize("NFD")
                .replace(/[\u0300-\u036f]/g, "")
                .replace(/đ/g, "d")
                .trim();
    }

    function getCustomerMode() {
        const selectedMode = document.querySelector(
                'input[name="customerMode"]:checked'
                );

        return selectedMode
                ? selectedMode.value
                : "guest";
    }

    function getCartRows() {
        if (!cartTableBody) {
            return [];
        }

        return Array.from(
                cartTableBody.querySelectorAll(
                        ".cart-row"
                        )
                );
    }

    function findCartRow(productCode) {
        return getCartRows().find(function (row) {
            return row.dataset.code === productCode;
        });
    }

    function updateEmptyCart() {
        if (!emptyCart) {
            return;
        }

        emptyCart.classList.toggle(
                "hidden",
                getCartRows().length > 0
                );
    }

    function getSelectedCustomerCode() {
        if (
                !selectedCustomerCodeInput
                || selectedCustomerCodeInput.disabled
                ) {
            return "";
        }

        return selectedCustomerCodeInput
                .value
                .trim();
    }

    function getCustomerDisplayText(item) {
        const code = item.dataset.code || "";
        const name = item.dataset.name || "";
        const phone = item.dataset.phone || "";

        return [
            code,
            name,
            phone
        ]
                .filter(Boolean)
                .join(" - ");
    }

    function setCustomerSearchMessage(
            message,
            isError
            ) {
        if (!customerSearchHelp) {
            return;
        }

        customerSearchHelp.textContent = message;

        customerSearchHelp.classList.toggle(
                "text-danger",
                Boolean(isError)
                );
    }

    function hideCustomerSearchResults() {
        if (customerSearchResults) {
            customerSearchResults
                    .classList
                    .add("hidden");
        }
    }

    function selectSavedCustomer(
            item,
            resetVoucher
            ) {
        if (
                !item
                || !selectedCustomerCodeInput
                ) {
            return;
        }

        const code = item.dataset.code || "";
        const name = item.dataset.name || "";
        const phone = item.dataset.phone || "";

        const points =
                Number(item.dataset.points) || 0;

        selectedCustomerCodeInput.value = code;

        if (customerSearchInput) {
            customerSearchInput.value =
                    getCustomerDisplayText(item);
        }

        if (selectedCustomerName) {
            selectedCustomerName.textContent =
                    name || "—";
        }

        if (selectedCustomerDetail) {
            selectedCustomerDetail.textContent =
                    code
                    + " · "
                    + (
                            phone
                            || "Chưa có số điện thoại"
                            );
        }

        if (selectedCustomerPoints) {
            selectedCustomerPoints.textContent =
                    points + " điểm";
        }

        if (selectedCustomerCard) {
            selectedCustomerCard
                    .classList
                    .remove("hidden");
        }

        hideCustomerSearchResults();

        setCustomerSearchMessage(
                "Đã tìm thấy và liên kết khách hàng với hóa đơn.",
                false
                );

        filterVouchers(
                Boolean(resetVoucher)
                );
    }

    function clearSelectedCustomer(
            resetSearchText
            ) {
        if (selectedCustomerCodeInput) {
            selectedCustomerCodeInput.value = "";
        }

        if (
                resetSearchText
                && customerSearchInput
                ) {
            customerSearchInput.value = "";
        }

        if (selectedCustomerCard) {
            selectedCustomerCard
                    .classList
                    .add("hidden");
        }

        setCustomerSearchMessage(
                "Nhập mã, họ tên hoặc số điện thoại để tìm khách hàng.",
                false
                );

        filterVouchers(true);
    }

    function searchSavedCustomers() {
        if (
                !customerSearchInput
                || !customerSearchResults
                ) {
            return;
        }

        const keyword = normalizeText(
                customerSearchInput.value
                );

        if (keyword === "") {
            hideCustomerSearchResults();

            setCustomerSearchMessage(
                    "Nhập mã, họ tên hoặc số điện thoại để tìm khách hàng.",
                    false
                    );

            return;
        }

        let matchedCount = 0;

        customerSearchItems.forEach(
                function (item) {
                    const searchText =
                            normalizeText(
                                    [
                                        item.dataset.code,
                                        item.dataset.name,
                                        item.dataset.phone
                                    ]
                                    .filter(Boolean)
                                    .join(" ")
                                    );

                    const matched =
                            searchText.includes(keyword);

                    item.classList.toggle(
                            "hidden",
                            !matched
                            );

                    if (matched) {
                        matchedCount++;
                    }
                }
        );

        if (customerSearchEmpty) {
            customerSearchEmpty
                    .classList
                    .toggle(
                            "hidden",
                            matchedCount !== 0
                            );
        }

        customerSearchResults
                .classList
                .remove("hidden");

        if (matchedCount === 0) {
            setCustomerSearchMessage(
                    "Không tìm thấy khách hàng phù hợp.",
                    true
                    );
        } else {
            setCustomerSearchMessage(
                    "Tìm thấy "
                    + matchedCount
                    + " khách hàng.",
                    false
                    );
        }
    }

    function restoreSelectedCustomer() {
        if (!selectedCustomerCodeInput) {
            return;
        }

        const customerCode =
                selectedCustomerCodeInput
                .value
                .trim();

        if (customerCode === "") {
            return;
        }

        const item = customerSearchItems.find(
                function (customerItem) {
                    return customerItem.dataset.code
                            === customerCode;
                }
        );

        if (item) {
            selectSavedCustomer(
                    item,
                    false
                    );
        }
    }

    function getVoucherValue() {
        if (
                voucherSelect
                && !voucherSelect.disabled
                ) {
            const option =
                    voucherSelect.options[
                            voucherSelect.selectedIndex
                    ];

            if (option) {
                return Number(
                        option.dataset.value
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

        const option =
                voucherSelect.options[
                        voucherSelect.selectedIndex
                ];

        const voucherCode = option
                ? option.dataset.code || ""
                : "";

        if (
                voucherCode
                && !voucherSelect.disabled
                ) {
            voucherCodeElement.textContent =
                    voucherCode;

            voucherPreview
                    .classList
                    .remove("hidden");
        } else {
            voucherCodeElement.textContent =
                    "—";

            voucherPreview
                    .classList
                    .add("hidden");
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

                    let quantity = quantityInput
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

        const vat = Math.round(
                subTotal * 0.08
                );

        const totalBeforeDiscount =
                subTotal + vat;

        const voucherValue =
                getVoucherValue();

        const grandTotal = Math.max(
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
                    "-"
                    + formatMoney(voucherValue);

            voucherDiscountValue
                    .classList
                    .toggle(
                            "text-danger",
                            voucherValue
                            > totalBeforeDiscount
                            );
        }

        if (grandTotalValue) {
            grandTotalValue.textContent =
                    formatMoney(grandTotal);
        }

        updateVoucherPreview();
        updateEmptyCart();
    }

    function filterVouchers(
            resetSelectedVoucher
            ) {
        if (!voucherSelect) {
            updateInvoiceTotal();
            return;
        }

        const useSavedCustomer =
                getCustomerMode() === "saved";

        const customerCode =
                useSavedCustomer
                ? getSelectedCustomerCode()
                : "";

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
                Boolean(
                        selectedOption
                        && selectedOption.dataset.customer
                        && selectedOption.dataset.customer
                        === customerCode
                        );

        if (
                resetSelectedVoucher
                || customerCode === ""
                || (
                        selectedOption
                        && selectedOption.dataset.customer
                        && !selectedBelongsToCustomer
                        )
                ) {
            voucherSelect.value = "";
        }

        voucherSelect.disabled =
                !useSavedCustomer
                || customerCode === ""
                || voucherCount === 0;

        if (voucherHelpText) {
            if (!useSavedCustomer) {
                voucherHelpText.textContent =
                        "Khách hàng mới chưa thể sử dụng voucher trong hóa đơn hiện tại.";
            } else if (customerCode === "") {
                voucherHelpText.textContent =
                        "Vui lòng tìm kiếm khách hàng đã lưu để xem voucher.";
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

        updateInvoiceTotal();
    }

    function syncCustomerMode(resetVoucher) {
        const useSavedCustomer =
                getCustomerMode() === "saved";

        if (savedCustomerSection) {
            savedCustomerSection.classList.toggle(
                    "hidden",
                    !useSavedCustomer
                    );
        }

        if (guestCustomerSection) {
            guestCustomerSection.classList.toggle(
                    "hidden",
                    useSavedCustomer
                    );
        }

        if (customerSearchInput) {
            customerSearchInput.disabled =
                    !useSavedCustomer;
        }

        if (customerSearchButton) {
            customerSearchButton.disabled =
                    !useSavedCustomer;
        }

        if (selectedCustomerCodeInput) {
            selectedCustomerCodeInput.disabled =
                    !useSavedCustomer;
        }

        if (newCustomerName) {
            newCustomerName.disabled =
                    useSavedCustomer;

            newCustomerName.required =
                    !useSavedCustomer;
        }

        if (newCustomerPhone) {
            newCustomerPhone.disabled =
                    useSavedCustomer;

            newCustomerPhone.required =
                    !useSavedCustomer;
        }

        if (saveCustomerCheckbox) {
            saveCustomerCheckbox.checked = true;
            saveCustomerCheckbox.disabled =
                    useSavedCustomer;
        }

        if (saveCustomerHiddenInput) {
            saveCustomerHiddenInput.disabled =
                    useSavedCustomer;
        }

        if (voucherSection) {
            voucherSection.classList.toggle(
                    "hidden",
                    !useSavedCustomer
                    );
        }

        if (!useSavedCustomer) {
            hideCustomerSearchResults();

            if (selectedCustomerCodeInput) {
                selectedCustomerCodeInput.value = "";
            }

            if (selectedCustomerCard) {
                selectedCustomerCard.classList.add(
                        "hidden"
                        );
            }

            if (voucherSelect) {
                voucherSelect.value = "";
                voucherSelect.disabled = true;
            }
        }

        filterVouchers(resetVoucher);
    }

    function createProductCell(
            productCode,
            productName,
            productPrice
            ) {
        const cell =
                document.createElement("td");

        const name =
                document.createElement("strong");

        const price =
                document.createElement("small");

        const hiddenInput =
                document.createElement("input");

        name.textContent = productName;

        price.textContent =
                formatMoney(productPrice);

        hiddenInput.type = "hidden";
        hiddenInput.name = "maSanPham";
        hiddenInput.value = productCode;

        cell.appendChild(name);
        cell.appendChild(price);
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

        const icon =
                document.createElement("i");

        button.className = "cart-remove";
        button.type = "button";
        button.title = "Xóa sản phẩm";

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
                || productButton.classList
                .contains("disabled")
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
                        String(
                                currentQuantity + 1
                                );
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
                normalizeText(
                        productSearch.value
                        );

        document
                .querySelectorAll(".product-pick")
                .forEach(function (button) {
                    const searchText =
                            normalizeText(
                                    button.dataset.search
                                    );

                    button.style.display =
                            searchText.includes(keyword)
                            ? ""
                            : "none";
                });
    }

    function validateCustomer() {
        const mode = getCustomerMode();

        if (mode === "saved") {
            if (
                    getSelectedCustomerCode()
                    === ""
                    ) {
                alert(
                        "Vui lòng tìm kiếm và chọn khách hàng đã lưu."
                        );

                if (customerSearchInput) {
                    customerSearchInput.focus();
                }

                return false;
            }

            return true;
        }

        const customerName =
                newCustomerName
                ? newCustomerName.value.trim()
                : "";

        const customerPhone =
                newCustomerPhone
                ? newCustomerPhone.value
                .replace(/\s+/g, "")
                : "";

        if (customerName === "") {
            alert(
                    "Vui lòng nhập tên khách hàng mới."
                    );

            if (newCustomerName) {
                newCustomerName.focus();
            }

            return false;
        }

        if (customerPhone === "") {
            alert(
                    "Vui lòng nhập số điện thoại khách hàng mới."
                    );

            if (newCustomerPhone) {
                newCustomerPhone.focus();
            }

            return false;
        }

        if (
                !/^0\d{8,10}$/.test(
                        customerPhone
                        )
                ) {
            alert(
                    "Số điện thoại phải bắt đầu bằng 0 và có từ 9 đến 11 số."
                    );

            if (newCustomerPhone) {
                newCustomerPhone.focus();
            }

            return false;
        }

        if (saveCustomerCheckbox) {
            saveCustomerCheckbox.checked = true;
        }

        if (saveCustomerHiddenInput) {
            saveCustomerHiddenInput.disabled = false;
            saveCustomerHiddenInput.value = "true";
        }

        return true;
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

                    return;
                }

                if (
                        customerSearchResults
                        && !customerSearchResults
                        .classList
                        .contains("hidden")
                        && !customerSearchResults
                        .contains(event.target)
                        && customerSearchInput
                        && !customerSearchInput
                        .contains(event.target)
                        && customerSearchButton
                        && !customerSearchButton
                        .contains(event.target)
                        ) {
                    hideCustomerSearchResults();
                }
            }
    );

    if (cartTableBody) {
        cartTableBody.addEventListener(
                "input",
                function (event) {
                    if (
                            event.target.classList
                            .contains(
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
                            !event.target.classList
                            .contains(
                                    "cart-quantity"
                                    )
                            ) {
                        return;
                    }

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
        );
    }

    if (productSearch) {
        productSearch.addEventListener(
                "input",
                filterProducts
                );
    }

    customerModeRadios.forEach(
            function (radio) {
                radio.addEventListener(
                        "change",
                        function () {
                            syncCustomerMode(true);
                        }
                );
            }
    );

    if (customerSearchButton) {
        customerSearchButton
                .addEventListener(
                        "click",
                        searchSavedCustomers
                        );
    }

    if (customerSearchInput) {
        customerSearchInput
                .addEventListener(
                        "input",
                        function () {
                            if (
                                    getSelectedCustomerCode()
                                    !== ""
                                    ) {
                                clearSelectedCustomer(
                                        false
                                        );
                            }

                            searchSavedCustomers();
                        }
                );

        customerSearchInput
                .addEventListener(
                        "keydown",
                        function (event) {
                            if (
                                    event.key === "Enter"
                                    ) {
                                event.preventDefault();

                                searchSavedCustomers();
                            }
                        }
                );
    }

    if (customerSearchResults) {
        customerSearchResults
                .addEventListener(
                        "click",
                        function (event) {
                            const item =
                                    event.target.closest(
                                            ".customer-search-item"
                                            );

                            if (!item) {
                                return;
                            }

                            selectSavedCustomer(
                                    item,
                                    true
                                    );
                        }
                );
    }

    if (clearSelectedCustomerButton) {
        clearSelectedCustomerButton
                .addEventListener(
                        "click",
                        function () {
                            clearSelectedCustomer(
                                    true
                                    );

                            if (customerSearchInput) {
                                customerSearchInput.focus();
                            }
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
        cancelInvoiceButton
                .addEventListener(
                        "click",
                        function () {
                            const reason =
                                    window.prompt(
                                            "Nhập lý do hủy hóa đơn:"
                                            );

                            if (reason === null) {
                                return;
                            }

                            if (
                                    reason.trim() === ""
                                    ) {
                                alert(
                                        "Vui lòng nhập lý do hủy."
                                        );

                                return;
                            }

                            if (
                                    !window.confirm(
                                            "Xác nhận hủy hóa đơn?"
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

    if (invoiceForm) {
        invoiceForm.addEventListener(
                "submit",
                function (event) {
                    const submitButton =
                            event.submitter;

                    const action = submitButton
                            ? submitButton.value
                            : "";

                    if (
                            action !== "save"
                            && action !== "pay"
                            ) {
                        return;
                    }

                    if (
                            getCartRows().length === 0
                            ) {
                        event.preventDefault();

                        alert(
                                "Hóa đơn phải có ít nhất một sản phẩm."
                                );

                        return;
                    }

                    if (!validateCustomer()) {
                        event.preventDefault();
                        return;
                    }

                    if (action !== "pay") {
                        return;
                    }

                    const voucherValue =
                            getVoucherValue();

                    const subTotal =
                            calculateSubTotal();

                    const vat = Math.round(
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
                        const option =
                                voucherSelect.options[
                                        voucherSelect
                                        .selectedIndex
                                ];

                        const voucherCode =
                                option
                                ? option.dataset.code
                                || ""
                                : "";

                        const confirmed =
                                window.confirm(
                                        "Xác nhận dùng voucher "
                                        + voucherCode
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

    restoreSelectedCustomer();

    if (
            customerModeRadios.length > 0
            ) {
        syncCustomerMode(false);
    } else {
        updateInvoiceTotal();
    }
});