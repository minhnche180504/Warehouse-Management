<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Forgot Password</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&family=Segoe+UI:wght@400;500;700&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet" />

    <style>
    
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
            max-width: 500px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            margin: 2rem;
            padding: 3rem 2rem;
        }
        h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 1.5rem;
            text-align: center;
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
        .form-group input {
            width: 100%;
            padding: 0.8rem 2.5rem 0.8rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-group input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
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
        .btn-submit {
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
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(59,130,246,0.3);
        }
        .back-link {
            text-align: center;
            font-size: 0.9rem;
            color: #6b7280;
            margin-top: 1rem;
        }
        .back-link a {
            color: #facc15;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
        .alert {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="login-container">

        <h2>Forgot Password</h2>

        <%-- Hiển thị thông báo lỗi hoặc thành công --%>
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

        <form action="forgotpass" method="post" autocomplete="off">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    placeholder="Enter your registered email" 
                    value="" 
                    required 
                />
                <i class="fas fa-envelope"></i>
            </div>

            <button type="submit" class="btn-submit">Send Reset Link</button>
        </form>

        <p class="back-link">
            Remember your password? <a href="login">Login here</a>
        </p>
    </div>
</body>
</html>
