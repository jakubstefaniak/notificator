@isTest 
private class LicenseOCR_Test {

    static testMethod void populateGetters() {
       LicenseOCR ocr = NotificatorTestUtils.prepareTestLicenseOCR(15,5);
        
       System.assertEquals('20', ocr.Total);
       System.assertEquals('2', ocr.Used);
       System.assertEquals('18', ocr.sRemaining);   
       System.assertEquals(18, ocr.iRemaining);         
       System.assertNotEquals(null,ocr.getSettings());            
    }
    
    static testMethod void isNotificationRequired_WhenNotificationIsNotRequired_ReturnEmptyString() {
       LicenseOCR ocr = NotificatorTestUtils.prepareTestLicenseOCR(15,5);
        
       System.assertEquals(false, ocr.isNotificationRequired());        
    }
    
    static testMethod void isNotificationRequired_WhenNotificationRequired_ReturnNotification() {
       LicenseOCR ocr = NotificatorTestUtils.prepareTestLicenseOCR(19,5);
        
       System.assertEquals(true, ocr.isNotificationRequired());        
    }    
    
    static testMethod void isUpdateRequired_WhenUpdateIsNotRequired_ReturnFalse() {
       LicenseOCR ocr = NotificatorTestUtils.prepareTestLicenseOCR(15,5);

       System.assertEquals(false, ocr.isUpdateRequired());
    }  
    
    static testMethod void isUpdateRequired_WhenUpdateIsRequired_ReturnTrue() {
       LicenseOCR ocr = NotificatorTestUtils.prepareTestLicenseOCR(19,5);

       System.assertEquals(true, ocr.isUpdateRequired());
    }     
    
    static testMethod void getObjectToUpdate_WhenInfoThresholdExceeded_ReturnObject() {
       LicenseOCR ocr = NotificatorTestUtils.prepareTestLicenseOCR(19,5);

       NotificatorLicense__c notificator = (NotificatorLicense__c) ocr.getObjectToUpdate();
       System.assertNotEquals(null, notificator);
       System.assertEquals('Info',notificator.Status__c);        
    }   
    
    static testMethod void isValid_WhenValid_ReturnTrue() {
       LicenseOCR ocr = NotificatorTestUtils.prepareTestLicenseOCR(19,5);

       System.assertEquals(true, ocr.isValid());
    }   
    
    static testMethod void isValid_WhenNotValid_ReturnFalseAndAddError() {
       LicenseOCR ocr = NotificatorTestUtils.prepareTestLicenseOCR(90,50);

       System.assertEquals(false, ocr.isValid());
       Database.SaveResult res=Database.Insert(ocr.getSettings(),false);       
       System.assert(!res.isSuccess());        
    }       
}