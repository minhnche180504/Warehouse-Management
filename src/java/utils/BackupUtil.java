package utils;

import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;

/**
 * Utility class for database backup
 * Note: This requires SQL Server backup utilities or can be configured to use SQL scripts
 */
public class BackupUtil {
    
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(BackupUtil.class);
    private static final String BACKUP_DIR = "backups";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
    
    /**
     * Create backup directory if not exists
     */
    public static void ensureBackupDirectory() {
        try {
            Path backupPath = Paths.get(BACKUP_DIR);
            if (!Files.exists(backupPath)) {
                Files.createDirectories(backupPath);
                logger.info("Created backup directory: {}", BACKUP_DIR);
            }
        } catch (IOException e) {
            logger.error("Error creating backup directory", e);
        }
    }
    
    /**
     * Generate backup filename with timestamp
     */
    public static String generateBackupFilename(String databaseName) {
        String timestamp = LocalDateTime.now().format(DATE_FORMATTER);
        return String.format("%s_backup_%s.sql", databaseName, timestamp);
    }
    
    /**
     * Create backup script content
     * Note: This is a template. Actual implementation depends on SQL Server setup
     */
    public static String createBackupScript(String databaseName, String backupPath) {
        return String.format(
            "BACKUP DATABASE [%s] TO DISK = '%s' WITH FORMAT, INIT, NAME = 'Full Backup of %s', SKIP, NOREWIND, NOUNLOAD, STATS = 10",
            databaseName, backupPath, databaseName
        );
    }
    
    /**
     * Schedule automatic backups
     * Note: This requires a scheduler (Quartz, etc.) or can be called by cron job
     */
    public static void scheduleBackup(String databaseName, int intervalHours) {
        logger.info("Scheduling backup for database: {} every {} hours", databaseName, intervalHours);
        // Implementation depends on scheduler framework
    }
    
    /**
     * Get backup file list
     */
    public static File[] listBackupFiles() {
        File backupDir = new File(BACKUP_DIR);
        if (!backupDir.exists() || !backupDir.isDirectory()) {
            return new File[0];
        }
        
        return backupDir.listFiles((dir, name) -> name.endsWith(".sql") || name.endsWith(".bak"));
    }
    
    /**
     * Delete old backups (older than specified days)
     */
    public static void deleteOldBackups(int daysToKeep) {
        File[] backupFiles = listBackupFiles();
        long cutoffTime = System.currentTimeMillis() - (daysToKeep * 24L * 60 * 60 * 1000);
        
        int deletedCount = 0;
        for (File file : backupFiles) {
            if (file.lastModified() < cutoffTime) {
                if (file.delete()) {
                    deletedCount++;
                    logger.info("Deleted old backup: {}", file.getName());
                }
            }
        }
        
        logger.info("Deleted {} old backup files (older than {} days)", deletedCount, daysToKeep);
    }
}

