<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Get cookies if exist
    String cEmail = "";
    String cPassword = "";
    boolean rememberChecked = false;

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("cEmail".equals(c.getName())) {
                cEmail = c.getValue();
            }
            if ("cPassword".equals(c.getName())) {
                cPassword = c.getValue();
            }
        }
    }

    // Check if both email and password cookies exist then check remember checkbox
    if (!cEmail.isEmpty() && !cPassword.isEmpty()) {
        rememberChecked = true;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Login</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" />

        <!-- Google Fonts & FontAwesome -->
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet" />

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Inter', 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
            }
            
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 1rem;
                position: relative;
                overflow-x: hidden;
            }
            
            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: 
                    radial-gradient(circle at 20% 50%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 80% 80%, rgba(118, 75, 162, 0.3) 0%, transparent 50%);
                animation: backgroundMove 20s ease infinite;
            }
            
            @keyframes backgroundMove {
                0%, 100% { transform: translate(0, 0) scale(1); }
                50% { transform: translate(-20px, -20px) scale(1.1); }
            }
            
            .login-container {
                width: 100%;
                max-width: 1100px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                box-shadow: 
                    0 20px 60px rgba(0, 0, 0, 0.15),
                    0 0 0 1px rgba(255, 255, 255, 0.2);
                overflow: hidden;
                margin: 2rem;
                position: relative;
                z-index: 1;
                animation: slideUp 0.6s ease-out;
            }
            
            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .illustration-side {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                padding: 3rem;
                overflow: hidden;
            }
            
            .illustration-side::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
                animation: rotate 20s linear infinite;
            }
            
            @keyframes rotate {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
            
            .illustration-side img {
                max-width: 100%;
                height: auto;
                border-radius: 20px;
                transition: transform 0.5s ease;
                position: relative;
                z-index: 1;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            }
            
            .illustration-side img:hover {
                transform: scale(1.05) rotate(2deg);
            }
            
            .form-side {
                padding: 3.5rem 3rem;
                display: flex;
                flex-direction: column;
                justify-content: center;
                background: white;
            }
            
            .form-side h2 {
                font-size: 2.25rem;
                font-weight: 700;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 0.5rem;
                letter-spacing: -0.5px;
            }
            
            .form-side p {
                color: #6b7280;
                font-size: 0.95rem;
                margin-bottom: 2rem;
            }
            
            .form-group {
                margin-bottom: 1.75rem;
                position: relative;
            }
            
            .form-group label {
                display: block;
                font-size: 0.875rem;
                font-weight: 600;
                color: #374151;
                margin-bottom: 0.5rem;
                letter-spacing: 0.3px;
            }
            
            .input-wrapper {
                position: relative;
                display: flex;
                align-items: center;
            }
            
            .input-icon {
                position: absolute;
                left: 1rem;
                color: #9ca3af;
                font-size: 1.1rem;
                z-index: 2;
                transition: color 0.3s;
            }
            
            .form-group input {
                width: 100%;
                padding: 0.875rem 1rem 0.875rem 3rem;
                border: 2px solid #e5e7eb;
                border-radius: 12px;
                font-size: 0.95rem;
                transition: all 0.3s ease;
                background: #f9fafb;
                color: #111827;
            }
            
            .form-group input:focus {
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
                outline: none;
            }
            
            .form-group input:focus + .input-icon,
            .form-group:focus-within .input-icon {
                color: #667eea;
            }
            
            .form-group.password-field .input-icon-lock {
                position: absolute;
                left: 1rem;
                color: #9ca3af;
                font-size: 1.1rem;
                z-index: 2;
                transition: color 0.3s;
            }
            
            .form-group.password-field input {
                padding-right: 3.5rem;
            }
            
            .form-group.password-field:focus-within .input-icon-lock {
                color: #667eea;
            }
            
            .password-toggle {
                position: absolute;
                right: 1rem;
                top: 50%;
                transform: translateY(-50%);
                color: #9ca3af;
                font-size: 1.1rem;
                cursor: pointer;
                z-index: 30;
                pointer-events: auto !important;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 32px;
                height: 32px;
                border-radius: 8px;
                transition: all 0.3s ease;
                user-select: none;
                -webkit-user-select: none;
            }
            
            .password-toggle:hover {
                color: #667eea;
                background: rgba(102, 126, 234, 0.1);
            }
            
            .password-toggle:active {
                transform: translateY(-50%) scale(0.95);
            }
            
            .form-options {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
            }
            
            .form-options .form-check {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }
            
            .form-options .form-check-input {
                width: 1.1rem;
                height: 1.1rem;
                cursor: pointer;
                border: 2px solid #d1d5db;
                border-radius: 4px;
            }
            
            .form-options .form-check-input:checked {
                background-color: #667eea;
                border-color: #667eea;
            }
            
            .form-options .form-check-label {
                font-size: 0.875rem;
                color: #4b5563;
                user-select: none;
                cursor: pointer;
            }
            
            .form-options a {
                font-size: 0.875rem;
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }
            
            .form-options a:hover {
                color: #764ba2;
                text-decoration: underline;
            }
            
            .btn-signin {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 12px;
                padding: 1rem;
                font-size: 1rem;
                font-weight: 600;
                width: 100%;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
                position: relative;
                overflow: hidden;
            }
            
            .btn-signin::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }
            
            .btn-signin:hover::before {
                left: 100%;
            }
            
            .btn-signin:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }
            
            .btn-signin:active {
                transform: translateY(0);
            }
            
            .alert {
                padding: 1rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
                border: none;
                font-size: 0.9rem;
            }
            
            .alert-danger {
                background: #fee2e2;
                color: #991b1b;
            }
            
            @media (max-width: 768px) {
                body {
                    padding: 0.5rem;
                }
                
                .login-container {
                    margin: 0;
                    border-radius: 16px;
                }
                
                .illustration-side {
                    padding: 2rem 1rem;
                    min-height: 200px;
                }
                
                .form-side {
                    padding: 2.5rem 1.5rem;
                }
                
                .form-side h2 {
                    font-size: 1.75rem;
                }
                
                .form-side p {
                    font-size: 0.875rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="row w-100 m-0">
                <!-- Illustration Side -->
                <div class="col-md-6 illustration-side">
                    <img src="admin/img/photos/test.jpg" alt="Warehouse Management Illustration" />
                </div>
                <!-- Form Side -->
                <div class="col-md-6 form-side">
                    <h2>Welcome back!</h2>
                    <p>Sign in to your account to continue</p>

                    <% if (request.getAttribute("error") != null) { 
                        String errorMsg = (String) request.getAttribute("error");
                        // Replace newlines with <br> for HTML display
                        errorMsg = errorMsg.replace("\n", "<br>");
                    %>
                    <div class="alert alert-danger" role="alert" style="white-space: pre-line; line-height: 1.6;">
                        <i class="fas fa-exclamation-circle"></i> 
                        <div style="margin-top: 0.5rem;"><%= errorMsg %></div>
                    </div>
                    <% } %>

                    <form action="login" method="post" autocomplete="off">
                        <div class="form-group">
                            <label for="username">
                                <i class="fas fa-user-circle" style="margin-right: 0.5rem; color: #667eea;"></i>
                                Username or Email
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-user input-icon"></i>
                                <input
                                    type="text"
                                    id="username"
                                    name="username"
                                    placeholder="Enter username or email"
                                    value="<%= cEmail %>"
                                    required
                                    />
                            </div>
                        </div>

                        <div class="form-group password-field">
                            <label for="password">
                                <i class="fas fa-key" style="margin-right: 0.5rem; color: #667eea;"></i>
                                Password
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-lock input-icon-lock"></i>
                                <input
                                    type="password"
                                    id="password"
                                    name="password"
                                    placeholder="Enter password"
                                    value="<%= cPassword %>"
                                    required
                                    />
                                <span class="password-toggle" id="togglePassword" role="button" tabindex="0" aria-label="Show password">
                                    <i class="fas fa-eye"></i>
                                </span>
                            </div>
                        </div>

                        <div class="form-options">
                            <div class="form-check">
                                <input
                                    type="checkbox"
                                    class="form-check-input"
                                    id="rememberMe"
                                    name="remember"
                                    <%= rememberChecked ? "checked" : "" %>
                                    />
                                <label class="form-check-label" for="rememberMe">Remember me</label>
                            </div>
                            <a href="${pageContext.request.contextPath}/forgotpass">Forgot password?</a>
                        </div>

                        <button type="submit" class="btn-signin">
                            <i class="fas fa-sign-in-alt" style="margin-right: 0.5rem;"></i>
                            Sign In
                        </button>
                        
                        <!-- Divider -->
                        <div style="text-align: center; margin: 2rem 0 1.5rem 0; display: flex; align-items: center; justify-content: center;">
                            <hr style="flex: 1; border: none; border-top: 1px solid #e5e7eb;">
                            <span style="padding: 0 1rem; color: #6b7280; font-size: 0.9rem; font-weight: 500;">Hoặc</span>
                            <hr style="flex: 1; border: none; border-top: 1px solid #e5e7eb;">
                        </div>
                        
                        <!-- Google Login Button -->
                        <a href="${pageContext.request.contextPath}/google-login" 
                           style="display: flex; align-items: center; justify-content: center; 
                                  gap: 0.75rem; padding: 1rem; background: white; 
                                  border: 2px solid #e5e7eb; border-radius: 12px; 
                                  color: #374151; text-decoration: none; font-weight: 600; 
                                  transition: all 0.3s; width: 100%; 
                                  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);">
                            <img src="https://www.google.com/favicon.ico" alt="Google" 
                                 style="width: 20px; height: 20px;">
                            <span>Đăng nhập bằng Google</span>
                        </a>

                    </form>
                </div>
            </div>
        </div>

        <script>
            (function() {
                function initPasswordToggle() {
                    const toggleButton = document.getElementById('togglePassword');
                    const passwordInput = document.getElementById('password');
                    
                    if (!toggleButton || !passwordInput) {
                        console.error('Password toggle elements not found');
                        return;
                    }
                    
                    const eyeIcon = toggleButton.querySelector('i');
                    
                    function togglePassword() {
                        if (passwordInput.type === 'password') {
                            passwordInput.type = 'text';
                            if (eyeIcon) {
                                eyeIcon.classList.remove('fa-eye');
                                eyeIcon.classList.add('fa-eye-slash');
                            }
                            toggleButton.setAttribute('aria-label', 'Hide password');
                        } else {
                            passwordInput.type = 'password';
                            if (eyeIcon) {
                                eyeIcon.classList.remove('fa-eye-slash');
                                eyeIcon.classList.add('fa-eye');
                            }
                            toggleButton.setAttribute('aria-label', 'Show password');
                        }
                    }
                    
                    // Click event
                    toggleButton.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        togglePassword();
                    });
                    
                    // Keyboard support (Enter/Space)
                    toggleButton.addEventListener('keydown', function(e) {
                        if (e.key === 'Enter' || e.key === ' ') {
                            e.preventDefault();
                            togglePassword();
                        }
                    });
                    
                    // Prevent form submission when clicking toggle
                    toggleButton.addEventListener('mousedown', function(e) {
                        e.preventDefault();
                    });
                }
                
                // Initialize when DOM is ready
                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', initPasswordToggle);
                } else {
                    initPasswordToggle();
                }
            })();
        </script>
    </body>
</html>