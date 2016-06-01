global class NotificatorJob implements Schedulable {
    public final static String JOB_NAME;
    static {
        if (Test.isRunningTest()) {
            JOB_NAME='Notificator_Test';
        } else {
            JOB_NAME='Notificator';
        }              
    }
    
    List<SObject> objectsToUpdate;
    NotificatorEmail email;

    global void execute(SchedulableContext ctx) {
        email = new NotificatorEmail();
        objectsToUpdate = new List<SObject>();

        checkLicenses();
        checkStorages();
                
        email.sendNotification();    
        update objectsToUpdate;
    }

    private void checkLicenses() {
        List<LicenseOCR> licenses = NotificatorSingleton.getLicenses();
        for (LicenseOCR license: licenses) {
            email.addLicense(license);
            if (license.isUpdateRequired()) objectsToUpdate.add(license.getObjectToUpdate());
        }
    }

    private void checkStorages() {      
        List<StorageOCR> storages = NotificatorSingleton.getStorages();
        for (StorageOCR storage: storages) {
            email.addStorage(storage);
            if (storage.isUpdateRequired()) objectsToUpdate.add(storage.getObjectToUpdate());
        }
    }
}