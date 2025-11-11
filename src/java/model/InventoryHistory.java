package model;

import lombok.ToString;
import lombok.Builder;
import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import java.sql.Date;
import java.math.BigDecimal;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class InventoryHistory {
    private Integer historyId;
    private Integer productId;
    private String productCode;
    private String productName;
    private String transactionType; // 'IN', 'OUT', 'ADJUSTMENT'
    private Integer quantityChange;
    private Integer quantityBefore;
    private Integer quantityAfter;
    private Date transactionDate;
    private String reason;
    private String referenceType; // 'PURCHASE_ORDER', 'SALES_ORDER', 'ADJUSTMENT'
    private Integer referenceId;
    private String referenceNumber;
    private String userName;
    private Integer userId;
    private String warehouseName;
    private Integer warehouseId;
    private String unitCode;
    private BigDecimal unitPrice;
    private String notes;
    
    // Additional display fields
    private String transactionTypeDisplay;
    private String quantityChangeDisplay;
} 