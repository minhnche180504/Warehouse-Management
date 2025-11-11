<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Edit Supplier - Admin Dashboard</title>
    <meta name="description" content="Edit Supplier">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/icons/icon-48x48.png">
    
    <!-- CSS here -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
       <jsp:include page="/purchase/PurchaseSidebar.jsp"/>
            <div class="main">
            <jsp:include page="/purchase/navbar.jsp"/>

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Edit</strong> Supplier</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<c:url value='/purchase/manage-supplier?action=list'/>" class="btn btn-secondary">Back to List</a>
                        </div>
                    </div>

                    <!-- Edit Supplier Form -->
                    <div class="row">
                        <div class="col-12 col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Edit Supplier Information</h5>
                                    <div class="text-muted">Supplier ID: ${supplier.supplierId}</div>
                                </div>
                                <div class="card-body">
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger" role="alert">
                                            ${errorMessage}
                                        </div>
                                    </c:if>

                                    <form action="<c:url value='/purchase/manage-supplier'/>" method="POST">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="${supplier.supplierId}">
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="name" class="form-label">Supplier Name <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="name" name="name" 
                                                       value="${supplier.name}" required maxlength="100">
                                                <div class="invalid-feedback" id="name-error"></div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="contactPerson" class="form-label">Contact Person <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="contactPerson" name="contactPerson" 
                                                       value="${supplier.contactPerson != null ? supplier.contactPerson : ''}" required maxlength="100">
                                                <div class="invalid-feedback" id="contactPerson-error"></div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="phone" class="form-label">Phone <span class="text-danger">*</span></label>
                                                <input type="tel" class="form-control" id="phone" name="phone" 
                                                       value="${supplier.phone != null ? supplier.phone : ''}" required maxlength="20">
                                                <div class="invalid-feedback" id="phone-error"></div>
                                                <div class="form-text">Format: Must start with 0 and have exactly 10 digits (e.g., 0123456789)</div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                                <input type="email" class="form-control" id="email" name="email" 
                                                       value="${supplier.email != null ? supplier.email : ''}" required maxlength="100">
                                                <div class="invalid-feedback" id="email-error"></div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="address" class="form-label">Address <span class="text-danger">*</span></label>
                                            <textarea class="form-control" id="address" name="address" rows="3" required maxlength="255">${supplier.address != null ? supplier.address : ''}</textarea>
                                            <div class="invalid-feedback" id="address-error"></div>
                                            <div class="form-text"><span id="address-count">0</span>/255 characters</div>
                                        </div>

                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <a href="<c:url value='/purchase/manage-supplier?action=list'/>" class="btn btn-secondary me-md-2">Cancel</a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="align-middle" data-feather="save"></i> Update Supplier
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="col-12 col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Supplier Details</h5>
                                </div>
                                <div class="card-body">
                                    <p><strong>Created:</strong><br>
                                    <c:if test="${supplier.dateCreated != null}">
                                        ${supplier.dateCreated}
                                    </c:if>
                                    <c:if test="${supplier.dateCreated == null}">
                                        Not available
                                    </c:if>
                                    </p>
                                    
                                    <p><strong>Last Updated:</strong><br>
                                    <c:if test="${supplier.lastUpdated != null}">
                                        ${supplier.lastUpdated}
                                    </c:if>
                                    <c:if test="${supplier.lastUpdated == null}">
                                        Never updated
                                    </c:if>
                                    </p>

                                    <hr>
                                    
                                    <p><strong>Required Fields:</strong></p>
                                    <ul>
                                        <li>Supplier Name - Must be unique among active suppliers</li>
                                        <li>Contact Person - Main contact at supplier</li>
                                        <li>Phone - Must start with 0, have exactly 10 digits, and be unique among active suppliers</li>
                                        <li>Email - Valid email address and must be unique among active suppliers</li>
                                        <li>Address - Supplier's address</li>
                                    </ul>

                                    <p><strong>Note:</strong></p>
                                    <ul>
                                        <li>Name, phone, and email must be unique among active suppliers</li>
                                        <li>System will check for duplicates automatically while typing</li>
                                        <li>Current supplier's data is excluded from uniqueness check</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <footer class="footer">
                <div class="container-fluid">
                    <div class="row text-muted">
                        <div class="col-6 text-start">
                            <p class="mb-0">
                                <a href="#" target="_blank" class="text-muted"><strong>AdminKit</strong></a> &copy;
                            </p>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </div>

    <script src="js/app.js"></script>

    <script>
        // Comprehensive form validation
        document.addEventListener('DOMContentLoaded', function() {
            var form = document.querySelector('form');
            var nameInput = document.getElementById('name');
            var emailInput = document.getElementById('email');
            var phoneInput = document.getElementById('phone');
            var addressInput = document.getElementById('address');
            var contactPersonInput = document.getElementById('contactPerson');
            var addressCount = document.getElementById('address-count');
            
            // Update character count for address
            function updateAddressCount() {
                var length = addressInput.value.length;
                addressCount.textContent = length;
                if (length > 255) {
                    addressCount.style.color = 'red';
                } else if (length > 200) {
                    addressCount.style.color = 'orange';
                } else {
                    addressCount.style.color = 'green';
                }
            }
            
            // Initial count update
            updateAddressCount();
            addressInput.addEventListener('input', updateAddressCount);
            
            // Validation functions
            function validateName(value) {
                if (!value || value.trim() === '') {
                    return 'Supplier name is required';
                }
                if (value.trim().length > 100) {
                    return 'Supplier name must not exceed 100 characters';
                }
                if (!/^[a-zA-Z0-9\s\.\-&'(),]+$/.test(value.trim())) {
                    return 'Supplier name contains invalid characters';
                }
                return null;
            }
            
            function validateEmail(value) {
                if (!value || value.trim() === '') {
                    return 'Email is required';
                }
                if (value.trim().length > 100) {
                    return 'Email must not exceed 100 characters';
                }
                var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                if (!emailRegex.test(value.trim())) {
                    return 'Invalid email format';
                }
                return null;
            }
            
            function validatePhone(value) {
                if (!value || value.trim() === '') {
                    return 'Phone number is required';
                }
                // Remove all non-digit characters
                var digitsOnly = value.replace(/[^0-9]/g, '');
                if (!digitsOnly.startsWith('0')) {
                    return 'Phone number must start with 0';
                }
                if (digitsOnly.length !== 10) {
                    return 'Phone number must have exactly 10 digits';
                }
                return null;
            }
            
            function validateContactPerson(value) {
                if (!value || value.trim() === '') {
                    return 'Contact person is required';
                }
                if (value.trim().length > 100) {
                    return 'Contact person name must not exceed 100 characters';
                }
                if (!/^[a-zA-Z\s\.\-']+$/.test(value.trim())) {
                    return 'Contact person name contains invalid characters';
                }
                return null;
            }
            
            function validateAddress(value) {
                if (!value || value.trim() === '') {
                    return 'Address is required';
                }
                if (value.trim().length > 255) {
                    return 'Address must not exceed 255 characters';
                }
                return null;
            }
            
            function showError(inputElement, errorElement, message) {
                inputElement.classList.add('is-invalid');
                inputElement.classList.remove('is-valid');
                errorElement.textContent = message;
                errorElement.style.display = 'block';
            }
            
            function showSuccess(inputElement, errorElement) {
                inputElement.classList.remove('is-invalid');
                inputElement.classList.add('is-valid');
                errorElement.textContent = '';
                errorElement.style.display = 'none';
            }
            
            function validateField(inputElement, errorElement, validationFunction) {
                var error = validationFunction(inputElement.value);
                if (error) {
                    showError(inputElement, errorElement, error);
                    return false;
                } else {
                    showSuccess(inputElement, errorElement);
                    return true;
                }
            }
            
            // Real-time validation
            nameInput.addEventListener('blur', function() {
                validateField(nameInput, document.getElementById('name-error'), validateName);
                if (nameInput.value.trim()) {
                    checkNameExists(nameInput.value.trim());
                }
            });
            
            emailInput.addEventListener('blur', function() {
                validateField(emailInput, document.getElementById('email-error'), validateEmail);
                if (emailInput.value.trim()) {
                    checkEmailExists(emailInput.value.trim());
                }
            });
            
            phoneInput.addEventListener('blur', function() {
                validateField(phoneInput, document.getElementById('phone-error'), validatePhone);
                if (phoneInput.value.trim()) {
                    checkPhoneExists(phoneInput.value.trim());
                }
            });
            
            contactPersonInput.addEventListener('blur', function() {
                validateField(contactPersonInput, document.getElementById('contactPerson-error'), validateContactPerson);
            });
            
            addressInput.addEventListener('blur', function() {
                validateField(addressInput, document.getElementById('address-error'), validateAddress);
            });
            
            // Functions to check for duplicates
            var currentSupplierId = document.querySelector('input[name="id"]').value;

            function checkNameExists(name) {
                fetch('${pageContext.request.contextPath}/purchase/manage-supplier?action=check-duplicate&type=name&value=' + encodeURIComponent(name) + '&id=' + currentSupplierId)
                    .then(function(response) { return response.json(); })
                    .then(function(data) {
                        if (data.exists) {
                            showError(nameInput, document.getElementById('name-error'), 'Supplier name already exists');
                        }
                    })
                    .catch(function(error) {
                        console.error('Error checking name:', error);
                    });
            }

            function checkPhoneExists(phone) {
                var digitsOnly = phone.replace(/[^0-9]/g, '');
                fetch('${pageContext.request.contextPath}/purchase/manage-supplier?action=check-duplicate&type=phone&value=' + encodeURIComponent(digitsOnly) + '&id=' + currentSupplierId)
                    .then(function(response) { return response.json(); })
                    .then(function(data) {
                        if (data.exists) {
                            showError(phoneInput, document.getElementById('phone-error'), 'Phone number already exists');
                        }
                    })
                    .catch(function(error) {
                        console.error('Error checking phone:', error);
                    });
            }

            function checkEmailExists(email) {
                fetch('${pageContext.request.contextPath}/purchase/manage-supplier?action=check-duplicate&type=email&value=' + encodeURIComponent(email) + '&id=' + currentSupplierId)
                    .then(function(response) { return response.json(); })
                    .then(function(data) {
                        if (data.exists) {
                            showError(emailInput, document.getElementById('email-error'), 'Email address already exists');
                        }
                    })
                    .catch(function(error) {
                        console.error('Error checking email:', error);
                    });
            }
            
            // Form submission validation
            form.addEventListener('submit', function(e) {
                var isValid = true;
                
                // Validate all fields
                isValid = validateField(nameInput, document.getElementById('name-error'), validateName) && isValid;
                isValid = validateField(emailInput, document.getElementById('email-error'), validateEmail) && isValid;
                isValid = validateField(phoneInput, document.getElementById('phone-error'), validatePhone) && isValid;
                isValid = validateField(contactPersonInput, document.getElementById('contactPerson-error'), validateContactPerson) && isValid;
                isValid = validateField(addressInput, document.getElementById('address-error'), validateAddress) && isValid;
                
                if (!isValid) {
                    e.preventDefault();
                    // Focus on first invalid field
                    var firstInvalid = form.querySelector('.is-invalid');
                    if (firstInvalid) {
                        firstInvalid.focus();
                    }
                }
            });
        });
    </script>
</body>

</html> 