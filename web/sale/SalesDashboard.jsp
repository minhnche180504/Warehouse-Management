<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Sales Staff Dashboard">
    <title>Sales Dashboard | Warehouse Management System</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    
    <style>
        /* Scoped Dashboard Styling - không ảnh hưởng navbar */
        .dashboard-container {
            --primary-color: #2563eb;
            --secondary-color: #64748b;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --light-gray: #f8fafc;
            --medium-gray: #e2e8f0;
            --dark-gray: #334155;
            --white: #ffffff;
            --border-radius: 8px;
            --box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --box-shadow-lg: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        
        .dashboard-container {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--light-gray);
            color: var(--dark-gray);
        }

        /* ENHANCED ANIMATIONS AND TRANSITIONS */
        
        /* Fade in animation for main container */
        .dashboard-container {
            opacity: 0;
            animation: fadeInUp 0.8s ease-out forwards;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Staggered card animations */
        .stats-card {
            opacity: 0;
            transform: translateY(20px) scale(0.95);
            animation: cardAppear 0.6s ease-out forwards;
        }

        .stats-card:nth-child(1) { animation-delay: 0.1s; }
        .stats-card:nth-child(2) { animation-delay: 0.2s; }
        .stats-card:nth-child(3) { animation-delay: 0.3s; }
        .stats-card:nth-child(4) { animation-delay: 0.4s; }

        @keyframes cardAppear {
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Enhanced loading shimmer effect */
        .loading-row {
            background: linear-gradient(90deg, #f1f5f9 25%, #e2e8f0 50%, #f1f5f9 75%);
            background-size: 200% 100%;
            height: 20px;
            border-radius: 4px;
            animation: shimmer 1.5s infinite;
        }
        
        @keyframes shimmer {
            0% {
                background-position: -200% 0;
            }
            100% {
                background-position: 200% 0;
            }
        }

        /* Number counter animation styling */
        .stats-number {
            position: relative;
            overflow: hidden;
        }

        .stats-number.counting {
            color: var(--primary-color);
            font-weight: 800;
            text-shadow: 0 0 10px rgba(37, 99, 235, 0.3);
        }

        /* Pulse effect for updating numbers */
        .stats-number.updating {
            animation: numberPulse 0.6s ease-in-out;
        }

        @keyframes numberPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); color: var(--primary-color); }
            100% { transform: scale(1); }
        }

        /* Revenue number special styling */
        .revenue-number {
            background: linear-gradient(45deg, #059669, #10b981);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: revenueGlow 2s ease-in-out infinite alternate;
        }

        @keyframes revenueGlow {
            from { filter: brightness(1); }
            to { filter: brightness(1.2); }
        }

        /* Enhanced table row animations */
        .table-clean tbody tr {
            opacity: 0;
            transform: translateX(-20px);
            animation: rowSlideIn 0.5s ease-out forwards;
        }

        .table-clean tbody tr:nth-child(1) { animation-delay: 0.1s; }
        .table-clean tbody tr:nth-child(2) { animation-delay: 0.2s; }
        .table-clean tbody tr:nth-child(3) { animation-delay: 0.3s; }
        .table-clean tbody tr:nth-child(4) { animation-delay: 0.4s; }
        .table-clean tbody tr:nth-child(5) { animation-delay: 0.5s; }

        @keyframes rowSlideIn {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Status badge animation */
        .status-badge {
            animation: badgePop 0.4s ease-out 0.6s both;
            transform: scale(0);
        }

        @keyframes badgePop {
            0% { transform: scale(0); }
            80% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        /* Progress bar for loading states */
        .loading-progress {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: var(--light-gray);
            z-index: 9999;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .loading-progress.show {
            opacity: 1;
        }

        .loading-progress::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            background: linear-gradient(90deg, var(--primary-color), var(--success-color));
            animation: progressMove 2s ease-in-out infinite;
            width: 30%;
        }

        @keyframes progressMove {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(333%); }
        }

        /* Success checkmark animation */
        .success-checkmark {
            display: inline-block;
            animation: checkmarkBounce 0.6s ease-in-out;
        }

        @keyframes checkmarkBounce {
            0%, 20%, 53%, 80%, 100% { transform: translate3d(0,0,0); }
            40%, 43% { transform: translate3d(0, -8px, 0); }
            70% { transform: translate3d(0, -4px, 0); }
            90% { transform: translate3d(0, -2px, 0); }
        }

        /* Enhanced hover effects */
        .stats-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .stats-card:hover .stats-number {
            transform: scale(1.05);
            transition: transform 0.3s ease;
        }

        /* Icon rotation on hover */
        .stats-icon i {
            transition: transform 0.3s ease;
        }

        .stats-card:hover .stats-icon i {
            transform: rotate(10deg) scale(1.1);
        }

        /* Dashboard Header */
        .dashboard-header {
            background: var(--white);
            border: 1px solid var(--medium-gray);
            border-radius: var(--border-radius);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
            animation: headerSlideDown 0.8s ease-out;
        }

        @keyframes headerSlideDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .dashboard-header h1 {
            font-size: 1.875rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin: 0 0 0.5rem 0;
        }
        
        /* LUXURY GRADIENT TITLE - BLUE TO GOLD EDITION với cỡ chữ gốc */
        .luxury-title {
            font-size: 1.875rem !important;
            font-weight: 700 !important;
            background: linear-gradient(
                135deg,
                #1e40af 0%,
                #2563eb 20%,
                #0ea5e9 40%,
                #f59e0b 60%,
                #d97706 80%,
                #92400e 100%
            );
            background-size: 300% 300%;
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: gradientShift 4s ease-in-out infinite;
            text-shadow: 0 0 30px rgba(37, 99, 235, 0.4);
            letter-spacing: -0.025em;
            line-height: 1.2;
            position: relative;
            display: inline-block;
        }
        
        .luxury-title::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(
                135deg,
                rgba(30, 64, 175, 0.15) 0%,
                rgba(37, 99, 235, 0.15) 20%,
                rgba(14, 165, 233, 0.15) 40%,
                rgba(245, 158, 11, 0.15) 60%,
                rgba(217, 119, 6, 0.15) 80%,
                rgba(146, 64, 14, 0.15) 100%
            );
            background-size: 300% 300%;
            animation: gradientShift 4s ease-in-out infinite;
            filter: blur(8px);
            z-index: -1;
            border-radius: 8px;
        }
        
        @keyframes gradientShift {
            0% {
                background-position: 0% 50%;
            }
            25% {
                background-position: 100% 50%;
            }
            50% {
                background-position: 100% 100%;
            }
            75% {
                background-position: 0% 100%;
            }
            100% {
                background-position: 0% 50%;
            }
        }
        
        /* Hover effect for luxury title */
        .luxury-title:hover {
            transform: translateY(-2px);
            transition: transform 0.3s ease;
        }
        
        .dashboard-header p {
            color: var(--secondary-color);
            margin: 0;
            font-size: 1rem;
        }
        
        /* Warehouse Info Badge - IMPROVED VERSION */
        .warehouse-info {
            background: var(--light-gray);
            border: 1px solid var(--medium-gray);
            border-left: 4px solid var(--primary-color);
            color: var(--dark-gray);
            padding: 1rem 1.25rem;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            margin-top: 0.75rem;
            transition: all 0.2s ease;
        }
        
        .warehouse-info:hover {
            background: var(--white);
            border-color: var(--primary-color);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.1);
        }
        
        .warehouse-info i {
            color: var(--primary-color);
            font-size: 1.1rem;
        }
        
        .warehouse-info .warehouse-name {
            color: var(--dark-gray);
            font-weight: 600;
        }
        
        .warehouse-info .warehouse-region {
            color: var(--secondary-color);
            font-weight: 400;
        }
        
        .warehouse-info .warehouse-separator {
            color: #10b981;
            margin: 0 0.25rem;
            animation: blink-dot 2s infinite;
            font-weight: 600;
            font-size: 1.1em;
        }
        
        @keyframes blink-dot {
            0%, 50% { 
                opacity: 1; 
                transform: scale(1);
            }
            25% { 
                opacity: 0.4; 
                transform: scale(0.85);
            }
            75% { 
                opacity: 1; 
                transform: scale(1.15);
            }
        }
        
        /* Statistics Cards */
        .stats-card {
            background: var(--white);
            border: 1px solid var(--medium-gray);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            box-shadow: var(--box-shadow);
            height: 100%;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        /* Subtle background pattern for cards */
        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100px;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.05) 0%, transparent 70%);
            border-radius: 50%;
            transform: translate(30px, -30px);
            transition: transform 0.3s ease;
        }

        .stats-card:hover::before {
            transform: translate(20px, -20px) scale(1.2);
        }
        
        .stats-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        
        .stats-title {
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--secondary-color);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin: 0;
        }
        
        .stats-icon {
            width: 40px;
            height: 40px;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.125rem;
            position: relative;
            z-index: 2;
        }
        
        .stats-icon.primary { background-color: #eff6ff; color: var(--primary-color); }
        .stats-icon.success { background-color: #f0fdf4; color: var(--success-color); }
        .stats-icon.warning { background-color: #fffbeb; color: var(--warning-color); }
        .stats-icon.secondary { background-color: #f1f5f9; color: var(--secondary-color); }
        
        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-gray);
            margin: 0 0 0.25rem 0;
            line-height: 1;
            position: relative;
            z-index: 2;
        }
        
        .stats-change {
            font-size: 0.875rem;
            color: var(--secondary-color);
            margin: 0;
            position: relative;
            z-index: 2;
        }
        
        /* Main Content Cards */
        .content-card {
            background: var(--white);
            border: 1px solid var(--medium-gray);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 2rem;
            animation: slideInLeft 0.8s ease-out 0.3s both;
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        .card-header-clean {
            padding: 1.5rem 1.5rem 0 1.5rem;
            border-bottom: none;
            background: transparent;
        }
        
        .card-title-clean {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin: 0 0 1.5rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .card-title-clean i {
            color: var(--primary-color);
        }
        
        /* Tables */
        .table-clean {
            margin: 0;
            font-size: 0.875rem;
        }
        
        .table-clean thead th {
            background-color: var(--light-gray);
            border-bottom: 1px solid var(--medium-gray);
            border-top: none;
            color: var(--secondary-color);
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1rem;
        }
        
        .table-clean tbody td {
            padding: 1rem;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }
        
        .table-clean tbody tr:hover {
            background-color: #f8fafc;
            transform: scale(1.005);
            transition: all 0.2s ease;
        }
        
        .table-clean tbody tr:last-child td {
            border-bottom: none;
        }
        
        /* Order ID Styling */
        .order-id {
            font-family: 'Monaco', 'Menlo', monospace;
            font-weight: 600;
            color: var(--primary-color);
            font-size: 0.875rem;
        }
        
        /* Status Badges */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }
        
        .status-order { background-color: #fef3c7; color: #92400e; }
        .status-delivery { background-color: #dbeafe; color: #1e40af; }
        .status-completed { background-color: #d1fae5; color: #065f46; }
        .status-cancelled { background-color: #fee2e2; color: #991b1b; }
        
        /* Amount Display */
        .amount-display {
            font-weight: 600;
            color: var(--success-color);
            font-size: 0.875rem;
        }
        
        /* Action Buttons */
        .action-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 6px;
            border: 1px solid var(--medium-gray);
            background: var(--white);
            color: var(--secondary-color);
            text-decoration: none;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            margin: 0 2px;
        }
        
        .action-btn:hover {
            color: var(--primary-color);
            border-color: var(--primary-color);
            background: #eff6ff;
            text-decoration: none;
            transform: translateY(-1px);
        }
        
        .action-btn.view-btn:hover {
            color: var(--primary-color);
            border-color: var(--primary-color);
            background: #eff6ff;
        }
        
        .action-btn.edit-btn:hover {
            color: #059669;
            border-color: #059669;
            background: #f0fdf4;
        }
        
        .action-btn:focus {
            outline: none;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
        }
        
        /* Clean Quick Actions */
        .quick-actions {
            background: var(--white);
            border: 1px solid var(--medium-gray);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
            animation: slideInRight 0.8s ease-out 0.4s both;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        .action-item {
            display: flex;
            align-items: center;
            background: var(--light-gray);
            border: 1px solid var(--medium-gray);
            border-radius: var(--border-radius);
            padding: 1rem 1.25rem;
            text-decoration: none;
            color: var(--dark-gray);
            margin-bottom: 0.75rem;
            transition: all 0.2s ease;
            transform: translateX(-10px);
            opacity: 0;
            animation: actionItemSlide 0.5s ease-out forwards;
        }

        .action-item:nth-child(2) { animation-delay: 0.6s; }
        .action-item:nth-child(3) { animation-delay: 0.7s; }
        .action-item:nth-child(4) { animation-delay: 0.8s; }
        .action-item:nth-child(5) { animation-delay: 0.9s; }

        @keyframes actionItemSlide {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        .action-item:hover {
            background: var(--white);
            border-color: var(--primary-color);
            color: var(--primary-color);
            text-decoration: none;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.1);
        }
        
        .action-item:last-child {
            margin-bottom: 0;
        }
        
        .action-item-icon {
            width: 36px;
            height: 36px;
            background: var(--white);
            border: 1px solid var(--medium-gray);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 0.875rem;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }
        
        .action-item:hover .action-item-icon {
            background: #eff6ff;
            border-color: var(--primary-color);
        }
        
        .action-item i {
            font-size: 0.9rem;
            color: var(--secondary-color);
            transition: color 0.2s ease;
        }
        
        .action-item:hover i {
            color: var(--primary-color);
        }
        
        .action-content {
            flex: 1;
            min-width: 0;
        }
        
        .action-title {
            font-weight: 600;
            font-size: 0.9rem;
            margin: 0 0 0.125rem 0;
            color: var(--dark-gray);
            transition: color 0.2s ease;
        }
        
        .action-item:hover .action-title {
            color: var(--primary-color);
        }
        
        .action-desc {
            color: var(--secondary-color);
            font-size: 0.8rem;
            margin: 0;
            line-height: 1.3;
        }
        
        /* Status Overview */
        .status-overview {
            background: var(--white);
            border: 1px solid var(--medium-gray);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
            animation: slideInUp 0.8s ease-out 0.5s both;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .status-item {
            text-align: center;
            padding: 1rem;
            transform: scale(0.8);
            opacity: 0;
            animation: statusItemAppear 0.5s ease-out forwards;
        }

        .status-item:nth-child(1) { animation-delay: 0.8s; }
        .status-item:nth-child(2) { animation-delay: 0.9s; }
        .status-item:nth-child(3) { animation-delay: 1.0s; }
        .status-item:nth-child(4) { animation-delay: 1.1s; }

        @keyframes statusItemAppear {
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        .status-item-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.75rem auto;
            font-size: 1.25rem;
        }
        
        .status-item-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--dark-gray);
            margin: 0 0 0.25rem 0;
        }
        
        .status-item-label {
            font-size: 0.875rem;
            color: var(--secondary-color);
            margin: 0;
        }
        
        /* No Data State */
        .no-data {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--secondary-color);
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }
        
        /* Error State */
        .error-state {
            text-align: center;
            padding: 2rem;
            color: var(--danger-color);
            animation: errorShake 0.5s ease-out;
        }

        @keyframes errorShake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        .error-state i {
            font-size: 2rem;
            margin-bottom: 1rem;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .luxury-title {
                font-size: 1.5rem !important;
            }
            
            .dashboard-header {
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }
            
            .stats-card {
                margin-bottom: 1rem;
            }
            
            .stats-number {
                font-size: 1.5rem;
            }
            
            .card-header-clean {
                padding: 1rem 1rem 0 1rem;
            }
            
            .table-clean thead th,
            .table-clean tbody td {
                padding: 0.75rem 0.5rem;
            }
            
            /* Hide actions column on mobile, show as hover on row */
            .mobile-actions {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                opacity: 0;
                transition: opacity 0.2s ease;
            }
            
            .table-clean tbody tr:hover .mobile-actions {
                opacity: 1;
            }
        }
        
        /* Spacing Utilities */
        .mb-section {
            margin-bottom: 2rem;
        }
        
        .gap-cards {
            gap: 1.5rem;
        }

        /* Data refresh indicator */
        .refresh-indicator {
            position: absolute;
            top: 10px;
            right: 10px;
            color: var(--success-color);
            opacity: 0;
            transform: scale(0);
            transition: all 0.3s ease;
        }

        .refresh-indicator.show {
            opacity: 1;
            transform: scale(1);
            animation: refreshSpin 0.5s ease-in-out;
        }

        @keyframes refreshSpin {
            from { transform: rotate(0deg) scale(1); }
            to { transform: rotate(360deg) scale(1); }
        }
    </style>
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <!-- Loading Progress Bar -->
    <div class="loading-progress" id="loadingProgress"></div>

    <div class="wrapper">
        <!-- Include Sales Sidebar -->
        <jsp:include page="/sale/SalesSidebar.jsp" />

        <div class="main">
            <!-- Include Navbar -->
            <jsp:include page="/sale/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0 dashboard-container">
                    
                    <!-- Error Message Display -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Thông báo:</strong> <c:out value="${errorMessage}"/>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Only show dashboard if user has warehouse assigned -->
                    <c:choose>
                        <c:when test="${not empty errorMessage}">
                            <!-- Show error state -->
                            <div class="text-center py-5">
                                <i class="fas fa-warehouse text-muted" style="font-size: 4rem; opacity: 0.3;"></i>
                                <h3 class="mt-3 text-muted">Warehouse Assignment Required</h3>
                                <p class="text-muted">Please contact your administrator to assign you to a warehouse.</p>
                                <a href="<c:url value='/sale/view-sales-order-list'/>" class="btn btn-primary mt-3">
                                    <i class="fas fa-list me-2"></i>View Orders
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                    
                    <!-- Dashboard Header -->
                    <div class="dashboard-header">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h1 class="luxury-title">Sales Intelligence Center</h1>
                                <p>Welcome back, <c:out value="${sessionScope.user.firstName}" default="Sales Staff"/>. Here's your sales overview.</p>
                                
                                <!-- Warehouse Info - IMPROVED VERSION -->
                                <c:if test="${not empty warehouseInfo}">
                                    <div class="warehouse-info">
                                        <i class="fas fa-warehouse"></i>
                                        <span class="warehouse-name"><c:out value="${warehouseInfo.warehouseName}"/></span>
                                        <span class="warehouse-separator">•</span>
                                        <span class="warehouse-region"><c:out value="${warehouseInfo.region}"/></span>
                                    </div>
                                </c:if>
                            </div>
                            <div class="col-md-4 text-end d-none d-md-block">
                                <i class="fas fa-chart-line text-muted" style="font-size: 2.5rem; opacity: 0.2;"></i>
                                <div class="refresh-indicator" id="refreshIndicator">
                                    <i class="fas fa-sync-alt"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Statistics Row -->
                    <div class="row mb-section">
                        <div class="col-xl-3 col-lg-6 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-header">
                                    <p class="stats-title">Total Orders</p>
                                    <div class="stats-icon primary">
                                        <i class="fas fa-shopping-cart"></i>
                                    </div>
                                </div>
                                <h2 class="stats-number" id="totalOrdersCount">-</h2>
                                <p class="stats-change" id="ordersChange">Loading...</p>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-lg-6 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-header">
                                    <p class="stats-title">Completed</p>
                                    <div class="stats-icon success">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                </div>
                                <h2 class="stats-number" id="completedOrdersCount">-</h2>
                                <p class="stats-change" id="completedChange">Loading...</p>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-lg-6 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-header">
                                    <p class="stats-title">Pending</p>
                                    <div class="stats-icon warning">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                </div>
                                <h2 class="stats-number" id="pendingOrdersCount">-</h2>
                                <p class="stats-change" id="pendingChange">Loading...</p>
                            </div>
                        </div>
                        
                        <div class="col-xl-3 col-lg-6 col-md-6 mb-3">
                            <div class="stats-card">
                                <div class="stats-header">
                                    <p class="stats-title">Revenue</p>
                                    <div class="stats-icon secondary">
                                        <i class="fas fa-dollar-sign"></i>
                                    </div>
                                </div>
                                <h2 class="stats-number revenue-number" id="totalRevenueAmount">-</h2>
                                <p class="stats-change" id="revenueChange">Loading...</p>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content Row -->
                    <div class="row">
                        <!-- Recent Orders -->
                        <div class="col-lg-8 mb-4">
                            <div class="content-card">
                                <div class="card-header-clean">
                                    <h3 class="card-title-clean">
                                        <i class="fas fa-list"></i>
                                        Recent Sales Orders
                                    </h3>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-clean" id="recentOrdersTable">
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Customer</th>
                                                <th class="d-none d-md-table-cell">Date</th>
                                                <th>Status</th>
                                                <th class="text-end">Amount</th>
                                                <th class="text-center d-none d-sm-table-cell" style="width: 80px;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="recentOrdersBody">
                                            <!-- Loading rows -->
                                            <tr>
                                                <td><div class="loading-row"></div></td>
                                                <td><div class="loading-row"></div></td>
                                                <td class="d-none d-md-table-cell"><div class="loading-row"></div></td>
                                                <td><div class="loading-row"></div></td>
                                                <td><div class="loading-row"></div></td>
                                                <td class="d-none d-sm-table-cell"><div class="loading-row"></div></td>
                                            </tr>
                                            <tr>
                                                <td><div class="loading-row"></div></td>
                                                <td><div class="loading-row"></div></td>
                                                <td class="d-none d-md-table-cell"><div class="loading-row"></div></td>
                                                <td><div class="loading-row"></div></td>
                                                <td><div class="loading-row"></div></td>
                                                <td class="d-none d-sm-table-cell"><div class="loading-row"></div></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="col-lg-4 mb-4">
                            <div class="quick-actions">
                                <h3 class="card-title-clean">
                                    <i class="fas fa-bolt"></i>
                                    Quick Actions
                                </h3>
                                
                                <a href="<c:url value='/sale/create-sales-order'/>" class="action-item">
                                    <div class="action-item-icon">
                                        <i class="fas fa-plus"></i>
                                    </div>
                                    <div class="action-content">
                                        <div class="action-title">Create Sales Order</div>
                                        <div class="action-desc">Start a new customer order</div>
                                    </div>
                                </a>
                                
                                <a href="<c:url value='/sale/requestImport'/>" class="action-item">
                                    <div class="action-item-icon">
                                        <i class="fas fa-download"></i>
                                    </div>
                                    <div class="action-content">
                                        <div class="action-title">Request Import</div>
                                        <div class="action-desc">Request products from warehouse</div>
                                    </div>
                                </a>
                                
                                <a href="<c:url value='/sale/createCustomer'/>" class="action-item">
                                    <div class="action-item-icon">
                                        <i class="fas fa-user-plus"></i>
                                    </div>
                                    <div class="action-content">
                                        <div class="action-title">Add Customer</div>
                                        <div class="action-desc">Register new customer</div>
                                    </div>
                                </a>
                                
                                <a href="<c:url value='/sale/view-sales-order-list'/>" class="action-item">
                                    <div class="action-item-icon">
                                        <i class="fas fa-list"></i>
                                    </div>
                                    <div class="action-content">
                                        <div class="action-title">View All Orders</div>
                                        <div class="action-desc">Manage existing orders</div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Status Overview -->
                    <div class="row">
                        <div class="col-12">
                            <div class="status-overview">
                                <h3 class="card-title-clean">
                                    <i class="fas fa-chart-pie"></i>
                                    Order Status Distribution
                                </h3>
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="status-item">
                                            <div class="status-item-icon primary">
                                                <i class="fas fa-shopping-cart"></i>
                                            </div>
                                            <h4 class="status-item-number" id="orderStatusCount">-</h4>
                                            <p class="status-item-label">New Orders</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="status-item">
                                            <div class="status-item-icon warning">
                                                <i class="fas fa-truck"></i>
                                            </div>
                                            <h4 class="status-item-number" id="deliveryStatusCount">-</h4>
                                            <p class="status-item-label">In Delivery</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="status-item">
                                            <div class="status-item-icon success">
                                                <i class="fas fa-check-circle"></i>
                                            </div>
                                            <h4 class="status-item-number" id="completedStatusCount">-</h4>
                                            <p class="status-item-label">Completed</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="status-item">
                                            <div class="status-item-icon secondary">
                                                <i class="fas fa-times-circle"></i>
                                            </div>
                                            <h4 class="status-item-number" id="cancelledStatusCount">-</h4>
                                            <p class="status-item-label">Cancelled</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    </c:otherwise>
                    </c:choose>
                    
                </div>
            </main>

            <!-- Footer -->
            <footer class="footer">
                <div class="container-fluid">
                    <div class="row text-muted">
                        <div class="col-12 text-center">
                            <p class="mb-0">
                                <a class="text-muted" href="#" target="_blank"><strong>Warehouse Management System</strong></a> &copy; 2025
                            </p>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>

    <script>
        let dataLoaded = false;
        
        document.addEventListener("DOMContentLoaded", function() {
            // Initialize Feather icons
            if (typeof feather !== 'undefined') {
                feather.replace();
            }
            
            // Initialize tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // Load dashboard data
            loadDashboardData();
            
            // Refresh data every 5 minutes
            setInterval(loadDashboardData, 300000);
        });

        function showLoadingProgress() {
            const progressBar = document.getElementById('loadingProgress');
            if (progressBar) {
                progressBar.classList.add('show');
            }
        }

        function hideLoadingProgress() {
            const progressBar = document.getElementById('loadingProgress');
            if (progressBar) {
                setTimeout(() => {
                    progressBar.classList.remove('show');
                }, 500);
            }
        }

        function showRefreshIndicator() {
            const indicator = document.getElementById('refreshIndicator');
            if (indicator) {
                indicator.classList.add('show');
                setTimeout(() => {
                    indicator.classList.remove('show');
                }, 1000);
            }
        }

        function loadDashboardData() {
            console.log('Loading dashboard data...');
            showLoadingProgress();
            
            fetch('<c:url value="/sale/api/dashboard-data"/>')
                .then(function(response) {
                    console.log('API Response status:', response.status);
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('Received data:', data);
                    
                    if (data.error) {
                        throw new Error(data.error);
                    }
                    
                    updateStatistics(data.statistics);
                    updateRecentOrders(data.recentOrders);
                    updateStatusOverview(data.statusCounts);
                    dataLoaded = true;
                    
                    hideLoadingProgress();
                    showRefreshIndicator();
                })
                .catch(function(error) {
                    console.error('Error loading dashboard data:', error);
                    hideLoadingProgress();
                    showErrorState(error.message);
                });
        }

        // Enhanced counter animation function
        function animateNumber(element, finalValue, duration = 1500, isRevenue = false) {
            const startValue = 0;
            const startTime = Date.now();
            
            // Add counting class for styling
            element.classList.add('counting');
            
            function updateNumber() {
                const now = Date.now();
                const elapsed = now - startTime;
                const progress = Math.min(elapsed / duration, 1);
                
                // Use easeOutCubic for smooth animation
                const easedProgress = 1 - Math.pow(1 - progress, 3);
                const currentValue = Math.round(startValue + (finalValue - startValue) * easedProgress);
                
                if (isRevenue) {
                    element.textContent = formatCurrencyShort(currentValue);
                } else {
                    element.textContent = currentValue.toLocaleString();
                }
                
                if (progress < 1) {
                    requestAnimationFrame(updateNumber);
                } else {
                    // Final value and cleanup
                    if (isRevenue) {
                        element.textContent = formatCurrencyShort(finalValue);
                    } else {
                        element.textContent = finalValue.toLocaleString();
                    }
                    element.classList.remove('counting');
                    element.classList.add('updating');
                    setTimeout(() => {
                        element.classList.remove('updating');
                    }, 600);
                }
            }
            
            updateNumber();
        }

        function updateStatistics(stats) {
            if (!stats) {
                console.warn('No statistics data received');
                return;
            }
            
            console.log('Updating statistics:', stats);
            
            // Animate numbers with staggered delays
            setTimeout(() => {
                animateNumber(document.getElementById('totalOrdersCount'), stats.totalOrders || 0, 1200);
            }, 100);
            
            setTimeout(() => {
                animateNumber(document.getElementById('completedOrdersCount'), stats.completedOrders || 0, 1400);
            }, 200);
            
            setTimeout(() => {
                animateNumber(document.getElementById('pendingOrdersCount'), stats.pendingOrders || 0, 1600);
            }, 300);
            
            setTimeout(() => {
                animateNumber(document.getElementById('totalRevenueAmount'), stats.totalRevenue || 0, 1800, true);
            }, 400);
            
            // Update change indicators with delay
            setTimeout(() => {
                updateChangeIndicator('ordersChange', stats.ordersGrowth || 'No data');
                updateChangeIndicator('completedChange', stats.completedGrowth || 'No data');
                updateChangeIndicator('pendingChange', stats.pendingStatus || 'No data');
                updateChangeIndicator('revenueChange', stats.revenueGrowth || 'No data');
            }, 1000);
        }

        function updateChangeIndicator(elementId, value) {
            const element = document.getElementById(elementId);
            if (element) {
                element.style.opacity = '0';
                element.style.transform = 'translateY(10px)';
                
                setTimeout(() => {
                    element.textContent = value;
                    element.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, 200);
            }
        }

        function updateRecentOrders(orders) {
            var tbody = document.getElementById('recentOrdersBody');
            
            if (!orders || orders.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4"><div class="no-data"><i class="fas fa-shopping-cart"></i><p>No recent orders found for your warehouse</p></div></td></tr>';
                return;
            }

            console.log('Updating recent orders:', orders);

            // Clear existing content
            tbody.innerHTML = '';

            // Add orders with staggered animation
            orders.forEach((order, index) => {
                setTimeout(() => {
                    const row = createOrderRow(order);
                    tbody.appendChild(row);
                }, index * 100);
            });
            
            // Reinitialize tooltips for new content
            setTimeout(function() {
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }, orders.length * 100 + 200);
        }

        function createOrderRow(order) {
            const row = document.createElement('tr');
            
            var customerEmailHtml = order.customerEmail ? 
                '<div class="text-muted" style="font-size: 0.75rem;">' + escapeHtml(order.customerEmail) + '</div>' : '';
            
            // Action buttons based on order status
            var actionButtons = '';
            actionButtons += '<a href="<c:url value="/sale/view-sales-order-detail"/>?id=' + (order.soId || 0) + '" class="action-btn view-btn" data-bs-toggle="tooltip" data-bs-placement="top" title="View Order Details">' +
                '<i class="fas fa-eye"></i>' +
                '</a>';
            
            // Add edit button only if order status is 'Order' (can be edited)
            if (order.status === 'Order') {
                actionButtons += '<a href="<c:url value="/sale/edit-sales-order"/>?id=' + (order.soId || 0) + '" class="action-btn edit-btn" data-bs-toggle="tooltip" data-bs-placement="top" title="Edit Order">' +
                    '<i class="fas fa-edit"></i>' +
                    '</a>';
            }
            
            row.innerHTML = '<td><span class="order-id">' + escapeHtml(order.orderNumber || 'N/A') + '</span></td>' +
                '<td>' +
                    '<div class="fw-semibold">' + escapeHtml(order.customerName || 'Unknown') + '</div>' +
                    customerEmailHtml +
                '</td>' +
                '<td class="d-none d-md-table-cell">' +
                    '<span class="text-muted">' + formatDate(order.orderDate) + '</span>' +
                '</td>' +
                '<td><span class="status-badge status-' + (order.status || 'order').toLowerCase() + '">' + (order.status || 'Order') + '</span></td>' +
                '<td class="text-end"><span class="amount-display">' + formatCurrency(order.totalAmount || 0) + '</span></td>' +
                '<td class="text-center d-none d-sm-table-cell">' + actionButtons + '</td>';
                
            return row;
        }

        function updateStatusOverview(statusCounts) {
            if (!statusCounts) {
                console.warn('No status counts data received');
                return;
            }
            
            console.log('Updating status overview:', statusCounts);
            
            // Animate status numbers with delays
            setTimeout(() => {
                animateNumber(document.getElementById('orderStatusCount'), statusCounts.Order || 0, 1000);
            }, 500);
            
            setTimeout(() => {
                animateNumber(document.getElementById('deliveryStatusCount'), statusCounts.Delivery || 0, 1200);
            }, 600);
            
            setTimeout(() => {
                animateNumber(document.getElementById('completedStatusCount'), statusCounts.Completed || 0, 1400);
            }, 700);
            
            setTimeout(() => {
                animateNumber(document.getElementById('cancelledStatusCount'), statusCounts.Cancelled || 0, 1600);
            }, 800);
        }

        function showErrorState(errorMessage) {
            var tbody = document.getElementById('recentOrdersBody');
            tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4"><div class="error-state"><i class="fas fa-exclamation-triangle"></i><p>Error loading data: ' + escapeHtml(errorMessage) + '</p><button class="btn btn-sm btn-outline-primary mt-2" onclick="loadDashboardData()">Retry</button></div></td></tr>';
            
            // Reset all statistics to show error state
            document.getElementById('totalOrdersCount').textContent = 'Error';
            document.getElementById('completedOrdersCount').textContent = 'Error';
            document.getElementById('pendingOrdersCount').textContent = 'Error';
            document.getElementById('totalRevenueAmount').textContent = 'Error';
            
            document.getElementById('ordersChange').textContent = 'Unable to load data';
            document.getElementById('completedChange').textContent = 'Unable to load data';
            document.getElementById('pendingChange').textContent = 'Unable to load data';
            document.getElementById('revenueChange').textContent = 'Unable to load data';
            
            document.getElementById('orderStatusCount').textContent = '-';
            document.getElementById('deliveryStatusCount').textContent = '-';
            document.getElementById('completedStatusCount').textContent = '-';
            document.getElementById('cancelledStatusCount').textContent = '-';
        }

        function formatCurrency(amount) {
            if (!amount) return '0 ₫';
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0
            }).format(amount);
        }

        function formatCurrencyShort(amount) {
            if (!amount) return '0';
            if (amount >= 1000000000) {
                return (amount / 1000000000).toFixed(1) + 'B ₫';
            } else if (amount >= 1000000) {
                return (amount / 1000000).toFixed(1) + 'M ₫';
            } else if (amount >= 1000) {
                return (amount / 1000).toFixed(1) + 'K ₫';
            }
            return formatCurrency(amount);
        }

        function formatDate(dateString) {
            if (!dateString) return '';
            try {
                var date = new Date(dateString);
                return date.toLocaleDateString('vi-VN', {
                    day: '2-digit',
                    month: '2-digit',
                    year: 'numeric'
                });
            } catch (e) {
                return 'Invalid date';
            }
        }

        function escapeHtml(text) {
            if (!text) return '';
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Add some interactive features
        document.addEventListener('DOMContentLoaded', function() {
            // Add click event for manual refresh
            const refreshIndicator = document.getElementById('refreshIndicator');
            if (refreshIndicator) {
                refreshIndicator.addEventListener('click', function() {
                    loadDashboardData();
                });
                refreshIndicator.style.cursor = 'pointer';
                refreshIndicator.title = 'Click to refresh data';
            }
        });
    </script>
</body>
</html>