public with sharing class ContactTriggerHandler {
    public static void updateContactsCount(List<Contact> contactList)
    {
        List<Id> accIds=new List<Id>();

        for(Contact con:contactList)
        {
            accIds.add(con.AccountId);
        }

        List<Account> accList = [SELECT Id,(Select Id from Contacts) from Account WHERE Id IN:accIds];

        for(Account acc:accList)
        {
            acc.Total_Contacts_Count__c=acc.Contacts.size();
        }

        update accList;
    }
}