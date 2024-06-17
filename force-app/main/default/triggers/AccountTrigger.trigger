trigger AccountTrigger on Account (before delete) {

    if(Trigger.isBefore && Trigger.isDelete)
    {
        //AccountTriggerHandler.deleteAccount();
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT Id,(SELECT Id from Contacts) FROM Account where Id IN:Trigger.oldMap.keySet()]);

        for(Account acc:Trigger.old)
        {
            if(!accMap.get(acc.Id).Contacts.isEmpty())
            {
                acc.addError('Account can\'t be deleted as its associated with contacts');
            }
        }
    }

    if(Trigger.isUpdate && Trigger.isAfter)
    {
        List<Id> accountIds = new List<Id>();

        for(Account acc:Trigger.new)
        {
            if(acc.BillingCity!=Trigger.oldMap.get(acc.Id).BillingCity)
            {
                accountIds.add(acc.Id);
            }
        }

        List<Contact> contactList = [SELECT Id FROM Contact WHERE AccountId IN:accountIds];

        for(Contact con:contactList)
        {
            con.BillingCity = Trigger.newMap.get(con.AccountId).BillingCity;
        }

        update contactList;
    }
}