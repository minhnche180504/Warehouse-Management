package utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Product;
import model.ProductAttribute;

public class ProductAttributeHelper {
    
    // Predefined common laptop attribute names
    public static final String ATTR_RAM = "RAM";
    public static final String ATTR_CPU = "CPU";
    public static final String ATTR_GPU = "GPU";
    public static final String ATTR_STORAGE = "Storage";
    public static final String ATTR_SCREEN = "Screen";
    public static final String ATTR_OS = "OS";
    public static final String ATTR_BATTERY = "Battery";
    public static final String ATTR_COLOR = "Color";
    
    // Get all common laptop attribute names
    public static List<String> getCommonLaptopAttributeNames() {
        List<String> attributeNames = new ArrayList<>();
        attributeNames.add(ATTR_RAM);
        attributeNames.add(ATTR_CPU);
        attributeNames.add(ATTR_GPU);
        attributeNames.add(ATTR_STORAGE);
        attributeNames.add(ATTR_SCREEN);
        attributeNames.add(ATTR_OS);
        attributeNames.add(ATTR_BATTERY);
        attributeNames.add(ATTR_COLOR);
        return attributeNames;
    }
    
    // Convert product attributes to a map for easier access in JSP
    public static Map<String, String> attributesToMap(Product product) {
        Map<String, String> attributeMap = new HashMap<>();
        
        if (product != null && product.getAttributes() != null) {
            for (ProductAttribute attr : product.getAttributes()) {
                attributeMap.put(attr.getAttributeName(), attr.getAttributeValue());
            }
        }
        
        return attributeMap;
    }
    
    // Create ProductAttribute objects from request parameters
    public static List<ProductAttribute> createAttributesFromMap(int productId, Map<String, String> attributeValues) {
        List<ProductAttribute> attributes = new ArrayList<>();
        
        for (Map.Entry<String, String> entry : attributeValues.entrySet()) {
            String name = entry.getKey();
            String value = entry.getValue();
            
            // Only add attributes with non-empty values
            if (value != null && !value.trim().isEmpty()) {
                ProductAttribute attr = new ProductAttribute();
                attr.setProductId(productId);
                attr.setAttributeName(name);
                attr.setAttributeValue(value);
                attributes.add(attr);
            }
        }
        
        return attributes;
    }
}
