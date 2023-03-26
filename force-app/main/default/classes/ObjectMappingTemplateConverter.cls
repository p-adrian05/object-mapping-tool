public interface ObjectMappingTemplateConverter {
    /**
       * Convert given records to other records based on the mapping setup.
       *
       * @param sourceRecordIds list of source records from the created records will derived from
       * @param objectMappingTemplate The object mapping template used to map source fields to target fields.
       *  @return a map containing the created records, where the keys of the map are the IDs of the source records
       *         and the values are the created records themselves.
       */
     Map<Id, SObject> convertRecords(List<Id> sourceRecordIds,ObjectMappingTemplate objectMappingTemplate);
}