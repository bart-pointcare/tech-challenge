trigger ContentVersionAfterInsert on ContentVersion (after insert) {
    ContentVersionHelper.processGuestRecordUploads_after(Trigger.new);
}