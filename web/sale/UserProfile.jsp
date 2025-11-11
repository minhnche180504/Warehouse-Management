<%-- 
    Document   : UserProfile
    Created on : May 22, 2025, 2:15:10 PM
    Author     : nguyen
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
        <meta name="author" content="AdminKit">
        <meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">

        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="img/icons/icon-48x48.png" />

        <link rel="canonical" href="pages-settings.html" />

        <title>User Profile</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">

        <link class="js-stylesheet" href="${pageContext.request.contextPath}/sale/css/light.css" rel="stylesheet">
        <!-- <script src="js/settings.js"></script> -->
        <style>
            body {
                opacity: 0;
            }
            .h3.mb-3 {
                margin-left: 30px;
            }
            .error-message {
                color: red;
                margin-bottom: 10px;
            }
            .success-message {
                color: green;
                margin-bottom: 10px;
            }
        </style>
        <script async src="https://www.googletagmanager.com/gtag/js?id=UA-120946860-10"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());

            gtag('config', 'UA-120946860-10', {'anonymize_ip': true});
        </script></head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/sale/SalesSidebar.jsp" />
        <div class="main">
        <jsp:include page="/sale/navbar.jsp" />
                    <div class="col-md-9 col-xl-10">
                        <div class="tab-content">
                            <div class="tab-pane fade show active" id="account" role="tabpanel">

                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Private info</h5>
                                    </div>
                                    <div class="card-body">
                                        <% if (request.getAttribute("errorMessage") != null) { %>
                                            <div class="error-message">${errorMessage}</div>
                                        <% } %>
                                        <% if (request.getAttribute("successMessage") != null) { %>
                                            <div class="success-message">${successMessage}</div>
                                        <% } %>
                                        
                                        <form id="profileForm" method="post" action="${pageContext.request.contextPath}/sale/UserProfile">
                                            <div class="row">
                                                <div class="mb-3 col-md-6">
                                                    <label for="inputUserId" class="form-label">User ID</label>
                                                    <input type="text" class="form-control" id="inputUserId" name="user_id" value="${user.userId}" readonly>
                                                </div>
                                                <div class="mb-3 col-md-6">
                                                    <label for="inputRoleName" class="form-label">Role</label>
                                                    <input type="text" class="form-control" id="inputRoleName" name="role_name" value="${user.role.roleName}" readonly>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="mb-3 col-md-6">
                                                    <label for="inputFirstName" class="form-label">First name</label>
                                                    <input type="text" class="form-control editable" id="inputFirstName" name="first_name" value="${user.firstName}" placeholder="First name" disabled>
                                                </div>
                                                <div class="mb-3 col-md-6">
                                                    <label for="inputLastName" class="form-label">Last name</label>
                                                    <input type="text" class="form-control editable" id="inputLastName" name="last_name" value="${user.lastName}" placeholder="Last name" disabled>
                                                </div>
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputEmail" class="form-label">Email</label>
                                                <input type="email" class="form-control editable" id="inputEmail" name="email" value="${user.email}" placeholder="Email" disabled>
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputAddress" class="form-label">Address</label>
                                                <input type="text" class="form-control editable" id="inputAddress" name="address" value="${user.address}" placeholder="Address" disabled>
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputWarehouse" class="form-label">Warehouse</label>
                                                <input type="text" class="form-control" id="inputWarehouse" name="warehouse" value="${not empty user.warehouseName ? user.warehouseName : 'Không thuộc kho nào'}" readonly>
                                            </div>
                                            <div class="mb-3">
                                                <label for="inputDob" class="form-label">Date of birth</label>
                                                <input type="date" class="form-control editable" id="inputDob" name="date_of_birth" value="${user.dateOfBirth}" disabled>
                                            </div>
                                            <div class="row">
                                                <div class="mb-3 col-md-4">
                                                    <label for="inputGender" class="form-label">Gender</label>
                                                    <select id="inputGender" name="gender" class="form-control editable" disabled>
                                                        <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                                        <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="mt-3 d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/sale/sales-dashboard" class="btn btn-secondary">Back</a>
                                                <button type="submit" id="saveBtn" class="btn btn-primary" style="display:none;">Save</button>
                                                <button type="button" id="cancelBtn" class="btn btn-danger" style="display:none;">Cancel</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script src="${pageContext.request.contextPath}/sale/js/app.js"></script>
        <script>
                   const editBtn = document.getElementById('editBtn');
                   const saveBtn = document.getElementById('saveBtn');
                   const cancelBtn = document.getElementById('cancelBtn');
                   const editableFields = document.querySelectorAll('.editable');
                   const profileForm = document.getElementById('profileForm');

                   editBtn.addEventListener('click', () => {
                       editableFields.forEach(field => field.disabled = false);
                       editBtn.style.display = 'none';
                       saveBtn.style.display = 'inline-block';
                       cancelBtn.style.display = 'inline-block';
                   });

                   cancelBtn.addEventListener('click', () => {
                       editableFields.forEach(field => field.disabled = true);
                       editBtn.style.display = 'inline-block';
                       saveBtn.style.display = 'none';
                       cancelBtn.style.display = 'none';
                       location.reload();
                   });

                   profileForm.addEventListener('submit', function(e) {
                       e.preventDefault();
                       
                       // Get all editable fields
                       const firstName = document.getElementById('inputFirstName').value.trim();
                       const lastName = document.getElementById('inputLastName').value.trim();
                       const email = document.getElementById('inputEmail').value.trim();
                       const address = document.getElementById('inputAddress').value.trim();
                       const dob = document.getElementById('inputDob').value.trim();
                       const gender = document.getElementById('inputGender').value.trim();
                       
                       // Check if any field is empty
                       if (!firstName || !lastName || !email || !address || !dob || !gender) {
                           alert('Please fill in all required information!');
                           return;
                       }
                       
                       // Validate email format
                       const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                       if (!emailRegex.test(email)) {
                           alert('Invalid email format!');
                           return;
                       }
                       
                       // If all validations pass, submit the form
                       this.submit();
                   });
        </script>
    </body>

</html>