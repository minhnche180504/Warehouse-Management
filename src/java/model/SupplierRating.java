package model;

import lombok.*;
import java.sql.Date;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class SupplierRating {
    private Integer ratingId;
    private Integer supplierId;
    private Integer userId;
    private Integer deliveryScore;
    private Integer qualityScore;
    private Integer serviceScore;
    private Integer priceScore;
    private String comment;
    private Date ratingDate;
} 