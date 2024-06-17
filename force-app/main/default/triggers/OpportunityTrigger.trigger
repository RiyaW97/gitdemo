trigger OpportunityTrigger on Account (after insert,after update) {

    if(Trigger.isInsert && Trigger.isAfter)
    {
        OpportunityTriggerHandler.createOppty();
    }

    if(Trigger.isUpdate && Trigger.isAfter)
    {
        OpportunityTriggerHandler.createOppty(Trigger.New,Trigger.oldMap);
    
    }

    if(Trigger.isBefore && Trigger.isDelete)
    {
        OpportunityTriggerHandler.deleteOppty(Trigger.New);
    }

    if(Trigger.isAfter && Trigger.isUpdate)
    {
        OpportunityTriggerHandler.sendEmail(Trigger.New);
    }

}