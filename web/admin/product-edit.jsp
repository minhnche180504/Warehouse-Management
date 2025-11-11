<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.util.List,java.util.Map,model.Product,dao.ProductDAO,model.Unit,dao.UnitDAO,model.ProductAttribute,utils.ProductAttributeHelper" %>
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
        <link rel="canonical" href="forms-layouts.html" />
        <title>Edit Product | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/admin/AdminSidebar.jsp" />
            <div class="main">
            <jsp:include page="/admin/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <%
                            // Get product ID from request parameter
                            String productIdParam = request.getParameter("id");
                            int productId = 0;
                            Product product = null;
                            
                            if (productIdParam != null && !productIdParam.isEmpty()) {
                                try {
                                    productId = Integer.parseInt(productIdParam);
                                    ProductDAO productDAO = new ProductDAO();
                                    product = productDAO.getById(productId);
                                } catch (NumberFormatException e) {
                                    // Handle invalid ID format
                                }
                            }
                            
                            // Get all active units for dropdown
                            UnitDAO unitDAO = new UnitDAO();
                            List<Unit> units = unitDAO.getAllActive();
                            
                            if (product == null) {
                        %>
                        <div class="alert alert-danger">
                            <h2>Product not found</h2>
                            <p>The requested product does not exist or has been removed.</p>
                            <a href="list-product" class="btn btn-primary">Back to Products</a>
                        </div>
                        <%
                            } else {
                                // Get success or error messages
                                String msg = request.getParameter("msg");
                                String error = request.getParameter("error");
                                if ("success".equals(msg)) {
                        %>
                        <div class="alert alert-success alert-dismissible" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-message">
                                Product updated successfully!
                            </div>
                        </div>
                        <%
                                } else if (error != null && !error.isEmpty()) {
                        %>
                        <div class="alert alert-danger alert-dismissible" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-message">
                                <%= error %>
                            </div>
                        </div>
                        <%
                                }
                        %>
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary">Edit Product</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="list-product" class="btn btn-secondary me-2">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>                                <a href="product-detail.jsp?id=<%= product.getProductId() %>" class="btn btn-info">
                                    <i class="align-middle" data-feather="eye"></i> View Details
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Product Information</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>                                    <div class="card-body pt-3">                                        <form action="${pageContext.request.contextPath}/admin/edit-product" method="post">
                                            <input type="hidden" name="product_id" value="<%= product.getProductId() %>">
                                            <input type="hidden" id="code" name="code" value="<%= product.getCode() %>">
                                            
                                            <!-- First Row of Inputs -->
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="code" class="form-label fw-medium">Product Code</label>
                                                    <input disabled type="text" class="form-control form-control-lg" value="<%= product.getCode() %>" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="name" class="form-label fw-medium">Product Name</label>
                                                    <input type="text" class="form-control form-control-lg" id="name" name="name" value="<%= product.getName() %>">
                                                </div>
                                            </div>

                                            <!-- Second Row of Inputs -->
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="unit_id" class="form-label fw-medium">Unit</label>
                                                    <select class="form-select form-select-lg" id="unit_id" name="unit_id">
                                                        <option value="">-- Select Unit --</option>
                                                        <% for (Unit unit : units) { %>
                                                            <option value="<%= unit.getUnitId() %>" <%= (product.getUnitId() == unit.getUnitId() ? "selected" : "") %>>
                                                                <%= unit.getUnitName() %> (<%= unit.getUnitCode() %>)
                                                            </option>
                                                        <% } %>
                                                    </select>
                                                </div>
                                            </div>

                                            <!-- Third Row of Inputs -->
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-12">
                                                    <label for="supplier_id" class="form-label fw-medium">Supplier</label>
                                                    <select class="form-select form-select-lg" id="supplier_id" name="supplier_id">
                                                        <option value="">-- Select Supplier --</option>
                                                        
                                                        
                                                    </select>
                                                </div>
                                            </div>                                            <!-- Fourth Row of Inputs -->
                                            <div class="row mb-4">
                                                <div class="col-md-12">
                                                    <label for="description" class="form-label fw-medium">Description</label>
                                                    <textarea class="form-control" id="description" name="description" rows="4"><%= product.getDescription() != null ? product.getDescription() : "" %></textarea>
                                                </div>
                                            </div>
                                            
                                            <!-- Product Attributes Section -->
                                            <div class="row mb-3">
                                                <div class="col-12">
                                                    <div class="card">
                                                        <div class="card-header pb-0">
                                                            <h5 class="card-title mb-0 fw-semibold">Product Specifications</h5>
                                                            <p class="text-muted small">Fill in details for laptop specifications (leave blank for non-laptop items)</p>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="row g-3">
                                                                <% 
                                                                // Get existing attributes as a map for easier access
                                                                Map<String, String> attributesMap = ProductAttributeHelper.attributesToMap(product);
                                                                
                                                                // Display fields for common laptop attributes
                                                                List<String> attributeNames = ProductAttributeHelper.getCommonLaptopAttributeNames();
                                                                for (String attrName : attributeNames) {
                                                                    String value = attributesMap.containsKey(attrName) ? attributesMap.get(attrName) : "";
                                                                %>
                                                                <div class="col-md-3">
                                                                    <label for="attr_<%= attrName %>" class="form-label fw-medium"><%= attrName %></label>
                                                                    <input type="text" class="form-control" 
                                                                           id="attr_<%= attrName %>" 
                                                                           name="attr_<%= attrName %>" 
                                                                           value="<%= value %>"
                                                                           placeholder="Enter <%= attrName %>">
                                                                </div>
                                                                <% } %>
                                                                
                                                                <!-- Custom attribute fields -->
                                                                <div class="col-md-12 mt-3">
                                                                    <div class="d-flex align-items-center mb-2">
                                                                        <h6 class="mb-0 me-2">Additional Attributes</h6>
                                                                        <button type="button" class="btn btn-sm btn-outline-primary" id="addAttributeBtn">
                                                                            <i data-feather="plus"></i> Add
                                                                        </button>
                                                                    </div>
                                                                    <div id="customAttributesContainer">
                                                                        <!-- Display existing custom attributes (those not in the common list) -->
                                                                        <% 
                                                                        int customAttrCount = 0;
                                                                        for (Map.Entry<String, String> entry : attributesMap.entrySet()) {
                                                                            if (!attributeNames.contains(entry.getKey())) {
                                                                                customAttrCount++;
                                                                        %>
                                                                        <div class="row g-2 mb-2 align-items-end custom-attribute-row">
                                                                            <div class="col-5">
                                                                                <label class="form-label">Name</label>
                                                                                <input type="text" class="form-control" name="custom_attr_name_<%= customAttrCount %>" value="<%= entry.getKey() %>" placeholder="Attribute name">
                                                                            </div>
                                                                            <div class="col-5">
                                                                                <label class="form-label">Value</label>
                                                                                <input type="text" class="form-control" name="custom_attr_value_<%= customAttrCount %>" value="<%= entry.getValue() %>" placeholder="Attribute value">
                                                                            </div>
                                                                            <div class="col-2">
                                                                                <button type="button" class="btn btn-outline-danger remove-attribute">
                                                                                    <i data-feather="trash-2"></i>
                                                                                </button>
                                                                            </div>
                                                                        </div>
                                                                        <% 
                                                                            }
                                                                        }
                                                                        %>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Submit Buttons -->
                                            <div class="row mt-4">
                                                <div class="col-12 text-end">
                                                    <button type="button" class="btn btn-secondary btn-lg me-2" onclick="window.location.href='list-product'">
                                                        Cancel
                                                    </button>
                                                    <button type="submit" class="btn btn-primary btn-lg px-4">
                                                        <i class="align-middle me-1" data-feather="save"></i> Save Changes
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </main>
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="row text-muted">
                            <div class="col-6 text-start">
                                <p class="mb-0">
                                    <a class="text-muted" href="#" target="_blank"><strong>Warehouse Management System</strong></a> &copy;
                                </p>
                            </div>
                            <div class="col-6 text-end">
                                <ul class="list-inline">
                                    <li class="list-inline-item">
                                        <a class="text-muted" href="#">Support</a>
                                    </li>
                                    <li class="list-inline-item">
                                        <a class="text-muted" href="#">Help Center</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>        <script src="js/app.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                // Initialize feather icons
                feather.replace();
                
                // Initialize dynamic attributes functionality
                initAttributeHandlers();
            });
            
            // Handle custom attribute functionality
            function initAttributeHandlers() {
                // Get references to elements
                const addAttributeBtn = document.getElementById('addAttributeBtn');
                const customAttributesContainer = document.getElementById('customAttributesContainer');
                
                // Set initial attribute counter based on existing custom attributes
                let attributeCounter = document.querySelectorAll('.custom-attribute-row').length + 1;
                
                // Add event listener to the add button
                if (addAttributeBtn) {
                    addAttributeBtn.addEventListener('click', function() {
                        addAttributeRow();
                    });
                }
                
                // Add attribute row
                function addAttributeRow() {
                    const newRow = document.createElement('div');
                    newRow.className = 'row g-2 mb-2 align-items-end custom-attribute-row';
                    
                    newRow.innerHTML = `
                        <div class="col-5">
                            <label class="form-label">Name</label>
                            <input type="text" class="form-control" name="custom_attr_name_${attributeCounter}" placeholder="Attribute name">
                        </div>
                        <div class="col-5">
                            <label class="form-label">Value</label>
                            <input type="text" class="form-control" name="custom_attr_value_${attributeCounter}" placeholder="Attribute value">
                        </div>
                        <div class="col-2">
                            <button type="button" class="btn btn-outline-danger remove-attribute">
                                <i data-feather="trash-2"></i>
                            </button>
                        </div>
                    `;
                    
                    // Append the new row to the container
                    customAttributesContainer.appendChild(newRow);
                    
                    // Initialize feather icons for the new button
                    feather.replace();
                    
                    // Add event listener to the remove button
                    newRow.querySelector('.remove-attribute').addEventListener('click', function() {
                        newRow.remove();
                    });
                    
                    // Increment counter for next attribute
                    attributeCounter++;
                }
                
                // Add event listeners to existing remove buttons
                document.querySelectorAll('.remove-attribute').forEach(button => {
                    button.addEventListener('click', function() {
                        this.closest('.custom-attribute-row').remove();
                    });
                });
            }
        </script>
    </body>
</html>
