@isTest
private class HTMLParser_Test {

    static testMethod void parse_whenCorrectFile() {
        HTMLParser parser = new HTMLParser(NotificatorTestUtils.LicensesPageRawData, 'Salesforce', 1);

        System.assertEquals('20', parser.parseField());
    }

    static testMethod void parse_whenWrongFileAndNameNotFound_throwException() {
        try {
            HTMLParser parser = new HTMLParser(NotificatorTestUtils.StoragesPageRawData, 'Salesforce', 0);
            System.assert(false);
        } catch (HTMLParser.ParserException ex) {
            System.Assert(ex.getMessage().contains(HTMLParser.PARSER_EXCEPTION));
        }
    }
}