public with sharing class ObjectUtilController {
    /**
     * Retrieves a list of fields for a given Salesforce object API name,
     * with the option to include formula fields in the returned list.
     *
     * @param sObjectApiName The API name of the Salesforce object to retrieve fields for.
     * @param isFormulaIncluded A boolean indicating whether or not to include formula fields in the returned list.
     * @return A List of FieldResponse objects representing the fields for the specified Salesforce object, sorted alphabetically.
     */
    @AuraEnabled(Cacheable = true)
    public static List<FieldResponse> getFieldsBySobjectApiName(String sObjectApiName,Boolean isFormulaIncluded){
        ObjectUtil.requireNonNull(sObjectApiName,'sObjectApiName cannot be null to get fields');
        ObjectUtil.requireNonNull(isFormulaIncluded,'isFormulaIncluded cannot be null to get fields');

        List<SObjectField> sObjectFields =  ObjectUtil.getFieldsForSObject(sObjectApiName,true,true,true,isFormulaIncluded);
        List<FieldResponse> fields = new List<FieldResponse>();
        for(SObjectField sObjectField: sObjectFields){
            DescribeFieldResult fieldResult = sObjectField.getDescribe();
            fields.add(new FieldResponse()
                    .setFieldApiName(fieldResult.getName())
                    .setFieldLabelName(fieldResult.getLabel())
                    .setFieldType(fieldResult.getType().name())
                    .setReferenceTo(fieldResult.getReferenceTo())
                    .setRequired(!fieldResult.isNillable()));
        }
        fields.sort();

        return fields;
    }
    /**
     * Retrieves a list of SObjects that can be created in the current Salesforce org.
     *
     * @return A List of SObjectResponse objects representing the SObjects that can be created, sorted alphabetically.
    */
    @AuraEnabled(Cacheable=true)
    public static List<SObjectResponse> getSObjects(){
        Map<String,SObjectType> sObjectTypeMap = Schema.getGlobalDescribe();
        List<SObjectResponse> sObjectResponses  = new List<SObjectResponse>();
        for(String key:sObjectTypeMap.keySet()){
            DescribeSObjectResult describeSObjectResult = sObjectTypeMap.get(key).getDescribe();

        if(!describeSObjectResult.isCustomSetting()
                && describeSObjectResult.isCreateable()){

                sObjectResponses.add(new SObjectResponse()
                        .setSObjectApiName(describeSObjectResult.getName())
                        .setSObjectLabelName(describeSObjectResult.getLabel()));
            }
        }
        sObjectResponses.sort();
        return sObjectResponses;
    }

   public class FieldResponse implements Comparable{
        @AuraEnabled public String labelName;
        @AuraEnabled public String apiName;
        @AuraEnabled public String type;
        @AuraEnabled public String referenceTo;
        @AuraEnabled public Boolean required;

        public FieldResponse setFieldLabelName(String fieldLabelName) {
            this.labelName = fieldLabelName;
            return this;
        }

        public FieldResponse setFieldApiName(String fieldApiName) {
            this.apiName = fieldApiName;
            return this;
        }

        public FieldResponse setFieldType(String fieldType) {
            this.type = fieldType;
            return this;
        }

        public FieldResponse setRequired(Boolean required) {
            this.required = required;
            return this;
        }
        public FieldResponse setReferenceTo(List<SObjectType> sObjectTypes) {
            if(sObjectTypes!=null && sObjectTypes.size()!=0){
                this.referenceTo = sObjectTypes.get(0).getDescribe().getName();
            }
            return this;
        }
        public Integer compareTo(Object fieldResponseObject) {
            Integer comparison = 0;
            FieldResponse fieldResponseToCompare = (FieldResponse) fieldResponseObject;
            if (this.labelName > fieldResponseToCompare.labelName) {
                comparison = 1;
            } else if (this.labelName < fieldResponseToCompare.labelName) {
                comparison = -1;
            }
            return comparison;
        }
    }

    public class SObjectResponse implements Comparable{
        @AuraEnabled public String label;
        @AuraEnabled public String objectApiName;

        public SObjectResponse setSObjectLabelName(String sObjectLabelName) {
            this.label = sObjectLabelName;
            return this;
        }

        public SObjectResponse setSObjectApiName(String sObjectApiName) {
            this.objectApiName = sObjectApiName;
            return this;
        }
        public Integer compareTo(Object objectResponse) {
            Integer comparison = 0;
            SObjectResponse objectResponseToCompare = (SObjectResponse) objectResponse;
            if (this.label > objectResponseToCompare.label) {
                comparison = 1;
            } else if (this.label < objectResponseToCompare.label) {
                comparison = -1;
            }
            return comparison;
        }

    }

}