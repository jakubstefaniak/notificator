@isTest 
private class  NotificatorJob_Test {
    
    static testMethod void StorageLicenseCheck_UpdateAlertStatus() {
       NotificatorSetting__c notificator = NotificatorTestUtils.prepareTestNotificator();
        
        NotificatorLicense__c licenseToUpdate = [SELECT Id, Name, WarningThreshold__c, InfoThreshold__c, Status__c 
                                                 FROM NotificatorLicense__c WHERE Name='Salesforce'];
        system.assertEquals('OK',licenseToUpdate.Status__c);
        
        licenseToUpdate.InfoThreshold__c=19;
        update licenseToUpdate;

       Test.startTest();
		System.schedule('NotificatorJob_Test',
                        '0 0 0 15 3 ? 2022', 
                        new NotificatorJob());        
        Test.stopTest();
        
		licenseToUpdate = [SELECT Id, Name, WarningThreshold__c, InfoThreshold__c, Status__c 
                                                 FROM NotificatorLicense__c WHERE Name='Salesforce'];
        system.assertEquals('Info',licenseToUpdate.Status__c); 
    }

}