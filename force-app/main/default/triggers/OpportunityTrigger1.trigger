trigger OpportunityTrigger1 on Opportunity (before delete) {
    OpportunityTriggerHandler.beforeDeleteMethod(Trigger.old);
}