<%@page import="java.util.HashMap"%>
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
        <title>Product Management | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="view/components/sidebar_loader.jsp" />
            <div class="main">
                <jsp:include page="view/components/navbar.jsp" />               
                <main class="content">                    
                    <div class="container-fluid p-0">
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary">Warehouse Management</h1>
                            </div>

                        </div>
                        <% 
                          // Display success messages
                          String msg = request.getParameter("msg");
                          if ("deleted".equals(msg)) { 
                        %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong> Product was deleted successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } else if ("success".equals(msg)) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong> Product updated successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% }
                            // Display message from session if available (from EditProduct servlet)
                            String successMessage = (String) session.getAttribute("successMessage");
                            if (successMessage != null) {
                                session.removeAttribute("successMessage"); // Clear the message
                        %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong> <%= successMessage %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% }
                            
                            // Display error messages
                            String error = request.getParameter("error");
                            if ("delete_failed".equals(error)) { 
                        %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> Failed to delete the product. It may be used in other records.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } else if ("exception".equals(error)) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> An unexpected error occurred. Please try again.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% }
                            // Display error message from session if available
                            String errorMessage = (String) session.getAttribute("errorMessage");
                            if (errorMessage != null) {
                                session.removeAttribute("errorMessage"); // Clear the message
                        %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> <%= errorMessage %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>


                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0">
                                        <h5 class="card-title mb-0 fw-semibold">Products List</h5>
                                        <div class="row mt-3">                                            <div class="col-md-6">
                                                <form action="stock-level" method="get" class="d-flex">
                                                    <input type="text" name="search" class="form-control me-2" placeholder="Search by name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                                                    <button type="submit" class="btn btn-primary">Search</button>
                                                </form>
                                            </div>
                                            <div class="col-md-6 text-end">
                                                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#attributeFilterModal">
                                                    <i data-feather="filter"></i> Filter by Specifications
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-hover">
                                                <thead>
                                                    <tr>
                                                        <th scope="col">#</th>
                                                        <th scope="col">Code</th>
                                                        <th scope="col">Name</th>
                                                        <th scope="col">Specifications</th>
                                                        <th scope="col">Unit</th>
                                                        <th scope="col">Supplier</th>
                                                        <th scope="col" class="text-end">Stock Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        try {
                                                            String search = request.getParameter("search");
                                                            ProductDAO productDAO = new ProductDAO();
                                                            List<Product> products;

                                                            // Load latest stock quantity map
                                                            Map<Integer, Integer> stockMap = productDAO.getLatestStockQuantities();

                                                            // Apply attribute filters if needed
                                                            Map<String, String> attributeFilters = new HashMap<>();
                                                            for (String attrName : ProductAttributeHelper.getCommonLaptopAttributeNames()) {
                                                                String paramValue = request.getParameter("attr_" + attrName);
                                                                if (paramValue != null && !paramValue.trim().isEmpty()) {
                                                                    attributeFilters.put(attrName, paramValue.trim());
                                                                }
                                                            }

                                                            if (!attributeFilters.isEmpty()) {
                                                                products = productDAO.searchByMultipleAttributes(attributeFilters);
                                                            } else if (search != null && !search.trim().isEmpty()) {
                                                                products = productDAO.searchByName(search);
                                                            } else {
                                                                products = productDAO.getAll();
                                                            }

                                                            if (products.isEmpty()) {
                                                    %>
                                                    <tr>
                                                        <td colspan="7" class="text-center">No products found</td>
                                                    </tr>
                                                    <%
                                                            } else {
                                                                for (Product product : products) {
                                                    %>
                                                    <tr>
                                                        <td><%= product.getProductId() %></td>
                                                        <td><%= product.getCode() %></td>
                                                        <td><%= product.getName() %></td>
                                                        <td>
                                                            <%
                                                                if (product.getAttributes() != null && !product.getAttributes().isEmpty()) {
                                                                    Map<String, String> attributesMap = ProductAttributeHelper.attributesToMap(product);
                                                                    StringBuilder specs = new StringBuilder();
                                                                    String[] keySpecs = {ProductAttributeHelper.ATTR_CPU, ProductAttributeHelper.ATTR_RAM, ProductAttributeHelper.ATTR_STORAGE};
                                                                    for (String spec : keySpecs) {
                                                                        if (attributesMap.containsKey(spec)) {
                                                                            if (specs.length() > 0) specs.append(" | ");
                                                                            specs.append("<span class=\"text-muted\">").append(spec).append(": </span>");
                                                                            specs.append("<span>").append(attributesMap.get(spec)).append("</span>");
                                                                        }
                                                                    }
                                                                    if (specs.length() > 0) {
                                                                        out.println("<small class=\"d-block text-truncate\" style=\"max-width: 250px;\">" + specs.toString() + "</small>");
                                                                    } else {
                                                                        out.println("<small class=\"text-muted\">Specifications available</small>");
                                                                    }
                                                                } else {
                                                                    out.println("<small class=\"text-muted\">No specifications</small>");
                                                                }
                                                            %>
                                                        </td>
                                                        <td>
                                                            <%= product.getUnitName() != null ? product.getUnitName() + " (" + product.getUnitCode() + ")" : "N/A" %>
                                                        </td>
                                                        <td><%= product.getSupplierName() != null ? product.getSupplierName() : "N/A" %></td>
                                                        <td class="text-end">
                                                            <%
                                                                Integer qty = stockMap.get(product.getProductId());
                                                                if (qty == null) {
                                                            %>
                                                            <span class="badge bg-secondary">Chưa kiểm kho</span>
                                                            <%
                                                                } else if (qty == 0) {
                                                            %>
                                                            <span class="badge bg-danger">Hết hàng</span>
                                                            <%
                                                                } else if (qty <= 50) {
                                                            %>
                                                            <span class="badge bg-warning text-dark">Cần nhập hàng</span>
                                                            <%
                                                                } else {
                                                            %>
                                                            <span class="badge bg-success">Còn hàng</span>
                                                            <%
                                                                }
                                                            %>
                                                        </td>
                                                    </tr>
                                                    <%
                                                                }
                                                            }
                                                        } catch (Exception e) {
                                                            e.printStackTrace();
                                                    %>
                                                    <tr>
                                                        <td colspan="7" class="text-center text-danger">An error occurred while loading products. Please try again later.</td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>                <!-- Attribute Filter Modal -->
                <div class="modal fade" id="attributeFilterModal" tabindex="-1" aria-labelledby="attributeFilterModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="attributeFilterModalLabel">Filter Products by Specifications</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form action="product-list.jsp" method="get" id="attributeFilterForm">
                                    <!-- Common laptop attribute filters -->
                                    <div class="row g-3">
                                        <%
                                        for (String attrName : ProductAttributeHelper.getCommonLaptopAttributeNames()) {
                                            String paramValue = request.getParameter("attr_" + attrName);
                                        %>
                                        <div class="col-md-6">
                                            <label for="filter_<%= attrName %>" class="form-label"><%= attrName %></label>
                                            <input type="text" class="form-control" id="filter_<%= attrName %>" 
                                                   name="attr_<%= attrName %>" value="<%= paramValue != null ? paramValue : "" %>"
                                                   placeholder="Filter by <%= attrName %>">
                                        </div>
                                        <% } %>
                                    </div>

                                    <div class="d-grid gap-2 mt-3">
                                        <button type="submit" class="btn btn-primary">Apply Filters</button>
                                        <a href="product-list.jsp" class="btn btn-outline-secondary">Clear Filters</a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

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

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this product? This action cannot be undone.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="js/app.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Initialize feather icons
                feather.replace();
            });

            function confirmDelete(productId) {
                // Set the delete link
                document.getElementById('confirmDeleteBtn').href = 'delete-product?id=' + productId;

                // Show the modal
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                deleteModal.show();

                return false;
            }
        </script>
    </body>
</html>