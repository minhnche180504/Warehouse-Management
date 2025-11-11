package utils;

/**
 * Utility class for pagination
 */
public class PaginationUtil {
    
    private static final int DEFAULT_PAGE_SIZE = 20;
    private static final int MAX_PAGE_SIZE = 100;
    
    /**
     * Calculate offset from page number and page size
     */
    public static int calculateOffset(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;
        if (pageSize > MAX_PAGE_SIZE) pageSize = MAX_PAGE_SIZE;
        
        return (page - 1) * pageSize;
    }
    
    /**
     * Get default page size
     */
    public static int getDefaultPageSize() {
        return DEFAULT_PAGE_SIZE;
    }
    
    /**
     * Get max page size
     */
    public static int getMaxPageSize() {
        return MAX_PAGE_SIZE;
    }
    
    /**
     * Validate and normalize page number
     */
    public static int normalizePage(int page) {
        return page < 1 ? 1 : page;
    }
    
    /**
     * Validate and normalize page size
     */
    public static int normalizePageSize(int pageSize) {
        if (pageSize < 1) return DEFAULT_PAGE_SIZE;
        if (pageSize > MAX_PAGE_SIZE) return MAX_PAGE_SIZE;
        return pageSize;
    }
    
    /**
     * Calculate total pages from total records and page size
     */
    public static int calculateTotalPages(int totalRecords, int pageSize) {
        if (totalRecords <= 0) return 1;
        if (pageSize <= 0) pageSize = DEFAULT_PAGE_SIZE;
        return (int) Math.ceil((double) totalRecords / pageSize);
    }
    
    /**
     * Pagination info class
     */
    public static class PaginationInfo {
        private int currentPage;
        private int pageSize;
        private int totalRecords;
        private int totalPages;
        private int offset;
        
        public PaginationInfo(int currentPage, int pageSize, int totalRecords) {
            this.currentPage = normalizePage(currentPage);
            this.pageSize = normalizePageSize(pageSize);
            this.totalRecords = totalRecords;
            this.totalPages = calculateTotalPages(totalRecords, this.pageSize);
            this.offset = calculateOffset(this.currentPage, this.pageSize);
        }
        
        public int getCurrentPage() { return currentPage; }
        public int getPageSize() { return pageSize; }
        public int getTotalRecords() { return totalRecords; }
        public int getTotalPages() { return totalPages; }
        public int getOffset() { return offset; }
        
        public boolean hasPrevious() { return currentPage > 1; }
        public boolean hasNext() { return currentPage < totalPages; }
        
        public int getPreviousPage() { return hasPrevious() ? currentPage - 1 : 1; }
        public int getNextPage() { return hasNext() ? currentPage + 1 : totalPages; }
    }
}

