<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Create New Account - 4LUA</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" />

        
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&family=Segoe+UI:wght@400;500;700&display=swap" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet" />

        <style>
            /* Giữ nguyên style từ form login */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Heebo', 'Segoe UI', sans-serif;
            }
            body {
                background: #f4f7fa;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #333;
            }
            .login-container {
                width: 100%;
                max-width: 1000px;
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin: 2rem;
            }
            .illustration-side {
                background: #e0e7ff;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                padding: 2rem;
            }
            .illustration-side img {
                max-width: 100%;
                height: auto;
                border-radius: 15px;
                transition: transform 0.3s ease;
            }
            .illustration-side img:hover {
                transform: scale(1.05);
            }
            .form-side {
                padding: 3rem 2rem;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            .form-side h2 {
                font-size: 2rem;
                font-weight: 700;
                color: #1e3a8a;
                margin-bottom: 1.5rem;
            }
            .form-group {
                margin-bottom: 1.5rem;
                position: relative;
            }
            .form-group label {
                display: block;
                font-size: 0.95rem;
                color: #6b7280;
                margin-bottom: 0.5rem;
            }
            .form-group input, .form-group select {
                width: 100%;
                padding: 0.8rem 1rem;
                border: 2px solid #e5e7eb;
                border-radius: 10px;
                font-size: 1rem;
                transition: border-color 0.3s, box-shadow 0.3s;
            }
            .form-group input:focus, .form-group select:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                outline: none;
            }
            .form-group i {
                position: absolute;
                top: 50%;
                right: 1rem;
                transform: translateY(-50%);
                color: #6b7280;
                font-size: 1.2rem;
            }
            .form-check {
                margin-bottom: 1.5rem;
            }
            .form-check-label {
                font-size: 0.9rem;
                color: #4b5563;
                user-select: none;
            }
            .form-check-input {
                cursor: pointer;
                width: 1.2rem;
                height: 1.2rem;
            }
            .btn-register {
                background: linear-gradient(135deg, #3b82f6, #1e3a8a);
                color: white;
                border: none;
                border-radius: 10px;
                padding: 0.8rem;
                font-size: 1.1rem;
                font-weight: 600;
                width: 100%;
                cursor: pointer;
                transition: transform 0.3s, box-shadow 0.3s;
                margin-bottom: 1rem;
            }
            .btn-register:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
            }
            .login-link {
                text-align: center;
                font-size: 0.9rem;
                color: #6b7280;
                margin-top: 1rem;
            }
            .login-link a {
                color: #facc15;
                text-decoration: none;
                font-weight: 600;
            }
            .login-link a:hover {
                text-decoration: underline;
            }
            @media (max-width: 768px) {
                .login-container {
                    margin: 1rem;
                }
                .illustration-side {
                    padding: 1rem;
                    min-height: 200px;
                }
                .form-side {
                    padding: 2rem 1.5rem;
                }
                .form-side h2 {
                    font-size: 1.5rem;
                }
                .btn-register {
                    padding: 0.6rem;
                    font-size: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="row w-100 m-0">
                <!-- Illustration Side -->
                <div class="col-md-6 illustration-side">
                    <img src="img/whmn.webp" alt="Warehouse Management Illustration" />
                </div>
                <!-- Form Side -->
                <div class="col-md-6 form-side">
                    <h2>Create New Account</h2>

                    <%-- Display error or success message --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>
                    <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success" role="alert">
                        <%= request.getAttribute("success") %>
                    </div>
                    <% } %>

                    <form action="register" method="post" autocomplete="off">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" placeholder="Username" required />
                            <i class="fas fa-user"></i>
                        </div>

                        <div class="form-group">
                            <label for="first_name">First Name</label>
                            <input type="text" id="first_name" name="first_name" placeholder="First Name" required />
                            <i class="fas fa-id-badge"></i>
                        </div>

                        <div class="form-group">
                            <label for="last_name">Last Name</label>
                            <input type="text" id="last_name" name="last_name" placeholder="Last Name" required />
                            <i class="fas fa-id-badge"></i>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" placeholder="Email address" required />
                            <i class="fas fa-envelope"></i>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" placeholder="Password" required />
                            <i class="fas fa-lock"></i>
                        </div>

                        <div class="form-group">
                            <label for="confirm_password">Confirm Password</label>
                            <input type="password" id="confirm_password" name="confirm_password" placeholder="Confirm Password" required />
                            <i class="fas fa-lock"></i>
                        </div>

                        <div class="form-group">
                            <label for="role_id">Role</label>
                            <select id="role_id" name="role_id" required>
                                <option value="">-- Select Role --</option>
                                <option value="1">Admin</option>
                                <option value="2">Warehouse Manager</option>
                                <option value="3">Sales Staff</option>
                                <option value="4">Warehouse Staff</option>
                            </select>
                            <i class="fas fa-user-tag"></i>
                        </div>

                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="terms" name="terms" required />
                            <label class="form-check-label" for="terms">
                                I agree to the <a href="terms.jsp" target="_blank">terms and conditions</a>
                            </label>
                        </div>

                        <button type="submit" class="btn-register">Register</button>

                        <p class="login-link">
                            Already have an account? <a href="login">Login</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
