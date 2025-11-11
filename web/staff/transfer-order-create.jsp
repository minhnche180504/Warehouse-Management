<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,model.Product,model.WarehouseDisplay,model.PurchaseOrder,model.PurchaseOrderItem,model.SalesOrder,model.SalesOrderItem,model.ImportRequest,model.ImportRequestDetail,model.InventoryTransfer,model.InventoryTransferItem,java.text.SimpleDateFormat" %>
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
        <link rel="shortcut icon" href="<c:url value='/staff/img/icons/icon-48x48.png'/>" />
        <link rel="canonical" href="forms-layouts.html" />
        <title>${pageTitle} | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="<c:url value='/staff/css/light.css'/>" rel="stylesheet">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />
        <!-- Custom Select2 Styles -->
        <style>
            .select2-container--bootstrap-5 .select2-selection {
                border: 1px solid #ced4da;
                padding: 0.375rem 0.75rem;
                font-size: 1rem;
                border-radius: 0.25rem;
            }
            .select2-container--bootstrap-5 .select2-search--dropdown .select2-search__field {
                padding: 8px;
                border-radius: 4px;
                border: 1px solid #ced4da;
            }
            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
                padding-left: 0;
            }
            .select2-container--bootstrap-5 .select2-dropdown {
                border-color: #ced4da;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            }
            .select2-container--bootstrap-5 .select2-results__option--highlighted[aria-selected] {
                background-color: #007bff;
            }
        </style>
        <script src="<c:url value='/staff/js/settings.js'/>"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/staff/WsSidebar.jsp" />
            <div class="main">
                <jsp:include page="/staff/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <%
                            // Get any error messages
                            String errorMessage = (String) request.getAttribute("errorMessage");
                            if (errorMessage != null && !errorMessage.isEmpty()) {
                        %>
                        <div class="alert alert-danger alert-dismissible" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-message">
                                <%= errorMessage %>
                            </div>
                        </div>
                        <%
                            }
                            
                            // Get page title and description
                            String pageTitle = (String) request.getAttribute("pageTitle");
                            String pageDescription = (String) request.getAttribute("pageDescription");
                            if (pageTitle == null) pageTitle = "Create Transfer Order";
                            if (pageDescription == null) pageDescription = "Move products between warehouses";
                            
                            // Get selected transfer type
                            String selectedType = (String) request.getAttribute("selectedType");
                            if (selectedType == null) selectedType = "transfer";
                        %>
                        
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary"><%= pageTitle %></h1>
                                <p class="text-muted"><%= pageDescription %></p>
                            </div>
                            <div class="col-6 text-end">
                                <a href="list-transfer-order" class="btn btn-secondary me-2">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Transfer Order Details</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>
                                    <div class="card-body pt-3">
                                        <form action="create-transfer-order" method="post" id="transferOrderForm">                                            <!-- Transfer Type Selection -->
                                            <div class="row mb-4">
                                                <div class="col-12">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <label class="form-label fw-medium mb-0 me-2">Transfer Type:</label>
                                                        <% if ("import".equals(selectedType)) { %>
                                                            <span class="badge bg-success p-2">Import Order</span>
                                                        <% } else if ("export".equals(selectedType)) { %>
                                                            <span class="badge bg-warning p-2">Export Order</span>
                                                        <% } else if ("transfer".equals(selectedType)) { %>
                                                            <span class="badge bg-info p-2">Warehouse Transfer</span>
                                                        <% } %>
                                                        <!-- Hidden input to store the transfer type value -->
                                                        <input type="hidden" name="transferType" value="<%= selectedType %>">
                                                    </div>
                                                    <small class="text-muted">
                                                        Transfer type is set during creation and cannot be changed.
                                                    </small>
                                                </div>
                                            </div>
                                            
                                            <!-- Warehouse Selection -->
                                            <div class="row mb-3">
                                                <% 
                                                    // Get current user's warehouse ID for automatic assignment
                                                    Integer currentUserWarehouseId = (Integer)request.getAttribute("currentUserWarehouseId");
                                                    String currentUserWarehouseName = "Unknown Warehouse";
                                                    String warehouseZeroName = "Kho Trung Chuyển";
                                                    
                                                    // Find warehouse names for display
                                                    List<WarehouseDisplay> warehouses = (List<WarehouseDisplay>)request.getAttribute("warehouses");
                                                    if (warehouses != null && currentUserWarehouseId != null) {
                                                        for (WarehouseDisplay warehouse : warehouses) {
                                                            if (currentUserWarehouseId.equals(warehouse.getWarehouseId())) {
                                                                currentUserWarehouseName = warehouse.getWarehouseName();
                                                                break;
                                                            }
                                                        }
                                                    }
                                                    
                                                    // Debug output (remove this later)
                                                    // System.out.println("Current User Warehouse ID: " + currentUserWarehouseId);
                                                    // System.out.println("Current User Warehouse Name: " + currentUserWarehouseName);
                                                %>
                                                
                                                <div class="col-md-6">
                                                    <label for="sourceWarehouseId" class="form-label fw-medium">
                                                        <% if ("import".equals(selectedType)) { %>
                                                            Source (External) *
                                                        <% } else { %>
                                                            Source Warehouse *
                                                        <% } %>
                                                    </label>
                                                    <% if ("import".equals(selectedType)) { %>
                                                        <!-- For import: source is warehouse 0 (external) -->
                                                        <input type="text" class="form-control form-control-lg" 
                                                               value="<%= warehouseZeroName %>" disabled readonly>
                                                        <input type="hidden" name="sourceWarehouseId" value="0">
                                                    <% } else if ("export".equals(selectedType)) { %>
                                                        <!-- For export: source is current user's warehouse -->
                                                        <input type="text" class="form-control form-control-lg" 
                                                               value="<%= currentUserWarehouseName %>" disabled readonly>
                                                        <input type="hidden" name="sourceWarehouseId" value="<%= currentUserWarehouseId != null ? currentUserWarehouseId : 0 %>">
                                                    <% } else { %>
                                                        <!-- For other types: show dropdown -->
                                                        <select class="form-select form-select-lg" id="sourceWarehouseId" name="sourceWarehouseId" required>
                                                            <option value="">-- Select Source Warehouse --</option>
                                                            <% 
                                                                if (warehouses != null) {
                                                                    for (WarehouseDisplay warehouse : warehouses) {
                                                            %>
                                                            <option value="<%= warehouse.getWarehouseId() %>"><%= warehouse.getWarehouseName() %></option>
                                                            <% 
                                                                    }
                                                                }
                                                            %>
                                                        </select>
                                                    <% } %>
                                                </div>
                                                
                                                <div class="col-md-6" id="destinationWarehouseContainer">
                                                    <label for="destinationWarehouseId" class="form-label fw-medium">
                                                        <% if ("export".equals(selectedType)) { %>
                                                            Destination (External) *
                                                        <% } else { %>
                                                            Destination Warehouse *
                                                        <% } %>
                                                    </label>
                                                    <% if ("import".equals(selectedType)) { %>
                                                        <!-- For import: destination is current user's warehouse -->
                                                        <input type="text" class="form-control form-control-lg" 
                                                               value="<%= currentUserWarehouseName %>" disabled readonly>
                                                        <input type="hidden" name="destinationWarehouseId" value="<%= currentUserWarehouseId != null ? currentUserWarehouseId : 0 %>">
                                                    <% } else if ("export".equals(selectedType)) { %>
                                                        <!-- For export: destination is warehouse 0 (external) -->
                                                        <input type="text" class="form-control form-control-lg" 
                                                               value="<%= warehouseZeroName %>" disabled readonly>
                                                        <input type="hidden" name="destinationWarehouseId" value="0">
                                                    <% } else { %>
                                                        <!-- For other types: show dropdown -->
                                                        <select class="form-select form-select-lg" id="destinationWarehouseId" name="destinationWarehouseId">
                                                            <option value="">-- Select Destination Warehouse --</option>
                                                            <% 
                                                                if (warehouses != null) {
                                                                    for (WarehouseDisplay warehouse : warehouses) {
                                                            %>
                                                            <option value="<%= warehouse.getWarehouseId() %>"><%= warehouse.getWarehouseName() %></option>
                                                            <% 
                                                                    }
                                                                }
                                                            %>
                                                        </select>
                                                    <% } %>
                                                </div>
                                            </div>
                                            
                                            <!-- Document Reference and Description -->
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label for="documentRefId" class="form-label fw-medium">Reference Document ID *</label>
                                                    
                                                    <% String transferType = (String)request.getAttribute("transferType"); %>
                                                    <% if ("import".equals(transferType)) { %>
                                                        <!-- Dropdown for Import type showing Purchase Orders and Inventory Transfers -->
                                                        <select class="form-control form-control-lg" id="documentRefId" name="documentRefId" 
                                                                onchange="loadDocumentItems(this.value)" required>
                                                            <option value="">-- Select Reference Document --</option>
                                                            
                                                            <!-- Purchase Orders Section -->
                                                            <optgroup label="Purchase Orders (Pending)">
                                                            <% 
                                                                List<PurchaseOrder> pendingPOs = (List<PurchaseOrder>)request.getAttribute("pendingPurchaseOrders");
                                                                if (pendingPOs != null) {
                                                                    for (PurchaseOrder po : pendingPOs) {
                                                            %>
                                                                        <option value="PO-<%= po.getPoId() %>" 
                                                                                <%= request.getAttribute("selectedPurchaseOrder") != null && 
                                                                                    ((PurchaseOrder)request.getAttribute("selectedPurchaseOrder")).getPoId().equals(po.getPoId()) ? "selected" : "" %>>
                                                                            PO-<%= po.getPoId() %> - <%= po.getSupplierName() %> - Pending
                                                                            (<%= new SimpleDateFormat("dd/MM/yyyy").format(po.getDate()) %>)
                                                                        </option>
                                                            <%      }
                                                                }
                                                            %>
                                                            </optgroup>
                                                            
                                                            <!-- Inventory Transfers Section -->
                                                            <optgroup label="Inventory Transfers">
                                                            <% 
                                                                List<InventoryTransfer> processingITs = (List<InventoryTransfer>)request.getAttribute("processingInventoryTransfers");
                                                                if (processingITs != null) {
                                                                    for (InventoryTransfer it : processingITs) {
                                                            %>
                                                                        <option value="IT-<%= it.getTransferId() %>" 
                                                                                <%= request.getAttribute("selectedInventoryTransfer") != null && 
                                                                                    ((InventoryTransfer)request.getAttribute("selectedInventoryTransfer")).getTransferId() == it.getTransferId() ? "selected" : "" %>>
                                                                            IT-<%= it.getTransferId() %> - <%= it.getSourceWarehouseName() %> → <%= it.getDestinationWarehouseName() %> 
                                                                            (<%= new SimpleDateFormat("dd/MM/yyyy").format(java.sql.Timestamp.valueOf(it.getDate())) %>)
                                                                        </option>
                                                            <%      }
                                                                }
                                                            %>
                                                            </optgroup>
                                                            
                                                            <!-- Returning Sales Orders Section -->
                                                            <optgroup label="Returning Sales Orders">
                                                            <% 
                                                                List<SalesOrder> returningSOs = (List<SalesOrder>)request.getAttribute("returningSalesOrders");
                                                                if (returningSOs != null) {
                                                                    for (SalesOrder so : returningSOs) {
                                                            %>
                                                                        <option value="RSO-<%= so.getSoId() %>" 
                                                                                <%= request.getAttribute("selectedReturningSalesOrder") != null && 
                                                                                    ((SalesOrder)request.getAttribute("selectedReturningSalesOrder")).getSoId() == so.getSoId() ? "selected" : "" %>>
                                                                            RSO-<%= so.getSoId() %> - <%= so.getCustomerName() %> - Returning
                                                                            (<%= new SimpleDateFormat("dd/MM/yyyy").format(so.getOrderDate()) %>)
                                                                        </option>
                                                            <%      }
                                                                }
                                                            %>
                                                            </optgroup>
                                                        </select>
                                                    <% } else if ("export".equals(transferType)) { %>
                                                        <!-- Dropdown for Export type showing Sales Orders and Inventory Transfers -->
                                                        <select class="form-control form-control-lg" id="documentRefId" name="documentRefId" 
                                                                onchange="loadDocumentItems(this.value)" required>
                                                            <option value="">-- Select Reference Document --</option>
                                                            
                                                            <!-- Sales Orders Section -->
                                                            <optgroup label="Sales Orders (Order)">
                                                            <% 
                                                                List<SalesOrder> orderSOs = (List<SalesOrder>)request.getAttribute("orderSalesOrders");
                                                                if (orderSOs != null) {
                                                                    for (SalesOrder so : orderSOs) {
                                                            %>
                                                                        <option value="SO-<%= so.getSoId() %>" 
                                                                                <%= request.getAttribute("selectedSalesOrder") != null && 
                                                                                    ((SalesOrder)request.getAttribute("selectedSalesOrder")).getSoId() == so.getSoId() ? "selected" : "" %>>
                                                                            SO-<%= so.getSoId() %> - <%= so.getCustomerName() %> - Order
                                                                            (<%= new SimpleDateFormat("dd/MM/yyyy").format(so.getOrderDate()) %>)
                                                                        </option>
                                                            <%      }
                                                                }
                                                            %>
                                                            </optgroup>
                                                            
                                                            <!-- Inventory Transfers Section -->
                                                            <optgroup label="Inventory Transfers">
                                                            <% 
                                                                List<InventoryTransfer> processingITs2 = (List<InventoryTransfer>)request.getAttribute("processingInventoryTransfers");
                                                                if (processingITs2 != null) {
                                                                    for (InventoryTransfer it : processingITs2) {
                                                            %>
                                                                        <option value="IT-<%= it.getTransferId() %>" 
                                                                                <%= request.getAttribute("selectedInventoryTransfer") != null && 
                                                                                    ((InventoryTransfer)request.getAttribute("selectedInventoryTransfer")).getTransferId() == it.getTransferId() ? "selected" : "" %>>
                                                                            IT-<%= it.getTransferId() %> - <%= it.getSourceWarehouseName() %> → <%= it.getDestinationWarehouseName() %> 
                                                                            (<%= new SimpleDateFormat("dd/MM/yyyy").format(java.sql.Timestamp.valueOf(it.getDate())) %>)
                                                                        </option>
                                                            <%      }
                                                                }
                                                            %>
                                                            </optgroup>
                                                        </select>
                                                    <% } else if ("transfer".equals(transferType)) { %>
                                                        <!-- Dropdown for Transfer type showing Import Requests -->
                                                        <select class="form-control form-control-lg" id="documentRefId" name="documentRefId" 
                                                                onchange="loadDocumentItems(this.value)" required>
                                                            <option value="">-- Select Import Request --</option>
                                                            <% 
                                                                List<ImportRequest> processingIRs = (List<ImportRequest>)request.getAttribute("processingImportRequests");
                                                                if (processingIRs != null) {
                                                                    for (ImportRequest ir : processingIRs) {
                                                            %>
                                                                        <option value="IR-<%= ir.getRequestId() %>" 
                                                                                <%= request.getAttribute("selectedImportRequest") != null && 
                                                                                    ((ImportRequest)request.getAttribute("selectedImportRequest")).getRequestId() == ir.getRequestId() ? "selected" : "" %>>
                                                                            IR-<%= ir.getRequestId() %> - <%= ir.getCreatedByName() %> 
                                                                            (<%= new SimpleDateFormat("dd/MM/yyyy").format(ir.getRequestDate()) %>)
                                                                        </option>
                                                            <%      }
                                                                }
                                                            %>
                                                        </select>
                                                    <% } else { %>
                                                        <!-- Text input for other types -->
                                                        <input type="text" class="form-control form-control-lg" id="documentRefId" 
                                                               name="documentRefId" placeholder="Sales Order or Purchase Order ID">
                                                    <% } %>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="description" class="form-label fw-medium">Description</label>
                                                    <textarea class="form-control" id="description" name="description" rows="2" placeholder="Transfer order description"></textarea>
                                                </div>
                                            </div>
                                            
                                            <!-- Product Items Section -->
                                            <div class="card mt-4 mb-3">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <h5 class="mb-0">Items</h5>
                                                    <button type="button" class="btn btn-primary btn-sm" id="addProductBtn">
                                                        <i data-feather="plus"></i> Add Product
                                                    </button>
                                                </div>
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered" id="productItemsTable">
                                                            <thead>                                                                <tr>
                                                                    <th style="width: 40%">Product</th>
                                                                    <th>Quantity</th>
                                                                    <th>Unit Price</th>
                                                                    <th>Total</th>
                                                                    <th style="width: 80px">Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="productItemsBody">
                                                                <% 
                                                                    List<PurchaseOrderItem> selectedPOItems = (List<PurchaseOrderItem>)request.getAttribute("selectedPurchaseOrderItems");
                                                                    List<SalesOrderItem> selectedSOItems = (List<SalesOrderItem>)request.getAttribute("selectedSalesOrderItems");
                                                                    List<ImportRequestDetail> selectedIRDetails = (List<ImportRequestDetail>)request.getAttribute("selectedImportRequestDetails");
                                                                    
                                                                    if (selectedPOItems != null && !selectedPOItems.isEmpty()) {
                                                                        // Pre-populate with selected Purchase Order items (Import case)
                                                                        for (PurchaseOrderItem item : selectedPOItems) {
                                                                %>
                                                                            <tr class="product-row">
                                                                                <td>
                                                                                    <select class="form-select product-select" name="productId" required>
                                                                                        <option value="">-- Select Product --</option>
                                                                                        <% 
                                                                                            List<Product> products = (List<Product>)request.getAttribute("products");
                                                                                            if (products != null) {
                                                                                                for (Product product : products) {
                                                                                                    String priceValue = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                                    boolean isSelected = item.getProductId().equals(product.getProductId());
                                                                                        %>
                                                                                                    <option value="<%= product.getProductId() %>" 
                                                                                                            data-price="<%= priceValue %>" 
                                                                                                            <%= isSelected ? "selected" : "" %>>
                                                                                                        <%= product.getName()%> (<%= product.getCode()%>)
                                                                                                    </option>
                                                                                        <%      }
                                                                                            }
                                                                                        %>
                                                                                    </select>
                                                                                </td>
                                                                                <td>
                                                                                    <input type="number" class="form-control quantity-input" 
                                                                                           name="quantity" min="1" value="<%= item.getQuantity() %>" required>
                                                                                </td>
                                                                                <td>
                                                                                    <input type="text" class="form-control unit-price" readonly 
                                                                                           value="<%= String.format("%,.0f VND", item.getUnitPrice()) %>">
                                                                                    <input type="hidden" name="unitPrice" value="<%= item.getUnitPrice() %>">
                                                                                </td>
                                                                                <td>
                                                                                    <input type="text" class="form-control row-total" readonly>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <button type="button" class="btn btn-sm btn-outline-danger remove-product">
                                                                                        <i data-feather="trash-2"></i>
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                <%      }
                                                                    } else if (selectedSOItems != null && !selectedSOItems.isEmpty()) {
                                                                        // Pre-populate with selected Sales Order items (Export case)
                                                                        for (SalesOrderItem item : selectedSOItems) {
                                                                %>
                                                                            <tr class="product-row">
                                                                                <td>
                                                                                    <select class="form-select product-select" name="productId" required>
                                                                                        <option value="">-- Select Product --</option>
                                                                                        <% 
                                                                                            List<Product> products = (List<Product>)request.getAttribute("products");
                                                                                            if (products != null) {
                                                                                                for (Product product : products) {
                                                                                                    String priceValue = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                                    boolean isSelected = item.getProductId() == product.getProductId();
                                                                                        %>
                                                                                                    <option value="<%= product.getProductId() %>" 
                                                                                                            data-price="<%= priceValue %>" 
                                                                                                            <%= isSelected ? "selected" : "" %>>
                                                                                                        <%= product.getName()%> (<%= product.getCode()%>)
                                                                                                    </option>
                                                                                        <%      }
                                                                                            }
                                                                                        %>
                                                                                    </select>
                                                                                </td>
                                                                                <td>
                                                                                    <input type="number" class="form-control quantity-input" 
                                                                                           name="quantity" min="1" value="<%= item.getQuantity() %>" required>
                                                                                </td>
                                                                                <td>
                                                                                    <input type="text" class="form-control unit-price" readonly 
                                                                                           value="<%= String.format("%,.0f VND", item.getUnitPrice()) %>">
                                                                                    <input type="hidden" name="unitPrice" value="<%= item.getUnitPrice() %>">
                                                                                </td>
                                                                                <td>
                                                                                    <input type="text" class="form-control row-total" readonly>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <button type="button" class="btn btn-sm btn-outline-danger remove-product">
                                                                                        <i data-feather="trash-2"></i>
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                <%      }
                                                                    } else if (request.getAttribute("selectedReturningSalesOrderItems") != null) {
                                                                        // Pre-populate with selected Returning Sales Order items (Import return case)
                                                                        List<SalesOrderItem> selectedReturningSaleOrderItems = (List<SalesOrderItem>)request.getAttribute("selectedReturningSalesOrderItems");
                                                                        for (SalesOrderItem item : selectedReturningSaleOrderItems) {
                                                                %>
                                                                            <tr class="product-row">
                                                                                <td>
                                                                                    <select class="form-select product-select" name="productId" required>
                                                                                        <option value="">-- Select Product --</option>
                                                                                        <% 
                                                                                            List<Product> products = (List<Product>)request.getAttribute("products");
                                                                                            if (products != null) {
                                                                                                for (Product product : products) {
                                                                                                    String priceValue = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                                    boolean isSelected = item.getProductId() == product.getProductId();
                                                                                        %>
                                                                                                    <option value="<%= product.getProductId() %>" 
                                                                                                            data-price="<%= priceValue %>" 
                                                                                                            <%= isSelected ? "selected" : "" %>>
                                                                                                        <%= product.getName()%> (<%= product.getCode()%>)
                                                                                                    </option>
                                                                                        <%      }
                                                                                            }
                                                                                        %>
                                                                                    </select>
                                                                                </td>
                                                                                <td>
                                                                                    <input type="number" class="form-control quantity-input" 
                                                                                           name="quantity" min="1" value="<%= item.getQuantity() %>" required>
                                                                                </td>
                                                                                <td>
                                                                                    <input type="text" class="form-control unit-price" readonly 
                                                                                           value="<%= String.format("%,.0f VND", item.getUnitPrice()) %>">
                                                                                    <input type="hidden" name="unitPrice" value="<%= item.getUnitPrice() %>">
                                                                                </td>
                                                                                <td>
                                                                                    <input type="text" class="form-control row-total" readonly>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <button type="button" class="btn btn-sm btn-outline-danger remove-product">
                                                                                        <i data-feather="trash-2"></i>
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                <%      }
                                                                    } else if (selectedIRDetails != null && !selectedIRDetails.isEmpty()) {
                                                                        // Pre-populate with selected Import Request details (Transfer case)
                                                                        for (ImportRequestDetail detail : selectedIRDetails) {
                                                                %>
                                                                            <tr class="product-row">
                                                                                <td>
                                                                                    <select class="form-select product-select" name="productId" required>
                                                                                        <option value="">-- Select Product --</option>
                                                                                        <% 
                                                                                            List<Product> products = (List<Product>)request.getAttribute("products");
                                                                                            if (products != null) {
                                                                                                for (Product product : products) {
                                                                                                    String priceValue = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                                    boolean isSelected = detail.getProductId() == product.getProductId();
                                                                                        %>
                                                                                                    <option value="<%= product.getProductId() %>" 
                                                                                                            data-price="<%= priceValue %>" 
                                                                                                            <%= isSelected ? "selected" : "" %>>
                                                                                                        <%= product.getName()%> (<%= product.getCode()%>)
                                                                                                    </option>
                                                                                        <%      }
                                                                                            }
                                                                                        %>
                                                                                    </select>
                                                                                </td>
                                                                                <td>
                                                                                    <input type="number" class="form-control quantity-input" 
                                                                                           name="quantity" min="1" value="<%= detail.getQuantity() %>" required>
                                                                                </td>
                                                                                <td>
                                                                                    <%
                                                                                        // Get the selected product price
                                                                                        List<Product> products2 = (List<Product>)request.getAttribute("products");
                                                                                        String selectedProductPrice = "0";
                                                                                        if (products2 != null) {
                                                                                            for (Product product : products2) {
                                                                                                if (product.getProductId() == detail.getProductId()) {
                                                                                                    selectedProductPrice = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                                    break;
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    %>
                                                                                    <input type="text" class="form-control unit-price" readonly 
                                                                                           value="<%= String.format("%,.0f VND", Double.parseDouble(selectedProductPrice)) %>">
                                                                                    <input type="hidden" name="unitPrice" value="<%= selectedProductPrice %>">
                                                                                </td>
                                                                                <td>
                                                                                    <input type="text" class="form-control row-total" readonly>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <button type="button" class="btn btn-sm btn-outline-danger remove-product">
                                                                                        <i data-feather="trash-2"></i>
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                <%      }
                                                                    } else if (request.getAttribute("selectedInventoryTransferItems") != null) {
                                                                        // Pre-populate with selected Inventory Transfer items
                                                                        List<InventoryTransferItem> selectedITItems = (List<InventoryTransferItem>)request.getAttribute("selectedInventoryTransferItems");
                                                                        for (InventoryTransferItem item : selectedITItems) {
                                                                %>
                                                                            <tr class="product-row">
                                                                                <td>
                                                                                    <select class="form-select product-select" name="productId" required>
                                                                                        <option value="">-- Select Product --</option>
                                                                                        <% 
                                                                                            List<Product> products = (List<Product>)request.getAttribute("products");
                                                                                            if (products != null) {
                                                                                                for (Product product : products) {
                                                                                                    String priceValue = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                                    boolean isSelected = item.getProductId() == product.getProductId();
                                                                                        %>
                                                                                                    <option value="<%= product.getProductId() %>" 
                                                                                                            data-price="<%= priceValue %>" 
                                                                                                            <%= isSelected ? "selected" : "" %>>
                                                                                                        <%= product.getName()%> (<%= product.getCode()%>)
                                                                                                    </option>
                                                                                        <%      }
                                                                                            }
                                                                                        %>
                                                                                    </select>
                                                                                </td>
                                                                                <td>
                                                                                    <input type="number" class="form-control quantity-input" 
                                                                                           name="quantity" min="1" value="<%= item.getQuantity() %>" required>
                                                                                </td>
                                                                                <td>
                                                                                    <%
                                                                                        // Get the selected product price
                                                                                        List<Product> products3 = (List<Product>)request.getAttribute("products");
                                                                                        String selectedProductPrice2 = "0";
                                                                                        if (products3 != null) {
                                                                                            for (Product product : products3) {
                                                                                                if (product.getProductId() == item.getProductId()) {
                                                                                                    selectedProductPrice2 = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                                    break;
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    %>
                                                                                    <input type="text" class="form-control unit-price" readonly 
                                                                                           value="<%= String.format("%,.0f VND", Double.parseDouble(selectedProductPrice2)) %>">
                                                                                    <input type="hidden" name="unitPrice" value="<%= selectedProductPrice2 %>">
                                                                                </td>
                                                                                <td>
                                                                                    <input type="text" class="form-control row-total" readonly>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <button type="button" class="btn btn-sm btn-outline-danger remove-product">
                                                                                        <i data-feather="trash-2"></i>
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                <%      }
                                                                    } else {
                                                                        // Default empty row if no items selected
                                                                %>
                                                                        <tr class="product-row">
                                                                            <td>
                                                                                <select class="form-select product-select" name="productId" required>
                                                                                    <option value="">-- Select Product --</option>
                                                                                    <% 
                                                                                        List<Product> products = (List<Product>)request.getAttribute("products");
                                                                                        if (products != null) {
                                                                                            for (Product product : products) {
                                                                                                String priceValue = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                    %>
                                                                                                <option value="<%= product.getProductId() %>" data-price="<%= priceValue %>">
                                                                                                    <%= product.getName()%> (<%= product.getCode()%>)
                                                                                                </option>
                                                                                    <% 
                                                                                            }
                                                                                        }
                                                                                    %>
                                                                                </select>
                                                                            </td>
                                                                            <td>
                                                                                <input type="number" class="form-control quantity-input" name="quantity" min="1" value="1" required>
                                                                            </td>
                                                                            <td>
                                                                                <input type="text" class="form-control unit-price" readonly>
                                                                                <input type="hidden" name="unitPrice" value="0">
                                                                            </td>
                                                                            <td>
                                                                                <input type="text" class="form-control row-total" readonly>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <button type="button" class="btn btn-sm btn-outline-danger remove-product">
                                                                                    <i data-feather="trash-2"></i>
                                                                                </button>
                                                                            </td>
                                                                        </tr>
                                                                <%  } %>                                                            </tbody>
                                                            <tfoot>
                                                                <tr class="table-active">
                                                                    <th colspan="3" class="text-end">Total:</th>
                                                                    <th id="orderTotal" class="text-end">0.00</th>
                                                                    <th></th>
                                                                </tr>
                                                            </tfoot>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Submit Buttons -->
                                            <div class="row mt-4">
                                                <div class="col-12 text-end">
                                                    <button type="button" class="btn btn-secondary btn-lg me-2" onclick="window.location.href='list-transfer-order'">
                                                        Cancel
                                                    </button>
                                                    <button type="reset" class="btn btn-lg btn-secondary me-2">Reset</button>
                                                    <button type="submit" name="action" value="saveDraft" class="btn btn-lg btn-warning me-2">
                                                        <i class="align-middle me-1" data-feather="edit"></i> Save Draft
                                                    </button>
                                                    <button type="submit" name="action" value="create" class="btn btn-lg btn-success">
                                                        <i class="align-middle me-1" data-feather="check-circle"></i> Create & Complete
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="/staff/footer.jsp" />
            </div>
        </div>

        <script src="<c:url value='/staff/js/app.js'/>"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script>
            // Function to load document items (unified for all document types)
            function loadDocumentItems(documentId) {
                console.log('loadDocumentItems called with:', documentId);
                
                if (documentId && documentId !== '') {
                    const currentUrl = new URL(window.location);
                    
                    // Clear all existing parameters
                    currentUrl.searchParams.delete('poId');
                    currentUrl.searchParams.delete('soId');
                    currentUrl.searchParams.delete('irId');
                    currentUrl.searchParams.delete('itId');
                    currentUrl.searchParams.delete('returningSoId');
                    
                    // Set the appropriate parameter based on document type prefix
                    if (documentId.startsWith('PO-')) {
                        const poId = documentId.substring(3); // Remove 'PO-' prefix
                        currentUrl.searchParams.set('poId', poId);
                    } else if (documentId.startsWith('SO-')) {
                        const soId = documentId.substring(3); // Remove 'SO-' prefix
                        currentUrl.searchParams.set('soId', soId);
                    } else if (documentId.startsWith('RSO-')) {
                        const returningSoId = documentId.substring(4); // Remove 'RSO-' prefix
                        currentUrl.searchParams.set('returningSoId', returningSoId);
                    } else if (documentId.startsWith('IR-')) {
                        const irId = documentId.substring(3); // Remove 'IR-' prefix
                        currentUrl.searchParams.set('irId', irId);
                    } else if (documentId.startsWith('IT-')) {
                        const itId = documentId.substring(3); // Remove 'IT-' prefix
                        currentUrl.searchParams.set('itId', itId);
                    } else {
                        // Handle legacy format (just numbers)
                        currentUrl.searchParams.set('poId', documentId);
                    }
                    
                    window.location.href = currentUrl.toString();
                } else {
                    // If no document selected, reload without any document parameters
                    const currentUrl = new URL(window.location);
                    currentUrl.searchParams.delete('poId');
                    currentUrl.searchParams.delete('soId');
                    currentUrl.searchParams.delete('irId');
                    currentUrl.searchParams.delete('itId');
                    currentUrl.searchParams.delete('returningSoId');
                    window.location.href = currentUrl.toString();
                }
            }
            
            // Legacy functions for backwards compatibility
            function loadPurchaseOrderItems(poId) {
                loadDocumentItems('PO-' + poId);
            }
            
            function loadSalesOrderItems(soId) {
                loadDocumentItems('SO-' + soId);
            }
            
            function loadImportRequestItems(irId) {
                loadDocumentItems('IR-' + irId);
            }
            
            function loadInventoryTransferItems(itId) {
                loadDocumentItems('IT-' + itId);
            }
            
            document.addEventListener("DOMContentLoaded", function() {
                // Get form reference at the top for use throughout the script
                const transferOrderForm = document.getElementById('transferOrderForm');
                
                // Initialize feather icons
                feather.replace();
                  // Initialize Select2 for product dropdowns
                $('.product-select').each(function() {
                    initializeSelect2($(this));
                });
                
                // Function to initialize Select2 on an element
                function initializeSelect2(element) {
                    // Destroy existing instance if it exists
                    if (element.data('select2')) {
                        element.select2('destroy');
                    }
                    
                    // Initialize fresh instance
                    element.select2({
                        theme: 'bootstrap-5',
                        width: '100%',
                        placeholder: "Search for a product...",
                        allowClear: true,
                        dropdownParent: element.parent()
                    });
                }
                  
                // Transfer type is fixed at page load based on the parameter
                const destinationWarehouseContainer = document.getElementById('destinationWarehouseContainer');
                
                function handleTransferTypeDisplay() {
                    const transferTypeInput = document.querySelector('input[name="transferType"]');
                    const selectedType = transferTypeInput.value;
                    
                    // Since warehouse fields are now auto-populated and disabled, 
                    // we don't need to manipulate them via JavaScript anymore
                    // The JSP handles the display logic based on transfer type
                    
                    // Keep the container visible for all types since we show the fields
                    if (destinationWarehouseContainer) {
                        destinationWarehouseContainer.style.display = 'block';
                    }
                }
                
                // Initialize based on selected type
                handleTransferTypeDisplay();
                  // Format currency function
                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', { 
                        style: 'currency', 
                        currency: 'VND',
                        minimumFractionDigits: 0,
                        maximumFractionDigits: 0
                    }).format(amount);
                }
                
                // Calculate row total
                function calculateRowTotal(row) {
                    const quantityInput = row.querySelector('.quantity-input');
                    const unitPriceInput = row.querySelector('.unit-price');
                    const rowTotalInput = row.querySelector('.row-total');
                    const hiddenUnitPrice = row.querySelector('input[name="unitPrice"]');
                    
                    const quantity = parseInt(quantityInput.value) || 0;
                    const unitPrice = parseFloat(hiddenUnitPrice.value) || 0;
                    const total = quantity * unitPrice;
                    
                    rowTotalInput.value = formatCurrency(total);
                    
                    return total;
                }
                
                // Calculate order total
                function calculateOrderTotal() {
                    let orderTotal = 0;
                    document.querySelectorAll('.product-row').forEach(row => {
                        orderTotal += calculateRowTotal(row);
                    });
                    
                    document.getElementById('orderTotal').textContent = formatCurrency(orderTotal);
                    return orderTotal;
                }
                  // Initialize product select change handler
                function initProductSelectHandler(select) {
                    // Use jQuery on to handle both native and Select2 change events
                    $(select).on('change', function() {
                        const row = this.closest('.product-row');
                        const selectedOption = this.options[this.selectedIndex];
                        const price = selectedOption ? (selectedOption.dataset.price || 0) : 0;
                        
                        const unitPriceInput = row.querySelector('.unit-price');
                        const hiddenUnitPrice = row.querySelector('input[name="unitPrice"]');
                        
                        hiddenUnitPrice.value = price;
                        unitPriceInput.value = formatCurrency(price);
                        
                        calculateRowTotal(row);
                        calculateOrderTotal();
                    });
                }
                
                // Initialize quantity input change handler
                function initQuantityInputHandler(input) {
                    input.addEventListener('change', function() {
                        const row = this.closest('.product-row');
                        calculateRowTotal(row);
                        calculateOrderTotal();
                    });
                    
                    input.addEventListener('keyup', function() {
                        const row = this.closest('.product-row');
                        calculateRowTotal(row);
                        calculateOrderTotal();
                    });
                }                // Add Product button functionality
                const addProductBtn = document.getElementById('addProductBtn');
                const productItemsBody = document.getElementById('productItemsBody');                
                addProductBtn.addEventListener('click', function() {
                    // Create a fresh row
                    const templateRow = document.createElement('tr');
                    templateRow.className = 'product-row';
                    
                    // Build the product options HTML
                    let optionsHTML = '<option value="">-- Select Product --</option>';
                    const productSelect = document.querySelector('.product-select');
                    
                    if (productSelect) {
                        Array.from(productSelect.options).forEach(function(option) {
                            if (option.value) {
                                optionsHTML += '<option value="' + option.value + '" data-price="' + 
                                    (option.dataset.price || '0') + '">' + 
                                    option.textContent + '</option>';
                            }
                        });
                    }
                    
                    // Create the row HTML
                    const rowHTML = '<td>' +
                        '<select class="form-select product-select" name="productId" required>' +
                        optionsHTML +
                        '</select>' +
                        '</td>' +
                        '<td>' +
                        '<input type="number" class="form-control quantity-input" name="quantity" min="1" value="1" required>' +
                        '</td>' +
                        '<td>' +
                        '<input type="text" class="form-control unit-price" readonly>' +
                        '<input type="hidden" name="unitPrice" value="0">' +
                        '</td>' +
                        '<td>' +
                        '<input type="text" class="form-control row-total" readonly>' +
                        '</td>' +
                        '<td class="text-center">' +
                        '<button type="button" class="btn btn-sm btn-outline-danger remove-product">' +
                        '<i data-feather="trash-2"></i>' +
                        '</button>' +
                        '</td>';
                    
                    templateRow.innerHTML = rowHTML;
                    
                    // Get elements
                    const selectElement = templateRow.querySelector('.product-select');
                    const quantityInput = templateRow.querySelector('.quantity-input');
                    const removeBtn = templateRow.querySelector('.remove-product');
                    
                    // Add event listeners
                    initProductSelectHandler(selectElement);
                    initQuantityInputHandler(quantityInput);
                    
                    // Add remove button functionality
                    removeBtn.addEventListener('click', function() {
                        if (document.querySelectorAll('.product-row').length > 1) {
                            $(templateRow).find('.product-select').select2('destroy');
                            templateRow.remove();
                            calculateOrderTotal();
                        }
                    });
                    
                    // Add the new row to the table
                    productItemsBody.appendChild(templateRow);
                    
                    // Initialize Select2 on the new product select
                    initializeSelect2($(selectElement));
                    
                    // Reinitialize feather icons
                    feather.replace();
                });
                  // Set up initial row functionality
                document.querySelectorAll('.product-row').forEach(row => {
                    const selectElement = row.querySelector('.product-select');
                    const quantityInput = row.querySelector('.quantity-input');
                    const removeBtn = row.querySelector('.remove-product');
                    
                    initProductSelectHandler(selectElement);
                    initQuantityInputHandler(quantityInput);
                    
                    removeBtn.addEventListener('click', function() {
                        if (document.querySelectorAll('.product-row').length > 1) {
                            // Make sure to properly destroy the select2 instance
                            $(row).find('.product-select').select2('destroy');
                            row.remove();
                            calculateOrderTotal();
                        }
                    });
                });
                
                // Initialize calculations
                calculateOrderTotal();
                
                // Handle form reset - reinitialize Select2 after reset
                transferOrderForm.addEventListener('reset', function() {
                    // Give the form time to reset
                    setTimeout(function() {
                        // Destroy all Select2 instances
                        $('.product-select').each(function() {
                            if ($(this).data('select2')) {
                                $(this).select2('destroy');
                            }
                        });
                        
                        // Reinitialize Select2 on all product dropdowns
                        $('.product-select').each(function() {
                            initializeSelect2($(this));
                        });
                        
                        // Reset unit prices and totals
                        document.querySelectorAll('.product-row').forEach(row => {
                            calculateRowTotal(row);
                        });
                        calculateOrderTotal();
                    }, 10);
                });
                
                // Form validation before submit
                
                transferOrderForm.addEventListener('submit', function(event) {
                    const selectedType = document.querySelector('input[name="transferType"]').value;
                    const sourceWarehouse = document.getElementById('sourceWarehouseId').value;
                    const destinationWarehouse = document.getElementById('destinationWarehouseId').value;
                    const documentRefId = document.getElementById('documentRefId').value;
                    
                    // Validate Reference Document ID for import, export, and transfer types
                    if (selectedType === 'import' && (!documentRefId || documentRefId.trim() === '')) {
                        event.preventDefault();
                        alert('Please select a Purchase Order for import type transfer.');
                        return false;
                    }
                    
                    if (selectedType === 'export' && (!documentRefId || documentRefId.trim() === '')) {
                        event.preventDefault();
                        alert('Please select a Sales Order for export type transfer.');
                        return false;
                    }
                    
                    if (selectedType === 'transfer' && (!documentRefId || documentRefId.trim() === '')) {
                        event.preventDefault();
                        alert('Please select an Import Request for transfer type transfer.');
                        return false;
                    }
                    
                    // Check that source and destination warehouses are different for transfers
                    if (selectedType === 'transfer' && sourceWarehouse === destinationWarehouse && sourceWarehouse !== '') {
                        event.preventDefault();
                        alert('Source and destination warehouses must be different for transfers');
                        return false;
                    }
                    
                    // Ensure at least one product is selected
                    const productSelects = document.querySelectorAll('select[name="productId"]');
                    let validProducts = false;
                    
                    productSelects.forEach(select => {
                        if (select.value !== '') {
                            validProducts = true;
                        }
                    });
                    
                    if (!validProducts) {
                        event.preventDefault();
                        alert('Please select at least one product');
                        return false;
                    }
                });
            });
        </script>
    </body>
</html>