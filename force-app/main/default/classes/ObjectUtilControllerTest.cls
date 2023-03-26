@IsTest
public class ObjectUtilControllerTest {

    @IsTest
    public static void testGetFieldsBySobjectApiName() {
        List<ObjectUtilController.FieldResponse> fields = ObjectUtilController.getFieldsBySobjectApiName('Account', true);

        Assert.isTrue(fields.size() > 0);

        for (ObjectUtilController.FieldResponse field : fields) {
            Assert.isNotNull(field.apiName);
            Assert.isNotNull(field.labelName);
            Assert.isNotNull(field.type);
            Assert.isNotNull(field.required);
        }
    }

    @IsTest
    public static void testGetSObjects() {
        List<ObjectUtilController.SObjectResponse> sObjectResponses = ObjectUtilController.getSObjects();

        Assert.isTrue(sObjectResponses.size() > 0);

        for (ObjectUtilController.SObjectResponse sObjectResponse : sObjectResponses) {
            Assert.isNotNull(sObjectResponse.objectApiName);
            Assert.isNotNull(sObjectResponse.label);
        }
    }
}