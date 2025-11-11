package model;

import lombok.ToString;
import lombok.Builder;
import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class InventoryReport {
    private Integer productId;
    private String productCode;
    private String productName;
    private BigDecimal unitCost;
    private BigDecimal totalValue;
    private Integer onHand;
    private Integer freeToUse;
    private Integer incoming;
    private Integer outgoing;
    private String replenishment;
    private String location;
    private String warehouseName;
    private Integer warehouseId;
    private String unitName;
    private String unitCode;
    private String supplierName;
    
    // Additional fields for calculations
    private Integer reorderThreshold;
    private Boolean needsRestock;
} 