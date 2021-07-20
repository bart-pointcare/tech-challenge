trigger ContentVersionBeforeInsert on ContentVersion (before insert) {
    ContentVersionHelper.processGuestRecordUploads_before(Trigger.new);
}