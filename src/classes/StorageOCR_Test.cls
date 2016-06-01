@isTest 
private class StorageOCR_Test {

    static testMethod void populateGetters() {
       StorageOCR ocr = NotificatorTestUtils.prepareTestStorageOCR(75,95);
        
       System.assertEquals('250.0 MB', ocr.storageLimit);
       System.assertEquals('146.0 MB', ocr.Usage);
       System.assertEquals('58%', ocr.sPercent);    
       System.assertEquals(58, ocr.iPercent);      
       System.assertNotEquals(null,ocr.getSettings());          
    }

    static testMethod void isNotificationRequired_WhenNotificationIsNotRequired_ReturnEmptyString() {
       StorageOCR ocr = NotificatorTestUtils.prepareTestStorageOCR(75,95);
        
       System.assertEquals(false, ocr.isNotificationRequired());        
    }
    
    static testMethod void isNotificationRequired_WhenNotificationRequired_ReturnNotification() {
       StorageOCR ocr = NotificatorTestUtils.prepareTestStorageOCR(40,95);
        
       System.assertEquals(true, ocr.isNotificationRequired());        
    }    
    
    static testMethod void isUpdateRequired_WhenUpdateIsNotRequired_ReturnFalse() {
       StorageOCR ocr = NotificatorTestUtils.prepareTestStorageOCR(75,95);

       System.assertEquals(false, ocr.isUpdateRequired());
    }  
    
    static testMethod void isUpdateRequired_WhenUpdateIsRequired_ReturnTrue() {
       StorageOCR ocr = NotificatorTestUtils.prepareTestStorageOCR(50,95);

       System.assertEquals(true, ocr.isUpdateRequired());
    }     
    
    static testMethod void getObjectToUpdate_WhenInfoThresholdExceeded_ReturnObject() {
       StorageOCR ocr = NotificatorTestUtils.prepareTestStorageOCR(50,95);

       NotificatorStorage__c notificator = (NotificatorStorage__c)ocr.getObjectToUpdate();
       System.assertNotEquals(null, notificator);
       System.assertEquals(notificator.Status__c, 'Info');        
    }       
}