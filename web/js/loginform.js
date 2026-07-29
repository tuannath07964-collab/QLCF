document.addEventListener(
    "DOMContentLoaded",
    function () {
        const loginForm =
                document.getElementById(
                    "loginForm"
                );

        const employeeId =
                document.getElementById(
                    "employeeId"
                );

        const passwordField =
                document.getElementById(
                    "passwordField"
                );

        const togglePassword =
                document.getElementById(
                    "togglePassword"
                );

        const toggleIcon =
                document.getElementById(
                    "toggleIcon"
                );

        const rememberEmployee =
                document.getElementById(
                    "rememberEmployee"
                );

        const capsLockWarning =
                document.getElementById(
                    "capsLockWarning"
                );

        const loginButton =
                document.getElementById(
                    "loginButton"
                );

        const loginButtonText =
                document.getElementById(
                    "loginButtonText"
                );

        const loginButtonIcon =
                document.getElementById(
                    "loginButtonIcon"
                );

        function togglePasswordVisibility() {
            if (
                !passwordField
                || !toggleIcon
            ) {
                return;
            }

            const isPassword =
                    passwordField.type
                    === "password";

            passwordField.type =
                    isPassword
                    ? "text"
                    : "password";

            toggleIcon.className =
                    isPassword
                    ? "fa-regular fa-eye-slash"
                    : "fa-regular fa-eye";

            if (togglePassword) {
                togglePassword.title =
                        isPassword
                        ? "Ẩn mật khẩu"
                        : "Hiển thị mật khẩu";
            }

            passwordField.focus();
        }

        function updateCapsLockWarning(
                event
        ) {
            if (!capsLockWarning) {
                return;
            }

            const capsLockEnabled =
                    event.getModifierState
                    && event.getModifierState(
                        "CapsLock"
                    );

            if (capsLockEnabled) {
                capsLockWarning.classList.add(
                    "show"
                );
            } else {
                capsLockWarning.classList.remove(
                    "show"
                );
            }
        }

        function loadRememberedEmployee() {
            if (
                !employeeId
                || !rememberEmployee
            ) {
                return;
            }

            try {
                const rememberedId =
                        localStorage.getItem(
                            "qlcfRememberedEmployee"
                        );

                if (
                    rememberedId
                    && !employeeId.value.trim()
                ) {
                    employeeId.value =
                            rememberedId;

                    rememberEmployee.checked =
                            true;

                    if (passwordField) {
                        passwordField.focus();
                    }
                }
            } catch (error) {
                console.log(
                    "Không đọc được mã nhân viên đã lưu."
                );
            }
        }

        function saveRememberedEmployee() {
            if (
                !employeeId
                || !rememberEmployee
            ) {
                return;
            }

            try {
                if (
                    rememberEmployee.checked
                    && employeeId.value.trim()
                ) {
                    localStorage.setItem(
                        "qlcfRememberedEmployee",
                        employeeId.value.trim()
                    );
                } else {
                    localStorage.removeItem(
                        "qlcfRememberedEmployee"
                    );
                }
            } catch (error) {
                console.log(
                    "Không thể lưu mã nhân viên."
                );
            }
        }

        function showLoadingState() {
            if (
                !loginButton
                || !loginButtonText
                || !loginButtonIcon
            ) {
                return;
            }

            loginButton.disabled =
                    true;

            loginButtonText.textContent =
                    "Đang đăng nhập...";

            loginButtonIcon.className =
                    "fa-solid fa-spinner fa-spin";
        }

        if (togglePassword) {
            togglePassword.addEventListener(
                "click",
                togglePasswordVisibility
            );
        }

        if (passwordField) {
            passwordField.addEventListener(
                "keydown",
                updateCapsLockWarning
            );

            passwordField.addEventListener(
                "keyup",
                updateCapsLockWarning
            );

            passwordField.addEventListener(
                "blur",
                function () {
                    if (capsLockWarning) {
                        capsLockWarning.classList.remove(
                            "show"
                        );
                    }
                }
            );
        }

        if (loginForm) {
            loginForm.addEventListener(
                "submit",
                function () {
                    saveRememberedEmployee();
                    showLoadingState();
                }
            );
        }

        loadRememberedEmployee();
    }
);