/**
* @author xyz, Traction on Demand.
* @date 10 Jan 2020
*
* @group Address
* @group-content ../../ApexDocContent/Addresses.htm
*
* @description Class for Addresses which will be treated as util of address(es)
*/
public  class AddressHelper {

    
    /*******************************************************************************************************
    * @description get service location from address wrapper object
    * @param addressObj object of address
    * @param fullAddress boolean value to check whether full address required including city, country etc.
    * @return String of service location
    * @example
    */
    public static String getServiceLocation(ServiceAddressesWrapper.addressWrapper address, Boolean fullAddress){

        //if object is null then return null
        if(null ==  address){
            return null;
        }

        String retVal = '';

        //Take the Unit Number from Unit Number where a value is specified, otherwise from Suite Number where a value is specified
        String suite = StringUtils.firstNonEmptyValue(new String[]{address.unitNumber,address.suiteNumber});

        //Take the Street Number from Civic Number where a value is specified,
        // otherwise from Building Number where a value is specified, otherwise from Street Number where a value is specified
        String streetNumber = StringUtils.firstNonEmptyValue(new String[]{address.civicNo,address.buildingNumber,address.streetNumber});

        //Take the street name from StreetName where a value is specified, otherwise from Street where a value is specified
        String streetName = StringUtils.firstNonEmptyValue(new String[]{address.streetName,address.street});

        retVal = StringUtils.joinArray(new String[]{StringUtils.trimToNull(suite), StringUtils.trimToNull(streetNumber),StringUtils.trimToNull(streetName)},' ');

        if(fullAddress){
            retVal = StringUtils.joinArray(new String[]{retVal, StringUtils.trimToNull(address.city),StringUtils.trimToNull(address.province)} ,' ');
        }

        return retVal;
    }

    public static String getFullAddress(SMBCare_Address__c address,Boolean addPC, Boolean addCountry){
        //if object is null then return null
        if(null ==  address){
            return null;
        }

        String provinceOrState =  StringUtils.firstNonEmptyValue(new String[]{address.Province__c,address.State__c});
        String retVal = StringUtils.joinArray(new String[]{StringUtils.trimToNull(address.Display_Address__c),StringUtils.trimToNull(address.City__c),StringUtils.trimToNull(provinceOrState)} ,' ');

        if(String.isNotBlank(address.Postal_Code__c) && addPC){
            string temPC = address.Postal_Code__c.replaceAll(' ','').replaceAll('-','');
            retVal = StringUtils.joinArray(new String[]{retVal, StringUtils.trimToNull(temPC)} ,' ');
        }

        if(String.isNotBlank(address.Country__c) && addCountry){
            retVal = StringUtils.joinArray(new String[]{retVal, StringUtils.trimToNull(address.Country__c)} ,' ');
        }
        return retVal;

    }

    /*******************************************************************************************************
    * @description find if given address is Odyssey address or not
    * @param address object of address
    * @param RCID  ID for RCID Type account (record type)
    * @return Boolean value (true/false)
    * @example
    */
    public static Boolean isOdysseyAddress(SMBCare_Address__c address, Id RCID){
        Boolean retVal = false;
        if(address.Account__c == RCID && String.isNotBlank(address.Service_Account_Id__c)){
            retVal = true;
        }
        return retVal;
    }

    /*******************************************************************************************************
    * @description find if given address is valid or not
    * @param address object of address
    * @return Boolean value (true/false)
    * @example
    */
    public static Boolean isValidatedAddress(SMBCare_Address__c address){
        return isValidatedAddress(address, new Set<Id>());
    }

    /*******************************************************************************************************
   * @description find if given address is valid or not
   * @param address object of address
   * @return Boolean value (true/false)
   * @example
   */
    public static Boolean isValidatedAddress(SMBCare_Address__c address, Set<Id> serviceAccountIds){
        Boolean retVal = false;

        if((string.isNotBlank(address.Location_Id__c)
               // && string.isNotBlank(address.FMS_Address_ID__c)
                && string.isNotBlank(address.Service_Account_Id__c))
                || serviceAccountIds.contains(address.Service_Account_Id__c)){

            retVal = true;
        }

        return retVal;
    }

    @Future(callout=true)
    public static void getGponDropStatus(Id serviceAddressId){
        if(!Test.isRunningTest()) {
            OrdrTechnicalAvailabilityManager.getGponDropStatus(serviceAddressId);
        }
    }

    @Future(callout=true)
    public static void checkProductTechnicalAvailability(Id serviceAddressId){
        if(!Test.isRunningTest()) {
            OrdrTechnicalAvailabilityManager.checkProductTechnicalAvailability(serviceAddressId);
        }
    }

    @Future(callout=true)
    public static void retrieveRateGroupInfo(Id serviceAddressId){
        if(!Test.isRunningTest()) {
            OrdrProductEligibilityManager.retrieveRateGroupInfo(serviceAddressId);
        }
    }
}