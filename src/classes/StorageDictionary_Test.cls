@isTest
private class StorageDictionary_Test {

    static testMethod void dataMap() {
        System.assertEquals(18, StorageDictionary.DataByLanguage.size());

        System.assertEquals('Data Storage', StorageDictionary.DataByLanguage.get('en_US'));        
    }

    static testMethod void fileMap() {
        System.assertEquals(18, StorageDictionary.FileByLanguage.size());

        System.assertEquals('File Storage', StorageDictionary.FileByLanguage.get('en_US'));        
    }

    
}