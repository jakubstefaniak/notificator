public class NotificatorSingleton {
    
    private static NotificatorSetting__c notificator;
    public static NotificatorSetting__c getNotificator() {
            if (notificator == null) init();
            return notificator;
    }
    
    private static List<StorageOCR> storages;
    public static List<StorageOCR> getStorages() {
            if (storages == null) init();
            return storages;
    }
  
    private static List<LicenseOCR> licenses;   
    public static List<LicenseOCR> getLicenses() {
            if (licenses == null) init();
            return licenses;
    }
    
    private static void init() {
        try {
            loadNotificator();
        } catch (System.QueryException ex) {
            initNewNotificator();
        }
    }

    private static void loadNotificator() {
        notificator = [
                SELECT recipient__c, (
                        SELECT ID, Name, InfoThreshold__c, WarningThreshold__c, Status__c, Setting__c
                        FROM NotificatorLicenses__r LIMIT 100
                ), (
                        SELECT ID, Name, InfoPercentageThreshold__c, WarningPercentageThreshold__c, Status__c, Setting__c
                        FROM NotificatorStorages__r LIMIT 100
                )
                FROM NotificatorSetting__c LIMIT 1
        ];

        licenses = new List<LicenseOCR>();
        for (NotificatorLicense__c nt: notificator.NotificatorLicenses__r) {
            licenses.add(new LicenseOCR(nt));
        }

        storages = new List<StorageOCR>();
        for (NotificatorStorage__c nt: notificator.NotificatorStorages__r) {
            storages.add(new StorageOCR(nt));
        }
    }

    public static void initNewNotificator() {
        notificator = new NotificatorSetting__c();
        initLicensesList();
        initStorageList();
    }

    private static void initLicensesList() {
        AggregateResult[] licenseNames = [SELECT Name FROM UserLicense GROUP BY Name LIMIT 100];
        licenses = new List<LicenseOCR>();

        for (AggregateResult name: licenseNames) {
            NotificatorLicense__c nl = new NotificatorLicense__c(Name = ''+name.get('Name'));
            LicenseOCR ocr = new LicenseOCR(nl);
            if(ocr.isValid) licenses.add(ocr);
        }
    }
	
    private static void initStorageList() {
        List<String> storageNames = new List<String> {
            StorageDictionary.DataByLanguage.get(UserInfo.getLanguage()),
            StorageDictionary.FileByLanguage.get(UserInfo.getLanguage())                
        };
        storages = new List<StorageOCR>();

        for (String name: storageNames) {
            NotificatorStorage__c ns = new NotificatorStorage__c(Name = name);
            StorageOCR ocr = new StorageOCR(ns);
            if(ocr.isValid) storages.add(ocr);              
        }
    }

}