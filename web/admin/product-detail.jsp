<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.util.List,java.util.Map,model.Product,model.ProductAttribute,dao.ProductDAO,dao.ProductAttributeDAO,utils.ProductAttributeHelper" %>
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
        <title>Product Details | Warehouse System</title>
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
                            
                            if (product == null) {
                        %>
                        <div class="alert alert-danger">
                            <h2>Product not found</h2>
                            <p>The requested product does not exist or has been removed.</p>
                            <a href="list-product" class="btn btn-primary">Back to Products</a>
                        </div>
                        <%
                            } else {
                        %>
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary">Product Details</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="list-product" class="btn btn-secondary me-2">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>                                <a href="edit-product?id=<%= product.getProductId() %>" class="btn btn-primary">
                                    <i class="align-middle" data-feather="edit"></i> Edit Product
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0 fw-bold text-primary"><%= product.getName() %></h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <div class="mb-4">
                                                    <h5 class="fw-semibold">Basic Information</h5>
                                                    <hr>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3 fw-semibold">Product ID:</div>
                                                        <div class="col-md-9"><%= product.getProductId() %></div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3 fw-semibold">Product Code:</div>
                                                        <div class="col-md-9"><%= product.getCode() %></div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3 fw-semibold">Product Name:</div>
                                                        <div class="col-md-9"><%= product.getName() %></div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3 fw-semibold">Description:</div>
                                                        <div class="col-md-9"><%= product.getDescription() != null ? product.getDescription() : "No description available" %></div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3 fw-semibold">Unit:</div>
                                                        <div class="col-md-9">
                                                            <% if (product.getUnitName() != null) { %>
                                                                <%= product.getUnitName() %> (<%= product.getUnitCode() %>)
                                                            <% } else { %>
                                                                N/A
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3 fw-semibold">Price:</div>
                                                        <%
                                                            String formattedPrice = "Not set";
                                                            if (product.getPrice() != null) {
                                                                java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                                                                nf.setMaximumFractionDigits(0);
                                                                formattedPrice = nf.format(product.getPrice()) + " ₫";
                                                            }
                                                        %>
                                                        <div class="col-md-9"><%= formattedPrice %></div>
                                                    </div>
                                                </div>

                                                <div class="mb-4">
                                                    <h5 class="fw-semibold">Supplier Information</h5>
                                                    <hr>
                                                    <% if (product.getSupplierId() != null && product.getSupplierName() != null) { %>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3 fw-semibold">Supplier:</div>
                                                        <div class="col-md-9"><%= product.getSupplierName() %></div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3 fw-semibold">Supplier ID:</div>
                                                        <div class="col-md-9"><%= product.getSupplierId() %></div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-md-3"></div>
                                                        <div class="col-md-9">
                                                            <a href="supplier.jsp?id=<%= product.getSupplierId() %>" class="btn btn-sm btn-outline-primary">
                                                                <i class="align-middle" data-feather="external-link"></i> View Supplier Details
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <% } else { %>
                                                    <p>No supplier assigned to this product.</p>
                                                    <% } %>                                                </div>
                                                  <!-- Product Attributes Section -->
                                                <div class="mb-4">
                                                    <h5 class="fw-semibold">Product Specifications</h5>
                                                    <hr>
                                                    <% 
                                                    if (product.getAttributes() != null && !product.getAttributes().isEmpty()) {
                                                        // Convert list to a map for easier handling in the view
                                                        Map<String, String> attributesMap = ProductAttributeHelper.attributesToMap(product);
                                                        
                                                        // Check if we have standard laptop attributes first
                                                        List<String> standardAttrs = ProductAttributeHelper.getCommonLaptopAttributeNames();
                                                        boolean hasStandardAttrs = false;
                                                        for (String attr : standardAttrs) {
                                                            if (attributesMap.containsKey(attr)) {
                                                                hasStandardAttrs = true;
                                                                break;
                                                            }
                                                        }
                                                        
                                                        if (hasStandardAttrs) {
                                                    %>
                                                    <div class="card mb-3 bg-light">
                                                        <div class="card-header">
                                                            <h6 class="card-title mb-0">Main Specifications</h6>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <div class="table-responsive">
                                                                <table class="table table-sm mb-0">
                                                                    <tbody>
                                                                        <% 
                                                                        for (String attr : standardAttrs) {
                                                                            if (attributesMap.containsKey(attr)) {
                                                                        %>
                                                                        <tr>
                                                                            <td width="30%" class="fw-medium"><%= attr %></td>
                                                                            <td><%= attributesMap.get(attr) %></td>
                                                                        </tr>
                                                                        <% 
                                                                                attributesMap.remove(attr);
                                                                            }
                                                                        }
                                                                        %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>
                                                    
                                                    <% if (!attributesMap.isEmpty()) { %>
                                                    <div class="card">
                                                        <div class="card-header">
                                                            <h6 class="card-title mb-0">Additional Specifications</h6>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <div class="table-responsive">
                                                                <table class="table table-sm mb-0">
                                                                    <tbody>
                                                                        <% for (Map.Entry<String, String> entry : attributesMap.entrySet()) { %>
                                                                        <tr>
                                                                            <td width="30%" class="fw-medium"><%= entry.getKey() %></td>
                                                                            <td><%= entry.getValue() %></td>
                                                                        </tr>
                                                                        <% } %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>
                                                    <% } else { %>
                                                    <p class="text-muted">No specifications available for this product.</p>
                                                    <% } %>
                                                </div>
                                            </div>

                                        </div>
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
        </div>

        <script src="js/app.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                
                feather.replace();
            });
        </script>
    </body>
</html>
