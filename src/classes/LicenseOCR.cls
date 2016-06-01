public class LicenseOCR extends SObjectOCR {

    public String Total { get; private set; }
    public String Used { get; private set; }
    public String sRemaining { get; private set; }
    public Integer iRemaining { get; private set; }
    public NotificatorLicense__c getSettings() {
        return (NotificatorLicense__c) settings;
    }    

    public LicenseOCR(NotificatorLicense__c nthreshold) {
        super(nthreshold);
        try {
            isValid = true;

            parser = new HTMLParser(licensesPageRawData, nthreshold.Name, 1);
            Total = parser.parseField();
            Used = parser.parseField();
            sRemaining = parser.parseField();
            iRemaining=integer.valueof(sRemaining);

            newStatus = calculateNewStatus();
        } catch (HTMLParser.ParserException ex) {
            isValid = false;
        }
    }
    
    public Boolean isValid() {
        Boolean isValid=true;
        Integer iTotal=integer.valueof(Total);
        NotificatorLicense__c settings = getSettings();
        if(settings.notificator__InfoThreshold__c>iTotal) {
    	    settings.notificator__InfoThreshold__c.addError(Label.Notificator_LicenseValidation);   
        	isValid=false;
        }
        
        if(settings.notificator__WarningThreshold__c>iTotal) {
            settings.notificator__WarningThreshold__c.addError(Label.Notificator_LicenseValidation);           
	        isValid=false;
        }
        return isValid;
    }
    
    private String calculateNewStatus() {
        NotificatorLicense__c settings = getSettings();
        if (settings.WarningThreshold__c > 0 && iRemaining <= settings.WarningThreshold__c) return SObjectOCR.STATUS_WARNING; 
        else if (settings.InfoThreshold__c > 0 && iRemaining <= settings.InfoThreshold__c) return SObjectOCR.STATUS_INFO; 
        else return SObjectOCR.STATUS_OK;
    }

    private Static String licensesPageRawData {
        get {
            if (licensesPageRawData != null) return licensesPageRawData;

            Organization orgDetails = [select Id, Name, Country from Organization limit 1];
            Id orgId = orgDetails.Id;

            PageReference licensesPage = new PageReference('/' + orgId + '?rowsperlist=50');
            
            if (Test.isRunningTest()) {
                licensesPageRawData = NotificatorTestUtils.LicensesPageRawData;
            } else {
              	licensesPageRawData = licensesPage.getContent().toString();  
            }
            return licensesPageRawData;
        }
        private set;
    }
}