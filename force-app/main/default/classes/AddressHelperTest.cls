/**
* @author Abdul Karim, Traction on Demand.
* @date 10 Jan 2020
*
* @group Address
* @group-content ../../ApexDocContent/Addresses.htm
*
* @description Test class for AddressHelper
*/
@isTest
public  class AddressHelperTest {

    /******************************************************************************************************
    * @description setup method to insert account and address once
    * @example
    */

    @TestSetup
    static void setup(){
        Account RCIDAcc = TestUtil.createAccount('RCID', true, null);
        TestUtil.createAddress(RCIDAcc.Id);
    }

    /*******************************************************************************************************
    * @description run test script which covers AddressHelper class
    * @example
    */
    static testMethod void runTest(){
        System.assert(AddressHelper.getFullAddress(null, false, false) == null);
        
        Id accountId = AddressesServiceTest.getAccountRCID().Id;
        SMBCare_Address__c addressObj = AddressesServiceTest.getAddressByAccountId(accountId);

        //pass missing values
        addressObj.Country__c = 'Canada';
        addressObj.State__c = addressObj.Province__c;
        addressObj.Province__c = null;
        AddressHelper.getFullAddress(addressObj, true, true);
    }

    static testMethod void testWrapperServiceLocation(){
        System.assert(AddressHelper.getServiceLocation(null, false) == null);

        Id accountId = AddressesServiceTest.getAccountRCID().Id;
        SMBCare_Address__c addressObj = AddressesServiceTest.getAddressByAccountId(accountId);

        ServiceAddressesWrapper.addressWrapper address = AddressesServiceTest.getAddressWrapper(addressObj);
        AddressHelper.getServiceLocation(address, true);

        address.country = 'Canada';
        address.unitNumber = address.suiteNumber;
        address.buildingNumber = address.streetNumber;
        AddressHelper.getServiceLocation(address, true);

        //pass different set o values
        address.civicNo = address.buildingNumber;
        address.street = address.streetName;
        address.streetName = null;
        AddressHelper.getServiceLocation(address, true);

    }

    static testMethod void testUtilMethods(){

        Id accountId = AddressesServiceTest.getAccountRCID().Id;
        SMBCare_Address__c addressObj = AddressesServiceTest.getAddressByAccountId(accountId);

        boolean isValid = AddressHelper.isValidatedAddress(addressObj);
        System.assert(!isValid);

        boolean isOdyssey = AddressHelper.isOdysseyAddress(addressObj,accountId);
        System.assert(isOdyssey);

        addressObj.Location_Id__c = 'TEST_LOCATION_ID';
        addressObj.FMS_Address_ID__c = 'TEST_FMS_ID';

        isValid = AddressHelper.isValidatedAddress(addressObj);
        System.assert(isValid);

    }

    static testMethod void testCalloutMethods(){

        Id accountId = AddressesServiceTest.getAccountRCID().Id;
        SMBCare_Address__c addressObj = AddressesServiceTest.getAddressByAccountId(accountId);

        //Future Methods
        try{
            AddressHelper.getGponDropStatus(addressObj.Id);
            AddressHelper.retrieveRateGroupInfo(addressObj.Id);
            AddressHelper.checkProductTechnicalAvailability(addressObj.Id);
        }catch(Exception ex){System.debug('EX = '+ex);}
    }
}